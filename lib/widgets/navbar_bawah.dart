import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    const mainColor = Color.fromARGB(255, 0, 128, 255);
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
          color: mainColor,
          width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
            backgroundColor: Colors.white,
            shadowColor: Colors.black,
            elevation: 10,
            destinations: const [

              NavigationDestination(
                icon: Icon(Icons.home_outlined, color: mainColor,),
                selectedIcon: Icon(Icons.home, color: mainColor),
                label: 'Home',
              ),

              NavigationDestination(
                icon: Icon(Icons.admin_panel_settings_outlined, color: mainColor,),
                selectedIcon: Icon(Icons.admin_panel_settings, color: mainColor,),
                label: 'Admin Action',
              ),
            ],
          ),
        ),
      ),
    );
  }
}