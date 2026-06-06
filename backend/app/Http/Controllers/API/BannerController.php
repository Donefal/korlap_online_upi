<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Banner;
use Illuminate\Http\Request;

/**
 * Controller: BannerController
 *
 * Mengelola data banner untuk BannerCarousel di Flutter.
 *
 * Endpoint:
 *   GET  /api/banners        → index()  — Daftar banner aktif (tanpa auth, publik)
 *   POST /api/banners        → store()  — Tambah banner (admin)
 *   PUT  /api/banners/{id}   → update() — Edit banner (admin)
 *   DELETE /api/banners/{id} → destroy()— Hapus banner (admin)
 *
 * Response format sesuai BannerItem model di Flutter (models/banner_item.dart):
 *   teks         => BannerItem.text
 *   image_url    => BannerItem.imageUrl
 *   warna_latar  => String hex seperti "FF5733" (tanpa #)
 */
class BannerController extends Controller
{
    /**
     * GET /api/banners
     *
     * Mengembalikan semua banner yang aktif, sudah diurutkan.
     * Endpoint ini TIDAK perlu autentikasi (diakses saat pertama buka app).
     */
    public function index()
    {
        $banners = Banner::aktif()->get();

        return response()->json([
            'success' => true,
            'data'    => $banners->map(fn($b) => [
                'id'          => $b->id,
                'teks'        => $b->teks,
                'image_url'   => $b->image_url,
                'warna_latar' => $b->warna_latar, // Hex string, e.g. "2196F3"
            ]),
        ]);
    }

    /**
     * POST /api/banners  [Admin Only]
     *
     * Request body:
     * {
     *   "teks": "Selamat Datang di Korlap Online",
     *   "image_url": null,              (opsional)
     *   "warna_latar": "FF8800",        (opsional, hex tanpa #)
     *   "urutan": 1
     * }
     */
    public function store(Request $request)
    {
        $data = $request->validate([
            'teks'        => 'required|string|max:255',
            'image_url'   => 'nullable|url',
            'warna_latar' => 'nullable|string|max:7', // Max 6 hex chars + opsional #
            'urutan'      => 'nullable|integer|min:0',
        ]);

        // Bersihkan karakter '#' jika ada
        if (isset($data['warna_latar'])) {
            $data['warna_latar'] = ltrim($data['warna_latar'], '#');
        }

        $banner = Banner::create($data);

        return response()->json([
            'success' => true,
            'message' => 'Banner berhasil ditambahkan.',
            'data'    => $banner,
        ], 201);
    }

    /**
     * PUT /api/banners/{id}  [Admin Only]
     */
    public function update(Request $request, int $id)
    {
        $banner = Banner::find($id);
        if (!$banner) {
            return response()->json(['success' => false, 'message' => 'Banner tidak ditemukan.'], 404);
        }

        $data = $request->validate([
            'teks'        => 'sometimes|string|max:255',
            'image_url'   => 'nullable|url',
            'warna_latar' => 'nullable|string|max:7',
            'urutan'      => 'sometimes|integer|min:0',
            'is_active'   => 'sometimes|boolean',
        ]);

        if (isset($data['warna_latar'])) {
            $data['warna_latar'] = ltrim($data['warna_latar'], '#');
        }

        $banner->update($data);

        return response()->json([
            'success' => true,
            'message' => 'Banner berhasil diperbarui.',
            'data'    => $banner->fresh(),
        ]);
    }

    /**
     * DELETE /api/banners/{id}  [Admin Only]
     */
    public function destroy(int $id)
    {
        $banner = Banner::find($id);
        if (!$banner) {
            return response()->json(['success' => false, 'message' => 'Banner tidak ditemukan.'], 404);
        }

        $banner->delete();

        return response()->json([
            'success' => true,
            'message' => 'Banner berhasil dihapus.',
        ]);
    }
}
