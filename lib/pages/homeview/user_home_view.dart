import 'package:flutter/material.dart';
import 'package:korlap_online_upi/models/banner_item.dart';
import 'package:korlap_online_upi/pages/adminaction.dart';
import 'package:korlap_online_upi/pages/histori/histori_peminjaman.dart';
import 'package:korlap_online_upi/pages/peminjaman/peminjaman_ruangan_1.dart';
import 'package:korlap_online_upi/pages/status/status_peminjaman.dart';
import 'package:korlap_online_upi/widgets/button_menu.dart';
import 'package:korlap_online_upi/widgets/index.dart';
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
    return SingleChildScrollView(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 30, bottom: 10),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0), // Higher number = more rounded
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 24.0, left: 24.0, top: 24, bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                const Text(
                  "Main Menu",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
          
                const SizedBox(height: 30),
          
                BannerCarousel(
                  height: 250,
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
          
                const SizedBox(height: 60),
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child:
                      ButtonMenu(
                      text: "Pinjam Ruangan",
                      desc: "Pinjam Ruangan",
                      icon: Icons.meeting_room,
                      margin: EdgeInsets.zero,
                      onPressed: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => const PeminjamanRuanganPage())
                          );
                      },
                    ),
                    ),
          
                    Expanded(child:
                      ButtonMenu(
                      text: "Status Peminjaman",
                      desc: "Status Peminjaman",
                      icon: Icons.assignment_turned_in,
                      margin: EdgeInsets.zero,
                      onPressed: () {
                          Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => const StatusPeminjamanPage())
                          );
                      },
                    ),
                    ),
                  ],
                ),
          
                const SizedBox(height: 25),
          
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child:
                      ButtonMenu(
                      text: "Histori Peminjaman",                    
                      desc: "Histori Peminjaman",
                      icon: Icons.history,
                      margin: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => const HistoriPeminjamanPage())
                          );
                      },
                    ),
                    ),
          
          
                    Expanded(child:
                      ButtonMenu(
                      text: "Coming Soon",                    
                      desc: "Coming Soon",
                      icon: Icons.timelapse,
                      margin: EdgeInsets.zero,
                      disable: true,
                      onPressed: (){
          
                      }
                    ),
                    )
                ]
                )
          
                
              ],
            ),
        ),
      ),
      );
  }
}