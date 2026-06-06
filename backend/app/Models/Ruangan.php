<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * Model: Ruangan
 *
 * Representasi tabel 'ruangan'.
 * Model ini memetakan kolom-kolom tabel ke properti objek PHP,
 * serta mendefinisikan relasi ke tabel peminjaman.
 *
 * Pemetaan ke Flutter RuanganItem (list_gedung.dart):
 *   ruangan.id            => RuanganItem.id
 *   ruangan.gedung        => RuanganItem.gedung
 *   ruangan.lantai        => RuanganItem.lantai
 *   ruangan.nama_ruangan  => RuanganItem.namaRuangan
 *   ruangan.status        => RuanganItem.status
 *   ruangan.jenis_ruangan => RuanganItem.jenisRuangan
 */
class Ruangan extends Model
{
    use HasFactory;

    protected $table = 'ruangan';

    protected $fillable = [
        'nama_ruangan',
        'gedung',
        'lantai',
        'jenis_ruangan',
        'status',
        'kapasitas',
        'fasilitas',
        'deskripsi',
        'is_active',
    ];

    protected $casts = [
        'lantai'    => 'integer',
        'kapasitas' => 'integer',
        'is_active' => 'boolean',
    ];

    // =====================================
    //  QUERY SCOPES (filter data siap pakai)
    // =====================================

    /**
     * Scope: Hanya tampilkan ruangan yang aktif.
     * Penggunaan: Ruangan::aktif()->get()
     */
    public function scopeAktif($query)
    {
        return $query->where('is_active', true);
    }

    /**
     * Scope: Hanya tampilkan ruangan yang statusnya 'tersedia'.
     * Penggunaan: Ruangan::tersedia()->get()
     */
    public function scopeTersedia($query)
    {
        return $query->where('status', 'tersedia');
    }

    /**
     * Scope: Filter berdasarkan gedung.
     * Penggunaan: Ruangan::diGedung('FPMIPA')->get()
     */
    public function scopeDiGedung($query, string $gedung)
    {
        return $query->where('gedung', $gedung);
    }

    // =====================================
    //  RELASI ELOQUENT
    // =====================================

    /**
     * Relasi: Ruangan memiliki banyak Peminjaman.
     * Dipanggil: $ruangan->peminjaman
     */
    public function peminjaman()
    {
        return $this->hasMany(Peminjaman::class, 'ruangan_id');
    }
}
