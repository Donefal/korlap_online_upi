// file: lib/pages/peminjaman/detail_peminjaman_page.dart
import 'package:flutter/material.dart';
import 'package:korlap_online_upi/widgets/navbar.dart';       
import 'package:korlap_online_upi/widgets/navbar_bawah.dart';  
import 'package:korlap_online_upi/widgets/button_aksi.dart';   
import 'package:korlap_online_upi/widgets/list_gedung.dart';   
import 'package:korlap_online_upi/pages/peminjaman/peminjaman_ruangan_3.dart';

class DetailPeminjamanPage extends StatelessWidget {
  final RuanganItem ruangan;

  const DetailPeminjamanPage({super.key, required this.ruangan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavbar(),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Peminjaman Ruangan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 2.0, bottom: 16.0),
                    child: Text(
                      "Panduan",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  RuanganCard(
                    item: RuanganItem(
                      id: ruangan.id,
                      gedung: ruangan.gedung,
                      lantai: ruangan.lantai,
                      namaRuangan: ruangan.namaRuangan,
                      status: ruangan.status,
                      jenisRuangan: ruangan.jenisRuangan,
                      onPinjam: null, 
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Syarat & Ketentuan Peminjaman:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "1. Peminjam bertanggung jawab penuh atas kebersihan dan fasilitas di dalam ruangan.",
                          style: TextStyle(fontSize: 13, height: 1.4),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "2. Pengajuan peminjaman dilakukan maksimal H-3 sebelum waktu penggunaan ruangan.",
                          style: TextStyle(fontSize: 13, height: 1.4),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "3. Jika status ruangan berubah menjadi 'Sudah Dipinjam', pengajuan otomatis dibatalkan.",
                          style: TextStyle(fontSize: 13, height: 1.4),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "4. Penggunaan atribut ruangan harus sesuai dengan izin operasional Korlap UPI.",
                          style: TextStyle(fontSize: 13, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  ButtonAction(
                    text: "Lanjutkan",
                    icon: Icons.arrow_forward,
                    width: 140,
                    height: 45,
                    posisi: Alignment.centerRight, 
                    margin: const EdgeInsets.only(bottom: 20),
                    onPressed: () {
                      print("Navigasi ke Halaman Konfirmasi Pengajuan...");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormPengajuanPage(ruangan: ruangan),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: AppBottomNav(
        currentIndex: 0, 
        onDestinationSelected: (int index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
      ),
    );
  }
}