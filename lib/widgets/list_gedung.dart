import 'package:flutter/material.dart';
import 'package:korlap_online_upi/widgets/index.dart';

// Model for the data
class RuanganItem {
  final int id;
  final String gedung;
  final int lantai;
  final String namaRuangan;
  final String status;
  final String jenisRuangan;
  final VoidCallback? onPinjam;

  const RuanganItem({
    required this.id,
    required this.gedung,
    required this.lantai,
    required this.namaRuangan,
    required this.status,
    required this.jenisRuangan,
    this.onPinjam,
  });
}

// Status chip color helper
Color _tentukanColorStatus(String status) {
  return switch (status.toLowerCase()) {
    'tersedia'                => Colors.green,
    'sudah dipinjam'          => Colors.red,
    _                         => Colors.black12,
  };
}

Color _tentukanColorRuangan(String jenis) {
  return switch (jenis.toLowerCase()) {
    'laboratorium'            => Colors.blueGrey,
    'ruang kelas'             => Colors.orange,
    'ruang microteaching'     => Colors.blue,
    'ruangan prodi'           => Colors.deepPurpleAccent,
    _                         => Colors.black12
  };
}


class RuanganCard extends StatelessWidget {
  final RuanganItem item;
  final bool showNext;

  const RuanganCard({super.key, required this.item, this.showNext = true});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // Avatar / image placeholder
            CircleAvatar(
              radius: 32,
              backgroundColor: const Color.fromARGB(255, 0, 128, 255),
              child: Icon(Icons.meeting_room_outlined, color: Colors.white),
            ),
            const SizedBox(width: 16),

            // Main content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gedung + lantai
                  AppText(text: '${item.gedung} -- LT. ${item.lantai}', ),
                  const SizedBox(height: 2),

                  // Nama ruangan
                  AppText(text: item.namaRuangan, mode: TextMode.subheaderbesar),
                  
                  const SizedBox(height: 8),

                  _buildChip(context, item.status, _tentukanColorStatus(item.status)),

                  const SizedBox(height: 8),

                  _buildChip(context, item.jenisRuangan, _tentukanColorRuangan(item.jenisRuangan)),

                ],
              ),
            ),

            if (showNext)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: item.onPinjam,
                    icon: const Icon(Icons.arrow_circle_right_rounded, color: Colors.black),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        border: Border.all(color: color.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: color),
      ),
    );
  }
}

// return ListView.builder(
//   itemCount: _data.length,
//   itemBuilder: (context, index) => RuanganCard(item: _data[index]),
// );
