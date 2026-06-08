import 'package:flutter/material.dart';
import 'package:korlap_online_upi/widgets/navbar.dart';
import 'package:korlap_online_upi/widgets/navbar_bawah.dart';
import 'package:korlap_online_upi/widgets/list_gedung.dart';

class StatusPeminjamanPage extends StatefulWidget {
  const StatusPeminjamanPage({super.key});

  @override
  State<StatusPeminjamanPage> createState() => _StatusPeminjamanPageState();
}

class _StatusPeminjamanPageState extends State<StatusPeminjamanPage> {
  final List<RuanganItem> _listAjuanOnGoing = [
    const RuanganItem(
      id: 101,
      gedung: "Gedung B",
      lantai: 3,
      namaRuangan: "Embedded & Network Laboratory",
      status: "sudah ada yg mengajukan",
      jenisRuangan: "Laboratorium",
    ),
    const RuanganItem(
      id: 102,
      gedung: "Gedung B",
      lantai: 3,
      namaRuangan: "20.4B.03.007",
      status: "sudah dipinjam",
      jenisRuangan: "Ruang Kelas",
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
            ), // Higher number = more rounded
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

                _listAjuanOnGoing.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: Text(
                            "Tidak ada pengajuan on-going / yang masih valid.",
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
                        itemCount: _listAjuanOnGoing.length,
                        itemBuilder: (context, index) {
                          final itemAjuan = _listAjuanOnGoing[index];

                          return RuanganCard(
                            item: RuanganItem(
                              id: itemAjuan.id,
                              gedung: itemAjuan.gedung,
                              lantai: itemAjuan.lantai,
                              namaRuangan: itemAjuan.namaRuangan,
                              status: itemAjuan.status,
                              jenisRuangan: itemAjuan.jenisRuangan,
                              onPinjam: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Melihat detail status: ${itemAjuan.namaRuangan}",
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
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
