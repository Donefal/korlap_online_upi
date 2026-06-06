import 'package:flutter/material.dart';
import 'package:korlap_online_upi/pages/homeview/user_home_view.dart';
import 'package:korlap_online_upi/session_provider.dart';
import 'package:korlap_online_upi/test.dart';
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
      home: const TestPage(),
    );
  }
}

