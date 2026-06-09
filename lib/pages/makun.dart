import 'package:flutter/material.dart';
import '../widgets/index.dart';

class MAkunPage extends StatefulWidget {
  const MAkunPage({super.key});

  @override
  State<MAkunPage> createState() => _MAkunPageState();
}

class _MAkunPageState extends State<MAkunPage> {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          right: 20,
          left: 20,
          top: 30,
          bottom: 10,
        ),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              right: 15,
              left: 15,
              top: 24,
              bottom: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header Title
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: AppText(text: "Manajemen Akun", mode: TextMode.header),
                ),
                const SizedBox(height: 16),

                // 2. Search Field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "(Cari Nama / ID...)",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                        color: Colors.blueAccent,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // 3. Action Buttons Row
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
                              builder: (context) =>
                                  const DetailMAkunPage(isNewUser: true),
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
                            const SnackBar(
                              content: Text("Modal Filter Dipicu"),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(thickness: 1, height: 1),
                const SizedBox(height: 16),

                // 4. Dynamic Data List Section
                _akunData.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: Center(
                          child: Text(
                            "Belum ada data akun terdaftar.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap:
                            true, // Allows the list to size itself within the Card
                        physics:
                            const NeverScrollableScrollPhysics(), // Passes scroll control up to the SingleChildScrollView
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
                              title: Text(
                                item['nama'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Text(
                                "ID: ${item['nomor_induk']} | Role: ${item['role']}\nStatus: ${item['status']}",
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: Colors.grey,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailMAkunPage(
                                      isNewUser: false,
                                      data: item,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
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
        padding: const EdgeInsets.only(
          right: 20,
          left: 20,
          top: 30,
          bottom: 10,
        ),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              right: 15,
              left: 15,
              top: 24,
              bottom: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header Title
                AppText(
                  text: widget.isNewUser
                      ? "Tambah Akun Pengguna"
                      : "Detail Pengguna",
                  mode: TextMode.header,
                ),
                const SizedBox(height: 20),

                // 2. Input Fields
                _buildInputField(
                  "Nama Lengkap",
                  "Masukkan nama...",
                  _namaController,
                ),
                const SizedBox(height: 14),

                _buildInputField(
                  "Nomor Induk (NIM / NIP)",
                  "Masukkan nomor induk...",
                  _nomorIndukController,
                ),
                const SizedBox(height: 14),

                // 3. Role Selection Dropdown
                const Text(
                  "Role Otoritas",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
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
                        DropdownMenuItem(
                          value: "Korlap",
                          child: Text("Korlap"),
                        ),
                        DropdownMenuItem(
                          value: "Mahasiswa",
                          child: Text("Mahasiswa"),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null)
                          setState(() => _selectedRoleForm = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // 4. Status Selection Dropdown
                const Text(
                  "Status Akun",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
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
                        DropdownMenuItem(
                          value: "Ditangguhkan",
                          child: Text("Ditangguhkan"),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null)
                          setState(() => _selectedStatusForm = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // 5. Action Button
                ButtonMenu(
                  text: widget.isNewUser ? "SIMPAN" : "PERBARUI",
                  desc: "",
                  icon: Icons.save_rounded,
                  margin: EdgeInsets.zero,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
      ],
    );
  }
}
