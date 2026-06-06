<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Middleware: RoleMiddleware
 *
 * Memproteksi route berdasarkan role user.
 * Dipakai di routes/api.php dengan cara: middleware('role:admin')
 *
 * Cara kerja:
 * 1. Request masuk → Sanctum sudah autentikasi (middleware 'auth:sanctum' jalan dulu)
 * 2. RoleMiddleware cek apakah role user cocok dengan yang dibutuhkan route
 * 3. Jika cocok → lanjut ke controller
 * 4. Jika tidak → return 403 Forbidden
 *
 * Pendaftaran middleware ada di bootstrap/app.php (Laravel 11+)
 * atau di app/Http/Kernel.php (Laravel 10 ke bawah).
 */
class RoleMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param string|null ...$roles Role yang diizinkan, contoh: 'admin'
     */
    public function handle(Request $request, Closure $next, string ...$roles): Response
    {
        $user = $request->user();

        // Pastikan user sudah login (seharusnya sudah dijamin oleh auth:sanctum)
        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthenticated.',
            ], 401);
        }

        // Cek apakah role user ada di daftar role yang diizinkan
        if (!in_array($user->role, $roles)) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak. Anda tidak memiliki izin untuk melakukan ini.',
            ], 403);
        }

        return $next($request);
    }
}
