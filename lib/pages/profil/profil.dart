import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:korlap_online_upi/widgets/index.dart';
import 'package:korlap_online_upi/providers/session_provider.dart';

class ProfilPage extends StatefulWidget {
  final String? nomorInduk;
  final String? nama;
  final String? instansi;

  const ProfilPage({
    super.key,
    this.nomorInduk,
    this.nama,
    this.instansi,
  });

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = true;
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              context.read<SessionProvider>().logout();
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Center(
                  child: AppText(
                    text: "Profil Akun",
                    mode: TextMode.header,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: AppText(
                    text: "Informasi Akun Anda",
                    mode: TextMode.subheader,
                  ),
                ),
                const SizedBox(height: 30),

                // Account Info ListView
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildProfileItem(
                      label: 'Nomor Induk',
                      value: widget.nomorInduk ?? 'N/A',
                      icon: Icons.badge,
                    ),
                    const Divider(height: 24),
                    _buildProfileItem(
                      label: 'Nama',
                      value: widget.nama ?? 'N/A',
                      icon: Icons.person,
                    ),
                    const Divider(height: 24),
                    _buildProfileItem(
                      label: 'Role',
                      value: context.watch<SessionProvider>().role ?? 'N/A',
                      icon: Icons.admin_panel_settings,
                    ),
                    const Divider(height: 24),
                    _buildProfileItem(
                      label: 'Instansi',
                      value: widget.instansi ?? 'N/A',
                      icon: Icons.business,
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Logout Button
                ElevatedButton.icon(
                  onPressed: _handleLogout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.blue,
          size: 24,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}