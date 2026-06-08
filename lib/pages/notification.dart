import 'package:flutter/material.dart';
import '../widgets/index.dart'; 

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final int _currentIndex = 1; 

  final List<Map<String, dynamic>> _notifikasiData = [
  ];

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
            child: AppText(text: "Notifikasi", mode: TextMode.header),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.5), 
                  borderRadius: BorderRadius.circular(8), 
                ),
                child: _notifikasiData.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Center(
                          child: Text(
                            "List notifikasi perpindahan status peminjaman, pengumuman, himbauan, dll",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey, 
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12.0),
                        itemCount: _notifikasiData.length,
                        itemBuilder: (context, index) {
                          return const SizedBox.shrink();
                        },
                      ),
              ),
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