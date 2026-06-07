<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * Model: Banner
 *
 * Merepresentasikan data banner untuk widget BannerCarousel di Flutter.
 *
 * Pemetaan ke Flutter BannerItem (models/banner_item.dart):
 *   banners.teks        => BannerItem.text
 *   banners.image_url   => BannerItem.imageUrl
 *   banners.warna_latar => BannerItem.backgroundColor (dikirim sebagai hex string)
 *
 * Catatan warna_latar:
 * Di Flutter, Color tidak bisa langsung dibuat dari hex string.
 * Flutter perlu: Color(int.parse('0xFF' + hexKode))
 * Jadi format yang dikirim API sebaiknya: "2196F3" (tanpa #)
 * Lalu di Flutter: Color(int.parse('0xFF$warnaLatar'))
 */
class Banner extends Model
{
    use HasFactory;

    protected $table = 'banners';

    protected $fillable = [
        'teks',
        'image_url',
        'warna_latar',
        'urutan',
        'is_active',
    ];

    protected $casts = [
        'urutan'    => 'integer',
        'is_active' => 'boolean',
    ];

    /**
     * Scope: Ambil banner yang aktif, diurutkan.
     * Penggunaan: Banner::aktif()->get()
     */
    public function scopeAktif($query)
    {
        return $query->where('is_active', true)->orderBy('urutan');
    }
}
