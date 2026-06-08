import 'package:flutter/material.dart';
import 'package:korlap_online_upi/pages/broadcast.dart';
import 'package:korlap_online_upi/pages/makun.dart';
import 'package:korlap_online_upi/pages/mpruangan.dart';
import '../widgets/index.dart';
import 'mruangan.dart';

class AdminActionPage extends StatefulWidget {
  const AdminActionPage({super.key});

  @override
  State<AdminActionPage> createState() => _AdminActionPageState();
}

class _AdminActionPageState extends State<AdminActionPage> {

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

              const SizedBox(height: 64),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ButtonMenu(
                      text: "Pengajuan",
                      desc: "Manage pengajuan peminjaman ruangan",
                      icon: Icons.gavel_rounded,
                      margin: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ManageRuanganPage(),
                          ),
                        );
                      },
                    ),
                  ),

                  Expanded(
                    child: ButtonMenu(
                      text: "Akun",
                      desc: "Manage akun user dan admin",
                      icon: Icons.manage_accounts_rounded,
                      margin: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MAkunPage(),
                          ),
                        );
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
