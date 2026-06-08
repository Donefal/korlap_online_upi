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
    return SingleChildScrollView(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 30, bottom: 10),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            24.0,
          ), // Higher number = more rounded
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            right: 24,
            left: 24,
            top: 24,
            bottom: 80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              Center(child: AppText(text: "Admin action", mode: TextMode.gede)),

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
                        // TODO: Navigasi ke halaman manajemen pengajuan peminjaman
                      },
                    ),
                  ),

                  Expanded(
                    child: ButtonMenu(
                      text: "Tambahkan broadcast",
                      desc: "Tambahkan broadcast",
                      icon: Icons.campaign_rounded,
                      margin: EdgeInsets.zero,
                      onPressed: () {
                        // TODO: Navigasi ke halaman tambah broadcast pengumuman
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ButtonMenu(
                      text: "Manage ruangan",
                      desc: "Manage ruangan",
                      icon: Icons.holiday_village_rounded,
                      margin: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MRuanganPage(),
                          ),
                        );
                      },
                    ),
                  ),

                  Expanded(
                    child: ButtonMenu(
                      text: "Manage akun",
                      desc: "Manage akun user dan admin",
                      icon: Icons.manage_accounts_rounded,
                      margin: EdgeInsets.zero,
                      onPressed: () {
                        // TODO: Navigasi ke halaman pengelolaan akun
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
