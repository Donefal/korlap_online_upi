import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool isAdmin;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    const mainColor = Color.fromARGB(255, 0, 128, 255);
    const disabledColor = Colors.grey;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18), 
              blurRadius: 16,                    
              spreadRadius: 0,                  
              offset: const Offset(0, 8),        
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              // Prevent access to admin page if not admin
              if (index == 1 && !isAdmin) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Admin access required'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }
              onDestinationSelected(index);
            },
            backgroundColor: Colors.white,
            shadowColor: Colors.black,
            elevation: 0,
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined, color: mainColor,),
                selectedIcon: Icon(Icons.home, color: mainColor),
                label: 'Home',
              ),

              NavigationDestination(
                icon: Icon(
                  Icons.admin_panel_settings_outlined,
                  color: isAdmin ? mainColor : disabledColor,
                ),
                selectedIcon: Icon(
                  Icons.admin_panel_settings,
                  color: isAdmin ? mainColor : disabledColor,
                ),
                label: 'Admin Action',
              ),
            ],
          ),
        ),
      ),
    );
  }
}