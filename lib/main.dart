import 'package:flutter/material.dart';
import 'package:korlap_online_upi/pages/homeview/user_home_view.dart';
import 'package:korlap_online_upi/pages/login/login_page.dart';
import 'package:korlap_online_upi/pages/peminjaman/peminjaman_ruangan_1.dart';
import 'package:korlap_online_upi/pages/peminjaman/peminjaman_ruangan_2.dart';
import 'package:korlap_online_upi/pages/peminjaman/peminjaman_ruangan_3.dart';
import 'package:korlap_online_upi/session_provider.dart';
import 'package:korlap_online_upi/test.dart';
import 'package:korlap_online_upi/widgets/auth_gate.dart';
import 'package:korlap_online_upi/widgets/index.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final session = SessionProvider();
  await session.restore();

  runApp(
    ChangeNotifierProvider.value(
      value: session,
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Korlap Digital (Kodig)',
      debugShowCheckedModeBanner: false,
      //TODO: Nanti ini diganti ke AuthGate() default nya 
      // TestPage() untuk nge test page
      home: const FormPengajuanPage(
        ruangan: RuanganItem(
          id: 4,
          gedung: "Gedung B",
          lantai: 3,
          namaRuangan: "20.4B.03.009",
          status: "Tersedia",
          jenisRuangan: "Kelas",
        )
      ));
  }
}

