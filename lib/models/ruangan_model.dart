class RuanganModel {
  final int id;
  final String namaRuangan;
  final String gedung;
  final String lantai;
  final String jenisRuangan;
  final String status;

  RuanganModel({
    required this.id,
    required this.namaRuangan,
    required this.gedung,
    required this.lantai,
    required this.jenisRuangan,
    required this.status,
  });

  // Fungsi untuk konversi dari JSON PHP ke Object Dart Flutter
  factory RuanganModel.fromJson(Map<String, dynamic> json) {
    return RuanganModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      namaRuangan: json['nama_ruangan'] ?? '',
      gedung: json['gedung'] ?? '',
      lantai: json['lantai'] ?? '',
      jenisRuangan: json['jenis_ruangan'] ?? '',
      status: json['status'] ?? 'tersedia',
    );
  }
}