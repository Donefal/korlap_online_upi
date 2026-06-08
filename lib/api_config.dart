class ApiConfig {
  // Ganti 'localhost' dengan IP Laptop/WiFi Anda, contoh: '119.168.1.10'
  // Cara cek IP di CMD: ipconfig (cari IPv4 Address)
  static const String baseUrl = "http://localhost/korlap_online_upi_backend";
  
  // Endpoint URL List
  static const String login = "$baseUrl/api/login.php";
  static const String register = "$baseUrl/api/register.php";
  static const String getRuangan = "$baseUrl/api/get_ruangan.php";
  static const String tambahPeminjaman = "$baseUrl/api/tambah_peminjaman.php";
  static const String historyPeminjaman = "$baseUrl/api/history_peminjaman.php";
  static const String getPeminjamanAdmin = "$baseUrl/api/get_peminjaman_admin.php";
  static const String updateStatusPeminjaman = "$baseUrl/api/update_status_peminjaman.php";
}