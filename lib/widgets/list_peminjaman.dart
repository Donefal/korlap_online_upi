import 'package:flutter/material.dart';
import 'package:korlap_online_upi/widgets/index.dart';

// Model for the data
class PeminjamanItem  {
  final int id;
  final String gedung;
  final int lantai;
  final String namaRuangan;
  final String statusPinjaman;
  final TimeOfDay start;
  final TimeOfDay end;
  final DateTime date;
  final VoidCallback? action;

  const PeminjamanItem ({
    required this.id,
    required this.gedung,
    required this.lantai,
    required this.namaRuangan,
    required this.statusPinjaman,
    required this.start,
    required this.end,
    required this.date,
    this.action
  });
}



// Status chip color helper
Color _tentukanColorStatus(String status) {
  return switch (status.toLowerCase()) {
    'diterima'                => Colors.green,
    'ditolak'          => Colors.red,
    'sedang diajukan'         => Colors.orange,
    _                         => Colors.black12,
  };
}



class PeminjamanCard extends StatelessWidget {
  final PeminjamanItem  item;
  final bool showAction;

  const PeminjamanCard({super.key, required this.item, this.showAction = true});

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
              child: Icon(Icons.post_add, color: Colors.white),
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

                  // Status + jenis chips
                  _buildChip(context, item.statusPinjaman, _tentukanColorStatus(item.statusPinjaman)),
                  const SizedBox(height: 8),
                  _buildChip(context, item.date.toString().split(' ')[0],Colors.black),
                  const SizedBox(height: 8),
                  _buildChip(context, "${item.start.format(context)} - ${item.end.format(context)}", Colors.black),

                ],
              ),
            ),

            if (showAction) 
              IconButton(
                onPressed: item.action,
                icon: const Icon(Icons.more_vert, color: Colors.black),
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
//   itemBuilder: (context, index) => PeminjamanCard(item: _data[index]),
// );
