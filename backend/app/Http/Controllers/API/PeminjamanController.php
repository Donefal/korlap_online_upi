<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Peminjaman;
use App\Models\Ruangan;
use App\Models\Notifikasi;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * Controller: PeminjamanController
 *
 * Logika bisnis inti: pengajuan, persetujuan, dan penolakan peminjaman ruangan.
 *
 * Endpoint:
 *   GET    /api/peminjaman           → index()   — Daftar peminjaman milik user / semua (admin)
 *   POST   /api/peminjaman           → store()   — Ajukan peminjaman baru (user)
 *   GET    /api/peminjaman/{id}      → show()    — Detail satu peminjaman
 *   PUT    /api/peminjaman/{id}/setujui  → setujui()   — Setujui pengajuan (admin)
 *   PUT    /api/peminjaman/{id}/tolak    → tolak()     — Tolak pengajuan (admin)
 *   DELETE /api/peminjaman/{id}      → cancel()  — Batalkan pengajuan (user, jika masih 'menunggu')
 */
class PeminjamanController extends Controller
{
    /**
     * GET /api/peminjaman
     *
     * - Jika user biasa  → hanya tampilkan peminjaman milik dirinya
     * - Jika admin       → tampilkan semua peminjaman (dengan filter status)
     *
     * Query params:
     *   ?status=menunggu   → filter per status
     *   ?page=1            → pagination (10 per halaman)
     *
     * Digunakan di Flutter untuk:
     *   - Halaman "Status Peminjaman" (status aktif user)
     *   - Halaman "Histori Peminjaman" (semua histori user)
     *   - Halaman "Admin Action" (semua pengajuan masuk untuk admin)
     */
    public function index(Request $request)
    {
        $user  = $request->user();
        $query = Peminjaman::with(['ruangan', 'user', 'admin']);
        // with() = eager loading, agar tidak terjadi N+1 query
        // Artinya: sekali query, sekalian ambil data ruangan, user, dan admin yang terkait

        if ($user->isAdmin()) {
            // Admin bisa lihat semua, filter opsional per status
            if ($request->filled('status')) {
                $query->where('status', $request->status);
            }
        } else {
            // User biasa hanya lihat milik dirinya
            $query->milikUser($user->id);

            // Filter histori vs aktif
            if ($request->filled('status')) {
                $query->where('status', $request->status);
            }
        }

        $peminjaman = $query->orderBy('created_at', 'desc')->paginate(10);

        return response()->json([
            'success'    => true,
            'data'       => $peminjaman->map(fn($p) => $this->formatPeminjaman($p)),
            'pagination' => [
                'current_page' => $peminjaman->currentPage(),
                'last_page'    => $peminjaman->lastPage(),
                'per_page'     => $peminjaman->perPage(),
                'total'        => $peminjaman->total(),
            ],
        ]);
    }

    /**
     * GET /api/peminjaman/{id}
     *
     * Detail lengkap satu peminjaman.
     * User hanya bisa lihat miliknya; admin bisa lihat semua.
     */
    public function show(Request $request, int $id)
    {
        $user       = $request->user();
        $peminjaman = Peminjaman::with(['ruangan', 'user', 'admin'])->find($id);

        if (!$peminjaman) {
            return response()->json(['success' => false, 'message' => 'Peminjaman tidak ditemukan.'], 404);
        }

        // Validasi kepemilikan: user hanya bisa lihat miliknya
        if (!$user->isAdmin() && $peminjaman->user_id !== $user->id) {
            return response()->json(['success' => false, 'message' => 'Akses ditolak.'], 403);
        }

        return response()->json([
            'success' => true,
            'data'    => $this->formatPeminjaman($peminjaman, detail: true),
        ]);
    }

