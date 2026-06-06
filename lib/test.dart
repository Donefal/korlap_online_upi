import 'package:flutter/material.dart';
import 'package:korlap_online_upi/widgets/index.dart';

/*
  Script ini dikhususkan untuk melakukan testing dengan widget yang sudah dibuat
  tanpa menggangu page utama.

  Panggil di main.dart pada MaterialApp(home: )
*/

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
   State<TestPage> createState() => _TestPageState();

}

class _TestPageState extends State<TestPage> {
  TextEditingController test = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavbar(),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
            // TODO Insert Tested widgets here

            FormBar(formCtrl: test),
            FormBar(formCtrl: test, formLabel: "Password", passwordText: true,),
            Row(
              children: [
                FormBar(formCtrl: test, formLabel: "Ukuran 1", size: 1,),
                FormBar(formCtrl: test, formLabel: "Ukuran 1", size: 1,),
                FormBar(formCtrl: test, formLabel: "Ukuran 1", size: 1,),
              ],
            ),
            
            Row(
              children: [
                FormBar(formCtrl: test, formLabel: "Ukuran 2", size: 2,),
                FormBar(formCtrl: test, formLabel: "Ukuran 2", size: 2, iconChoice: IconChoice.nim,),
              ],
            )
            


            ]
          ),
        )
        
      ),
    );
  }

}
