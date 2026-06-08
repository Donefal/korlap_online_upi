import 'package:flutter/material.dart';
import 'package:korlap_online_upi/pages/adminaction.dart';
import 'package:korlap_online_upi/pages/homeview/user_home_view.dart';
import 'package:korlap_online_upi/widgets/dropdown.dart';
import 'package:korlap_online_upi/widgets/navbar.dart';
import 'package:korlap_online_upi/widgets/button_aksi.dart';
import 'package:korlap_online_upi/widgets/navbar_bawah.dart';
import 'package:korlap_online_upi/widgets/list_gedung.dart';
import 'package:korlap_online_upi/pages/peminjaman/peminjaman_ruangan_2.dart';

class PeminjamanRuanganPage extends StatefulWidget {
  const PeminjamanRuanganPage({super.key});

  @override
  State<PeminjamanRuanganPage> createState() => _PeminjamanRuanganPageState();
}

class _PeminjamanRuanganPageState extends State<PeminjamanRuanganPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [const UserHomeView(), const AdminActionPage()];

  final TextEditingController _gedungCtrl = TextEditingController();
  final TextEditingController _lantaiCtrl = TextEditingController();

  final List<String> _dataGedung = ["Gedung B", "Gedung E"];
  List<String> _dataLantai = [];

  final List<RuanganItem> _masterRuanganList = [
    RuanganItem(
      id: 1,
      gedung: "Gedung B",
      lantai: 1,
      namaRuangan: "Ruang Prodi TeknIK Komputer",
      status: "Tersedia",
      jenisRuangan: "Ruangan Prodi",
    ),
    RuanganItem(
      id: 2,
      gedung: "Gedung B",
      lantai: 2,
      namaRuangan: "Laboratorium Bahasa",
      status: "Tersedia",
      jenisRuangan: "Laboratorium",
    ),
    RuanganItem(
      id: 3,
      gedung: "Gedung B",
      lantai: 3,
      namaRuangan: "20.4B.03.007",
      status: "Tersedia",
      jenisRuangan: "Ruang Kelas",
    ),
    RuanganItem(
      id: 4,
      gedung: "Gedung B",
      lantai: 3,
      namaRuangan: "20.4B.03.009",
      status: "Tersedia",
      jenisRuangan: "Ruangan Microteaching",
    ),
    RuanganItem(
      id: 5,
      gedung: "Gedung B",
      lantai: 3,
      namaRuangan: "20.4B.03.010",
      status: "Tersedia",
      jenisRuangan: "Ruangan Microteaching Observer",
    ),
    RuanganItem(
      id: 6,
      gedung: "Gedung B",
      lantai: 3,
      namaRuangan: "Embedded & Network Laboratory",
      status: "Tersedia",
      jenisRuangan: "Laboratorium",
    ),
    RuanganItem(
      id: 7,
      gedung: "Gedung B",
      lantai: 3,
      namaRuangan: "20.4B.03.001",
      status: "Tersedia",
      jenisRuangan: "Ruang Kelas",
    ),
    RuanganItem(
      id: 8,
      gedung: "Gedung B",
      lantai: 3,
      namaRuangan: "Audio Visual Laboratory",
      status: "Tersedia",
      jenisRuangan: "Laboratorium",
    ),
    RuanganItem(
      id: 9,
      gedung: "Gedung B",
      lantai: 3,
      namaRuangan: "Laboratorium Komputer Pendidikan",
      status: "Tersedia",
      jenisRuangan: "Laboratorium",
    ),
    RuanganItem(
      id: 10,
      gedung: "Gedung B",
      lantai: 3,
      namaRuangan: "20.4B.03.002",
      status: "Tersedia",
      jenisRuangan: "Ruang Kelas",
    ),
    RuanganItem(
      id: 11,
      gedung: "Gedung B",
      lantai: 4,
      namaRuangan: "20.4B.04.001",
      status: "Tersedia",
      jenisRuangan: "Ruang Kelas",
    ),
    RuanganItem(
      id: 12,
      gedung: "Gedung B",
      lantai: 4,
      namaRuangan: "20.4B.04.002",
      status: "Tersedia",
      jenisRuangan: "Ruang Kelas",
    ),
    RuanganItem(
      id: 13,
      gedung: "Gedung B",
      lantai: 4,
      namaRuangan: "20.4B.04.009",
      status: "Tersedia",
      jenisRuangan: "Ruang Kelas",
    ),
    RuanganItem(
      id: 14,
      gedung: "Gedung B",
      lantai: 4,
      namaRuangan: "20.4B.04.005",
      status: "Tersedia",
      jenisRuangan: "Ruang Kelas",
    ),
    RuanganItem(
      id: 15,
      gedung: "Gedung B",
      lantai: 3,
      namaRuangan: "20.4B.03.006",
      status: "Tersedia",
      jenisRuangan: "Ruang Kelas",
    ),
    RuanganItem(
      id: 16,
      gedung: "Gedung B",
      lantai: 5,
      namaRuangan: "20.4B.05.005",
      status: "Tersedia",
      jenisRuangan: "Ruang Kelas",
    ),
    RuanganItem(
      id: 17,
      gedung: "Gedung B",
      lantai: 5,
      namaRuangan: "20.4B.05.007",
      status: "Tersedia",
      jenisRuangan: "Ruang Kelas",
    ),
    RuanganItem(
      id: 18,
      gedung: "Gedung B",
      lantai: 5,
      namaRuangan: "20.4B.05.008",
      status: "Tersedia",
      jenisRuangan: "Ruang Kelas",
    ),
    RuanganItem(
      id: 19,
      gedung: "Gedung B",
      lantai: 5,
      namaRuangan: "20.4B.05.009",
      status: "Tersedia",
      jenisRuangan: "Ruang Kelas",
    ),
    RuanganItem(
      id: 20,
      gedung: "Gedung B",
      lantai: 5,
      namaRuangan: "20.4B.05.000",
      status: "Tersedia",
      jenisRuangan: "Ruang Kelas",
    ),
    RuanganItem(
      id: 21,
      gedung: "Gedung B",
      lantai: 5,
      namaRuangan: "20.4B.05.002",
      status: "Tersedia",
      jenisRuangan: "Ruang Kelas",
    ),
    RuanganItem(
      id: 22,
      gedung: "Gedung B",
      lantai: 5,
      namaRuangan: "20.4B.05.001",
      status: "Tersedia",
      jenisRuangan: "Ruang Kelas",
    ),

    RuanganItem(
      id: 23,
      gedung: "Gedung E",
      lantai: 1,
      namaRuangan: "20.4E.01.004",
      status: "Tersedia",
      jenisRuangan: "Ruang Kelas",
    ),
    RuanganItem(
      id: 24,
      gedung: "Gedung E",
      lantai: 2,
      namaRuangan: "20.4E.02.006",
      status: "Tersedia",
      jenisRuangan: "Ruang Kelas",
    ),
    RuanganItem(
      id: 25,
      gedung: "Gedung E",
      lantai: 1,
      namaRuangan: "20.4E.01.001",
      status: "Tersedia",
      jenisRuangan: "Ruang Kelas",
    ),
    RuanganItem(
      id: 26,
      gedung: "Gedung E",
      lantai: 3,
      namaRuangan: "20.4E.03.003",
      status: "Tersedia",
      jenisRuangan: "Ruang Kelas",
    ),
    RuanganItem(
      id: 27,
      gedung: "Gedung E",
      lantai: 3,
      namaRuangan: "20.4E.03.002",
      status: "Tersedia",
      jenisRuangan: "Ruang Kelas",
    ),
    RuanganItem(
      id: 28,
      gedung: "Gedung E",
      lantai: 3,
      namaRuangan: "20.4E.03.001",
      status: "Tersedia",
      jenisRuangan: "Ruang Kelas",
    ),
    RuanganItem(
      id: 29,
      gedung: "Gedung E",
      lantai: 3,
      namaRuangan: "20.4E.03.000",
      status: "Tersedia",
      jenisRuangan: "Ruang Kelas",
    ),
  ];

  List<RuanganItem> _filterRuanganList = [];

  @override
  void initState() {
    super.initState();
    _gedungCtrl.addListener(_onGedungChanged);
  }

  @override
  void dispose() {
    _gedungCtrl.removeListener(_onGedungChanged);
    _gedungCtrl.dispose();
    _lantaiCtrl.dispose();
    super.dispose();
  }

  void _onGedungChanged() {
    setState(() {
      _lantaiCtrl.clear();
      if (_gedungCtrl.text == "Gedung B") {
        _dataLantai = ["1", "2", "3", "4", "5"];
      } else if (_gedungCtrl.text == "Gedung E") {
        _dataLantai = ["1", "2", "3"];
      } else {
        _dataLantai = [];
      }
    });
  }

  void _eksekusiFilter() {
    if (_gedungCtrl.text.isEmpty || _lantaiCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silakan pilih Gedung dan Lantai terlebih dahulu!"),
        ),
      );
      return;
    }

    final int angkaLantaiTujuan = int.parse(_lantaiCtrl.text);

    setState(() {
      _filterRuanganList = _masterRuanganList.where((ruangan) {
        return ruangan.gedung == _gedungCtrl.text &&
            ruangan.lantai == angkaLantaiTujuan;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavbar(),
      body: SingleChildScrollView(
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
              right: 15.0,
              left: 15.0,
              top: 24,
              bottom: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 12.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Peminjaman Ruangan",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: AppDropDown(
                              ddCtrl: _gedungCtrl,
                              data: _dataGedung,
                              ddLabel: "Gedung",
                              size: 2,
                              margin: 0,
                              iconChoice: DdIcon.gedung,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppDropDown(
                              key: UniqueKey(),
                              ddCtrl: _lantaiCtrl,
                              data: _dataLantai,
                              ddLabel: "Lantai",
                              size: 2,
                              margin: 0,
                              iconChoice: DdIcon.lantai,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      ButtonAction(
                        text: "Filter",
                        icon: Icons.search,
                        width: 120,
                        height: 42,
                        posisi: Alignment.centerRight,
                        margin: const EdgeInsets.only(bottom: 20),
                        onPressed: _eksekusiFilter,
                      ),

                      const Text(
                        "List Peminjaman Ruangan:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),

                _filterRuanganList.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Text(
                            "Tidak ada data.\nSilakan tentukan Gedung & Lantai lalu klik Filter.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        // IMPORTANT FIXES FOR SINGLECHILDSCROLLVIEW:
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filterRuanganList.length,
                        itemBuilder: (context, index) {
                          final ruangan = _filterRuanganList[index];

                          return RuanganCard(
                            item: RuanganItem(
                              id: ruangan.id,
                              gedung: ruangan.gedung,
                              lantai: ruangan.lantai,
                              namaRuangan: ruangan.namaRuangan,
                              status: ruangan.status,
                              jenisRuangan: ruangan.jenisRuangan,

                              onPinjam: () {
                                print(
                                  "Membuka panduan peminjaman ruangan: ${ruangan.namaRuangan}",
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailPeminjamanPage(ruangan: ruangan),
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
