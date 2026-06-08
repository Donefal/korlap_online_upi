import 'package:flutter/material.dart';
import '../widgets/index.dart'; // Mengimport komponen kustom kelompok secara mutakhir

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Menentukan indeks navigasi bawah untuk halaman Notifikasi (B2)
  final int _currentIndex = 1; 

  // Wadah List Data Notifikasi (Kotak Besar di bagian tengah)
  final List<Map<String, dynamic>> _notifikasiData = [
    // Tempat menampung data notifikasi nyata nantinya
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavbar(), // Navigasi Atas bawaan tim (A1 di pojok kanan)
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Judul Utama Halaman menggunakan AppText kustom tim (Mode Header)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: AppText(text: "Notifikasi", mode: TextMode.header),
          ),
          const SizedBox(height: 16),

          // =========================================================================
          // BINGKAI KOTAK BESAR "LIST NOTIFIKASI" PERSIS SEPERTI GAMBAR SKETSA B2
          // =========================================================================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.5), // Garis kotak hitam tegas
                  borderRadius: BorderRadius.circular(8), // Kelengkungan sudut standar
                ),
                child: _notifikasiData.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Center(
                          child: Text(
                            "List notifikasi perpindahan status peminjaman, pengumuman, himbauan, dll",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey, 
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12.0),
                        itemCount: _notifikasiData.length,
                        itemBuilder: (context, index) {
                          // Tempat merender item notifikasi jika data sudah tersedia
                          return const SizedBox.shrink();
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
      // Navigasi Bawah kustom kelompok (Menampilkan B1, B2, B3)
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onDestinationSelected: (int index) {
          // Logika perpindahan antar halaman menu utama bisa diatur di sini
        },
      ),
    );
  }
}