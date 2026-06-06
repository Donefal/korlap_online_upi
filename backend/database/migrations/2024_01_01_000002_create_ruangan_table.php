<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Migration: Membuat tabel 'ruangan'
 *
 * Tabel ini menyimpan data seluruh ruangan di UPI yang bisa dipinjam.
 * Data ini digunakan oleh widget RuanganCard & RuanganItem di Flutter.
 *
 * Kolom status diambil dari logika _tentukanColorStatus() di list_gedung.dart:
 *   - 'tersedia'                => hijau
 *   - 'sudah dipinjam'         => merah
 *   - 'sudah ada yg mengajukan'=> orange
 *
 * Kolom jenis_ruangan diambil dari _tentukanColorRuangan():
 *   - 'Laboratorium'
 *   - 'Ruang Kelas'
 *
 * Relasi:
 *   - ruangan hasMany peminjaman
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('ruangan', function (Blueprint $table) {
            $table->id();
            $table->string('nama_ruangan');                        // Contoh: "Lab Rekayasa Perangkat Lunak"
            $table->string('gedung');                              // Contoh: "FPMIPA"
            $table->integer('lantai');                             // Nomor lantai, contoh: 3
            $table->enum('jenis_ruangan', [                        // Jenis ruangan sesuai warna di Flutter
                'Laboratorium',
                'Ruang Kelas',
                'Aula',
                'Ruang Rapat',
                'Lainnya'
            ])->default('Ruang Kelas');
            $table->enum('status', [                               // Status ketersediaan ruangan
                'tersedia',
                'sudah dipinjam',
                'sudah ada yg mengajukan'
            ])->default('tersedia');
            $table->integer('kapasitas')->nullable();               // Jumlah kursi/orang
            $table->text('fasilitas')->nullable();                 // Contoh: "AC, Proyektor, Whiteboard"
            $table->text('deskripsi')->nullable();                 // Keterangan tambahan
            $table->boolean('is_active')->default(true);           // Aktif/nonaktif untuk dipinjam
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('ruangan');
    }
};
