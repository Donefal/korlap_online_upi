import 'package:flutter/material.dart';
import 'package:korlap_online_upi/widgets/index.dart';
import 'package:korlap_online_upi/models/banner_item.dart';
import 'package:korlap_online_upi/widgets/navbar_bawah.dart';

/*
  Script ini dikhususkan untuk melakukan testing dengan widget yang sudah dibuat
  tanpa menggangu page utama.

  Panggil di main.dart pada MaterialApp(home: )
*/

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
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login Berhasil!')),
    );
  }



  TextEditingController test = TextEditingController();
  List<String> dataList = ["data1", "data2", "data3"];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavbar(),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0, 
        onDestinationSelected: (index) {setState(() {
          
        });},
      ),
      
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
            // TODO Insert Tested widgets here

            BannerCarousel(
            height: 220, // Tinggi fiks untuk semua banner
            banners: [
              BannerItem(
                text: "Promo Diskon 50% Hari Ini!",
                backgroundColor: Colors.blueAccent, // Menggunakan Warna
              ),
              BannerItem(
                text: "Koleksi Terbaru Musim Panas",
                imageUrl: "https://images.unsplash.com/photo-1441986300917-64674bd600d8", // Menggunakan Gambar
              ),
              BannerItem(
                text: "Gratis Ongkir ke Seluruh Indonesia",
                backgroundColor: Colors.orange,
              ),
              BannerItem(text: "Ini tambahan dari urang", backgroundColor: Colors.blueAccent)
            ],
          ),


            FormBar(formCtrl: test),
            FormBar(formCtrl: test, formLabel: "Password", passwordText: true,),
            Row(
              children: [
                FormBar(formCtrl: test, formLabel: "Ukuran 1", size: 1,),
                FormBar(formCtrl: test, formLabel: "Ukuran 1", size: 1,),
                FormBar(formCtrl: test, formLabel: "Ukuran 1", size: 1,),
              ],
            ),
            
            Row(
              children: [
                FormBar(formCtrl: test, formLabel: "Ukuran 2", size: 2,),
                FormBar(formCtrl: test, formLabel: "Ukuran 2", size: 2, formIcon: FormIcon.nim),
              ],
            ),
            

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
              onPressed:() {
                print('Pindah menu dieksekusi');
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonMenu( text: 'Home', icon: Icons.home, 
                  onPressed: () {},
                ),
                ButtonMenu(text: 'Notifikasi', icon: Icons.notifications,
                  onPressed: () {},
                ),
                ButtonMenu( text: 'Pengaturan', icon: Icons.settings,
                  onPressed: () {},
                ),
              ],
            ),
            
            AppDropDown(
              ddCtrl: test, 
              data: dataList
            ),

            AppText(text: "Text biasa"),
            AppText(text: "Text subheader", mode:TextMode.subheader),
            AppText(text: "Text header", mode:TextMode.header)

            ]
          ),
        )
        
      ),
    );
  }

}
