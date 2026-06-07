import 'package:flutter/material.dart';
import 'package:korlap_online_upi/models/banner_item.dart';
import 'package:korlap_online_upi/widgets/button_menu.dart';
import 'package:korlap_online_upi/widgets/navbar.dart';
import 'package:korlap_online_upi/widgets/banner_carousel.dart';
import 'package:korlap_online_upi/widgets/navbar_bawah.dart';

class UserHomeView extends StatefulWidget {
  const UserHomeView ({super.key});

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
  int _currentFooterIndex = 0;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: const AppNavbar(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Main Menu",
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
                  text: "Selamat datang",
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
                ButtonMenu(
                  desc: "Pinjam ruangan untuk keperluanmu",
                  text: "Pinjam Ruangan",
                  icon: Icons.meeting_room,
                  margin: EdgeInsets.zero,
                  onPressed: () {
                    print("Menuju Halaman Peminjaman Ruangan");
                    //TODO: Navigasi ke page Peminjaman Ruangan
                  },
                ),
                ButtonMenu(
                  desc: "Lihat status peminjamanmu",
                  text: "Status Peminjaman",  
                  icon: Icons.assignment_turned_in,
                  margin: EdgeInsets.zero,
                  onPressed: () {
                    print("Menuju ke halaman Status Peminjaman");
                    //TODO: Navigasi ke halaman status peminjaman
                  },
                ),
                ButtonMenu(
                  desc: "Lihat histori peminjamanmu",
                  text: "Histori Peminjaman",  
                  icon: Icons.history,
                  margin: EdgeInsets.zero,
                  onPressed: () {
                    print("Menuju halaman Histori");
                    //TODO: Navigasi ke halaman histori
                  },
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
            print("User klik Home"); 
            // tetep di Home
          } else if (index == 1) {
            print("User klik Menu Notif"); 
            //TODO: ganti ke halaman notif
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Ntar diatur")),
            );
          }
        },
      ),
    );
  }
}