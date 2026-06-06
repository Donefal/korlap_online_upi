import 'package:flutter/material.dart';

class ButtonMenu extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final double? width;
  final double height;
  final Alignment posisi;
  final EdgeInsetsGeometry margin;

  /// Custom ButtonMenu (Ikon di atas, Teks di bawah)
  /// 
  /// Parameter:
  /// - **required text**: Teks yang ditampilkan di bawah ikon (ukuran lebih kecil)
  /// - **required onPressed**: Fungsi callback ketika tombol ditekan
  /// - **required icon**: Ikon utama yang diletakkan di atas teks
  /// - **isLoading**: Kondisi loading untuk menampilkan progress indicator (default: false)
  /// - **backgroundColor**: Warna latar belakang tombol (default: putih)
  /// - **textColor**: Warna teks dan ikon tombol (default: biru azure)
  /// - **width**: Lebar kustom tombol, jika null panjangnya otomatis mengikuti konten
  /// - **height**: Tinggi kustom tombol (default: 72 agar proporsional secara vertikal)
  /// - **posisi**: Penyelarasan posisi objek tombol di dalam layar (default: Alignment.topCenter)
  /// - **margin**: Jarak aman luar tombol (default: bottom 20)
  const ButtonMenu({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
    this.isLoading = false,
    this.backgroundColor = const Color.fromARGB(255, 0, 128, 255),
    this.textColor = Colors.white,
    this.width = 100,
    this.height = 90, 
    this.posisi = Alignment.topCenter,
    this.margin = const EdgeInsets.only(bottom: 20),
  });

  // Helper method untuk membangun indikator loading
  Widget _buildLoadingIndicator() {
    return const SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(
        color: Color.fromARGB(255, 0, 128, 255),
        strokeWidth: 2.5,
      ),
    );
  }

  // Helper method untuk membangun konten Vertikal (Ikon di atas, Teks di bawah)
  Widget _buildButtonContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: textColor, size: 26),
        const SizedBox(height: 6), // Jarak antara ikon dan teks
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: textColor,
              fontSize: 14, // Ukuran teks dibuat lebih kecil (default sebelumnya 16)
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Align(
        alignment: posisi,
        child: SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              elevation: isLoading ? 0 : 2,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: isLoading ? null : onPressed,
            child: isLoading ? _buildLoadingIndicator() : _buildButtonContent(),
          ),
        ),
      ),
    );
  }
}