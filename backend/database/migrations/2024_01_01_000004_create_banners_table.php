<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Migration: Membuat tabel 'banners'
 *
 * Tabel ini menyimpan data banner yang ditampilkan di BannerCarousel Flutter.
 * Admin bisa menambah/mengubah/menghapus banner dari backend.
 *
 * Pemetaan ke Flutter BannerItem model:
 *   banners.teks        => BannerItem.text
 *   banners.image_url   => BannerItem.imageUrl
 *   banners.warna_latar => BannerItem.backgroundColor (dalam format hex string, mis: "#FF5733")
 *
 * Jika image_url diisi, banner akan tampil dengan gambar (+ overlay gelap).
 * Jika image_url kosong, banner menggunakan warna solid dari warna_latar.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('banners', function (Blueprint $table) {
            $table->id();
            $table->string('teks');                                // Teks yang ditampilkan di tengah banner
            $table->string('image_url')->nullable();               // URL gambar (opsional)
            $table->string('warna_latar')->nullable();             // Warna latar dalam hex, contoh: "#2196F3"
            $table->integer('urutan')->default(0);                 // Urutan tampil (0 = pertama)
            $table->boolean('is_active')->default(true);           // Aktif/nonaktif banner
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('banners');
    }
};
