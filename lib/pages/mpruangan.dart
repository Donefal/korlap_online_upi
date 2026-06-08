import 'package:flutter/material.dart';
import '../widgets/index.dart'; 

class MPruanganPage extends StatefulWidget {
  const MPruanganPage({super.key});

  @override
  State<MPruanganPage> createState() => _MPruanganPageState();
}

class _MPruanganPageState extends State<MPruanganPage> {
  final int _currentIndex = 0; 

  final TextEditingController gedungFilterCtrl = TextEditingController();
  final TextEditingController lantaiFilterCtrl = TextEditingController();

  final List<String> listGedung = ['Gedung A', 'Gedung B', 'Gedung C', 'FPMIPA J'];
  final List<String> listLantai = ['Lantai 1', 'Lantai 2', 'Lantai 3'];

  final List<Map<String, dynamic>> _peminjamanData = [];

  @override
  void dispose() {
    gedungFilterCtrl.dispose();
    lantaiFilterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double halfWidth = (MediaQuery.of(context).size.width - 42) / 2;

    return Scaffold(
      appBar: const AppNavbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: AppText(text: "Peminjaman Ruangan", mode: TextMode.header),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AppDropDown(
                        ddCtrl: gedungFilterCtrl,
                        data: listGedung,
                        ddLabel: "Gedung",
                        size: 2,
                        margin: 0,
                        iconChoice: DdIcon.gedung,
                      ),
                    ),
                    const SizedBox(width: 10), 
                    Expanded(
                      child: AppDropDown(
                        ddCtrl: lantaiFilterCtrl,
                        data: listLantai,
                        ddLabel: "Lantai",
                        size: 2,
                        margin: 0,
                        iconChoice: DdIcon.lantai,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonAction(
                      text: "Tambahkan",
                      icon: Icons.add,
                      width: halfWidth,
                      margin: EdgeInsets.zero,
                      posisi: Alignment.centerLeft,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TambahPeminjamanPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    ButtonAction(
                      text: "Filter",
                      icon: Icons.search,
                      width: halfWidth,
                      margin: EdgeInsets.zero,
                      posisi: Alignment.centerRight,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Memfilter: ${gedungFilterCtrl.text.isEmpty ? 'Semua' : gedungFilterCtrl.text} - ${lantaiFilterCtrl.text.isEmpty ? 'Semua' : lantaiFilterCtrl.text}"
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(thickness: 1, height: 1),

          Expanded(
            child: _peminjamanData.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada riwayat peminjaman ruangan.",
                      style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: _peminjamanData.length,
                    itemBuilder: (context, index) => const SizedBox.shrink(),
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
class TambahPeminjamanPage extends StatefulWidget {
  const TambahPeminjamanPage({super.key});

  @override
  State<TambahPeminjamanPage> createState() => _TambahPeminjamanPageState();
}

class _TambahPeminjamanPageState extends State<TambahPeminjamanPage> {
  final TextEditingController namaRuanganCtrl = TextEditingController();
  final TextEditingController gedungCtrl = TextEditingController();
  final TextEditingController lantaiCtrl = TextEditingController();

  @override
  void dispose() {
    namaRuanganCtrl.dispose();
    gedungCtrl.dispose();
    lantaiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: AppText(text: "Tambahkan Peminjaman", mode: TextMode.header),
          ),
          const SizedBox(height: 16),


          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FormBar(
                              formCtrl: namaRuanganCtrl,
                              formLabel: "Nama Ruangan",
                              size: 3,
                              margin: 4,
                            ),
                            const SizedBox(height: 12),
                            FormBar(
                              formCtrl: gedungCtrl,
                              formLabel: "Nama Gedung",
                              size: 3,
                              margin: 4,
                            ),
                            const SizedBox(height: 12),
                            FormBar(
                              formCtrl: lantaiCtrl,
                              formLabel: "Posisi Lantai",
                              size: 3,
                              margin: 4,
                              formIcon: FormIcon.nim, 
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  ButtonAction(
                    text: "Tambahkan",
                    icon: Icons.check_circle_outline,
                    width: 150,
                    margin: const EdgeInsets.only(bottom: 16),
                    posisi: Alignment.centerRight,
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Permohonan Peminjaman Berhasil Ditambahkan!")),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
        onDestinationSelected: (int index) {},
      ),
    );
  }
}