    /**
     * POST /api/peminjaman  [User Auth Required]
     *
     * Mengajukan peminjaman baru.
     * Otomatis mengubah status ruangan menjadi 'sudah ada yg mengajukan'.
     *
     * Request body (JSON):
     * {
     *   "ruangan_id": 1,
     *   "keperluan": "Praktikum RPL",
     *   "tanggal_pinjam": "2024-12-25",
     *   "jam_mulai": "08:00",
     *   "jam_selesai": "10:00",
     *   "jumlah_peserta": 30,
     *   "catatan_user": "Butuh proyektor nyala"
     * }
     */
    public function store(Request $request)
    {
        $data = $request->validate([
            'ruangan_id'     => 'required|integer|exists:ruangan,id',
            'keperluan'      => 'required|string|max:500',
            'tanggal_pinjam' => 'required|date|after_or_equal:today',
            'jam_mulai'      => 'required|date_format:H:i',
            'jam_selesai'    => 'required|date_format:H:i|after:jam_mulai',
            'jumlah_peserta' => 'nullable|integer|min:1',
            'catatan_user'   => 'nullable|string|max:1000',
        ]);

        // Cek ruangan tersedia
        $ruangan = Ruangan::find($data['ruangan_id']);
        if ($ruangan->status !== 'tersedia') {
            return response()->json([
                'success' => false,
                'message' => "Ruangan tidak tersedia. Status saat ini: {$ruangan->status}",
            ], 422);
        }

        // Cek konflik jadwal di tanggal yang sama untuk ruangan ini
        $konflik = Peminjaman::where('ruangan_id', $data['ruangan_id'])
            ->where('tanggal_pinjam', $data['tanggal_pinjam'])
            ->whereIn('status', ['menunggu', 'disetujui'])
            ->where(function ($q) use ($data) {
                // Cek overlap waktu: jam_mulai baru < jam_selesai existing AND jam_selesai baru > jam_mulai existing
                $q->whereBetween('jam_mulai', [$data['jam_mulai'], $data['jam_selesai']])
                  ->orWhereBetween('jam_selesai', [$data['jam_mulai'], $data['jam_selesai']]);
            })->exists();

        if ($konflik) {
            return response()->json([
                'success' => false,
                'message' => 'Sudah ada peminjaman di jam tersebut.',
            ], 422);
        }

        // Gunakan DB transaction: jika salah satu gagal, semua di-rollback
        DB::transaction(function () use ($data, $request, $ruangan) {
            $peminjaman = Peminjaman::create([
                ...$data,
                'user_id' => $request->user()->id,
                'status'  => 'menunggu',
            ]);

            // Update status ruangan → 'sudah ada yg mengajukan'
            $ruangan->update(['status' => 'sudah ada yg mengajukan']);

            $this->peminjaman = $peminjaman; // Simpan sementara untuk return
        });

        return response()->json([
            'success' => true,
            'message' => 'Pengajuan peminjaman berhasil dikirim. Menunggu persetujuan admin.',
            'data'    => $this->formatPeminjaman(
                Peminjaman::with(['ruangan'])->find($this->peminjaman->id)
            ),
        ], 201);
    }

    /**
     * PUT /api/peminjaman/{id}/setujui  [Admin Only]
     *
     * Admin menyetujui pengajuan peminjaman.
     * Otomatis:
     *   - Ubah status peminjaman → 'disetujui'
     *   - Ubah status ruangan   → 'sudah dipinjam'
     *   - Kirim notifikasi ke user
     */
    public function setujui(Request $request, int $id)
    {
        $peminjaman = Peminjaman::with('ruangan')->find($id);

        if (!$peminjaman) {
            return response()->json(['success' => false, 'message' => 'Peminjaman tidak ditemukan.'], 404);
        }

        if ($peminjaman->status !== 'menunggu') {
            return response()->json([
                'success' => false,
                'message' => 'Hanya pengajuan berstatus "menunggu" yang bisa disetujui.',
            ], 422);
        }

        $request->validate([
            'catatan_admin' => 'nullable|string|max:500',
        ]);

        DB::transaction(function () use ($request, $peminjaman) {
            $peminjaman->update([
                'status'         => 'disetujui',
                'admin_id'       => $request->user()->id,
                'catatan_admin'  => $request->catatan_admin,
                'diproses_pada'  => now(),
            ]);

            // Update status ruangan → 'sudah dipinjam'
            $peminjaman->ruangan->update(['status' => 'sudah dipinjam']);

            // Kirim notifikasi ke user peminjam
            Notifikasi::create([
                'user_id'       => $peminjaman->user_id,
                'peminjaman_id' => $peminjaman->id,
                'judul'         => 'Pengajuan Disetujui ✅',
                'pesan'         => "Pengajuan peminjaman {$peminjaman->ruangan->nama_ruangan} "
                                 . "pada {$peminjaman->tanggal_pinjam->format('d M Y')} "
                                 . "jam {$peminjaman->jam_mulai} - {$peminjaman->jam_selesai} "
                                 . "telah DISETUJUI.",
            ]);
        });

        return response()->json([
            'success' => true,
            'message' => 'Pengajuan berhasil disetujui.',
        ]);
    }

