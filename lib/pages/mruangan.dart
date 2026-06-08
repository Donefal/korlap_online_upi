import 'package:flutter/material.dart';
import '../widgets/index.dart'; 

class MRuanganPage extends StatefulWidget {
  const MRuanganPage({super.key});

  @override
  State<MRuanganPage> createState() => _MRuanganPageState();
}

class _MRuanganPageState extends State<MRuanganPage> {
  final int _currentIndex = 2;

  final TextEditingController gedungFilterCtrl = TextEditingController();
  final TextEditingController lantaiFilterCtrl = TextEditingController();

  final List<String> listGedung = ['Gedung A', 'Gedung B', 'Gedung C', 'FPMIPA J'];
  final List<String> listLantai = ['Lantai 1', 'Lantai 2', 'Lantai 3'];

  final List<Map<String, dynamic>> _ruanganData = [];

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
            child: AppText(text: "Manajemen Ruangan", mode: TextMode.header),
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
                const SizedBox(height: 10),

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
                            builder: (context) => const TambahRuanganPage(),
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _ruanganData.isEmpty
                    ? const Center(
                        child: Text(
                          "List jadwal",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _ruanganData.length,
                        itemBuilder: (context, index) => const SizedBox.shrink(),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TambahRuanganPage extends StatefulWidget {
  const TambahRuanganPage({super.key});

  @override
  State<TambahRuanganPage> createState() => _TambahRuanganPageState();
}

class _TambahRuanganPageState extends State<TambahRuanganPage> {
  final int _currentIndex = 2; 

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
            child: AppText(text: "Tambahkan Ruangan", mode: TextMode.header),
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
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FormBar(
                              formCtrl: namaRuanganCtrl,
                              formLabel: "nama ruangan",
                              size: 3,
                              margin: 4,
                            ),
                            const SizedBox(height: 14),
                            FormBar(
                              formCtrl: gedungCtrl,
                              formLabel: "gedung",
                              size: 3,
                              margin: 4,
                            ),
                            const SizedBox(height: 14),
                            FormBar(
                              formCtrl: lantaiCtrl,
                              formLabel: "lantai",
                              size: 3,
                              margin: 4,
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
                        const SnackBar(content: Text("Ruangan Baru Berhasil Ditambahkan!")),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}