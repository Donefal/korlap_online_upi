import 'package:flutter/material.dart';
import '../widgets/index.dart'; // Mengimport komponen kustom kelompok secara mutakhir

// ==========================================================
// 1. PAGE D5.1: DAFTAR MANAJEMEN RUANGAN (ADMIN)
// ==========================================================
class MRuanganPage extends StatefulWidget {
  const MRuanganPage({super.key});

  @override
  State<MRuanganPage> createState() => _MRuanganPageState();
}

class _MRuanganPageState extends State<MRuanganPage> {
  // Variabel lokal untuk halaman D5.1
  final int _currentIndex = 2; // Posisi menu Admin Action pada navbar bawah

  // Controller untuk sinkronisasi nilai widget AppDropDown tim kamu
  final TextEditingController gedungFilterCtrl = TextEditingController();
  final TextEditingController lantaiFilterCtrl = TextEditingController();

  final List<String> listGedung = ['Gedung A', 'Gedung B', 'Gedung C', 'FPMIPA J'];
  final List<String> listLantai = ['Lantai 1', 'Lantai 2', 'Lantai 3'];

  // Wadah List Jadwal / Data Ruangan (Kotak Besar di D5.1)
  final List<Map<String, dynamic>> _ruanganData = [];

  @override
  void dispose() {
    gedungFilterCtrl.dispose();
    lantaiFilterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Menghitung lebar proporsional untuk membagi ButtonAction berdampingan agar pas setengah layar
    double halfWidth = (MediaQuery.of(context).size.width - 42) / 2;

    return Scaffold(
      appBar: const AppNavbar(), // Navigasi Atas dengan tanda panah balik & A1
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Judul Utama Halaman menggunakan AppText kustom tim
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: AppText(text: "Manajemen Ruangan", mode: TextMode.header),
          ),
          const SizedBox(height: 16),

          // =========================================================
          // STRUKTUR FILTER & AKSI PERSIS SEPERTI GAMBAR D5.1
          // =========================================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // BARIS 1: DD Gedung & DD Lantai (Menggunakan AppDropDown tim size: 2)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AppDropDown(
                        ddCtrl: gedungFilterCtrl,
                        data: listGedung,
                        ddLabel: "Gedung",
                        size: 2,
                        margin: 0,
                        iconChoice: DdIcon.gedung,
                      ),
                    ),
                    const SizedBox(width: 10), // Jarak sela antar dropdown
                    Expanded(
                      child: AppDropDown(
                        ddCtrl: lantaiFilterCtrl,
                        data: listLantai,
                        ddLabel: "Lantai",
                        size: 2,
                        margin: 0,
                        iconChoice: DdIcon.lantai,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // BARIS 2: Tombol "Tambahkan" & "Filter" (Menggunakan ButtonAction tim)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Button Tambahkan untuk berpindah ke Page D5.2
                    ButtonAction(
                      text: "Tambahkan",
                      icon: Icons.add,
                      width: halfWidth,
                      margin: EdgeInsets.zero,
                      posisi: Alignment.centerLeft,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TambahRuanganPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    // Button Filter untuk memproses pencarian data
                    ButtonAction(
                      text: "Filter",
                      icon: Icons.search,
                      width: halfWidth,
                      margin: EdgeInsets.zero,
                      posisi: Alignment.centerRight,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Memfilter: ${gedungFilterCtrl.text.isEmpty ? 'Semua' : gedungFilterCtrl.text} - ${lantaiFilterCtrl.text.isEmpty ? 'Semua' : lantaiFilterCtrl.text}"
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(thickness: 1, height: 1),

          // =========================================================
          // BINGKAI KOTAK BESAR "LIST JADWAL" PERSIS SEPERTI GAMBAR D5.1
          // =========================================================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _ruanganData.isEmpty
                    ? const Center(
                        child: Text(
                          "List jadwal",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _ruanganData.length,
                        itemBuilder: (context, index) => const SizedBox.shrink(),
                      ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav( // Navigasi Bawah B1, B2, B3
        currentIndex: _currentIndex,
        onDestinationSelected: (int index) {},
      ),
    );
  }
}

// ==========================================================
// 2. PAGE D5.2: FORMULIR TAMBAHKAN RUANGAN (ADMIN)
// ==========================================================
class TambahRuanganPage extends StatefulWidget {
  const TambahRuanganPage({super.key});

  @override
  State<TambahRuanganPage> createState() => _TambahRuanganPageState();
}

class _TambahRuanganPageState extends State<TambahRuanganPage> {
  // Membuat variabel lokal _currentIndex terpisah khusus untuk halaman D5.2
  final int _currentIndex = 2; 

  // Controller untuk Isian nama, gedung, dan lantai di Page D5.2
  final TextEditingController namaRuanganCtrl = TextEditingController();
  final TextEditingController gedungCtrl = TextEditingController();
  final TextEditingController lantaiCtrl = TextEditingController();

  @override
  void dispose() {
    namaRuanganCtrl.dispose();
    gedungCtrl.dispose();
    lantaiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavbar(), // Navigasi Atas dengan tanda panah balik & A1
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Judul Halaman Form menggunakan AppText tim
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: AppText(text: "Tambahkan Ruangan", mode: TextMode.header),
          ),
          const SizedBox(height: 16),

          // =========================================================
          // AREA FRAME KOTAK BESAR "ISIAN NAMA, GEDUNG, LANTAI" (D5.2)
          // =========================================================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Menggunakan FormBar kustom milik timmu (size: 3 untuk full-width)
                            FormBar(
                              formCtrl: namaRuanganCtrl,
                              formLabel: "nama ruangan",
                              size: 3,
                              margin: 4,
                            ),
                            const SizedBox(height: 14),
                            FormBar(
                              formCtrl: gedungCtrl,
                              formLabel: "gedung",
                              size: 3,
                              margin: 4,
                            ),
                            const SizedBox(height: 14),
                            FormBar(
                              formCtrl: lantaiCtrl,
                              formLabel: "lantai",
                              size: 3,
                              margin: 4,
                              // Parameter formIcon: FormIcon.nim sudah dihapus agar tidak memunculkan tanda pagar (#)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // =========================================================
                  // TOMBOL AKSI "TAMBAHKAN" DI SEBELAH KANAN BAWAH KOTAK (D5.2)
                  // =========================================================
                  ButtonAction(
                    text: "Tambahkan",
                    icon: Icons.check_circle_outline,
                    width: 150,
                    margin: const EdgeInsets.only(bottom: 16),
                    posisi: Alignment.centerRight, // Mendorong tombol ke kanan sesuai sketsa gambar D5.2
                    onPressed: () {
                      Navigator.pop(context); // Kembali ke halaman utama D5.1
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Ruangan Baru Berhasil Ditambahkan!")),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav( // Navigasi Bawah B1, B2, B3
        currentIndex: _currentIndex, 
        onDestinationSelected: (int index) {},
      ),
    );
  }
}