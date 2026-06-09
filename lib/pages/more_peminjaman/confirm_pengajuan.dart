// file: confirm_pengajuan.dart
import 'package:flutter/material.dart';
import 'package:korlap_online_upi/widgets/index.dart';
import 'package:korlap_online_upi/widgets/navbar.dart';
import 'package:korlap_online_upi/widgets/button_aksi.dart'; 

import 'package:korlap_online_upi/services/peminjaman_service.dart';
import 'package:korlap_online_upi/models/peminjaman_model.dart';

class ConfirmPengajuanPage extends StatefulWidget {
  final int id;
  const ConfirmPengajuanPage({super.key, required this.id});

  @override
  State<ConfirmPengajuanPage> createState() => _ConfirmPengajuanPageState();
}

class _ConfirmPengajuanPageState extends State<ConfirmPengajuanPage> {
  final PeminjamanService _peminjamanService = PeminjamanService();
  PeminjamanModel? _detailPeminjaman;
  
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _muatDetailPengajuan();
  }

  Future<void> _muatDetailPengajuan() async {
    try {
      final data = await _peminjamanService.fetchDetailPeminjaman(widget.id);
      setState(() {
        _detailPeminjaman = data;
        _isLoading = false;
      });
    } catch (e) {
      // 💡 Mencetak log error asli ke Debug Console agar mudah dilacak jika terjadi error parsing
      debugPrint("ERROR_PARSING_MODEL: $e");
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _prosesAksiStatus(String statusBaru) async {
    setState(() => _isSubmitting = true);
    try {
      final berhasil = await _peminjamanService.updateStatusPeminjaman(widget.id, statusBaru);
      setState(() => _isSubmitting = false);

      if (berhasil) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Pengajuan berhasil di-set menjadi: $statusBaru")),
        );
        Navigator.pop(context); 
      } else {
        _tampilkanPesan("Gagal memperbarui status di sistem.");
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      _tampilkanPesan(e.toString());  
    }
  }

  void _tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 20, left: 20, top: 30, bottom: 10),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
          child: Padding(
            padding: const EdgeInsets.only(right: 15, left: 15, top: 24, bottom: 40),
            child: _isLoading 
                ? const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()))
                : _errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0), 
                          // Jika error, teks di bawah ini akan memunculkan detail pesan errornya
                          child: Text("Terjadi Gangguan:\n$_errorMessage", textAlign: TextAlign.center, style: const TextStyle(color: Colors.red))
                        )
                      )
                    : _detailPeminjaman == null
                        ? const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text("Data pengajuan tidak ditemukan.")))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(child: AppText(text: "Aksi Peminjaman", mode: TextMode.header)),
                              const SizedBox(height: 24),

                              // Tampilan Box Ringkasan Data Pengajuan
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("ID Pengajuan: #${_detailPeminjaman!.id}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const Divider(),
                                    Text("Gedung / Lantai: ${_detailPeminjaman!.gedung} / Lantai ${_detailPeminjaman!.lantai}"),
                                    const SizedBox(height: 6),
                                    Text("Ruangan: ${_detailPeminjaman!.namaRuangan}", style: const TextStyle(fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 6),
                                    Text("Tanggal: ${_detailPeminjaman!.tanggalPeminjaman.toLocal().toString().split(' ')[0]}"),
                                    const SizedBox(height: 6),
                                    // 💡 SEKARANG BISA MENAMPILKAN JAM KARENA SUDAH DISINKRONKAN DENGAN MODEL
                                    Text("Waktu: ${_detailPeminjaman!.waktuMulaiPeminjaman.format(context)} - ${_detailPeminjaman!.waktuAkhirPeminjaman.format(context)}"),
                                    const SizedBox(height: 10),
                                    Text("Status saat ini: ${_detailPeminjaman!.statusPengajuan}", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 30),

                              // Tombol Kontrol Pilihan Admin
                              _isSubmitting
                                  ? const Center(child: CircularProgressIndicator())
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        ButtonAction(
                                          onPressed: () => _prosesAksiStatus("diterima"),
                                          text: "Terima Pengajuan",
                                          backgroundColor: Colors.green,
                                          height: 50,
                                        ),
                                        const SizedBox(height: 16),
                                        ButtonAction(
                                          onPressed: () => _prosesAksiStatus("ditolak"),
                                          text: "Tolak Pengajuan",
                                          backgroundColor: Colors.red,
                                          height: 50,
                                        ),
                                      ],
                                    ),
                            ],
                          ),
          ),
        ),
      ),
    );
  }
}