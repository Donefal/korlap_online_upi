// file: lib/login_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. Tambahkan import provider
import 'package:korlap_online_upi/main_gate.dart';
import 'package:korlap_online_upi/widgets/index.dart';

// Import Service dan Provider (Sesuaikan path folder jika berbeda di proyek Anda)
import 'package:korlap_online_upi/services/auth_service.dart';
import 'package:korlap_online_upi/providers/session_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage ({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState(); 
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoginLoading = false;

  @override
  void dispose(){
    _nimController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar : const AppNavbar (),
      body: Center(
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text ("Login", 
                textAlign:TextAlign.center,
                style: TextStyle(fontSize: 20, 
                fontWeight: FontWeight.bold,
                color:Colors.black87,),),
                const SizedBox(height: 20), 
              
                FormBar(
                  formCtrl: _nimController,
                  formLabel: "NIM/NIP",
                  formIcon: FormIcon.nim,
                  size: 3,
                ),
              
                const SizedBox(height: 15),
              
                FormBar(
                  formCtrl: _passwordController,
                  formLabel: "Password",
                  passwordText: true,
                  size: 3,
                ),
              
                const SizedBox(height: 25),
              
                ButtonAction(
                  text: "Login",
                  isLoading: _isLoginLoading,
                  posisi: Alignment.centerRight,
                  width: 140,
                  backgroundColor: const Color.fromARGB(255, 0, 128, 255),
                  textColor: Colors.white,
                  
                  // 2. Tambahkan kata 'async' di sini karena kita akan menunggu response API
                  onPressed: () async { 
              
                    String nimInput = _nimController.text.trim();
                    String passInput = _passwordController.text;
              
                    print("Data Input -> NIM: $nimInput, Pass: $passInput");
              
                    if(nimInput.isEmpty || passInput.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("NIM/Email dan Password tidak boleh kosong")),
                      );
                      return;
                    }
              
                    // Mulai loading animasi pada tombol
                    setState(() {
                      _isLoginLoading = true;
                    });
              
                    // 3. PROSES LOGIN ASLI KE DATABASE
                    try {
                      final authService = AuthService();
                      
                      // Tembak API login backend PHP
                      final userData = await authService.loginBackend(nimInput, passInput);

                      if (userData != null && mounted) {
                        String idUserStr = userData['id'].toString();
                        String role      = userData['role'];

                        // Masukkan token (id) & role ke SessionProvider milik temanmu
                        final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
                        await sessionProvider.login(idUserStr, role);

                        // Matikan loading sebelum pindah halaman
                        setState(() {
                          _isLoginLoading = false;
                        });

                        // Lempar ke MainGate (MainGate akan otomatis mendeteksi role baru)
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MainGate()),
                        );
                      }
                    } catch (error) {
                      // JIKA GAGAL (Password salah / akun tidak terdaftar)
                      if (mounted) {
                        setState(() {
                          _isLoginLoading = false; // Matikan loading
                        });
                        
                        // Tampilkan pesan error asli yang dikirim oleh backend PHP Anda
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error.toString()), 
                            backgroundColor: Colors.red
                          ),
                        );
                      }
                    }
                  }
                )
              ]
            ),
          ),
        )
      )
      )
    );
  }
}