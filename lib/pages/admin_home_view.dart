import 'package:flutter/material.dart';
import 'package:korlap_online_upi/models/banner_item.dart';
import 'package:korlap_online_upi/widgets/button_menu.dart';
import 'package:korlap_online_upi/widgets/navbar.dart';
import 'package:korlap_online_upi/widgets/banner_carousel.dart';
import 'package:korlap_online_upi/widgets/navbar_bawah.dart';
import 'mruangan.dart'; 

class AdminHomeView extends StatefulWidget {
  const AdminHomeView({super.key});

  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
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
              "Admin Menu", 
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 60),

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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
    );
  }
}