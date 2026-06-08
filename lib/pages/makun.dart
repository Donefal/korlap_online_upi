import 'package:flutter/material.dart';
import '../widgets/index.dart'; 

class MAkunPage extends StatefulWidget {
  const MAkunPage({super.key});

  @override
  State<MAkunPage> createState() => _MAkunPageState();
}

class _MAkunPageState extends State<MAkunPage> {
  final int _currentIndex = 2; 
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _akunData = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavbar(), 
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: AppText(text: "Manajemen Akun", mode: TextMode.header),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "(Cari Nama / ID...)",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 10), 

                Row(
                  children: [
                    Expanded(
                      child: ButtonMenu(
                        text: "Tambahkan",
                        desc: "", 
                        icon: Icons.add,
                        margin: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DetailMAkunPage(isNewUser: true),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10), 

                    Expanded(
                      child: ButtonMenu(
                        text: "Filter",
                        desc: "", 
                        icon: Icons.filter_list,
                        margin: EdgeInsets.zero,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Modal Filter Dipicu")),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(thickness: 1, height: 1),

          Expanded(
            child: _akunData.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada data akun terdaftar.",
                      style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: _akunData.length,
                    itemBuilder: (context, index) {
                      final item = _akunData[index];
                      return Card(
                        elevation: 1,
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(item['nama'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: Text("ID: ${item['nomor_induk']} | Role: ${item['role']}\nStatus: ${item['status']}"),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailMAkunPage(isNewUser: false, data: item),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onDestinationSelected: (int index) {},
      ),
    );
  }
}

class DetailMAkunPage extends StatefulWidget {
  final bool isNewUser; 
  final Map<String, dynamic>? data;

  const DetailMAkunPage({super.key, required this.isNewUser, this.data});

  @override
  State<DetailMAkunPage> createState() => _DetailMAkunPageState();
}

class _DetailMAkunPageState extends State<DetailMAkunPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nomorIndukController = TextEditingController();
  
  String _selectedRoleForm = "Mahasiswa";
  String _selectedStatusForm = "Aktif";

  @override
  void initState() {
    super.initState();
    if (!widget.isNewUser && widget.data != null) {
      _namaController.text = widget.data!['nama'] ?? '';
      _nomorIndukController.text = widget.data!['nomor_induk'] ?? '';
      _selectedRoleForm = widget.data!['role'] ?? 'Mahasiswa';
      _selectedStatusForm = widget.data!['status'] ?? 'Aktif';
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nomorIndukController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavbar(), // Widget kustom tim
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              
              AppText(
                text: widget.isNewUser ? "Tambah Akun Pengguna" : "Detail Pengguna",
                mode: TextMode.header,
              ),
              const SizedBox(height: 20),
              
              _buildInputField("Nama Lengkap", "Masukkan nama...", _namaController),
              const SizedBox(height: 14),
              _buildInputField("Nomor Induk (NIM / NIP)", "Masukkan nomor induk...", _nomorIndukController),
              const SizedBox(height: 14),
              
              const Text("Role Otoritas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedRoleForm,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: "Admin", child: Text("Admin")),
                      DropdownMenuItem(value: "Korlap", child: Text("Korlap")),
                      DropdownMenuItem(value: "Mahasiswa", child: Text("Mahasiswa")),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedRoleForm = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text("Status Akun", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedStatusForm,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: "Aktif", child: Text("Aktif")),
                      DropdownMenuItem(value: "Ditangguhkan", child: Text("Ditangguhkan")),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedStatusForm = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 28),
              
              ButtonMenu(
                text: widget.isNewUser ? "SIMPAN" : "PERBARUI",
                desc: "", // Kosongkan agar teks kapital terpusat dengan baik
                icon: Icons.save_rounded,
                margin: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 2,
        onDestinationSelected: (int index) {},
      ),
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
      ],
    );
  }
}