import 'package:flutter/material.dart';
import 'package:korlap_online_upi/widgets/list_peminjaman.dart';
import 'package:korlap_online_upi/widgets/navbar.dart';

class HistoriPeminjamanPage extends StatefulWidget {
  const HistoriPeminjamanPage({super.key});

  @override
  State<HistoriPeminjamanPage> createState() => _HistoriPeminjamanPageState();
}

class _HistoriPeminjamanPageState extends State<HistoriPeminjamanPage> {
  final List<PeminjamanItem> _listHistori = [
    const PeminjamanItem(
      id: 201,
      gedung: "Gedung B",
      lantai: 1,
      namaRuangan: "Ruang Prodi Teknik Komputer",
      statusPinjaman: "Diterima",
      start: TimeOfDay(hour: 12, minute: 0),
      end: TimeOfDay(hour: 24, minute: 0),
    ),

    const PeminjamanItem(
      id: 202,
      gedung: "Gedung E",
      lantai: 1,
      namaRuangan: "20.4E.01.001",
      statusPinjaman: "Tidak Diterima",
      start: TimeOfDay(hour: 12, minute: 0),
      end: TimeOfDay(hour: 24, minute: 0)
    ),

    const PeminjamanItem(
      id: 202,
      gedung: "Gedung E",
      lantai: 1,
      namaRuangan: "20.4E.01.001",
      statusPinjaman: "Sedang diajukan",
      start: TimeOfDay(hour: 12, minute: 0),
      end: TimeOfDay(hour: 24, minute: 0)
    ),
  ];

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
            borderRadius: BorderRadius.circular(
              24.0,
            ), 
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

                _listHistori.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: Text(
                            "Belum ada pengajuan peminjaman.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: _listHistori.length,
                        itemBuilder: (context, index) {
                          final itemHistori = _listHistori[index];

                          return PeminjamanCard(
                            showAction: false,
                            item: PeminjamanItem(
                              id: itemHistori.id,
                              gedung: itemHistori.gedung,
                              lantai: itemHistori.lantai,
                              namaRuangan: itemHistori.namaRuangan,
                              statusPinjaman: itemHistori.statusPinjaman,
                              start: itemHistori.start,
                              end: itemHistori.end,
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
