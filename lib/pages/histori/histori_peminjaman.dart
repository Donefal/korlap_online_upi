import 'package:flutter/material.dart';
import 'package:korlap_online_upi/widgets/list_peminjaman.dart';
import 'package:korlap_online_upi/widgets/navbar.dart';

// 💡 IMPORT SERVICE DAN MODEL YANG SUDAH DIBUAT
import 'package:korlap_online_upi/services/peminjaman_service.dart';
import 'package:korlap_online_upi/models/peminjaman_model.dart';

class HistoriPeminjamanPage extends StatefulWidget {
  const HistoriPeminjamanPage({super.key});

  @override
  State<HistoriPeminjamanPage> createState() => _HistoriPeminjamanPageState();
}

class _HistoriPeminjamanPageState extends State<HistoriPeminjamanPage> {
  // 💡 INISIALISASI STATE MANAJEMEN API
  final PeminjamanService _peminjamanService = PeminjamanService();
  List<PeminjamanModel> _listHistori = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _muatDataHistori();
  }

  // 💡 FUNGSI UNTUK MENGAMBIL DATA DARI BACKEND
  Future<void> _muatDataHistori() async {
    try {
      // Menggunakan id_akun = 1 sebagai placeholder akun user aktif
      int idAkunPlaceholder = 1; 
      
      final data = await _peminjamanService.fetchStatusPeminjaman(idAkunPlaceholder);
      setState(() {
        _listHistori = data; // Menampung semua data tanpa di-filter statusnya
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavbar(),
      body: RefreshIndicator(
        onRefresh: _muatDataHistori, // Fitur tarik ke bawah untuk refresh data terbaru
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Memastikan scroll aktif meski data sedikit
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
                      "Histori Peminjaman",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  // 💡 KONTROL UI BERDASARKAN STATUS LOADING / ERROR / DATA
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
                          "Gagal memuat histori:\n$_errorMessage",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red), // Style diletakkan di dalam Text
                        ),
                      ),
                    )
                  else if (_listHistori.isEmpty)
                    const Center(
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
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: _listHistori.length,
                      itemBuilder: (context, index) {
                        final itemHistori = _listHistori[index];

                        return PeminjamanCard(
                          showAction: false, // Tetap false karena ini halaman histori (hanya baca)
                          item: PeminjamanItem(
                            id: itemHistori.id,
                            gedung: itemHistori.gedung,
                            // Antisipasi konversi tipe data string lantai dari DB menjadi int di widget
                            lantai: int.tryParse(itemHistori.lantai) ?? 0,
                            namaRuangan: itemHistori.namaRuangan,
                            statusPinjaman: itemHistori.statusPengajuan,
                            start: itemHistori.waktuMulaiPeminjaman,
                            end: itemHistori.waktuAkhirPeminjaman,
                            date: itemHistori.tanggalPeminjaman,
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