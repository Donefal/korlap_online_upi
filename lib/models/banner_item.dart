import 'package:flutter/material.dart';

// Model untuk menyimpan data setiap banner
class BannerItem {
  final String text;
  final Color? backgroundColor;
  final String? imageUrl;

  BannerItem({
    required this.text,
    this.backgroundColor,
    this.imageUrl,
  });
}