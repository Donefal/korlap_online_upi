import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_config.dart';
import '../models/ruangan_model.dart';

class RuanganService {
  Future<List<RuanganModel>> fetchRuangan() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.getRuangan));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        if (responseData['status'] == 'success') {
          List<dynamic> listData = responseData['data'];
          // Looping data JSON menjadi List berbasis Model
          return listData.map((e) => RuanganModel.fromJson(e)).toList();
        } else {
          throw responseData['message'] ?? 'Gagal mengambil data ruangan';
        }
      } else {
        throw 'Gagal terhubung ke server (${response.statusCode})';
      }
    } catch (e) {
      rethrow;
    }
  }
}