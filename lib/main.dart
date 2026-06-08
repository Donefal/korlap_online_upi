import 'package:flutter/material.dart';
import 'package:korlap_online_upi/main_gate.dart';
import 'package:korlap_online_upi/providers/session_provider.dart';
import 'package:korlap_online_upi/widgets/auth_gate.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Membuat objek session dan mengisi datanya dari SharedPreferences
  final session = SessionProvider();
  await session.restore();

  runApp(
    ChangeNotifierProvider(
      // 2. PERBAIKAN: Masukkan variabel 'session' yang sudah terisi data tadi ke sini
      create: (context) => session, 
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

      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F6FA), 
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white, 
          ),
        ),
      ),
      
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color.fromARGB(255, 0, 128, 255),  
                const Color.fromARGB(255, 245, 248, 250),  
              ],
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              scaffoldBackgroundColor: Colors.transparent, 
            ),
            child: child!,
          ),
        );
      },
      
      // Mengarah ke AuthGate yang bertugas sebagai satpam halaman
      home: const AuthGate(),
    );
  }
}