// file: lib/pages/peminjaman/peminjaman_ruangan_3.dart
import 'package:flutter/material.dart';
import 'package:korlap_online_upi/widgets/navbar.dart';
import 'package:korlap_online_upi/widgets/button_aksi.dart';
import 'package:korlap_online_upi/widgets/list_gedung.dart';
import 'package:korlap_online_upi/widgets/form_bar.dart';
import 'package:file_picker/file_picker.dart';

// Import Service Baru
import 'package:korlap_online_upi/services/peminjaman_service.dart';

class FormPengajuanPage extends StatefulWidget {
  final RuanganItem ruangan;

  const FormPengajuanPage({super.key, required this.ruangan});

  @override
  State<FormPengajuanPage> createState() => _FormPengajuanPageState();
}

class _FormPengajuanPageState extends State<FormPengajuanPage> {
  final TextEditingController _namaKegiatanCtrl = TextEditingController();
  final TextEditingController _keperluanCtrl = TextEditingController();

  TimeOfDay? _waktuMulai;
  TimeOfDay? _waktuSelesai;
  DateTime? _hari;

  // Ubah tipe data menjadi PlatformFile untuk menampung objek file asli
  PlatformFile? _fileSK;
  PlatformFile? _fileSPM;

  final PeminjamanService _peminjamanService = PeminjamanService();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _namaKegiatanCtrl.dispose();
    _keperluanCtrl.dispose();
    super.dispose();
  }

  // Helper untuk mengubah format TimeOfDay ke format database (HH:mm:ss)
  String _formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return "$hours:$minutes:00";
  }

  Future<void> _pilihWaktu(BuildContext context, bool isMulai) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isMulai) {
          _waktuMulai = picked;
        } else {
          _waktuSelesai = picked;
        }
      });
    }
  }

  Future<void> _pilihTanggal(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        _hari = pickedDate;
      });
    }
  }

  Future<void> _pilihFile(String jenisFile) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        if (jenisFile == 'SK') {
          _fileSK = result.files.first;
        } else if (jenisFile == 'PM') {
          _fileSPM = result.files.first;
        }
      });
    }
  }

  Future<void> _kirimFormulirKeAPI() async {
    if (_namaKegiatanCtrl.text.isEmpty ||
        _keperluanCtrl.text.isEmpty ||
        _waktuMulai == null ||
        _waktuSelesai == null ||
        _hari == null ||
        _fileSK == null ||
        _fileSPM == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Harap lengkapi semua form, waktu, dan file dokumen!"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Format data agar sesuai kebutuhan database MySQL
      String formattedDate = "${_hari!.year}-${_hari!.month.toString().padLeft(2, '0')}-${_hari!.day.toString().padLeft(2, '0')}";
      String formattedWaktuMulai = _formatTimeOfDay(_waktuMulai!);
      String formattedWaktuSelesai = _formatTimeOfDay(_waktuSelesai!);
      
      // Gabungkan input Kegiatan dan Detail ke kolom keperluan database
      String gabunganKeperluan = "Kegiatan: ${_namaKegiatanCtrl.text}\nDetail: ${_keperluanCtrl.text}";

      // Id akun sementara diset 1 (Nanti bisa diganti dengan ID User yang sedang login)
      int idAkunPlaceholder = 1; 

      bool success = await _peminjamanService.kirimPengajuan(
        idRuangan: widget.ruangan.id,
        idAkun: idAkunPlaceholder,
        tanggalPeminjaman: formattedDate,
        waktuMulai: formattedWaktuMulai,
        waktuSelesai: formattedWaktuSelesai,
        keperluan: gabunganKeperluan,
        fileSK: _fileSK,
        fileSPM: _fileSPM,
      );

      setState(() {
        _isSubmitting = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Pengajuan Acara ${_namaKegiatanCtrl.text} Berhasil Dikirim!"),
            backgroundColor: Colors.green,
          ),
        );
        // Kembali ke halaman utama dashboard
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal mengirim pengajuan ke server. Coba lagi."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
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
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 15, left: 15, top: 24, bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Peminjaman Ruangan",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 2.0, bottom: 16.0),
                  child: Text(
                    "Pengajuan",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
                  ),
                ),

                RuanganCard(
                  showNext: false,
                  item: RuanganItem(
                    id: widget.ruangan.id,
                    gedung: widget.ruangan.gedung,
                    lantai: widget.ruangan.lantai,
                    namaRuangan: widget.ruangan.namaRuangan,
                    status: widget.ruangan.status,
                    jenisRuangan: widget.ruangan.jenisRuangan,
                    onPinjam: null,
                  ),
                ),

                const SizedBox(height: 30),
                const Text("Formulir Data Pengajuan:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                FormBar(
                  formCtrl: _namaKegiatanCtrl,
                  formLabel: "Nama Kegiatan / Acara",
                  size: 3, margin: 0, formIcon: FormIcon.none,
                ),
                const SizedBox(height: 14),

                FormBar(
                  formCtrl: _keperluanCtrl,
                  formLabel: "Detail Keperluan Acara",
                  size: 3, margin: 0, formIcon: FormIcon.none,
                ),
                const SizedBox(height: 30),

                const Text("Waktu Peminjaman Ruangan:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 15),

                OutlinedButton.icon(
                  onPressed: () => _pilihTanggal(context),
                  icon: const Icon(Icons.calendar_month_rounded),
                  label: Text(
                    _hari == null
                        ? "Pilih Tanggal"
                        : "${_hari!.day.toString().padLeft(2, '0')}/${_hari!.month.toString().padLeft(2, '0')}/${_hari!.year}",
                  ),
                ),
                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pilihWaktu(context, true),
                        icon: const Icon(Icons.access_time_filled_rounded, size: 18),
                        label: Text(_waktuMulai == null ? "Jam Mulai" : "Mulai: ${_waktuMulai!.format(context)}", style: const TextStyle(fontSize: 13)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: _waktuMulai != null ? Colors.blue : Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pilihWaktu(context, false),
                        icon: const Icon(Icons.access_time_rounded, size: 18),
                        label: Text(_waktuSelesai == null ? "Jam Selesai" : "Selesai: ${_waktuSelesai!.format(context)}", style: const TextStyle(fontSize: 13)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: _waktuSelesai != null ? Colors.blue : Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                const Text("Unggah Dokumen Pendukung (SK & PM):", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 10),

                _buildUploadBox(
                  label: "Upload Surat Kegiatan (SK)",
                  fileName: _fileSK?.name,
                  onTap: () => _pilihFile('SK'),
                ),
                const SizedBox(height: 12),

                _buildUploadBox(
                  label: "Upload Surat Peminjaman (SPM)",
                  fileName: _fileSPM?.name,
                  onTap: () => _pilihFile('PM'),
                ),
                const SizedBox(height: 24),

                _isSubmitting
                    ? const Center(child: CircularProgressIndicator())
                    : ButtonAction(
                        text: "Ajukan",
                        icon: Icons.send_rounded,
                        width: 120, height: 45,
                        posisi: Alignment.centerRight,
                        margin: const EdgeInsets.only(bottom: 20),
                        backgroundColor: Colors.green,
                        onPressed: _kirimFormulirKeAPI,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadBox({required String label, required String? fileName, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: fileName == null ? Colors.grey.shade100 : Colors.green.shade50,
          border: Border.all(color: fileName == null ? Colors.grey.shade400 : Colors.green),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              fileName == null ? Icons.cloud_upload_rounded : Icons.check_circle_rounded,
              color: fileName == null ? Colors.grey.shade700 : Colors.green,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  fileName != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            fileName,
                            style: const TextStyle(fontSize: 11, color: Colors.black54, fontStyle: FontStyle.italic),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}