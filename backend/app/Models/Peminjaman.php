<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * Model: Peminjaman
 *
 * Model inti aplikasi. Merepresentasikan satu transaksi peminjaman ruangan.
 *
 * Alur Bisnis:
 * 1. User mengajukan peminjaman → status: 'menunggu'
 * 2. Admin melihat daftar menunggu → status ruangan: 'sudah ada yg mengajukan'
 * 3a. Admin menyetujui → status peminjaman: 'disetujui', status ruangan: 'sudah dipinjam'
 * 3b. Admin menolak   → status peminjaman: 'ditolak',   status ruangan: 'tersedia' lagi
 * 4. Setelah tanggal lewat → status bisa diubah ke 'selesai'
 *
 * Catatan: Perubahan status ruangan dilakukan di PeminjamanController,
 * bukan di sini, supaya logika bisnis terpusat.
 */
class Peminjaman extends Model
{
    use HasFactory;

    protected $table = 'peminjaman';

    protected $fillable = [
        'user_id',
        'ruangan_id',
        'admin_id',
        'keperluan',
        'tanggal_pinjam',
        'jam_mulai',
        'jam_selesai',
        'jumlah_peserta',
        'status',
        'catatan_user',
        'catatan_admin',
        'diproses_pada',
    ];

    protected $casts = [
        'tanggal_pinjam'  => 'date',        // Otomatis jadi Carbon date object
        'jam_mulai'       => 'datetime:H:i', // Format jam HH:MM
        'jam_selesai'     => 'datetime:H:i',
        'jumlah_peserta'  => 'integer',
        'diproses_pada'   => 'datetime',
    ];

    // =====================================
    //  QUERY SCOPES
    // =====================================

    /**
     * Scope: Filter peminjaman yang statusnya 'menunggu'.
     * Untuk halaman admin yang melihat pengajuan baru.
     */
    public function scopeMenunggu($query)
    {
        return $query->where('status', 'menunggu');
    }

    /**
     * Scope: Filter peminjaman berdasarkan user_id.
     * Untuk halaman "Status Peminjaman" dan "Histori" milik user.
     */
    public function scopeMilikUser($query, int $userId)
    {
        return $query->where('user_id', $userId);
    }

    // =====================================
    //  RELASI ELOQUENT
    // =====================================

    /**
     * Peminjaman ini dilakukan oleh satu User (peminjam).
     * Dipanggil: $peminjaman->user
     */
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    /**
     * Peminjaman ini untuk satu Ruangan tertentu.
     * Dipanggil: $peminjaman->ruangan
     */
    public function ruangan()
    {
        return $this->belongsTo(Ruangan::class, 'ruangan_id');
    }

    /**
     * Peminjaman ini diproses oleh satu Admin (User dengan role admin).
     * Dipanggil: $peminjaman->admin
     */
    public function admin()
    {
        return $this->belongsTo(User::class, 'admin_id');
    }
}
