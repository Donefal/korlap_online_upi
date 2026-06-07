<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Ruangan;
use Illuminate\Http\Request;

/**
 * Controller: RuanganController
 *
 * Mengelola data ruangan yang ditampilkan di widget RuanganCard (list_gedung.dart).
 *
 * Endpoint:
 *   GET  /api/ruangan           → index()  — Daftar semua ruangan (dengan filter)
 *   GET  /api/ruangan/{id}      → show()   — Detail satu ruangan
 *   POST /api/ruangan           → store()  — Tambah ruangan baru (admin only)
 *   PUT  /api/ruangan/{id}      → update() — Update data ruangan (admin only)
 *   DELETE /api/ruangan/{id}    → destroy()— Hapus ruangan (admin only)
 *
 * Semua endpoint GET bisa diakses user biasa (setelah login).
 * POST/PUT/DELETE hanya untuk admin (dicek via middleware 'role:admin').
 */
class RuanganController extends Controller
{
    /**
     * GET /api/ruangan
     *
     * Mengembalikan daftar ruangan. Mendukung query parameter:
     *   ?gedung=FPMIPA          → filter per gedung
     *   ?status=tersedia        → filter per status
     *   ?jenis=Laboratorium     → filter per jenis
     *   ?search=lab             → cari berdasarkan nama ruangan
     *
     * Response: Array of RuanganItem-compatible objects
     * Dipetakan ke RuanganItem di list_gedung.dart:
     *   id, gedung, lantai, nama_ruangan, status, jenis_ruangan
     */
    public function index(Request $request)
    {
        $query = Ruangan::aktif(); // Hanya tampil yang aktif

        // Filter opsional dari query string URL
        if ($request->filled('gedung')) {
            $query->where('gedung', $request->gedung);
        }

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        if ($request->filled('jenis')) {
            $query->where('jenis_ruangan', $request->jenis);
        }

        if ($request->filled('search')) {
            $query->where('nama_ruangan', 'like', '%' . $request->search . '%');
        }

        $ruangan = $query->orderBy('gedung')->orderBy('lantai')->get();

        return response()->json([
            'success' => true,
            'data'    => $ruangan->map(fn($r) => $this->formatRuangan($r)),
        ]);
    }

    /**
     * GET /api/ruangan/{id}
     *
     * Detail satu ruangan beserta peminjaman aktif-nya.
     */
    public function show(int $id)
    {
        $ruangan = Ruangan::find($id);

        if (!$ruangan) {
            return response()->json(['success' => false, 'message' => 'Ruangan tidak ditemukan.'], 404);
        }

        return response()->json([
            'success' => true,
            'data'    => $this->formatRuangan($ruangan, detail: true),
        ]);
    }

    /**
     * POST /api/ruangan  [Admin Only]
     *
     * Menambahkan ruangan baru.
     *
     * Request body (JSON):
     * {
     *   "nama_ruangan": "Lab RPL",
     *   "gedung": "FPMIPA",
     *   "lantai": 3,
     *   "jenis_ruangan": "Laboratorium",
     *   "kapasitas": 40,
     *   "fasilitas": "AC, Proyektor, Komputer x40"
     * }
     */
    public function store(Request $request)
    {
        $data = $request->validate([
            'nama_ruangan'  => 'required|string|max:255',
            'gedung'        => 'required|string|max:100',
            'lantai'        => 'required|integer|min:1',
            'jenis_ruangan' => 'required|in:Laboratorium,Ruang Kelas,Aula,Ruang Rapat,Lainnya',
            'kapasitas'     => 'nullable|integer|min:1',
            'fasilitas'     => 'nullable|string',
            'deskripsi'     => 'nullable|string',
        ]);

        $ruangan = Ruangan::create($data);

        return response()->json([
            'success' => true,
            'message' => 'Ruangan berhasil ditambahkan.',
            'data'    => $this->formatRuangan($ruangan),
        ], 201);
    }

    /**
     * PUT /api/ruangan/{id}  [Admin Only]
     *
     * Mengupdate data ruangan (termasuk mengubah status secara manual).
     */
    public function update(Request $request, int $id)
    {
        $ruangan = Ruangan::find($id);

        if (!$ruangan) {
            return response()->json(['success' => false, 'message' => 'Ruangan tidak ditemukan.'], 404);
        }

        $data = $request->validate([
            'nama_ruangan'  => 'sometimes|string|max:255',
            'gedung'        => 'sometimes|string|max:100',
            'lantai'        => 'sometimes|integer|min:1',
            'jenis_ruangan' => 'sometimes|in:Laboratorium,Ruang Kelas,Aula,Ruang Rapat,Lainnya',
            'status'        => 'sometimes|in:tersedia,sudah dipinjam,sudah ada yg mengajukan',
            'kapasitas'     => 'nullable|integer|min:1',
            'fasilitas'     => 'nullable|string',
            'deskripsi'     => 'nullable|string',
            'is_active'     => 'sometimes|boolean',
        ]);

        $ruangan->update($data);

        return response()->json([
            'success' => true,
            'message' => 'Ruangan berhasil diperbarui.',
            'data'    => $this->formatRuangan($ruangan->fresh()),
        ]);
    }

    /**
     * DELETE /api/ruangan/{id}  [Admin Only]
     *
     * Menghapus (soft-deactivate) ruangan.
     * Rekomendasi: jangan hapus permanen, tapi set is_active = false.
     */
    public function destroy(int $id)
    {
        $ruangan = Ruangan::find($id);

        if (!$ruangan) {
            return response()->json(['success' => false, 'message' => 'Ruangan tidak ditemukan.'], 404);
        }

        // Soft-delete: matikan saja, bukan hapus dari DB
        $ruangan->update(['is_active' => false]);

        return response()->json([
            'success' => true,
            'message' => 'Ruangan berhasil dinonaktifkan.',
        ]);
    }

    /**
     * Helper: Format data Ruangan menjadi array yang sesuai dengan RuanganItem Flutter.
     *
     * @param bool $detail Jika true, sertakan fasilitas dan deskripsi.
     */
    private function formatRuangan(Ruangan $ruangan, bool $detail = false): array
    {
        $data = [
            'id'            => $ruangan->id,
            'nama_ruangan'  => $ruangan->nama_ruangan,  // => RuanganItem.namaRuangan
            'gedung'        => $ruangan->gedung,         // => RuanganItem.gedung
            'lantai'        => $ruangan->lantai,         // => RuanganItem.lantai
            'jenis_ruangan' => $ruangan->jenis_ruangan,  // => RuanganItem.jenisRuangan
            'status'        => $ruangan->status,         // => RuanganItem.status
            'kapasitas'     => $ruangan->kapasitas,
        ];

        if ($detail) {
            $data['fasilitas']  = $ruangan->fasilitas;
            $data['deskripsi']  = $ruangan->deskripsi;
        }

        return $data;
    }
}
