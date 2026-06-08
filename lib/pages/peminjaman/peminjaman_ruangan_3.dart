import 'package:flutter/material.dart';
import 'package:korlap_online_upi/widgets/navbar.dart';        
import 'package:korlap_online_upi/widgets/navbar_bawah.dart';  
import 'package:korlap_online_upi/widgets/button_aksi.dart';   
import 'package:korlap_online_upi/widgets/list_gedung.dart';   
import 'package:korlap_online_upi/widgets/form_bar.dart';      

class FormPengajuanPage extends StatefulWidget {
  final RuanganItem ruangan;

  const FormPengajuanPage({super.key, required this.ruangan});

  @override
  State<FormPengajuanPage> createState() => _FormPengajuanPageState();
}

class _FormPengajuanPageState extends State<FormPengajuanPage> {

  final TextEditingController _nimCtrl = TextEditingController();
  final TextEditingController _keperluanCtrl = TextEditingController();

  @override
  void dispose() {
    _nimCtrl.dispose();
    _keperluanCtrl.dispose();
    super.dispose();
  }

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
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 2.0, bottom: 16.0),
                    child: Text(
                      "Pengajuan",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
                    ),
                  ),

                  RuanganCard(
                    item: RuanganItem(
                      id: widget.ruangan.id,
                      gedung: widget.ruangan.gedung,
                      lantai: widget.ruangan.lantai,
                      namaRuangan: widget.ruangan.namaRuangan,
                      status: widget.ruangan.status,
                      jenisRuangan: widget.ruangan.jenisRuangan,
                      onPinjam: null,
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    "Formulir Data Pengajuan:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),


                  FormBar(
                    formCtrl: _nimCtrl,
                    formLabel: "NIM Peminjam",
                    size: 3,
                    margin: 0,
                    formIcon: FormIcon.nim, 
                  ),
                  
                  const SizedBox(height: 14), 
                  
                  FormBar(
                    formCtrl: _keperluanCtrl,
                    formLabel: "Keperluan / Nama Acara",
                    size: 3,
                    margin: 0,
                    formIcon: FormIcon.none, // 
                  ),

                  const SizedBox(height: 30),

                  ButtonAction(
                    text: "Ajukan",
                    icon: Icons.send_rounded,
                    width: 120,
                    height: 45,
                    posisi: Alignment.centerRight,
                    margin: const EdgeInsets.only(bottom: 20),
                    backgroundColor: Colors.green,
                    onPressed: () {

                      if (_nimCtrl.text.isEmpty || _keperluanCtrl.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Harap isi NIM dan Keperluan terlebih dahulu!"),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }

                      print("NIM: ${_nimCtrl.text}");
                      print("Keperluan: ${_keperluanCtrl.text}");
                      print("Mengajukan ruangan: ${widget.ruangan.namaRuangan}");
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Pengajuan atas NIM ${_nimCtrl.text} Berhasil Dikirim!"),
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