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
    const Text appTitle = Text("Korlap Online", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white));

    return Container(
      margin: EdgeInsets.only(top: 20, left: 20),
      child: AppBar(
        elevation: 0,
        title: ModalRoute.of(context)?.canPop == true ? null : appTitle,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
      
            child: IconButton(
              icon: const Icon(Icons.person),
              color: Colors.blueAccent,
              onPressed: () => _navigateToAccountMenu(context), 
            ),
          ),
      
          SizedBox(width: 10,)
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
