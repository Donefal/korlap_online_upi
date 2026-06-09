// file: lib/pages/peminjaman/status_peminjaman.dart
import 'package:flutter/material.dart';
import 'package:korlap_online_upi/pages/more_peminjaman/confirm_pembatalan.dart';
import 'package:korlap_online_upi/widgets/navbar.dart';
import 'package:korlap_online_upi/widgets/list_peminjaman.dart';

// Import Service dan Model Baru
import 'package:korlap_online_upi/services/peminjaman_service.dart';
import 'package:korlap_online_upi/models/peminjaman_model.dart';

class StatusPeminjamanPage extends StatefulWidget {
  const StatusPeminjamanPage({super.key});

  @override
  State<StatusPeminjamanPage> createState() => _StatusPeminjamanPageState();
}

class _StatusPeminjamanPageState extends State<StatusPeminjamanPage> {
  final PeminjamanService _peminjamanService = PeminjamanService();
  List<PeminjamanModel> _masterPeminjamanList = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _muatDataStatusPeminjaman();
  }

  Future<void> _muatDataStatusPeminjaman() async {
    try {
      // Menggunakan id_akun = 1 sebagai placeholder (Sama seperti peminjaman_ruangan_3.dart)
      int idAkunPlaceholder = 1; 
      
      final data = await _peminjamanService.fetchStatusPeminjaman(idAkunPlaceholder);
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

  void _moveToAction(int id) {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => ConfirmPembatalanPage(id: id)),
    ).then((value) {
      // Jika user kembali dari halaman pembatalan, refresh data otomatis
      setState(() {
        _isLoading = true;
      });
      _muatDataStatusPeminjaman();
    });
  }

  // Filter dinamis berdasarkan status pengajuan dari database MySQL
  List<PeminjamanModel> get _listOnGoing => _masterPeminjamanList
      .where((item) => item.statusPengajuan.toLowerCase() == "sedang diajukan")
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavbar(),
      body: RefreshIndicator(
        onRefresh: _muatDataStatusPeminjaman, // Fitur swipe to refresh data
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(right: 20, left: 20, top: 30, bottom: 10),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, top: 24, bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: Text(
                      "Status Pengajuan",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),

                  // Kontrol UI Dinamis Berbasis Status API (Mengikuti logika peminjaman_ruangan_1.dart)
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
                          style: TextStyle(color: Colors.red),
                          "Gagal memuat status pengajuan:\n$_errorMessage",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else if (_listOnGoing.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: Text(
                          "Tidak ada pengajuan yang sedang diajukan.",
                          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: _listOnGoing.length,
                      itemBuilder: (context, index) {
                        final peminjaman = _listOnGoing[index];

                        // Mapping data dari PeminjamanModel ke widget PeminjamanCard Anda
                        return PeminjamanCard(
                          item: PeminjamanItem(
                            id: peminjaman.id,
                            gedung: peminjaman.gedung,
                            // Parsing string lantai ke int jika widget PeminjamanItem mewajibkan int
                            lantai: int.tryParse(peminjaman.lantai) ?? 0, 
                            namaRuangan: peminjaman.namaRuangan,
                            statusPinjaman: peminjaman.statusPengajuan,
                            start: peminjaman.waktuMulaiPeminjaman,
                            end: peminjaman.waktuAkhirPeminjaman,
                            date: peminjaman.tanggalPeminjaman,
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
      ),
    );
  }
}