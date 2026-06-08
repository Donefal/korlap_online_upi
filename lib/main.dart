import 'package:flutter/material.dart';
import 'package:korlap_online_upi/pages/histori/histori_peminjaman.dart';
import 'package:korlap_online_upi/pages/homeview/user_home_view.dart';
import 'package:korlap_online_upi/pages/login/login_page.dart';
import 'package:korlap_online_upi/pages/peminjaman/peminjaman_ruangan_1.dart';
import 'package:korlap_online_upi/pages/peminjaman/peminjaman_ruangan_2.dart';
import 'package:korlap_online_upi/pages/peminjaman/peminjaman_ruangan_3.dart';
import 'package:korlap_online_upi/pages/status/status_peminjaman.dart';
import 'package:korlap_online_upi/session_provider.dart';
import 'package:korlap_online_upi/test.dart';
import 'package:korlap_online_upi/widgets/auth_gate.dart';
import 'package:korlap_online_upi/widgets/index.dart';
import 'package:provider/provider.dart';
import 'session_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final session = SessionProvider();
  await session.restore();

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
      
      // 1. Seting warna fallback dasar aplikasi
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F6FA), // Abu-abu bersih
      ),
      
      // 2. 🟢 SUNTIKAN GRADIENT GLOBAL DI SINI 🟢
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color.fromARGB(255, 73, 179, 255),       // Efek biru soft di bagian atas
                const Color.fromARGB(255, 245, 248, 250),  // Gradasi ke flat abu-abu di bagian bawah
              ],
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              // Bikin warna dasar Scaffold bawaan jadi transparan 
              // supaya lapisan gradient di Container belakangnya kelihatan menembus
              scaffoldBackgroundColor: Colors.transparent, 
            ),
            child: child!,
          ),
        );
      },
      
      // TODO: Nanti ini diganti ke AuthGate() default nya 
      // TestPage() untuk nge test page
      home: const UserHomeView(),
    );
  }
}