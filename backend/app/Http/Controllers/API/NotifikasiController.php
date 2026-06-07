<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Notifikasi;
use Illuminate\Http\Request;

/**
 * Controller: NotifikasiController
 *
 * Mengelola notifikasi untuk user.
 * Digunakan di tab "Notification" di AppBottomNav Flutter.
 *
 * Endpoint:
 *   GET  /api/notifikasi             → index()     — Daftar notifikasi user
 *   GET  /api/notifikasi/unread-count → unreadCount()— Jumlah belum dibaca (untuk badge)
 *   PUT  /api/notifikasi/{id}/baca   → markRead()  — Tandai satu notifikasi sebagai dibaca
 *   PUT  /api/notifikasi/baca-semua  → markAllRead()— Tandai semua sebagai dibaca
 */
class NotifikasiController extends Controller
{
    /**
     * GET /api/notifikasi
     *
     * Daftar notifikasi milik user yang sedang login.
     * Diurutkan dari terbaru ke terlama.
     */
    public function index(Request $request)
    {
        $notifikasi = Notifikasi::where('user_id', $request->user()->id)
            ->orderBy('created_at', 'desc')
            ->paginate(20);

        return response()->json([
            'success' => true,
            'data'    => $notifikasi->map(fn($n) => [
                'id'            => $n->id,
                'judul'         => $n->judul,
                'pesan'         => $n->pesan,
                'sudah_dibaca'  => $n->sudah_dibaca,
                'peminjaman_id' => $n->peminjaman_id,
                'created_at'    => $n->created_at?->format('Y-m-d H:i'),
            ]),
            'pagination' => [
                'current_page' => $notifikasi->currentPage(),
                'last_page'    => $notifikasi->lastPage(),
                'total'        => $notifikasi->total(),
            ],
        ]);
    }

    /**
     * GET /api/notifikasi/unread-count
     *
     * Mengembalikan jumlah notifikasi yang belum dibaca.
     * Digunakan untuk menampilkan badge angka di ikon notifikasi.
     */
    public function unreadCount(Request $request)
    {
        $count = Notifikasi::where('user_id', $request->user()->id)
            ->belumDibaca()
            ->count();

        return response()->json([
            'success' => true,
            'data'    => ['unread_count' => $count],
        ]);
    }

    /**
     * PUT /api/notifikasi/{id}/baca
     *
     * Tandai satu notifikasi sebagai sudah dibaca.
     */
    public function markRead(Request $request, int $id)
    {
        $notifikasi = Notifikasi::where('id', $id)
            ->where('user_id', $request->user()->id) // Pastikan milik user ini
            ->first();

        if (!$notifikasi) {
            return response()->json(['success' => false, 'message' => 'Notifikasi tidak ditemukan.'], 404);
        }

        $notifikasi->update([
            'sudah_dibaca' => true,
            'dibaca_pada'  => now(),
        ]);

        return response()->json(['success' => true, 'message' => 'Notifikasi ditandai sudah dibaca.']);
    }

    /**
     * PUT /api/notifikasi/baca-semua
     *
     * Tandai semua notifikasi user sebagai sudah dibaca.
     * (Dipanggil saat user klik "Baca Semua" di halaman notifikasi)
     */
    public function markAllRead(Request $request)
    {
        Notifikasi::where('user_id', $request->user()->id)
            ->belumDibaca()
            ->update([
                'sudah_dibaca' => true,
                'dibaca_pada'  => now(),
            ]);

        return response()->json(['success' => true, 'message' => 'Semua notifikasi ditandai sudah dibaca.']);
    }
}
