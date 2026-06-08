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
                Center(child: AppText(text: "Main Menu", mode: TextMode.gede)),
          
                const SizedBox(height: 30),
          
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
                      // imageUrl: "https://perslima.com/wp-content/uploads/2023/05/UPI-Kampus-Cibiru-Menyelesaikan-Pembangunan-Gedung-Baru-Setinggi-Tiga-Lantai.webp"
                      // backgroundColor: Color.fromARGB(255, 28, 199, 241)
                      imageUrl: "https://images.unsplash.com/photo-1523240795612-9a054b0db644?q=80&w=1000&auto=format&fit=crop"
                    ),
                    BannerItem(
                      header: "PEMELIHARAAN FASILITAS BERKALA",
                      subText: "Gedung Serba Guna (GSG) saat ini sedang dalam proses perawatan sistem audio dan pencahayaan hingga tanggal yang belum ditentukan. Mohon maaf atas ketidaknyamanan ini.",
                      // backgroundColor: const Color.fromARGB(255, 0, 200, 255),
                      imageUrl: "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?q=80&w=1000&auto=format&fit=crop"
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