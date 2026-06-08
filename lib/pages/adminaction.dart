import 'package:flutter/material.dart';
import '../widgets/index.dart'; 
import 'mruangan.dart'; 

class AdminActionPage extends StatefulWidget {
  const AdminActionPage({super.key});

  @override
  State<AdminActionPage> createState() => _AdminActionPageState();
}

class _AdminActionPageState extends State<AdminActionPage> {
  final int _currentIndex = 2; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavbar(), 
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

      
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: AppText(text: "Admin action", mode: TextMode.header),
            ),
            
            const SizedBox(height: 32),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ButtonMenu(
                    text: "Manage pengajuan",
                    desc: "Manage pengajuan peminjaman ruangan",
                    icon: Icons.gavel_rounded,
                    margin: EdgeInsets.zero,
                    onPressed: () {
                      print("Klik: Manage pengajuan peminjaman ruangan");
                      // TODO: Navigasi ke halaman manajemen pengajuan peminjaman
                    },
                  ),
                ),
                const SizedBox(width: 12), 

                Expanded(
                  child: ButtonMenu(
                    text: "Tambahkan broadcast",
                    desc: "Tambahkan broadcast",
                    icon: Icons.campaign_rounded,
                    margin: EdgeInsets.zero,
                    onPressed: () {
                      print("Klik: Tambahkan broadcast");
                      // TODO: Navigasi ke halaman tambah broadcast pengumuman
                    },
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: ButtonMenu(
                    text: "Manage ruangan",
                    desc: "Manage ruangan",
                    icon: Icons.holiday_village_rounded,
                    margin: EdgeInsets.zero,
                    onPressed: () {
                      print("Klik: Manage ruangan -> Menuju Halaman MRuanganPage");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MRuanganPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16), 

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ButtonMenu(
                    text: "Manage akun",
                    desc: "Manage akun user dan admin",
                    icon: Icons.manage_accounts_rounded,
                    margin: EdgeInsets.zero,
                    onPressed: () {
                      print("Klik: Manage akun user dan admin");
                      // TODO: Navigasi ke halaman pengelolaan akun
                    },
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: ButtonMenu(
                    text: "Coming soon",
                    desc: "Fitur tambahan akan segera hadir",
                    icon: Icons.hourglass_empty_rounded,
                    margin: EdgeInsets.zero,
                    onPressed: () {
                      print("Klik: Coming soon");
                    },
                  ),
                ),
                const SizedBox(width: 12),

                const Expanded(
                  child: SizedBox.shrink(),
                ),
              ],
            ),
          ],
        ),
      ),

      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onDestinationSelected: (int index) {
        },
      ),
    );
  }
}