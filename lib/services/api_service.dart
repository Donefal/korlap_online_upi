// lib/services/api_service.dart
//
// Service layer untuk komunikasi antara Flutter dan Laravel backend.
// Semua HTTP request ke API dikentralisasi di sini.
//
// Cara pakai di page/widget:
//   final api = ApiService();
//   final result = await api.login('2200123', 'user123');
//
// Struktur response dari Laravel selalu:
//   { "success": true/false, "message": "...", "data": {...} }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // ─────────────────────────────────────────────────────────
  // BASE URL — Ganti sesuai IP server kamu
  // Jika pakai emulator Android: 10.0.2.2 (host machine)
  // Jika pakai device fisik: IP komputer di jaringan yang sama
  // Contoh: 'http://192.168.1.5:8000'
  // ─────────────────────────────────────────────────────────
  static const String baseUrl = 'http://10.0.2.2:8000';

  // Header standar untuk semua request
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ─────────────────────────────────────────────────────────
  // Helper: Ambil token dari SharedPreferences
  // Token ini disimpan oleh SessionProvider.login() setelah login berhasil
  // ─────────────────────────────────────────────────────────
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // ─────────────────────────────────────────────────────────
  // Helper: Header dengan token (untuk endpoint yang butuh auth)
  // Laravel Sanctum membaca token dari: Authorization: Bearer {token}
  // ─────────────────────────────────────────────────────────
  Future<Map<String, String>> _authHeaders() async {
    final token = await _getToken();
    return {
      ..._defaultHeaders,
      'Authorization': 'Bearer $token',
    };
  }

  // ─────────────────────────────────────────────────────────
  // Helper: Parse response JSON dari Laravel
  // ─────────────────────────────────────────────────────────
  Map<String, dynamic> _parseResponse(http.Response response) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  // =============================================================
  // AUTH ENDPOINTS
  // =============================================================

  /// POST /api/auth/login
  ///
  /// Mengirim NIM + password ke backend, mendapat token & role kembali.
  /// Dipanggil dari LoginPage saat tombol "Login" ditekan.
  ///
  /// Menggantikan TODO di login_page.dart:
  ///   "TODO: Ganti 'HalamanHome()' dengan kelas page..."
  ///
  /// Return: Map dengan keys: success, token, role, user
  Future<Map<String, dynamic>> login(String nimNip, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: _defaultHeaders,
      body: jsonEncode({
        'nim_nip': nimNip,
        'password': password,
      }),
    );
    return _parseResponse(response);
  }

  /// POST /api/auth/register
  Future<Map<String, dynamic>> register({
    required String nimNip,
    required String nama,
    required String password,
    required String passwordConfirmation,
    String? email,
    String? jurusan,
    String? fakultas,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: _defaultHeaders,
      body: jsonEncode({
        'nim_nip': nimNip,
        'nama': nama,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'email': email,
        'jurusan': jurusan,
        'fakultas': fakultas,
      }),
    );
    return _parseResponse(response);
  }

  /// POST /api/auth/logout
  ///
  /// Invalidate token di server.
  /// Dipanggil sebelum SessionProvider.logout() yang menghapus token lokal.
  Future<Map<String, dynamic>> logout() async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/logout'),
      headers: await _authHeaders(),
    );
    return _parseResponse(response);
  }

  /// GET /api/auth/me
  ///
  /// Ambil data profil user yang sedang login.
  Future<Map<String, dynamic>> getMe() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/auth/me'),
      headers: await _authHeaders(),
    );
    return _parseResponse(response);
  }

  // =============================================================
  // RUANGAN ENDPOINTS
  // =============================================================

  /// GET /api/ruangan
  ///
  /// Daftar ruangan. Mengembalikan list yang cocok dengan RuanganItem.
  ///
  /// Parameter opsional:
  ///   gedung: filter nama gedung (contoh: 'FPMIPA')
  ///   status: filter status (contoh: 'tersedia')
  ///   jenis: filter jenis (contoh: 'Laboratorium')
  ///   search: cari berdasarkan nama ruangan
  Future<Map<String, dynamic>> getRuangan({
    String? gedung,
    String? status,
    String? jenis,
    String? search,
  }) async {
    // Bangun query string dari parameter yang tidak null
    final queryParams = <String, String>{};
    if (gedung != null) queryParams['gedung'] = gedung;
    if (status != null) queryParams['status'] = status;
    if (jenis != null) queryParams['jenis'] = jenis;
    if (search != null) queryParams['search'] = search;

    final uri = Uri.parse('$baseUrl/api/ruangan')
        .replace(queryParameters: queryParams.isEmpty ? null : queryParams);

    final response = await http.get(uri, headers: _defaultHeaders);
    return _parseResponse(response);
  }

  /// GET /api/ruangan/{id}
  Future<Map<String, dynamic>> getRuanganDetail(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/ruangan/$id'),
      headers: _defaultHeaders,
    );
    return _parseResponse(response);
  }

  // =============================================================
  // PEMINJAMAN ENDPOINTS
  // =============================================================

  /// GET /api/peminjaman
  ///
  /// Daftar peminjaman.
  ///   - Jika user biasa: hanya miliknya
  ///   - Jika admin: semua
  ///
  /// status: filter ('menunggu', 'disetujui', 'ditolak', 'selesai', 'dibatalkan')
  /// page: halaman untuk pagination
  Future<Map<String, dynamic>> getPeminjaman({String? status, int page = 1}) async {
    final queryParams = <String, String>{'page': '$page'};
    if (status != null) queryParams['status'] = status;

    final uri = Uri.parse('$baseUrl/api/peminjaman')
        .replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: await _authHeaders());
    return _parseResponse(response);
  }

  /// POST /api/peminjaman
  ///
  /// Mengajukan peminjaman baru.
  /// Dipakai di halaman "Pinjam Ruangan".
  Future<Map<String, dynamic>> ajukanPeminjaman({
    required int ruanganId,
    required String keperluan,
    required String tanggalPinjam, // Format: 'YYYY-MM-DD'
    required String jamMulai,      // Format: 'HH:MM'
    required String jamSelesai,    // Format: 'HH:MM'
    int? jumlahPeserta,
    String? catatanUser,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/peminjaman'),
      headers: await _authHeaders(),
      body: jsonEncode({
        'ruangan_id': ruanganId,
        'keperluan': keperluan,
        'tanggal_pinjam': tanggalPinjam,
        'jam_mulai': jamMulai,
        'jam_selesai': jamSelesai,
        'jumlah_peserta': jumlahPeserta,
        'catatan_user': catatanUser,
      }),
    );
    return _parseResponse(response);
  }

  /// DELETE /api/peminjaman/{id}
  ///
  /// User membatalkan pengajuannya.
  Future<Map<String, dynamic>> batalkanPeminjaman(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/peminjaman/$id'),
      headers: await _authHeaders(),
    );
    return _parseResponse(response);
  }

  // Admin: Setujui pengajuan
  /// PUT /api/admin/peminjaman/{id}/setujui
  Future<Map<String, dynamic>> setujuiPeminjaman(int id, {String? catatan}) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/admin/peminjaman/$id/setujui'),
      headers: await _authHeaders(),
      body: jsonEncode({'catatan_admin': catatan}),
    );
    return _parseResponse(response);
  }

  // Admin: Tolak pengajuan
  /// PUT /api/admin/peminjaman/{id}/tolak
  Future<Map<String, dynamic>> tolakPeminjaman(int id, {required String alasan}) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/admin/peminjaman/$id/tolak'),
      headers: await _authHeaders(),
      body: jsonEncode({'catatan_admin': alasan}),
    );
    return _parseResponse(response);
  }

  // =============================================================
  // BANNER ENDPOINTS
  // =============================================================

  /// GET /api/banners
  ///
  /// Ambil daftar banner aktif.
  /// Dipanggil di halaman home untuk mengisi BannerCarousel.
  Future<Map<String, dynamic>> getBanners() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/banners'),
      headers: _defaultHeaders,
    );
    return _parseResponse(response);
  }

  // =============================================================
  // NOTIFIKASI ENDPOINTS
  // =============================================================

  /// GET /api/notifikasi
  Future<Map<String, dynamic>> getNotifikasi({int page = 1}) async {
    final uri = Uri.parse('$baseUrl/api/notifikasi')
        .replace(queryParameters: {'page': '$page'});
    final response = await http.get(uri, headers: await _authHeaders());
    return _parseResponse(response);
  }

  /// GET /api/notifikasi/unread-count
  ///
  /// Jumlah notifikasi belum dibaca (untuk badge di ikon notifikasi).
  Future<Map<String, dynamic>> getUnreadCount() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/notifikasi/unread-count'),
      headers: await _authHeaders(),
    );
    return _parseResponse(response);
  }

  /// PUT /api/notifikasi/{id}/baca
  Future<Map<String, dynamic>> tandaiBaca(int id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/notifikasi/$id/baca'),
      headers: await _authHeaders(),
    );
    return _parseResponse(response);
  }

  /// PUT /api/notifikasi/baca-semua
  Future<Map<String, dynamic>> tandaiBacaSemua() async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/notifikasi/baca-semua'),
      headers: await _authHeaders(),
    );
    return _parseResponse(response);
  }
}
