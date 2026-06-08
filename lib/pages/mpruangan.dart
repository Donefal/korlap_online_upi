import 'package:flutter/material.dart';
import 'package:korlap_online_upi/pages/adminaction.dart';
import 'package:korlap_online_upi/pages/homeview/user_home_view.dart';
import 'package:korlap_online_upi/widgets/dropdown.dart';
import 'package:korlap_online_upi/widgets/index.dart';
import 'package:korlap_online_upi/widgets/navbar.dart';
import 'package:korlap_online_upi/widgets/button_aksi.dart';
import 'package:korlap_online_upi/widgets/navbar_bawah.dart';
import 'package:korlap_online_upi/widgets/list_gedung.dart';
import 'package:korlap_online_upi/pages/peminjaman/peminjaman_ruangan_2.dart';
import 'package:korlap_online_upi/widgets/list_peminjaman.dart';

class ManageRuanganPage extends StatefulWidget {
  const ManageRuanganPage({super.key});

  @override
  State<ManageRuanganPage> createState() => _ManageRuanganPageState();
}

class _ManageRuanganPageState extends State<ManageRuanganPage> {
  final TextEditingController _gedungCtrl = TextEditingController();
  final TextEditingController _lantaiCtrl = TextEditingController();
  final TextEditingController _statusCtrl = TextEditingController();

  final List<String> _dataGedung = ["Gedung B", "Gedung E"];
  final List<String> _dataStatus = ["Diterima", "Tidak Diterima", "Sedang Diajukan"];
  List<String> _dataLantai = [];

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

  List<PeminjamanItem> _filterRuanganList = [];

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
    if ((_gedungCtrl.text.isEmpty || _lantaiCtrl.text.isEmpty) && (_statusCtrl.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silakan pilih data terlebih dahulu!"),
        ),
      );
      return;
    }

    if(_statusCtrl.text.isNotEmpty) {
      setState(() {
        _filterRuanganList = _listHistori.where((ruangan) {
          return ruangan.statusPinjaman == _statusCtrl.text;
        }).toList();
      });


      return;
    }

    final int angkaLantaiTujuan = int.parse(_lantaiCtrl.text);

    setState(() {
      _filterRuanganList = _listHistori.where((ruangan) {
        return ruangan.gedung == _gedungCtrl.text &&
            ruangan.lantai == angkaLantaiTujuan;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayList = _filterRuanganList.isEmpty
        ? _listHistori
        : _filterRuanganList;

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
                      Center(child: AppText(text: "Peminjaman Ruangan", mode: TextMode.header)),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: AppDropDown(
                              ddCtrl: _gedungCtrl,
                              data: _dataGedung,
                              ddLabel: "Gedung",
                              size: 1,
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
                              size: 1,
                              margin: 0,
                              iconChoice: DdIcon.lantai,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: AppDropDown(
                              key: UniqueKey(),
                              ddCtrl: _statusCtrl,
                              data: _dataStatus,
                              ddLabel: "Lantai",
                              size: 1,
                              margin: 0,
                              iconChoice: DdIcon.status,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          ButtonAction(
                            text: "Filter",
                            icon: Icons.search,
                            width: 120,
                            height: 42,
                            posisi: Alignment.centerRight,
                            margin: const EdgeInsets.only(bottom: 20),
                            onPressed: _eksekusiFilter,
                          ),
                        ],
                      ),

                      AppText(
                        text: "List Pengajuan:",
                        mode: TextMode.subheaderbesar,
                      ),

                      const SizedBox(height: 6),
                    ],
                  ),
                ),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayList.length,
                  itemBuilder: (context, index) {
                    final ruangan = displayList[index];

                    return PeminjamanCard(
                      item: PeminjamanItem(
                        id: ruangan.id,
                        gedung: ruangan.gedung,
                        lantai: ruangan.lantai,
                        namaRuangan: ruangan.namaRuangan,
                        statusPinjaman: ruangan.statusPinjaman,
                        start: ruangan.start,
                        end: ruangan.end,
                        yesAction: () {

                        },

                        noAction: () {

                        }
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
