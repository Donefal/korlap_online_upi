<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Migration: Membuat tabel 'users'
 *
 * Tabel ini menyimpan data pengguna aplikasi Korlap Online UPI.
 * Mendukung dua jenis role: 'admin' (staff/dosen) dan 'user' (mahasiswa).
 * Kolom 'nim_nip' adalah identitas unik setiap pengguna.
 *
 * Relasi:
 *   - users hasMany peminjaman (satu user bisa punya banyak peminjaman)
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();                                           // Primary key auto-increment
            $table->string('nim_nip')->unique();                   // NIM untuk mahasiswa / NIP untuk dosen, harus unik
            $table->string('nama');                                // Nama lengkap pengguna
            $table->string('email')->unique()->nullable();         // Email (opsional, tapi harus unik)
            $table->string('password');                            // Password ter-hash (bcrypt)
            $table->enum('role', ['admin', 'user'])->default('user'); // Role: 'user'=mahasiswa, 'admin'=staff
            $table->string('jurusan')->nullable();                 // Jurusan/Prodi mahasiswa
            $table->string('fakultas')->nullable();                // Fakultas mahasiswa
            $table->boolean('is_active')->default(true);           // Status aktif akun
            $table->rememberToken();                               // Token untuk "remember me" (Laravel default)
            $table->timestamps();                                  // created_at & updated_at otomatis
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};
