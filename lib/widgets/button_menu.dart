import 'package:flutter/material.dart';

class ButtonMenu extends StatelessWidget {
  final String text;
  final String desc;
  final VoidCallback onPressed;
  final IconData icon;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final Alignment posisi;
  final EdgeInsetsGeometry margin;
  final bool disable;

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
    required this.desc,
    required this.onPressed,
    required this.icon,
    this.isLoading = false,
    this.backgroundColor = Colors.white,
    this.textColor = const Color.fromARGB(255, 0, 128, 255),
    this.height = 100, 
    this.posisi = Alignment.topCenter,
    this.margin = const EdgeInsets.all(20),
    this.disable = false,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: textColor, size: 26),
        const SizedBox(height: 2), // Jarak antara ikon dan teks
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: textColor,
              fontSize: 14, // Ukuran teks dibuat lebih kecil (default sebelumnya 16)
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Flexible(
          child: Text(
            desc,
            maxLines: 2,
            style: TextStyle(
              color: textColor,
              fontSize: 10, // Ukuran teks dibuat lebih kecil (default sebelumnya 16)
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double halfWidth = MediaQuery.of(context).size.width / 2 - 20;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: margin,
        child: Align(
          alignment: posisi,
          child: SizedBox(
            width: halfWidth,
            height: height,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                alignment: Alignment.topLeft,
                backgroundColor: backgroundColor,
                elevation: isLoading ? 0 : 5,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: disable||isLoading ? null : onPressed,
              child: isLoading ? _buildLoadingIndicator() : _buildButtonContent(),
            ),
          ),
        ),
      ),
    );
  }
}