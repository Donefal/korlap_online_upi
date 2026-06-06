import "package:flutter/material.dart";

class AppNavbar extends StatelessWidget implements PreferredSizeWidget {
  const AppNavbar({super.key});

  void _navigateToAccountMenu(BuildContext context) {
    // Navigator.push(
    //   context, 
    //   // TODO: AccoutPage() diubah sesuai dengan page akun yang dibutuhkan
    //   MaterialPageRoute(builder: (context) => const AccountPage()) 
    // ).then((value) {
    //     // TODO: Nanti refresh page disini
    // });
  }

  @override
  Widget build(BuildContext context) {
    const String appTitle = "Korlap Online";

    return AppBar(
      title: const Text(appTitle),
      backgroundColor: Color.fromARGB(255, 0, 128, 255),
      foregroundColor: Colors.white,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.person),
          tooltip: "Account Settings",
          onPressed: () => _navigateToAccountMenu(context), 
        ),

        SizedBox(width: 10,)
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
