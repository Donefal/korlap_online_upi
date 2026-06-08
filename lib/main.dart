import 'package:flutter/material.dart';
import 'package:korlap_online_upi/pages/makun.dart';
import 'package:provider/provider.dart';
import 'session_provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SessionProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Korlap Online UPI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const MAkunPage(), // Menjalankan Halaman Home Admin
    );
  }
}