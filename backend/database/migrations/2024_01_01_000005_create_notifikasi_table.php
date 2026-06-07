<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Migration: Membuat tabel 'notifikasi'
 *
 * Tabel ini menyimpan notifikasi untuk setiap user.
 * Notifikasi dibuat otomatis oleh backend saat status peminjaman berubah.
 *
 * Contoh notifikasi yang digenerate:
 *   - "Pengajuan peminjaman Anda untuk Lab RPL telah DISETUJUI"
 *   - "Pengajuan peminjaman Anda untuk Ruang 301 DITOLAK: [alasan admin]"
 *
 * Relasi:
 *   - notifikasi belongsTo user
 *   - notifikasi belongsTo peminjaman (opsional, untuk deep link)
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('notifikasi', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')
                  ->constrained('users')
                  ->onDelete('cascade');
            $table->foreignId('peminjaman_id')
                  ->nullable()
                  ->constrained('peminjaman')
                  ->onDelete('set null');
            $table->string('judul');                               // Judul notifikasi pendek
            $table->text('pesan');                                 // Isi pesan lengkap
            $table->boolean('sudah_dibaca')->default(false);       // Status baca
            $table->timestamp('dibaca_pada')->nullable();          // Kapan dibaca
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('notifikasi');
    }
};
