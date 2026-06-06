<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

/**
 * Controller: AuthController
 *
 * Menangani proses autentikasi: login, register, logout, dan ambil profil.
 *
 * Menggunakan Laravel Sanctum (token-based auth), cocok untuk Flutter
 * karena Flutter tidak bisa menyimpan session cookie seperti browser web.
 *
 * Alur Login di Flutter (session_provider.dart):
 * 1. User ketik NIM + password di LoginPage
 * 2. Flutter POST ke /api/auth/login
 * 3. Backend validasi, kirim balik: { token, role, user: {...} }
 * 4. Flutter simpan token + role ke SharedPreferences via SessionProvider.login()
 * 5. Flutter lampirkan token di setiap request berikutnya (Header: Authorization: Bearer {token})
 */
class AuthController extends Controller
{
    /**
     * POST /api/auth/login
     *
     * Menerima NIM/NIP + password, memvalidasi, dan mengembalikan token akses.
     *
     * Request body (JSON):
     * {
     *   "nim_nip": "1234567890",
     *   "password": "rahasia123"
     * }
     *
     * Response sukses (200):
     * {
     *   "success": true,
     *   "message": "Login berhasil",
     *   "data": {
     *     "token": "1|abc123...",
     *     "role": "user",
     *     "user": { "id": 1, "nama": "Budi", "nim_nip": "...", ... }
     *   }
     * }
     *
     * Di Flutter, token dan role ini disimpan ke SharedPreferences.
     * Dipetakan dari TODO di session_provider.dart:
     *   "Login nanti konek ke database dlu untuk ambil token (id user) sama role nya"
     */
    public function login(Request $request)
    {
        // Validasi input — jika gagal, Laravel otomatis return 422 dengan pesan error
        $request->validate([
            'nim_nip'  => 'required|string',
            'password' => 'required|string',
        ]);

        // Cari user berdasarkan nim_nip
        $user = User::where('nim_nip', $request->nim_nip)->first();

        // Jika user tidak ditemukan ATAU password salah
        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'NIM/NIP atau password salah.',
            ], 401); // 401 = Unauthorized
        }

        // Cek akun masih aktif
        if (!$user->is_active) {
            return response()->json([
                'success' => false,
                'message' => 'Akun Anda telah dinonaktifkan. Hubungi admin.',
            ], 403); // 403 = Forbidden
        }

        // Hapus token lama (opsional, agar tidak menumpuk)
        $user->tokens()->delete();

        // Buat token baru dengan nama device (untuk audit log)
        $token = $user->createToken('flutter-app')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Login berhasil.',
            'data'    => [
                'token' => $token,  // Ini yang disimpan di SessionProvider._token
                'role'  => $user->role, // Ini yang disimpan di SessionProvider._role
                'user'  => [
                    'id'       => $user->id,
                    'nama'     => $user->nama,
                    'nim_nip'  => $user->nim_nip,
                    'email'    => $user->email,
                    'jurusan'  => $user->jurusan,
                    'fakultas' => $user->fakultas,
                    'role'     => $user->role,
                ],
            ],
        ]);
    }

    /**
     * POST /api/auth/register
     *
     * Mendaftarkan akun baru (role default: 'user' / mahasiswa).
     * Admin dibuat manual oleh superadmin, tidak melalui endpoint ini.
     *
     * Request body (JSON):
     * {
     *   "nim_nip": "1234567890",
     *   "nama": "Budi Santoso",
     *   "email": "budi@upi.edu",       (opsional)
     *   "password": "rahasia123",
     *   "password_confirmation": "rahasia123",
     *   "jurusan": "Ilmu Komputer",     (opsional)
     *   "fakultas": "FPMIPA"            (opsional)
     * }
     */
    public function register(Request $request)
    {
        $request->validate([
            'nim_nip'  => 'required|string|unique:users,nim_nip',
            'nama'     => 'required|string|max:255',
            'email'    => 'nullable|email|unique:users,email',
            'password' => 'required|string|min:6|confirmed', // 'confirmed' = harus ada 'password_confirmation'
            'jurusan'  => 'nullable|string|max:100',
            'fakultas' => 'nullable|string|max:100',
        ]);

        $user = User::create([
            'nim_nip'  => $request->nim_nip,
            'nama'     => $request->nama,
            'email'    => $request->email,
            'password' => $request->password, // Model sudah casting 'hashed', tidak perlu Hash::make()
            'jurusan'  => $request->jurusan,
            'fakultas' => $request->fakultas,
            'role'     => 'user', // Selalu 'user' untuk registrasi mandiri
        ]);

        $token = $user->createToken('flutter-app')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Registrasi berhasil.',
            'data'    => [
                'token' => $token,
                'role'  => $user->role,
                'user'  => [
                    'id'      => $user->id,
                    'nama'    => $user->nama,
                    'nim_nip' => $user->nim_nip,
                    'email'   => $user->email,
                    'role'    => $user->role,
                ],
            ],
        ], 201); // 201 = Created
    }

    /**
     * POST /api/auth/logout  [Butuh Auth Token]
     *
     * Menghapus token saat ini dari database (invalidate token).
     * Dipanggil dari Flutter saat user menekan tombol Logout.
     *
     * Setelah ini, Flutter harus memanggil SessionProvider.logout()
     * untuk menghapus token dan role dari SharedPreferences.
     */
    public function logout(Request $request)
    {
        // Hapus token yang sedang dipakai
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logout berhasil.',
        ]);
    }

    /**
     * GET /api/auth/me  [Butuh Auth Token]
     *
     * Mengembalikan data profil user yang sedang login.
     * Header: Authorization: Bearer {token}
     */
    public function me(Request $request)
    {
        $user = $request->user();

        return response()->json([
            'success' => true,
            'data'    => [
                'id'       => $user->id,
                'nama'     => $user->nama,
                'nim_nip'  => $user->nim_nip,
                'email'    => $user->email,
                'jurusan'  => $user->jurusan,
                'fakultas' => $user->fakultas,
                'role'     => $user->role,
            ],
        ]);
    }
}
