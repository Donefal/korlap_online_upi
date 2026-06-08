import 'package:flutter/material.dart';
import 'package:korlap_online_upi/widgets/index.dart';
import 'package:korlap_online_upi/models/banner_item.dart';
// Impor navbar_bawah.dart dihapus karena sudah diwakili oleh index.dart (menghindari duplikasi)

/*
  Script ini dikhususkan untuk melakukan testing dengan widget yang sudah dibuat
  tanpa menggangu page utama.

  Panggil di main.dart pada MaterialApp(home: )
*/

// KATA KUNCI 'const' DI SINI DIHAPUS karena model RuanganItem memiliki properti dinamis (seperti fungsi onPinjam)
final RuanganItem testItem = RuanganItem(
  id: 1,
  gedung: 'FPMIPA',
  lantai: 3,
  namaRuangan: 'Lab Rekayasa Perangkat Lunak',
  status: 'tersedia',
  jenisRuangan: 'Laboratorium',
  onPinjam: null,
);

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  
  bool _isLoginLoading = false;

  // Fungsi simulasi proses login
  void _handleLogin() async {
    setState(() {
      _isLoginLoading = true;
    });

    // Simulasi jeda waktu memanggil API
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoginLoading = false;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Berhasil!')),
      );
    }
  }

  TextEditingController test = TextEditingController();
  List<String> dataList = ["data1", "data2", "data3"];

  @override
  void dispose() {
    test.dispose(); // Best practice untuk menghindari memory leak di testing page
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavbar(),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0, 
        onDestinationSelected: (index) {
          setState(() {});
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              // ==========================================
              // TESTED WIDGETS
              // ==========================================

              BannerCarousel(
                height: 220, // Tinggi fiks untuk semua banner
                banners: [
                  BannerItem(
                    text: "Promo Diskon 50% Hari Ini!",
                    backgroundColor: Colors.blueAccent, 
                  ),
                  BannerItem(
                    text: "Koleksi Terbaru Musim Panas",
                    imageUrl: "https://images.unsplash.com/photo-1441986300917-64674bd600d8", 
                  ),
                  BannerItem(
                    text: "Gratis Ongkir ke Seluruh Indonesia",
                    backgroundColor: Colors.orange,
                  ),
                  BannerItem(
                    text: "Ini tambahan dari urang", 
                    backgroundColor: Colors.blueAccent
                  )
                ],
              ),
              const SizedBox(height: 10),

              FormBar(formCtrl: test),
              FormBar(formCtrl: test, formLabel: "Password", passwordText: true),
              
              // SETIAP FORMBAR DI DALAM ROW WAJIB DIBUNGKUS EXPANEDED AGAR UKURANNYA JELAS DAN TIDAK EROR
              Row(
                children: [
                  Expanded(child: FormBar(formCtrl: test, formLabel: "Ukuran 1", size: 1)),
                  const SizedBox(width: 5),
                  Expanded(child: FormBar(formCtrl: test, formLabel: "Ukuran 1", size: 1)),
                  const SizedBox(width: 5),
                  Expanded(child: FormBar(formCtrl: test, formLabel: "Ukuran 1", size: 1)),
                ],
              ),
              
              Row(
                children: [
                  Expanded(child: FormBar(formCtrl: test, formLabel: "Ukuran 2", size: 2)),
                  const SizedBox(width: 5),
                  Expanded(child: FormBar(formCtrl: test, formLabel: "Ukuran 2", size: 2, formIcon: FormIcon.nim)),
                ],
              ),
              const SizedBox(height: 10),

              ButtonAction(
                text: 'Login',
                isLoading: _isLoginLoading,
                onPressed: _handleLogin,
              ),

              ButtonAction(
                width: 200,
                text: 'test',
                icon: Icons.face,
                posisi: Alignment.centerRight,
                margin: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
                onPressed: () {
                  print('Pindah menu dieksekusi');
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonMenu(
                    text: 'Home', 
                    icon: Icons.home, 
                    desc: "rumah pulang ke dalam rumah aku hore oke oke mantap",
                    onPressed: () {},
                  ),
                  ButtonMenu(
                    text: 'Notifikasi', 
                    icon: Icons.notifications, 
                    desc: "pesan",
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 10),
              
              AppDropDown(
                ddCtrl: test, 
                data: dataList,
              ),
              const SizedBox(height: 10),

              const AppText(text: "Text biasa"),
              const AppText(text: "Text subheader", mode: TextMode.subheader),
              const AppText(text: "Text header", mode: TextMode.header),
              const SizedBox(height: 10),

              RuanganCard(item: testItem),
            ],
          ),
        ),
      ),
    );
  }
}