import 'package:flutter/material.dart';
import 'widgets/index.dart';
import 'package:korlap_online_upi/test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const TestPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoginLoading = false;

  // Fungsi simulasi proses login
  void _handleLogin() async {
    setState(() {
      _isLoginLoading = true;
    });

    // Simulasi jeda waktu memanggil API
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoginLoading = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login Berhasil!')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reusable Button Demo')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ButtonAction(
              width: 200,
              text: 'Login',
              isLoading: _isLoginLoading,
              onPressed: _handleLogin,
            ),
            
            const SizedBox(height: 40),
            
            ButtonAction(
              // text: 'Ke Halaman Profil',
              icon: Icons.person,
              backgroundColor: const Color.fromARGB(255, 195, 255, 249),
              onPressed: () {
                print('Pindah menu dieksekusi');
              },
            ),

            ButtonAction(
              text: 'Ke Halaman Profil',
              icon: Icons.face,
              backgroundColor: const Color.fromARGB(255, 195, 255, 249),
              onPressed: () {
                // Logika pindah halaman
                /* Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
                */
                print('Pindah menu dieksekusi');
              },
            ),

            
          ],
        ),
      ),
    );
  }
}
