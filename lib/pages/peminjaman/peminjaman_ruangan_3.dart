// file: lib/pages/peminjaman/form_pengajuan_page.dart
import 'package:flutter/material.dart';
import 'package:korlap_online_upi/widgets/navbar.dart';   
import 'package:korlap_online_upi/widgets/navbar_bawah.dart'; 
import 'package:korlap_online_upi/widgets/button_aksi.dart';   
import 'package:korlap_online_upi/widgets/list_gedung.dart';   

class FormPengajuanPage extends StatelessWidget {
  final RuanganItem ruangan;

  const FormPengajuanPage({super.key, required this.ruangan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: const AppNavbar(),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  const Text(
                    "Peminjaman Ruangan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 2.0, bottom: 16.0),
                    child: Text(
                      "Pengajuan",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),


                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.black12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.meeting_room, color: Colors.blueAccent),
                              const SizedBox(width: 8),
                              Text(
                                ruangan.namaRuangan,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          Text("Lokasi       : ${ruangan.gedung} -- LT. ${ruangan.lantai}", style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 6),
                          Text("Kategori   : ${ruangan.jenisRuangan}", style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 6),
                          Text("Status       : ${ruangan.status}", style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40), 


                  const Text(
                    "Dengan menekan tombol Ajukan, Anda akan mengirimkan permohonan peminjaman ruangan ini ke pihak Korlap UPI.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.4),
                  ),
                  const SizedBox(height: 24),

                  ButtonAction(
                    text: "Ajukan",
                    icon: Icons.send_rounded,
                    width: 120,
                    height: 45,
                    posisi: Alignment.centerRight, 
                    margin: const EdgeInsets.only(bottom: 20),
                    backgroundColor: Colors.green, 
                    onPressed: () {
                      //TODO: ganti biar pindah halaman dll entahlah
                      

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Pengajuan untuk ${ruangan.namaRuangan} Berhasil Dikirim!"),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Navigator.popUntil(context, (route) => route.isFirst);
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
        onDestinationSelected: (int index) {
          if (index == 0) {

            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
      ),
    );
  }
}