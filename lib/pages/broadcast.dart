import 'package:flutter/material.dart';
import '../widgets/index.dart'; 

class BroadcastPage extends StatefulWidget {
  const BroadcastPage({super.key});

  @override
  State<BroadcastPage> createState() => _BroadcastPageState();
}

class _BroadcastPageState extends State<BroadcastPage> {
  final List<Map<String, dynamic>> _broadcastData = [];
  final int _currentIndex = 1; 

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
            child: AppText(text: "Broadcast", mode: TextMode.header),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 120, 
                child: ButtonMenu(
                  text: "Tambahkan",
                  desc: "", 
                  icon: Icons.add,
                  margin: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TambahBroadcastPage(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(thickness: 1, height: 1),

          Expanded(
            child: _broadcastData.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada data broadcast.",
                      style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: _broadcastData.length,
                    itemBuilder: (context, index) {
                      return const SizedBox.shrink();
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex, 
        onDestinationSelected: (int index) {
        },
      ),
    );
  }
}

class TambahBroadcastPage extends StatefulWidget {
  const TambahBroadcastPage({super.key});

  @override
  State<TambahBroadcastPage> createState() => _TambahBroadcastPageState();
}

class _TambahBroadcastPageState extends State<TambahBroadcastPage> {
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final int _currentIndex = 1;

  @override
  void dispose() {
    _dataController.dispose();
    _linkController.dispose();
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
            child: AppText(text: "Tambahkan Broadcast", mode: TextMode.header),
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
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.2),
                        borderRadius: BorderRadius.circular(4), 
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Data-data / Pesan Broadcast", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _dataController,
                              maxLines: 4, 
                              decoration: const InputDecoration(
                                hintText: "Masukkan isi data atau informasi broadcast...",
                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            const Text("Foto / Media (Optional)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 6),
                            OutlinedButton.icon(
                              onPressed: () {
                              },
                              icon: const Icon(Icons.image, size: 18, color: Colors.black),
                              label: const Text("Pilih Foto/Gambar", style: TextStyle(color: Colors.black, fontSize: 12)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.grey),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            const Text("Hyperlink / Tautan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _linkController,
                              decoration: const InputDecoration(
                                hintText: "Contoh: https://upi.edu",
                                prefixIcon: Icon(Icons.link, size: 18),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12), 

                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 140, 
                      child: ButtonMenu(
                        text: "Tambahkan",
                        desc: "", 
                        icon: Icons.check_circle_outline,
                        margin: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Broadcast Berhasil Ditambahkan!")),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16), 
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onDestinationSelected: (int index) {
          // Logika interaksi navigasi kelompokmu
        },
      ),
    );
  }
}