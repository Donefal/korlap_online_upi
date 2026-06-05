import 'package:flutter/material.dart';

class ButtonAction extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final double? width;
  final Alignment posisi;
  final EdgeInsetsGeometry margin;

  /// Custom ButtonAction
  /// 
  /// Parameter:
  /// - **required onPressed**: Fungsi callback ketika tombol ditekan
  /// - **text**: Teks yang ditampilkan pada tombol (nullable, jika null tombol hanya menampilkan ikon)
  /// - **icon**: Ikon pendukung yang diletakkan di sebelah teks (nullable)
  /// - **isLoading**: Kondisi loading untuk menampilkan progress indicator (default: false, triggernya onpressed) 
  /// - **backgroundColor**: Warna latar belakang tombol (default: putih)
  /// - **textColor**: Warna teks dan ikon tombol (default: biru azure)
  /// - **width**: Lebar kustom tombol, jika null panjangnya otomatis mengikuti teks
  /// - **posisi**: Penyelarasan posisi objek tombol di dalam layar (default: Alignment.topCenter)
  /// - **margin**: Jarak aman luar tombol (default: bottom 20)
  
  const ButtonAction({
    super.key,
    required this.onPressed,
    this.text,
    this.icon,
    this.isLoading = false,
    this.backgroundColor = Colors.white,
    this.textColor = const Color.fromARGB(255, 0, 128, 255),
    this.width,
    this.posisi = Alignment.center,
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

  // Helper method untuk membangun konten normal (Ikon & Teks)
  Widget _buildButtonContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) 
          Icon(icon, color: textColor, size: 20),
        if (icon != null && text != null) 
          const SizedBox(width: 8),
        if (text != null)
          Flexible(
            child: Text(
              text!,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
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
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              elevation: isLoading ? 0 : 2,
              padding: const EdgeInsets.symmetric(horizontal: 16),
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