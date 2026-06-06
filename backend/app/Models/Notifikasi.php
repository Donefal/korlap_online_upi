<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * Model: Notifikasi
 *
 * Menyimpan notifikasi per-user.
 * Dibuat otomatis oleh backend saat status peminjaman berubah.
 *
 * Di Flutter, notifikasi ini akan ditampilkan di tab "Notification"
 * yang ada di AppBottomNav (navbar_bawah.dart).
 */
class Notifikasi extends Model
{
    use HasFactory;

    protected $table = 'notifikasi';

    protected $fillable = [
        'user_id',
        'peminjaman_id',
        'judul',
        'pesan',
        'sudah_dibaca',
        'dibaca_pada',
    ];

    protected $casts = [
        'sudah_dibaca' => 'boolean',
        'dibaca_pada'  => 'datetime',
    ];

    /**
     * Scope: Notifikasi yang belum dibaca.
     * Untuk menampilkan badge/counter di ikon notifikasi.
     */
    public function scopeBelumDibaca($query)
    {
        return $query->where('sudah_dibaca', false);
    }

    /**
     * Relasi: Notifikasi ini milik satu User.
     */
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    /**
     * Relasi: Notifikasi ini terkait satu Peminjaman (opsional).
     */
    public function peminjaman()
    {
        return $this->belongsTo(Peminjaman::class, 'peminjaman_id');
    }
}
