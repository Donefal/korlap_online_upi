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
  
  const ButtonAction({
    Key? key,
    this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.backgroundColor = Colors.white,// warna bg diatur putih tapi bisa diatur 
    this.textColor = const Color.fromARGB(255, 0, 128, 255), //warna teks diatur biru azure tapi bisa diatur 
    this.width,
    this.posisi = Alignment.topCenter, // diatur posisi defaultnya center
    this.margin = const EdgeInsets.only(bottom: 20),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 3. Bungkus dengan Align untuk mengatur posisi objek tombolnya di layar
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), 
              ),
              elevation: isLoading ? 0 : 2, 
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onPressed: isLoading ? null : onPressed,
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 0, 128, 255),
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    // Konten di dalam tombol (teks & ikon) harus selalu di tengah tombol
                    mainAxisAlignment: MainAxisAlignment.center, 
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) Icon(icon, color: textColor, size: 20),
                      if (icon != null && text != null) const SizedBox(width: 8),
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
                  ),
          ),
        ),
      ),
    );
  }
}