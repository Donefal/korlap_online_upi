// file: lib/models/peminjaman_model.dart
import 'package:flutter/material.dart';

class PeminjamanModel {
  final int id;
  final int idRuangan;
  final String namaRuangan;
  final String gedung;
  final String lantai;
  final String statusPengajuan; 
  final DateTime tanggalPeminjaman;
  final TimeOfDay waktuMulaiPeminjaman;
  final TimeOfDay waktuAkhirPeminjaman;

  PeminjamanModel({
    required this.id,
    required this.idRuangan,
    required this.namaRuangan,
    required this.gedung,
    required this.lantai,
    required this.statusPengajuan,
    required this.tanggalPeminjaman,
    required this.waktuMulaiPeminjaman,
    required this.waktuAkhirPeminjaman,
  });

  factory PeminjamanModel.fromJson(Map<String, dynamic> json) {
    // Helper mengubah String "HH:mm:ss" dari PHP ke TimeOfDay Flutter
    TimeOfDay parseTimeString(String timeStr) {
      final parts = timeStr.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    return PeminjamanModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      idRuangan: json['id_ruangan'] is int ? json['id_ruangan'] : int.parse(json['id_ruangan'].toString()),
      
      // 💡 Pastikan key di bawah ini sesuai dengan field yang di-SELECT oleh query model PHP Anda
      namaRuangan: json['nama_ruangan'] ?? '',
      gedung: json['gedung'] ?? '',
      lantai: json['lantai']?.toString() ?? '0',
      
      // Biasanya di database bertipe enum/string: 'Sedang diajukan', 'Disetujui', 'Ditolak'
      statusPengajuan: json['status_pengajuan'] ?? json['status_peminjaman'] ?? 'Sedang diajukan', 
      
      tanggalPeminjaman: DateTime.parse(json['tanggal_peminjaman']),
      waktuMulaiPeminjaman: parseTimeString(json['waktu_mulai_peminjaman'] ?? json['waktu_awal'] ?? '00:00:00'),
      waktuAkhirPeminjaman: parseTimeString(json['waktu_akhir_peminjaman'] ?? json['waktu_selesai'] ?? '00:00:00'),
    );
  }
}