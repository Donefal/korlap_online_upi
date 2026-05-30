/*

Pengaturan tema utama, untuk penggunaan:

Pakai `Theme.of(context).colorScheme.primaryContainer,` di property style: pada elemen terkait
*/

import 'package:flutter/material.dart';

class AppTheme {
  static const _seedColor = Colors.red;

  static ThemeData get main => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: _seedColor), // Warna utama
    brightness: Brightness.dark,

    // Input data ke theme psuat
    textTheme: _textTheme,
    elevatedButtonTheme: _elevatedButtonTheme,
    appBarTheme: _appBarTheme,
    inputDecorationTheme: _inputDecorationTheme,
    bottomNavigationBarTheme: _bottomNavBarTheme
  );

  // Untuk text-text an
  static const _textTheme = TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold), // Heading utama
      titleMedium:  TextStyle(fontSize: 18, fontWeight: FontWeight.w600), // Sub header
      bodyMedium:   TextStyle(fontSize: 14), // Untuk paragraf
      labelSmall:   TextStyle(fontSize: 11, letterSpacing: 0.5), // Tambahan yang lebih kecil lagi
  );

  // Untuk button biasa
  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(

    )
  );

  // Untuk form
  static final _inputDecorationTheme = InputDecorationThemeData(
    
  );

  // Untuk navbar atas
  static final _appBarTheme = AppBarThemeData(

  );

  // Untuk navbar bawah
  static final _bottomNavBarTheme = BottomNavigationBarThemeData(
    
  );


}

