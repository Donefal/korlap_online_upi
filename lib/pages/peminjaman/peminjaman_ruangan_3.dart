import 'package:flutter/material.dart';
import 'package:korlap_online_upi/widgets/navbar.dart';
import 'package:korlap_online_upi/widgets/navbar_bawah.dart';
import 'package:korlap_online_upi/widgets/button_aksi.dart';
import 'package:korlap_online_upi/widgets/list_gedung.dart';
import 'package:korlap_online_upi/widgets/form_bar.dart';
import 'package:file_picker/file_picker.dart';

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

  String? _namaFileSK;
  String? _namaFilePM;

  @override
  void dispose() {
    _namaKegiatanCtrl.dispose();
    _keperluanCtrl.dispose();
    super.dispose();
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
    {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
      );

      if (result != null && result.files.isNotEmpty) {
        final platformFile = result.files.first;
        final String? namaTerpilih = platformFile.name;

        if (namaTerpilih != null && namaTerpilih.isNotEmpty) {
          setState(() {
            if (jenisFile == 'SK') {
              _namaFileSK = namaTerpilih;
            } else if (jenisFile == 'PM') {
              _namaFilePM = namaTerpilih;
            }
          });
        }
      }
    }
  }

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
                const Text(
                  "Peminjaman Ruangan",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 2.0, bottom: 16.0),
                  child: Text(
                    "Pengajuan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
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

                const Text(
                  "Formulir Data Pengajuan:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                FormBar(
                  formCtrl: _namaKegiatanCtrl,
                  formLabel: "Nama Kegiatan / Acara",
                  size: 3,
                  margin: 0,
                  formIcon: FormIcon.none,
                ),
                const SizedBox(height: 14),

                FormBar(
                  formCtrl: _keperluanCtrl,
                  formLabel: "Detail Keperluan Acara",
                  size: 3,
                  margin: 0,
                  formIcon: FormIcon.none,
                ),
                const SizedBox(height: 30),

                const Text(
                  "Waktu Peminjaman Ruangan:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),

                OutlinedButton.icon(
                  onPressed: () => _pilihTanggal(context),
                  icon: const Icon(Icons.calendar_month_rounded),
                  label: Text(
                    _hari == null
                        ? "Pilih Tanggal"
                        // 👇 Formats the date manually so it looks like DD/MM/YYYY
                        : "${_hari!.day.toString().padLeft(2, '0')}/${_hari!.month.toString().padLeft(2, '0')}/${_hari!.year}",
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pilihWaktu(context, true),
                        icon: const Icon(
                          Icons.access_time_filled_rounded,
                          size: 18,
                        ),
                        label: Text(
                          _waktuMulai == null
                              ? "Jam Mulai"
                              : "Mulai: ${_waktuMulai!.format(context)}",
                          style: const TextStyle(fontSize: 13),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(
                            color: _waktuMulai != null
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pilihWaktu(context, false),
                        icon: const Icon(Icons.access_time_rounded, size: 18),
                        label: Text(
                          _waktuSelesai == null
                              ? "Jam Selesai"
                              : "Selesai: ${_waktuSelesai!.format(context)}",
                          style: const TextStyle(fontSize: 13),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(
                            color: _waktuSelesai != null
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                const Text(
                  "Unggah Dokumen Pendukung (SK & PM):",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),

                _buildUploadBox(
                  label: "Upload Surat Kegiatan (SK)",
                  fileName: _namaFileSK,
                  onTap: () => _pilihFile('SK'),
                ),
                const SizedBox(height: 12),

                _buildUploadBox(
                  label: "Upload Surat Peminjaman (SPM)",
                  fileName: _namaFilePM,
                  onTap: () => _pilihFile('SPM'),
                ),

                const SizedBox(height: 24),

                ButtonAction(
                  text: "Ajukan",
                  icon: Icons.send_rounded,
                  width: 120,
                  height: 45,
                  posisi: Alignment.centerRight,
                  margin: const EdgeInsets.only(bottom: 20),
                  backgroundColor: Colors.green,
                  onPressed: () {
                    if (_namaKegiatanCtrl.text.isEmpty ||
                        _keperluanCtrl.text.isEmpty ||
                        _waktuMulai == null ||
                        _waktuSelesai == null ||
                        _namaFileSK == null ||
                        _namaFilePM == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Harap lengkapi semua form, waktu, dan file dokumen!",
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      return;
                    }

                    print("Nama Kegiatan: ${_namaKegiatanCtrl.text}");
                    print("Keperluan: ${_keperluanCtrl.text}");
                    print(
                      "Durasi: ${_waktuMulai!.format(context)} s/d ${_waktuSelesai!.format(context)}",
                    );
                    print("File SK: $_namaFileSK");
                    print("File PM: $_namaFilePM");

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Pengajuan Acara ${_namaKegiatanCtrl.text} Berhasil Dikirim!",
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadBox({
    required String label,
    required String? fileName,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: fileName == null ? Colors.grey.shade100 : Colors.green.shade50,
          border: Border.all(
            color: fileName == null ? Colors.grey.shade400 : Colors.green,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              fileName == null
                  ? Icons.cloud_upload_rounded
                  : Icons.check_circle_rounded,
              color: fileName == null ? Colors.grey.shade700 : Colors.green,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  fileName != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            fileName,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                              fontStyle: FontStyle.italic,
                            ),
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
