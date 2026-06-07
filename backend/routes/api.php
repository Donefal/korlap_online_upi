<?php

use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\BannerController;
use App\Http\Controllers\API\NotifikasiController;
use App\Http\Controllers\API\PeminjamanController;
use App\Http\Controllers\API\RuanganController;
use Illuminate\Support\Facades\Route;

/**
 * routes/api.php — Definisi semua API endpoint
 *
 * Semua route di file ini diawali dengan prefix /api/
 * (dikonfigurasi di bootstrap/app.php atau RouteServiceProvider)
 *
 * Struktur proteksi:
 * ┌─────────────────────────────────┬──────────────────────────┐
 * │ Route Group                     │ Middleware               │
 * ├─────────────────────────────────┼──────────────────────────┤
 * │ Publik (tanpa login)            │ -                        │
 * │ User Biasa                      │ auth:sanctum             │
 * │ Admin Only                      │ auth:sanctum + role:admin│
 * └─────────────────────────────────┴──────────────────────────┘
 *
 * auth:sanctum  = cek token Bearer di header Authorization
 * role:admin    = cek field 'role' di tabel users == 'admin'
 */

// =====================================================================
// PUBLIK — Tidak perlu login
// =====================================================================
// Diakses saat app pertama dibuka, sebelum user login

Route::prefix('auth')->group(function () {
    // POST /api/auth/login
    // Body: { nim_nip, password }
    // Return: { token, role, user: {...} }
    // Dipetakan dari TODO di session_provider.dart: login() yang menyimpan token & role
    Route::post('login', [AuthController::class, 'login']);

    // POST /api/auth/register
    // Body: { nim_nip, nama, email?, password, password_confirmation, jurusan?, fakultas? }
    Route::post('register', [AuthController::class, 'register']);
});

// GET /api/banners — Diakses saat home screen pertama load
Route::get('banners', [BannerController::class, 'index']);

// GET /api/ruangan — List ruangan bisa dilihat tanpa login juga
Route::get('ruangan', [RuanganController::class, 'index']);
Route::get('ruangan/{id}', [RuanganController::class, 'show']);


// =====================================================================
// AUTHENTICATED — Perlu login (token Bearer)
// Header: Authorization: Bearer {token_dari_login}
// =====================================================================

Route::middleware('auth:sanctum')->group(function () {

    // --- Auth Routes ---
    Route::prefix('auth')->group(function () {
        // POST /api/auth/logout — Hapus token (invalidate)
        Route::post('logout', [AuthController::class, 'logout']);

        // GET /api/auth/me — Ambil profil user yang sedang login
        Route::get('me', [AuthController::class, 'me']);
    });

    // --- Peminjaman Routes (User & Admin) ---
    // GET /api/peminjaman
    //   User  → daftar peminjaman milik dirinya
    //   Admin → semua peminjaman (query ?status=menunggu untuk filter)
    Route::get('peminjaman', [PeminjamanController::class, 'index']);

    // GET /api/peminjaman/{id}
    Route::get('peminjaman/{id}', [PeminjamanController::class, 'show']);

    // POST /api/peminjaman — User mengajukan peminjaman baru
    Route::post('peminjaman', [PeminjamanController::class, 'store']);

    // DELETE /api/peminjaman/{id} — User membatalkan pengajuannya
    Route::delete('peminjaman/{id}', [PeminjamanController::class, 'cancel']);

    // --- Notifikasi Routes (User) ---
    // GET /api/notifikasi
    Route::get('notifikasi', [NotifikasiController::class, 'index']);

    // GET /api/notifikasi/unread-count
    Route::get('notifikasi/unread-count', [NotifikasiController::class, 'unreadCount']);

    // PUT /api/notifikasi/{id}/baca
    Route::put('notifikasi/{id}/baca', [NotifikasiController::class, 'markRead']);

    // PUT /api/notifikasi/baca-semua
    Route::put('notifikasi/baca-semua', [NotifikasiController::class, 'markAllRead']);


    // ===================================================================
    // ADMIN ONLY — Perlu login DAN role == 'admin'
    // Dipetakan dari kondisi isAdmin di session_provider.dart & auth_gate.dart
    // ===================================================================

    Route::middleware('role:admin')->group(function () {

        // Admin: Kelola Ruangan
        // POST   /api/admin/ruangan
        // PUT    /api/admin/ruangan/{id}
        // DELETE /api/admin/ruangan/{id}
        Route::prefix('admin')->group(function () {
            Route::post('ruangan', [RuanganController::class, 'store']);
            Route::put('ruangan/{id}', [RuanganController::class, 'update']);
            Route::delete('ruangan/{id}', [RuanganController::class, 'destroy']);

            // Admin: Proses Pengajuan Peminjaman
            // PUT /api/admin/peminjaman/{id}/setujui
            // PUT /api/admin/peminjaman/{id}/tolak
            Route::put('peminjaman/{id}/setujui', [PeminjamanController::class, 'setujui']);
            Route::put('peminjaman/{id}/tolak', [PeminjamanController::class, 'tolak']);

            // Admin: Kelola Banner
            Route::post('banners', [BannerController::class, 'store']);
            Route::put('banners/{id}', [BannerController::class, 'update']);
            Route::delete('banners/{id}', [BannerController::class, 'destroy']);
        });
    });
});