    /**
     * PUT /api/peminjaman/{id}/tolak  [Admin Only]
     *
     * Admin menolak pengajuan peminjaman.
     * Otomatis:
     *   - Ubah status peminjaman → 'ditolak'
     *   - Ubah status ruangan   → 'tersedia' (dikembalikan)
     *   - Kirim notifikasi ke user
     */
    public function tolak(Request $request, int $id)
    {
        $peminjaman = Peminjaman::with('ruangan')->find($id);

        if (!$peminjaman) {
            return response()->json(['success' => false, 'message' => 'Peminjaman tidak ditemukan.'], 404);
        }

        if ($peminjaman->status !== 'menunggu') {
            return response()->json([
                'success' => false,
                'message' => 'Hanya pengajuan berstatus "menunggu" yang bisa ditolak.',
            ], 422);
        }

        $request->validate([
            'catatan_admin' => 'required|string|max:500', // Alasan penolakan wajib diisi
        ]);

        DB::transaction(function () use ($request, $peminjaman) {
            $peminjaman->update([
                'status'        => 'ditolak',
                'admin_id'      => $request->user()->id,
                'catatan_admin' => $request->catatan_admin,
                'diproses_pada' => now(),
            ]);

            // Kembalikan status ruangan ke 'tersedia'
            $peminjaman->ruangan->update(['status' => 'tersedia']);

            // Kirim notifikasi ke user peminjam
            Notifikasi::create([
                'user_id'       => $peminjaman->user_id,
                'peminjaman_id' => $peminjaman->id,
                'judul'         => 'Pengajuan Ditolak ❌',
                'pesan'         => "Pengajuan peminjaman {$peminjaman->ruangan->nama_ruangan} "
                                 . "pada {$peminjaman->tanggal_pinjam->format('d M Y')} "
                                 . "DITOLAK. Alasan: {$request->catatan_admin}",
            ]);
        });

        return response()->json([
            'success' => true,
            'message' => 'Pengajuan berhasil ditolak.',
        ]);
    }

    /**
     * DELETE /api/peminjaman/{id}  [User Auth Required]
     *
     * User membatalkan pengajuannya sendiri (hanya jika masih 'menunggu').
     */
    public function cancel(Request $request, int $id)
    {
        $peminjaman = Peminjaman::with('ruangan')->find($id);

        if (!$peminjaman) {
            return response()->json(['success' => false, 'message' => 'Peminjaman tidak ditemukan.'], 404);
        }

        // User hanya bisa batalkan miliknya
        if ($peminjaman->user_id !== $request->user()->id) {
            return response()->json(['success' => false, 'message' => 'Akses ditolak.'], 403);
        }

        if ($peminjaman->status !== 'menunggu') {
            return response()->json([
                'success' => false,
                'message' => 'Hanya pengajuan berstatus "menunggu" yang bisa dibatalkan.',
            ], 422);
        }

        DB::transaction(function () use ($peminjaman) {
            $peminjaman->update(['status' => 'dibatalkan']);

            // Kembalikan status ruangan ke 'tersedia'
            $peminjaman->ruangan->update(['status' => 'tersedia']);
        });

        return response()->json([
            'success' => true,
            'message' => 'Pengajuan berhasil dibatalkan.',
        ]);
    }

    /**
     * Helper: Format data Peminjaman ke array untuk Flutter.
     */
    private function formatPeminjaman(Peminjaman $p, bool $detail = false): array
    {
        $data = [
            'id'             => $p->id,
            'keperluan'      => $p->keperluan,
            'tanggal_pinjam' => $p->tanggal_pinjam?->format('Y-m-d'),
            'jam_mulai'      => $p->jam_mulai,
            'jam_selesai'    => $p->jam_selesai,
            'status'         => $p->status,
            'ruangan'        => $p->ruangan ? [
                'id'           => $p->ruangan->id,
                'nama_ruangan' => $p->ruangan->nama_ruangan,
                'gedung'       => $p->ruangan->gedung,
                'lantai'       => $p->ruangan->lantai,
            ] : null,
            'created_at' => $p->created_at?->format('Y-m-d H:i'),
        ];

        if ($detail) {
            $data['jumlah_peserta'] = $p->jumlah_peserta;
            $data['catatan_user']   = $p->catatan_user;
            $data['catatan_admin']  = $p->catatan_admin;
            $data['diproses_pada']  = $p->diproses_pada?->format('Y-m-d H:i');
            $data['user']           = $p->user ? [
                'id'      => $p->user->id,
                'nama'    => $p->user->nama,
                'nim_nip' => $p->user->nim_nip,
            ] : null;
            $data['admin'] = $p->admin ? [
                'id'   => $p->admin->id,
                'nama' => $p->admin->nama,
            ] : null;
        }

        return $data;
    }
}
