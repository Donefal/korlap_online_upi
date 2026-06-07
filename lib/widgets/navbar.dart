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
      elevation: 0,
      title: const Text(
        appTitle,
        style: TextStyle(fontWeight: FontWeight.w700)
      ),
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
          ),

          child: IconButton(
            icon: const Icon(Icons.person),
            color: Colors.white,
            onPressed: () => _navigateToAccountMenu(context), 
          ),
        ),

        SizedBox(width: 10,)
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
