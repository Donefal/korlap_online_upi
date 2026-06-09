import 'package:flutter/material.dart';
import 'package:korlap_online_upi/widgets/index.dart';

class ConfirmPengajuanPage extends StatefulWidget {
  final int id;
  const ConfirmPengajuanPage({super.key, required this.id});

  @override
  State<ConfirmPengajuanPage> createState() => _ConfirmPengajuanPageState();
}

class _ConfirmPengajuanPageState extends State<ConfirmPengajuanPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          right: 20,
          left: 20,
          top: 30,
          bottom: 10,
        ),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              right: 15,
              left: 15,
              top: 24,
              bottom: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: AppText(
                    text: "Aksi Peminjman",
                    mode: TextMode.header,
                  ),
                ),

                const SizedBox(height: 20),

                // TODO Perlihatkan data dulu

                ButtonAction(
                  onPressed: () {},
                  text: "Terima Pengajuan",
                  backgroundColor: Colors.green,
                  height: 50,
                ),

                const SizedBox(height: 20),

                ButtonAction(
                  onPressed: () {},
                  text: "Tolak Pengajuan",
                  backgroundColor: Colors.red,
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}