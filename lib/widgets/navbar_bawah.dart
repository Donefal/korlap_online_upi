import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home), 
          label: 'Home'
        ),

        NavigationDestination(
          icon: Icon(Icons.notification_important),
          label: 'Notification'
        ),

        NavigationDestination(
          icon: Icon(Icons.add_moderator),
          label: 'Admin Action'
        ),
      ],

    );
  }
}