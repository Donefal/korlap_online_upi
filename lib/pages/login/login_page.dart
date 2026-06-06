// file: lib/login_page.dart
import 'package:flutter/material.dart';
import 'package:korlap_online_upi/widgets/button_aksi.dart';
import 'package:korlap_online_upi/widgets/index.dart';

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
                const SizedBox(height: 20), 
              
                FormBar(
                  formCtrl: _nimController,
                  formLabel: "NIM/Email UPI",
                  iconChoice: IconChoice.nim,
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
                  onPressed: () {
              
                    String nimInput = _nimController.text.trim();
                    String passInput = _passwordController.text;
              
                    print("Data Input -> NIM: $nimInput, Pass: $passInput");
              
                    if(nimInput.isEmpty || passInput.isEmpty){
              
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("NIM/Email dan Password tidak boleh kosong")),
                      );
                      return;
                    }
              
                    setState(() {
                      _isLoginLoading = true;
                    });
              
                    Future.delayed(const Duration(seconds: 2), (){
                      if(mounted){
                        setState(() {
                          _isLoginLoading = false;
                        });
              
                        print("Login Berhasil");
              
                        // TODO: Ganti 'HalamanHome()' dengan kelas page B1 Home Menu nanti
                        /*
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HalamanHome()),
                        );
                        */
                      }
                    });
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