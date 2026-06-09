import 'package:flutter/material.dart';
import 'package:korlap_online_upi/pages/more_peminjaman/confirm_pembatalan.dart';
import 'package:korlap_online_upi/widgets/navbar.dart';
import 'package:korlap_online_upi/widgets/list_peminjaman.dart';

class StatusPeminjamanPage extends StatefulWidget {
  const StatusPeminjamanPage({super.key});

  @override
  State<StatusPeminjamanPage> createState() => _StatusPeminjamanPageState();
}

class _StatusPeminjamanPageState extends State<StatusPeminjamanPage> {

  void _moveToAction(int id) {
    Navigator.push(
      context, 
      MaterialPageRoute(builder:(context) => ConfirmPembatalanPage(id: id))
    );

  }

  final List<PeminjamanItem> _listAjuan = [
    PeminjamanItem(
      id: 101,
      gedung: "Gedung B",
      lantai: 3,
      namaRuangan: "Embedded & Network Laboratory",
      statusPinjaman: "Sedang diajukan",
      start: TimeOfDay(hour: 12, minute: 0),
      end: TimeOfDay(hour: 14, minute: 0),
      date: DateTime(2026, 6, 9),
    ),
    PeminjamanItem(
      id: 102,
      gedung: "Gedung B",
      lantai: 3,
      namaRuangan: "20.4B.03.007",
      statusPinjaman: "Diterima", // this won't show
      start: TimeOfDay(hour: 9, minute: 0),
      end: TimeOfDay(hour: 11, minute: 0),
      date: DateTime(2026, 6, 9),
    ),
  ];

  // filter here
  List<PeminjamanItem> get _listOnGoing =>
      _listAjuan.where((item) => item.statusPinjaman == "Sedang diajukan").toList();

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
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    "Status Pengajuan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                _listOnGoing.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: Text(
                            "Tidak ada pengajuan yang sedang diajukan.",
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
                        itemCount: _listOnGoing.length,
                        itemBuilder: (context, index) {
                          final peminjaman = _listOnGoing[index];

                          return PeminjamanCard(
                            item: PeminjamanItem(
                              id: peminjaman.id, 
                              gedung: peminjaman.gedung, 
                              lantai: peminjaman.lantai, 
                              namaRuangan: peminjaman.namaRuangan, 
                              statusPinjaman: peminjaman.statusPinjaman, 
                              start: peminjaman.start, 
                              end: peminjaman.end, 
                              date: peminjaman.date,

                              action: () {
                                _moveToAction(peminjaman.id);
                              },
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