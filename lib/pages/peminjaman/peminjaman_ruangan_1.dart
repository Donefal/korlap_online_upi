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

// Import Model dan Service API
import 'package:korlap_online_upi/models/ruangan_model.dart';
import 'package:korlap_online_upi/services/ruangan_service.dart';

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

  // Inisialisasi Service dan State manajemen penampung data dari database PHP
  final RuanganService _ruanganService = RuanganService();
  List<RuanganModel> _masterRuanganList = [];
  List<RuanganModel> _filterRuanganList = [];
  
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _gedungCtrl.addListener(_onGedungChanged);
    _muatDataRuanganFromServer(); // Ambil data saat halaman dibuka
  }

  @override
  void dispose() {
    _gedungCtrl.removeListener(_onGedungChanged);
    _gedungCtrl.dispose();
    _lantaiCtrl.dispose();
    super.dispose();
  }

  Future<void> _muatDataRuanganFromServer() async {
    try {
      final data = await _ruanganService.fetchRuangan();
      setState(() {
        _masterRuanganList = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
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

    setState(() {
      _filterRuanganList = _masterRuanganList.where((ruangan) {
        return ruangan.gedung.toLowerCase() == _gedungCtrl.text.toLowerCase() &&
            ruangan.lantai == _lantaiCtrl.text;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan daftar render berdasarkan status filter pencarian
    final displayList = _filterRuanganList.isEmpty && _gedungCtrl.text.isEmpty
        ? _masterRuanganList
        : _filterRuanganList;

    return Scaffold(
      appBar: const AppNavbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 20, left: 20, top: 30, bottom: 10),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 15.0, left: 15.0, top: 24, bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0),
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

                      AppText(
                        text: "List Peminjaman Ruangan:",
                        mode: TextMode.subheaderbesar,
                      ),

                      const SizedBox(height: 6),
                    ],
                  ),
                ),

                // Manajemen UI Dinamis berbasis state data API
                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (_errorMessage != null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Gagal memuat data ruangan:\n$_errorMessage",
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else if (displayList.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Text(
                        "Tidak ada ruangan yang sesuai filter.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
                      final ruangan = displayList[index];

                      return RuanganCard(
                        item: RuanganItem(
                          id: ruangan.id,
                          gedung: ruangan.gedung,
                          lantai: int.tryParse(ruangan.lantai) ?? 0, 
                          namaRuangan: ruangan.namaRuangan,
                          status: ruangan.status,
                          jenisRuangan: ruangan.jenisRuangan,
                          onPinjam: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPeminjamanPage(
                                  ruangan: RuanganItem(
                                    id: ruangan.id,
                                    gedung: ruangan.gedung,
                                    lantai: int.tryParse(ruangan.lantai) ?? 0,
                                    namaRuangan: ruangan.namaRuangan,
                                    status: ruangan.status,
                                    jenisRuangan: ruangan.jenisRuangan,
                                  ),
                                ),
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