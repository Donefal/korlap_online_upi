import 'package:flutter/material.dart';
import 'package:korlap_online_upi/widgets/index.dart';

class ConfirmPembatalanPage extends StatefulWidget {
  final int id;
  const ConfirmPembatalanPage({super.key, required this.id});

  @override
  State<ConfirmPembatalanPage> createState() => _ConfirmPembatalanPageState();
}

class _ConfirmPembatalanPageState extends State<ConfirmPembatalanPage> {

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

                ButtonAction(
                  // TODO Logic batalkan pengajuan blm
                  onPressed: () {},
                  text: "Batalakan Pengajuan",
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