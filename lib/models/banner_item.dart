import 'package:flutter/material.dart';
import 'dart:async';

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