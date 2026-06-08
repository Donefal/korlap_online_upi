import 'package:flutter/material.dart';
import 'package:korlap_online_upi/pages/login/login_page.dart';
import 'package:korlap_online_upi/main_gate.dart'; // Pastikan import MainGate aman
import 'package:korlap_online_upi/pages/adminaction.dart'; // Import halaman admin
import 'package:provider/provider.dart';
import 'package:korlap_online_upi/providers/session_provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch akan memicu rebuild otomatis jika data di SessionProvider berubah (login/logout)
    final session = context.watch<SessionProvider>();

    // 1. Jika belum login, selalu tampilkan halaman LoginPage
    if (!session.isLoggedIn) {
      return const LoginPage();
    }

    // 2. Jika sudah login, switch halaman otomatis berdasarkan Role dari database PHP
    return switch (session.role) {
      'admin' => const AdminActionPage(), // Jika admin, ke halaman kelola admin
      'user'  => const MainGate(),        // Jika user, ke dashboard utama user
      _       => const LoginPage(),
    };
  }
}