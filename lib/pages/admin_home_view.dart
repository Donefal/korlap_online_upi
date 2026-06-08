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
                  height: 250,
                  banners: [
                    BannerItem(
                      header: "WELCOME TO",
                      subText:"Indonesian Education University\nCibiru Campus",
                      imageUrl: "https://i.ytimg.com/vi/VF3T3b-C1jw/maxresdefault.jpg"
                    ),
                    BannerItem(
                      header: "REKOMENDASI RUANG ACARA BESAR",
                      subText: "Merencanakan seminar atau kegiatan Organisasi.\nCek jadwal ketersediaan Auditorium bulan ini.",
                      imageUrl: "https://images.unsplash.com/photo-1523240795612-9a054b0db644?q=80&w=1000&auto=format&fit=crop"
                    ),
                    BannerItem(
                      header: "PEMELIHARAAN FASILITAS BERKALA",
                      subText: "Gedung Serba Guna (GSG) saat ini sedang dalam proses perawatan sistem audio dan pencahayaan hingga tanggal yang belum ditentukan. Mohon maaf atas ketidaknyamanan ini.",
                      imageUrl: "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?q=80&w=1000&auto=format&fit=crop"
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