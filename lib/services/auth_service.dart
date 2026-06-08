import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_config.dart'; // Sesuaikan dengan jalur file IP Config Anda

class AuthService {
  // Fungsi untuk mengirim nomor induk dan password ke backend PHP
  Future<Map<String, dynamic>?> loginBackend(String nomorInduk, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.login),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nomor_induk": nomorInduk,
          "password": password,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        // Mengembalikan data user (id, nama, role, instansi) dari dalam 'data'
        return responseData['data'];
      } else {
        // Jika gagal (password salah / tidak terdaftar), lempar pesan error dari PHP
        throw responseData['message'] ?? 'Gagal login';
      }
    } catch (e) {
      rethrow;
    }
  }
}