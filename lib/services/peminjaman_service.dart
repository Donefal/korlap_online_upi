import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // 💡 WAJIB IMPORT INI UNTUK kIsWeb
import 'package:korlap_online_upi/models/peminjaman_model.dart';

class PeminjamanService {
  // 💡 Catatan URL: 
  // Jika run di Flutter Web, gunakan 'localhost'. 
  // Jika run di Emulator Android, gunakan '10.0.2.2'.
  final String baseUrl = kIsWeb ? "http://localhost/korlap_online_upi_backend/api" : "http://10.0.2.2/korlap_online_upi_backend/api"; 

  Future<bool> kirimPengajuan({
    required int idRuangan,
    required int idAkun,
    required String tanggalPeminjaman,
    required String waktuMulai,
    required String waktuSelesai,
    required String keperluan,
    required PlatformFile? fileSK,
    required PlatformFile? fileSPM,
  }) async {
    try {
      var uri = Uri.parse("$baseUrl/tambah_peminjaman.php");
      var request = http.MultipartRequest('POST', uri);

      // Mengisi form fields teks
      request.fields['id_ruangan'] = idRuangan.toString();
      request.fields['id_akun'] = idAkun.toString();
      request.fields['tanggal_peminjaman'] = tanggalPeminjaman;
      request.fields['waktu_mulai_peminjaman'] = waktuMulai;
      request.fields['waktu_akhir_peminjaman'] = waktuSelesai;
      request.fields['keperluan'] = keperluan;

      // 💡 SINKRONISASI FILE SK (Sesuai kolom database: doc_SIK)
      if (fileSK != null) {
        if (kIsWeb) {
          // Khusus Web: Ambil data berdasarkan bytes, bukan path
          if (fileSK.bytes != null) {
            request.files.add(http.MultipartFile.fromBytes(
              'doc_SIK', 
              fileSK.bytes!, 
              filename: fileSK.name,
            ));
          }
        } else {
          // Khusus Mobile: Ambil data berdasarkan path file lokal
          if (fileSK.path != null) {
            request.files.add(await http.MultipartFile.fromPath('doc_SIK', fileSK.path!));
          }
        }
      }

      // 💡 SINKRONISASI FILE SPM (Sesuai kolom database: doc_SPM)
      if (fileSPM != null) {
        if (kIsWeb) {
          // Khusus Web: Ambil data berdasarkan bytes
          if (fileSPM.bytes != null) {
            request.files.add(http.MultipartFile.fromBytes(
              'doc_SPM', 
              fileSPM.bytes!, 
              filename: fileSPM.name,
            ));
          }
        } else {
          // Khusus Mobile: Ambil data berdasarkan path
          if (fileSPM.path != null) {
            request.files.add(await http.MultipartFile.fromPath('doc_SPM', fileSPM.path!));
          }
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return jsonResponse['success'] == true;
      }
      return false;
    } catch (e) {
      // Menangkap log error asli untuk mempermudah debugging jika gagal
      throw Exception("Terjadi kesalahan sistem: $e");
    }
  }

  Future<List<PeminjamanModel>> fetchStatusPeminjaman(int idAkun) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/history_peminjaman.php?id_akun=$idAkun"));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        
        // 💡 SINKRONISASI: Ambil list data dari key ['data'] sesuai format backend PHP Anda
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
          final List<dynamic> listData = jsonResponse['data'];
          return listData.map((data) => PeminjamanModel.fromJson(data)).toList();
        } else {
          return []; // Jika sukses tapi data kosong
        }
      } else {
        throw Exception("Gagal memuat data dari server (Status: ${response.statusCode})");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan sistem: $e");
    }
  }
  Future<List<PeminjamanModel>> fetchAllPeminjaman() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/get_all_peminjaman.php"));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
          final List<dynamic> listData = jsonResponse['data'];
          return listData.map((data) => PeminjamanModel.fromJson(data)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception("Gagal memuat data manajemen (Status: ${response.statusCode})");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan sistem: $e");
    }
  }

  Future<PeminjamanModel?> fetchDetailPeminjaman(int id) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/get_detail_peminjaman.php?id=$id"));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
          return PeminjamanModel.fromJson(jsonResponse['data']);
        }
      }
      return null;
    } catch (e) {
      throw Exception("Gagal memuat detail pengajuan: $e");
    }
  }

  // 💡 FUNGSI UPDATE STATUS PENGAJUAN (TERIMA / TOLAK)
  Future<bool> updateStatusPeminjaman(int id, String statusBaru) async {
    try {
      final Map<String, dynamic> requestBody = {
        "id_peminjaman": id,
        "status_pengajuan": statusBaru,
        "catatan_petugas": null
      };

      final response = await http.post(
        Uri.parse("$baseUrl/update_status_peminjaman.php"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode(requestBody),
      );

      // Cek apa yang dimuntahkan PHP di debug console kamu
      debugPrint("KODE RESPONS: ${response.statusCode}");
      debugPrint("ISI RESPONS: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['status'] == 'success';
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Terjadi kesalahan sistem: $e");
      return false;
    }
  }
}