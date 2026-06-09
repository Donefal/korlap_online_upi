// file: mpruangan.dart
import 'package:flutter/material.dart';
import 'package:korlap_online_upi/pages/more_peminjaman/confirm_pengajuan.dart';
import 'package:korlap_online_upi/widgets/index.dart';
import 'package:korlap_online_upi/widgets/list_peminjaman.dart';

// 💡 IMPORT SERVICE DAN MODEL
import 'package:korlap_online_upi/services/peminjaman_service.dart';
import 'package:korlap_online_upi/models/peminjaman_model.dart';

class ManageRuanganPage extends StatefulWidget {
  const ManageRuanganPage({super.key});

  @override
  State<ManageRuanganPage> createState() => _ManageRuanganPageState();
}

class _ManageRuanganPageState extends State<ManageRuanganPage> {
  // 💡 INISIALISASI STATE MANAGEMENT API
  final PeminjamanService _peminjamanService = PeminjamanService();
  List<PeminjamanModel> _masterPeminjamanList = [];
  List<PeminjamanModel> _filterPeminjamanList = [];
  
  bool _isLoading = true;
  bool _isFiltered = false; // Flag untuk mendeteksi status filter aktif
  String? _errorMessage;

  void _moveToAction(int id) {
    Navigator.push(
      context, 
      MaterialPageRoute(builder:(context) => ConfirmPengajuanPage(id: id))
    ).then((_) {
      // Refresh otomatis setelah admin memproses persetujuan/penolakan
      _muatSemuaDataPeminjaman();
    });
  }

  final TextEditingController _gedungCtrl = TextEditingController();
  final TextEditingController _lantaiCtrl = TextEditingController();
  final TextEditingController _statusCtrl = TextEditingController();

  final List<String> _dataGedung = ["Gedung B", "Gedung E"];
  final List<String> _dataStatus = ["Diterima", "Tidak Diterima", "Sedang Diajukan"];
  List<String> _dataLantai = [];

  @override
  void initState() {
    super.initState();
    _gedungCtrl.addListener(_onGedungChanged);
    _muatSemuaDataPeminjaman(); // 💡 Ambil data dari server saat halaman dibuka
  }

  @override
  void dispose() {
    _gedungCtrl.removeListener(_onGedungChanged);
    _gedungCtrl.dispose();
    _lantaiCtrl.dispose();
    _statusCtrl.dispose();
    super.dispose();
  }

  // 💡 AMBIL DATA DARI BACKEND
  Future<void> _muatSemuaDataPeminjaman() async {
    try {
      setState(() {
        _isLoading = true;
        _isFiltered = false;
        _errorMessage = null;
      });
      
      final data = await _peminjamanService.fetchAllPeminjaman();
      
      setState(() {
        _masterPeminjamanList = data;
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

  // 💡 LOGIKA FILTER DATA BERBASIS MODEL DATABASE
  void _eksekusiFilter() {
    if ((_gedungCtrl.text.isEmpty || _lantaiCtrl.text.isEmpty) && (_statusCtrl.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silakan pilih data terlebih dahulu!"),
        ),
      );
      return;
    }

    setState(() {
      _isFiltered = true;
      
      // Jika filter status dipilih
      if (_statusCtrl.text.isNotEmpty) {
        _filterPeminjamanList = _masterPeminjamanList.where((peminjaman) {
          return peminjaman.statusPengajuan.toLowerCase() == _statusCtrl.text.toLowerCase();
        }).toList();
        return;
      }

      // Jika filter Gedung dan Lantai dipilih
      _filterPeminjamanList = _masterPeminjamanList.where((peminjaman) {
        return peminjaman.gedung == _gedungCtrl.text &&
            peminjaman.lantai == _lantaiCtrl.text;
      }).toList();
    });
  }

  // Fungsi untuk mereset filter kembali ke awal
  void _resetFilter() {
    setState(() {
      _gedungCtrl.clear();
      _lantaiCtrl.clear();
      _statusCtrl.clear();
      _isFiltered = false;
      _filterPeminjamanList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan data mana yang akan ditampilkan ke user
    final displayList = _isFiltered ? _filterPeminjamanList : _masterPeminjamanList;

    return Scaffold(
      appBar: const AppNavbar(),
      body: RefreshIndicator(
        onRefresh: _muatSemuaDataPeminjaman,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                                ddLabel: "Status", // 💡 Perbaikan label dari sebelumnya "Lantai"
                                size: 1,
                                margin: 0,
                                iconChoice: DdIcon.status,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (_isFiltered) ...[
                              ElevatedButton.icon(
                                onPressed: _resetFilter,
                                icon: const Icon(Icons.refresh, size: 16),
                                label: const Text("Reset"),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade300, foregroundColor: Colors.black),
                              ),
                              const SizedBox(width: 8),
                            ],
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
  
                  // 💡 KONTROL UI BERDASARKAN STATUS CALL API BACKEND
                  if (_isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_errorMessage != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Gagal memuat manajemen pengajuan:\n$_errorMessage",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    )
                  else if (displayList.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: Text(
                          "Tidak ada pengajuan peminjaman ditemukan.",
                          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
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
  
                        return PeminjamanCard(
                          item: PeminjamanItem(
                            id: ruangan.id,
                            gedung: ruangan.gedung,
                            // Sinkronisasi konversi tipe data String dari DB ke int widget Anda
                            lantai: int.tryParse(ruangan.lantai) ?? 0,
                            namaRuangan: ruangan.namaRuangan, 
                            statusPinjaman: ruangan.statusPengajuan,
                            start: ruangan.waktuMulaiPeminjaman,
                            end: ruangan.waktuAkhirPeminjaman,
                            date: ruangan.tanggalPeminjaman,
                            action: () {
                              _moveToAction(ruangan.id);
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
      ),
    );
  }
}