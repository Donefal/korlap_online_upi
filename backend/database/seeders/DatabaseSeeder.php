<?php

namespace Database\Seeders;

use App\Models\Banner;
use App\Models\Ruangan;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

/**
 * DatabaseSeeder: Data dummy untuk development & testing
 *
 * Jalankan dengan: php artisan db:seed
 * Atau saat migrate: php artisan migrate --seed
 *
 * Data yang dibuat:
 * - 1 akun Admin
 * - 3 akun User mahasiswa
 * - 10 data Ruangan (gabungan dari nama-nama di project Flutter)
 * - 3 Banner awal
 */
class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // ─────────────────────────────────────────────
        //  USERS
        // ─────────────────────────────────────────────

        // Akun Admin (role: 'admin')
        // NIM/NIP bisa dipakai untuk login di Flutter LoginPage
        $admin = User::create([
            'nim_nip'  => 'ADMIN001',
            'nama'     => 'Admin Korlap',
            'email'    => 'admin@upi.edu',
            'password' => Hash::make('admin123'),
            'role'     => 'admin',
            'fakultas' => 'Sistem Informasi UPI',
        ]);

        // Akun Mahasiswa (role: 'user')
        $user1 = User::create([
            'nim_nip'  => '2200123',
            'nama'     => 'Budi Santoso',
            'email'    => 'budi@student.upi.edu',
            'password' => Hash::make('user123'),
            'role'     => 'user',
            'jurusan'  => 'Ilmu Komputer',
            'fakultas' => 'FPMIPA',
        ]);

        $user2 = User::create([
            'nim_nip'  => '2200456',
            'nama'     => 'Siti Aminah',
            'email'    => 'siti@student.upi.edu',
            'password' => Hash::make('user123'),
            'role'     => 'user',
            'jurusan'  => 'Pendidikan Ilmu Komputer',
            'fakultas' => 'FPMIPA',
        ]);

        $user3 = User::create([
            'nim_nip'  => '2200789',
            'nama'     => 'Ahmad Rizki',
            'email'    => 'ahmad@student.upi.edu',
            'password' => Hash::make('user123'),
            'role'     => 'user',
            'jurusan'  => 'Teknik Informatika',
            'fakultas' => 'FPTK',
        ]);

        // ─────────────────────────────────────────────
        //  RUANGAN
        //  Berdasarkan testItem di test.dart: FPMIPA, lantai 3, Lab RPL
        // ─────────────────────────────────────────────

        $ruanganData = [
            // FPMIPA
            ['nama_ruangan' => 'Lab Rekayasa Perangkat Lunak', 'gedung' => 'FPMIPA', 'lantai' => 3, 'jenis_ruangan' => 'Laboratorium', 'kapasitas' => 40, 'fasilitas' => 'AC, 40 Komputer, Proyektor'],
            ['nama_ruangan' => 'Lab Jaringan Komputer', 'gedung' => 'FPMIPA', 'lantai' => 3, 'jenis_ruangan' => 'Laboratorium', 'kapasitas' => 30, 'fasilitas' => 'AC, 30 Komputer, Router Cisco'],
            ['nama_ruangan' => 'Lab Multimedia', 'gedung' => 'FPMIPA', 'lantai' => 2, 'jenis_ruangan' => 'Laboratorium', 'kapasitas' => 35, 'fasilitas' => 'AC, Komputer Grafis, Tablet Wacom'],
            ['nama_ruangan' => 'Ruang 301 FPMIPA', 'gedung' => 'FPMIPA', 'lantai' => 3, 'jenis_ruangan' => 'Ruang Kelas', 'kapasitas' => 40, 'fasilitas' => 'AC, Proyektor, Whiteboard'],
            ['nama_ruangan' => 'Ruang 201 FPMIPA', 'gedung' => 'FPMIPA', 'lantai' => 2, 'jenis_ruangan' => 'Ruang Kelas', 'kapasitas' => 35, 'fasilitas' => 'Proyektor, Whiteboard'],
            // FPTK
            ['nama_ruangan' => 'Lab Basis Data', 'gedung' => 'FPTK', 'lantai' => 1, 'jenis_ruangan' => 'Laboratorium', 'kapasitas' => 25, 'fasilitas' => 'AC, 25 Komputer, MySQL Server'],
            ['nama_ruangan' => 'Ruang Seminar FPTK', 'gedung' => 'FPTK', 'lantai' => 2, 'jenis_ruangan' => 'Aula', 'kapasitas' => 100, 'fasilitas' => 'AC, Sound System, Proyektor, Podium'],
            // FIP
            ['nama_ruangan' => 'Ruang Rapat Dekan FIP', 'gedung' => 'FIP', 'lantai' => 1, 'jenis_ruangan' => 'Ruang Rapat', 'kapasitas' => 20, 'fasilitas' => 'AC, TV 65 inci, Whiteboard'],
            ['nama_ruangan' => 'Lab Psikologi', 'gedung' => 'FIP', 'lantai' => 2, 'jenis_ruangan' => 'Laboratorium', 'kapasitas' => 20, 'fasilitas' => 'AC, Kamera CCTV, Ruang Konsultasi'],
            // FPBS
            ['nama_ruangan' => 'Ruang 101 FPBS', 'gedung' => 'FPBS', 'lantai' => 1, 'jenis_ruangan' => 'Ruang Kelas', 'kapasitas' => 30, 'fasilitas' => 'Proyektor, Whiteboard'],
        ];

        foreach ($ruanganData as $data) {
            Ruangan::create([
                ...$data,
                'status'    => 'tersedia',
                'is_active' => true,
            ]);
        }

        // ─────────────────────────────────────────────
        //  BANNERS
        //  Sesuai dengan banners di UserHomeView (user_home_view.dart)
        // ─────────────────────────────────────────────

        Banner::create([
            'teks'        => 'Selamat Datang di Korlap Online UPI',
            'warna_latar' => 'FF9400', // Orange
            'urutan'      => 0,
            'is_active'   => true,
        ]);

        Banner::create([
            'teks'        => 'Pinjam ruangan dengan mudah dan cepat!',
            'warna_latar' => '0094FF', // Biru
            'urutan'      => 1,
            'is_active'   => true,
        ]);

        Banner::create([
            'teks'        => 'Cek status pengajuanmu secara real-time',
            'warna_latar' => 'AA00FF', // Ungu
            'urutan'      => 2,
            'is_active'   => true,
        ]);

        $this->command->info('✅ Seeder selesai!');
        $this->command->info('─────────────────────────────────');
        $this->command->info('Admin Login  → NIM/NIP: ADMIN001 | Password: admin123');
        $this->command->info('User Login 1 → NIM/NIP: 2200123  | Password: user123');
        $this->command->info('User Login 2 → NIM/NIP: 2200456  | Password: user123');
        $this->command->info('─────────────────────────────────');
    }
}
