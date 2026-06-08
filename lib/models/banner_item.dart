import 'package:flutter/material.dart';

class BannerItem {
  final String header;      // Menggantikan text lama
  final String? subText;    // Menambahkan sub-teks (opsional)
  final Color? backgroundColor;
  final String? imageUrl;

  BannerItem({
    required this.header,
    this.subText,
    this.backgroundColor,
    this.imageUrl,
  });
}