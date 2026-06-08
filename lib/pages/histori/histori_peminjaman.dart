import 'package:flutter/material.dart';
import 'package:korlap_online_upi/widgets/navbar.dart';
import 'package:korlap_online_upi/widgets/navbar_bawah.dart';
import 'package:korlap_online_upi/widgets/list_gedung.dart'; 

class HistoriPeminjamanPage extends StatefulWidget {
  const HistoriPeminjamanPage({super.key});

  @override
  State<HistoriPeminjamanPage> createState() => _HistoriPeminjamanPageState();
}

class _HistoriPeminjamanPageState extends State<HistoriPeminjamanPage> {
  final List<RuanganItem> _listHistori = [
    const RuanganItem(
      id: 201,
      gedung: "Gedung B",
      lantai: 1,
      namaRuangan: "Ruang Prodi Teknik Komputer",
      status: "sudah dipinjam", 
      jenisRuangan: "Ruangan Prodi",
    ),
    const RuanganItem(
      id: 202,
      gedung: "Gedung E",
      lantai: 1,
      namaRuangan: "20.4E.01.001",
      status: "tersedia", 
      jenisRuangan: "Ruang Kelas",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: const AppNavbar(),
      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          const Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: Text(
              "Histori Peminjaman",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          Expanded(
            child: _listHistori.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada histori peminjaman.",
                      style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: _listHistori.length,
                    itemBuilder: (context, index) {
                      final itemHistori = _listHistori[index];
                      
                      return RuanganCard(
                        item: RuanganItem(
                          id: itemHistori.id,
                          gedung: itemHistori.gedung,
                          lantai: itemHistori.lantai,
                          namaRuangan: itemHistori.namaRuangan,
                          status: itemHistori.status,
                          jenisRuangan: itemHistori.jenisRuangan,
                          onPinjam: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Detail Arsip: ${itemHistori.namaRuangan}"),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      bottomNavigationBar: AppBottomNav(
        currentIndex: 0, 
        onDestinationSelected: (int index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (index == 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Ntar diatur")),
            );
          }
        },
      ),
    );
  }
}