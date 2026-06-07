<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Migration: Membuat tabel 'peminjaman'
 *
 * Tabel inti yang mencatat semua transaksi peminjaman ruangan.
 * Setiap baris = satu pengajuan pinjam ruangan oleh satu user.
 *
 * Alur status pengajuan:
 *   menunggu → disetujui → selesai
 *   menunggu → ditolak
 *
 * Relasi:
 *   - peminjaman belongsTo user   (siapa yang meminjam)
 *   - peminjaman belongsTo ruangan (ruangan mana yang dipinjam)
 *   - peminjaman belongsTo admin (siapa yang approve/tolak) - nullable
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('peminjaman', function (Blueprint $table) {
            $table->id();

            // Foreign Keys
            $table->foreignId('user_id')
                  ->constrained('users')
                  ->onDelete('cascade');                           // Jika user dihapus, peminjaman juga terhapus

            $table->foreignId('ruangan_id')
                  ->constrained('ruangan')
                  ->onDelete('cascade');                           // Jika ruangan dihapus, peminjaman juga terhapus

            $table->foreignId('admin_id')
                  ->nullable()
                  ->constrained('users')
                  ->onDelete('set null');                          // Admin yang memproses (boleh null jika belum diproses)

            // Data Peminjaman
            $table->string('keperluan');                           // Alasan/keperluan meminjam
            $table->date('tanggal_pinjam');                        // Tanggal penggunaan ruangan
            $table->time('jam_mulai');                             // Jam mulai penggunaan
            $table->time('jam_selesai');                           // Jam selesai penggunaan
            $table->integer('jumlah_peserta')->nullable();         // Perkiraan jumlah orang

            // Status Pengajuan
            $table->enum('status', [
                'menunggu',     // Baru diajukan, menunggu review admin
                'disetujui',    // Admin sudah approve
                'ditolak',      // Admin menolak
                'selesai',      // Peminjaman sudah selesai/berlangsung
                'dibatalkan'    // User membatalkan sendiri
            ])->default('menunggu');

            $table->text('catatan_user')->nullable();              // Catatan tambahan dari user
            $table->text('catatan_admin')->nullable();             // Alasan penolakan/catatan dari admin

            $table->timestamp('diproses_pada')->nullable();        // Kapan admin memproses
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('peminjaman');
    }
};
