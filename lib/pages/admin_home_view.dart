import 'package:flutter/material.dart';
import 'package:korlap_online_upi/models/banner_item.dart';
import 'package:korlap_online_upi/widgets/button_menu.dart';
import 'package:korlap_online_upi/widgets/navbar.dart';
import 'package:korlap_online_upi/widgets/banner_carousel.dart';
import 'package:korlap_online_upi/widgets/navbar_bawah.dart';
import 'mruangan.dart'; // Mengimpor halaman Manajemen Ruangan Admin yang sudah kita buat

class AdminHomeView extends StatefulWidget {
  const AdminHomeView({super.key});

  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  // Secara rancangan sketsa, halaman aksi admin berada di tab index ke-2 (B3)
  int _currentFooterIndex = 2; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavbar(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Admin Menu", // Diubah dari "Main Menu" agar merepresentasikan sisi Admin
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 60),

            // Banner tetap dipertahankan persis sesuai sketsa F1 (Banner selamat datang admin)
            BannerCarousel(
              height: 350,
              banners: [
                BannerItem(
                  text: "Selamat datang Admin",
                  backgroundColor: const Color.fromARGB(255, 255, 148, 0),
                ),
                BannerItem(
                  text: "Ntar diatur",
                  backgroundColor: const Color.fromARGB(255, 255, 0, 255),
                ),
                BannerItem(
                  text: "Man idk",
                  backgroundColor: const Color.fromARGB(255, 0, 148, 255),
                ),
              ],
            ),

            const SizedBox(height: 80),

            // MODIFIKASI TOMBOL MENU UTAMA (C1, C2, C3 dst.) MENJADI AKSI KELOLA ADMIN
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 1. Tombol Manajemen/Kelola Ruangan (Mengarah ke file mruangan.dart)
                Expanded(
                  child: ButtonMenu(
                    text: "Kelola Ruangan",
                    desc: "Manajemen Ruangan",
                    icon: Icons.holiday_village,
                    margin: EdgeInsets.zero,
                    onPressed: () {
                      print("Admin Menuju Halaman Manajemen Ruangan");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MRuanganPage(),
                        ),
                      );
                    },
                  ),
                ),

                // 2. Tombol Validasi/Persetujuan Peminjaman 
                Expanded(
                  child: ButtonMenu(
                    text: "Persetujuan",
                    desc: "Validasi Peminjaman",
                    icon: Icons.gavel,
                    margin: EdgeInsets.zero,
                    onPressed: () {
                      print("Admin Menuju Halaman Persetujuan Peminjaman");
                      // TODO: Navigasi ke halaman persetujuan/validasi berkas peminjaman
                    },
                  ),
                ),

                // 3. Tombol Log/Histori Aktivitas Sistem
                Expanded(
                  child: ButtonMenu(
                    text: "Log Aktivitas",                    
                    desc: "Histori Global",
                    icon: Icons.analytics,
                    margin: EdgeInsets.zero,
                    onPressed: () {
                      print("Admin Menuju Halaman Log Aktivitas Global");
                      // TODO: Navigasi ke halaman log admin
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentFooterIndex, 
        onDestinationSelected: (int index) {
          setState(() {
            _currentFooterIndex = index;
          });

          if (index == 0) {
            print("Admin klik Home User View"); 
            // TODO: Arahkan balik ke UserHomeView jika admin ingin melihat tampilan biasa (B1)
          } else if (index == 1) {
            print("Admin klik Menu Notif"); 
            // TODO: Ganti ke halaman notification.dart yang kita buat tadi (B2)
          } else if (index == 2) {
            print("Admin klik Menu Admin Action");
            // Tetap di halaman AdminHomeView ini (B3)
          }
        },
      ),
    );
  }
}