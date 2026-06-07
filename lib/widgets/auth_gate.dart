import 'package:flutter/material.dart';
import 'package:korlap_online_upi/pages/login/login_page.dart';
import 'package:provider/provider.dart';
import 'package:korlap_online_upi/session_provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionProvider>();

    if (!session.isLoggedIn) {
      return const LoginPage();
    }

    return switch (session.role) {
      // TODO: Ini class page nya disesuaiin lagi aja
      // 'admin' => const AdminPage(),
      // 'user' => const UserPage(),
      _ => const LoginPage(),
    };
  }
}