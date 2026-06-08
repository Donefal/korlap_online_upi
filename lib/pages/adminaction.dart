import 'package:flutter/material.dart';
import '../widgets/index.dart'; // Mengimport komponen kustom kelompok secara mutakhir
import 'mruangan.dart'; // Mengimpor halaman Manajemen Ruangan untuk disambungkan ke D3

class AdminActionPage extends StatefulWidget {
  const AdminActionPage({super.key});

  @override
  State<AdminActionPage> createState() => _AdminActionPageState();
}

class _AdminActionPageState extends State<AdminActionPage> {
  // Menentukan indeks navigasi bawah untuk halaman Admin Action (B3)
  final int _currentIndex = 2; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavbar(), // Navigasi Atas bawaan tim (A1 di pojok kanan)
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Judul Halaman menggunakan AppText kustom tim (Mode Header) sesuai teks sketsa
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: AppText(text: "Admin action", mode: TextMode.header),
            ),
            
            const SizedBox(height: 32),

            // =========================================================================
            // GRID TOMBOL AKSI ADMIN (D1 - D5) SESUAI TATA LETAK SKETSA IMAGE_CDB0B0.PNG
            // =========================================================================
            
            // BARIS 1: Tombol D1, D2, dan D3 Berdampingan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // D1: Manage Pengajuan Peminjaman Ruangan
                Expanded(
                  child: ButtonMenu(
                    text: "Manage pengajuan",
                    desc: "Manage pengajuan peminjaman ruangan",
                    icon: Icons.gavel_rounded,
                    margin: EdgeInsets.zero,
                    onPressed: () {
                      print("Klik: Manage pengajuan peminjaman ruangan");
                      // TODO: Navigasi ke halaman manajemen pengajuan peminjaman
                    },
                  ),
                ),
                const SizedBox(width: 12), // Jarak sela horizontal antar tombol

                // D2: Tambahkan Broadcast
                Expanded(
                  child: ButtonMenu(
                    text: "Tambahkan broadcast",
                    desc: "Tambahkan broadcast",
                    icon: Icons.campaign_rounded,
                    margin: EdgeInsets.zero,
                    onPressed: () {
                      print("Klik: Tambahkan broadcast");
                      // TODO: Navigasi ke halaman tambah broadcast pengumuman
                    },
                  ),
                ),
                const SizedBox(width: 12),

                // D3: Manage Ruangan (Dihubungkan langsung ke mruangan.dart)
                Expanded(
                  child: ButtonMenu(
                    text: "Manage ruangan",
                    desc: "Manage ruangan",
                    icon: Icons.holiday_village_rounded,
                    margin: EdgeInsets.zero,
                    onPressed: () {
                      print("Klik: Manage ruangan -> Menuju Halaman MRuanganPage");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MRuanganPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16), // Jarak sela vertikal antar baris grid

            // BARIS 2: Tombol D4 dan D5 (D6 Sudah Dihapus, diganti Box Kosong agar ukuran tetap proporsional)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // D4: Manage Akun User dan Admin
                Expanded(
                  child: ButtonMenu(
                    text: "Manage akun",
                    desc: "Manage akun user dan admin",
                    icon: Icons.manage_accounts_rounded,
                    margin: EdgeInsets.zero,
                    onPressed: () {
                      print("Klik: Manage akun user dan admin");
                      // TODO: Navigasi ke halaman pengelolaan akun
                    },
                  ),
                ),
                const SizedBox(width: 12),

                // D5: Coming Soon
                Expanded(
                  child: ButtonMenu(
                    text: "Coming soon",
                    desc: "Fitur tambahan akan segera hadir",
                    icon: Icons.hourglass_empty_rounded,
                    margin: EdgeInsets.zero,
                    onPressed: () {
                      print("Klik: Coming soon");
                    },
                  ),
                ),
                const SizedBox(width: 12),

                // Placeholder Transparan untuk menggantikan D6 agar baris kedua tidak rusak/melebar sendirian
                const Expanded(
                  child: SizedBox.shrink(),
                ),
              ],
            ),
          ],
        ),
      ),

      // Navigasi Bawah kustom kelompok (Menampilkan B1, B2, B3)
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex, // Index 2 aktif pada menu B3
        onDestinationSelected: (int index) {
          // Logika interaksi pindah halaman menu utama tim kamu
        },
      ),
    );
  }
}