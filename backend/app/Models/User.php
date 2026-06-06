<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

/**
 * Model: User
 *
 * Representasi tabel 'users' dalam bentuk objek PHP.
 * Menggunakan Laravel Sanctum untuk autentikasi token berbasis API
 * (karena Flutter menggunakan token, bukan session cookie).
 *
 * HasApiTokens  => Memberikan kemampuan generate/revoke token Sanctum
 * Authenticatable => Menjadikan model ini sebagai "user yang bisa login"
 * Notifiable    => Untuk Laravel Notification system (email, dll)
 *
 * Properti Penting:
 * - $fillable: Kolom yang boleh diisi massal (mass assignment) via create()/fill()
 * - $hidden:   Kolom yang disembunyikan saat model di-serialize ke JSON (tidak keluar di API response)
 * - $casts:    Otomatis mengkonversi tipe data kolom (string DB → tipe PHP yang tepat)
 */
class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $table = 'users'; // Nama tabel di database

    /**
     * Kolom yang boleh diisi massal.
     * Ini adalah pelindung dari "mass assignment vulnerability".
     */
    protected $fillable = [
        'nim_nip',
        'nama',
        'email',
        'password',
        'role',
        'jurusan',
        'fakultas',
        'is_active',
    ];

    /**
     * Kolom yang DISEMBUNYIKAN dari JSON response.
     * Password dan token jangan pernah dikirim ke Flutter!
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Konversi tipe otomatis:
     * - 'email_verified_at' → Carbon (objek tanggal PHP) atau null
     * - 'password' → akan di-hash otomatis saat di-set (Laravel 10+)
     * - 'is_active' → boolean PHP (true/false)
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
        'is_active' => 'boolean',
    ];

    // =====================================
    //  HELPER METHODS (logika role)
    // =====================================

    /**
     * Cek apakah user adalah admin.
     * Dipanggil: $user->isAdmin()
     * Sesuai dengan logika session_provider.dart -> get isAdmin => _role == 'admin'
     */
    public function isAdmin(): bool
    {
        return $this->role === 'admin';
    }

    /**
     * Cek apakah user adalah mahasiswa biasa.
     * Dipanggil: $user->isUser()
     */
    public function isUser(): bool
    {
        return $this->role === 'user';
    }

    // =====================================
    //  RELASI ELOQUENT
    // =====================================

    /**
     * Relasi: User memiliki banyak Peminjaman (sebagai peminjam).
     * Dipanggil: $user->peminjaman
     */
    public function peminjaman()
    {
        return $this->hasMany(Peminjaman::class, 'user_id');
    }

    /**
     * Relasi: User memiliki banyak Notifikasi.
     * Dipanggil: $user->notifikasi
     */
    public function notifikasi()
    {
        return $this->hasMany(Notifikasi::class, 'user_id');
    }
}
