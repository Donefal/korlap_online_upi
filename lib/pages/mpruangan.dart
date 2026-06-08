import 'package:flutter/material.dart';
import '../widgets/index.dart'; // Mengimport komponen kustom kelompok secara mutakhir

// ==========================================
// 1. PAGE D1.1: DAFTAR PEMINJAMAN RUANGAN (USER)
// ==========================================
class MPruanganPage extends StatefulWidget {
  const MPruanganPage({super.key});

  @override
  State<MPruanganPage> createState() => _MPruanganPageState();
}

class _MPruanganPageState extends State<MPruanganPage> {
  final int _currentIndex = 0; // Posisi menu Home / Peminjaman User

  // Controller untuk sinkronisasi nilai widget AppDropDown tim
  final TextEditingController gedungFilterCtrl = TextEditingController();
  final TextEditingController lantaiFilterCtrl = TextEditingController();

  final List<String> listGedung = ['Gedung A', 'Gedung B', 'Gedung C', 'FPMIPA J'];
  final List<String> listLantai = ['Lantai 1', 'Lantai 2', 'Lantai 3'];

  // Wadah List Data Ruangan Peminjaman (Kosong Sesuai Konsep Awal)
  final List<Map<String, dynamic>> _peminjamanData = [];

  @override
  void dispose() {
    gedungFilterCtrl.dispose();
    lantaiFilterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Menghitung lebar proporsional untuk membagi ButtonAction berdampingan secara simetris
    double halfWidth = (MediaQuery.of(context).size.width - 42) / 2;

    return Scaffold(
      appBar: const AppNavbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Judul Utama Halaman menggunakan AppText kustom tim
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: AppText(text: "Peminjaman Ruangan", mode: TextMode.header),
          ),
          const SizedBox(height: 16),

          // =========================================================
          // FORMASI STRUKTUR LAYOUT DROPDOWN & BUTTON AKSI TIM (D1.1)
          // =========================================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // BARIS 1: Menampilkan AppDropDown Kelompok (Gedung & Lantai)
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
                    const SizedBox(width: 10), // Sela antar dropdown
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
                const SizedBox(height: 12),

                // BARIS 2: Menampilkan ButtonAction Kelompok (Tambahkan & Filter)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Button Tambahkan kustom tim (Membuka Form D1.2)
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
                            builder: (context) => const TambahPeminjamanPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    // Button Filter kustom tim
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

          // WADAH TENGAH LIST PEMINJAMAN (Biarkan Kosong Sesuai Konsep)
          Expanded(
            child: _peminjamanData.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada riwayat peminjaman ruangan.",
                      style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: _peminjamanData.length,
                    itemBuilder: (context, index) => const SizedBox.shrink(),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onDestinationSelected: (int index) {},
      ),
    );
  }
}

// ==========================================
// 2. PAGE D1.2: TAMBAHKAN PEMINJAMAN (FORM)
// ==========================================
class TambahPeminjamanPage extends StatefulWidget {
  const TambahPeminjamanPage({super.key});

  @override
  State<TambahPeminjamanPage> createState() => _TambahPeminjamanPageState();
}

class _TambahPeminjamanPageState extends State<TambahPeminjamanPage> {
  // Controller pengisian data form baru peminjaman D1.2
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
      appBar: const AppNavbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Judul Halaman Form menggunakan AppText tim
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: AppText(text: "Tambahkan Peminjaman", mode: TextMode.header),
          ),
          const SizedBox(height: 16),

          // AREA FORM UTAMA (Bingkai Kotak D1.2)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // 1. FRAME KOTAK BESAR ISI FORM BAR TIM
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.2),
                        borderRadius: BorderRadius.circular(10), // Serasi dengan kelengkukan widget timmu
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Menggunakan FormBar kustom timmu secara mutakhir (size: 3 = full width)
                            FormBar(
                              formCtrl: namaRuanganCtrl,
                              formLabel: "Nama Ruangan",
                              size: 3,
                              margin: 4,
                            ),
                            const SizedBox(height: 12),
                            FormBar(
                              formCtrl: gedungCtrl,
                              formLabel: "Nama Gedung",
                              size: 3,
                              margin: 4,
                            ),
                            const SizedBox(height: 12),
                            FormBar(
                              formCtrl: lantaiCtrl,
                              formLabel: "Posisi Lantai",
                              size: 3,
                              margin: 4,
                              formIcon: FormIcon.nim, // Meminjam ikon numbers agar estetik untuk penomoran lantai
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 2. TOMBOL SIMPAN TAMBAHKAN DI POJOK KANAN BAWAH KOTAK
                  ButtonAction(
                    text: "Tambahkan",
                    icon: Icons.check_circle_outline,
                    width: 150,
                    margin: const EdgeInsets.only(bottom: 16),
                    posisi: Alignment.centerRight,
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Permohonan Peminjaman Berhasil Ditambahkan!")),
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
        onDestinationSelected: (int index) {},
      ),
    );
  }
}