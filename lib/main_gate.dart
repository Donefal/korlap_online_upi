// lib/pages/dashboard/user_dashboard.dart

import 'package:flutter/material.dart';
import 'package:korlap_online_upi/pages/adminaction.dart';
import 'package:korlap_online_upi/pages/homeview/user_home_view.dart';
import 'package:korlap_online_upi/pages/histori/histori_peminjaman.dart';
import 'package:korlap_online_upi/pages/status/status_peminjaman.dart';
import 'package:korlap_online_upi/widgets/index.dart';

class MainGate extends StatefulWidget {
  final bool isAdmin;
  const MainGate({super.key, this.isAdmin = false});

  @override
  State<MainGate> createState() => _MainGateState();
}

class _MainGateState extends State<MainGate> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const UserHomeView(),
    const AdminActionPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: const AppNavbar(),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        isAdmin: widget.isAdmin,
      ),
      body: _pages[_currentIndex],
    );
  }
}