import 'package:flutter/material.dart';

enum FormIcon {
  none,
  nim,
}

class FormBar extends StatefulWidget {
  final TextEditingController formCtrl;
  final String formLabel;
  final bool passwordText;
  final int size;
  final double margin;
  final FormIcon formIcon;

  /// Custom FormBar 
  /// 
  /// Parameter:
  /// - **required formCtrl**: variabel TextEditingControl yang dibuat di page
  /// - **formLabel**: Label identitas form ini itu apa (default: "Form")
  /// - **passwordText**: boolean untuk mode password (default: false)
  /// - **size**: ukuran formBar untuk keperluan tertentu
  ///   - size=1 : Untuk satu row muat 3 widget
  ///   - size=2 : Untuk satu row muat 2 widget
  ///   - size=3 : Untuk satu row muat 1 widget
  /// - **FormIcon** : Pilih icon sesuai kebutuhan dengan FormIcon.pilihan (default: FormIcon.none)
  const FormBar(
    {
      super.key, 
      required this.formCtrl,
      this.formLabel = "Form",
      this.passwordText = false,
      this.size = 3,
      this.margin = 5,
      this.formIcon = FormIcon.none
      }
  );

  @override
  State<FormBar> createState() => _FormBarState();
}

class _FormBarState extends State<FormBar> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.passwordText;
  }

  double _cariWidth(BuildContext context){
    final screenWidth = MediaQuery.of(context).size.width;
    return switch (widget.size) {
      1 => (screenWidth - 20) / 3,
      2 => (screenWidth - 20) / 2,
      _ => double.infinity,
    };
  }
  
  Icon? _tentukanIcon() {
    if (widget.passwordText) return const Icon(Icons.password); 

    return switch (widget.formIcon) {
      FormIcon.nim  => const Icon(Icons.numbers),
      FormIcon.none => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _cariWidth(context),
      child: Container(
        margin: EdgeInsets.all(widget.margin),

        child: TextField(
            controller: widget.formCtrl,
            obscureText: _obscure,
        
            decoration: InputDecoration(
              labelText: widget.formLabel,
              hintText:  "Masukkan ${widget.formLabel}",
              border: OutlineInputBorder(),

              prefixIcon: _tentukanIcon(),
        
              // Apabila passwordText True: show Icon Button, apabila false: hide (null kan)
              suffixIcon: widget.passwordText ? IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility)
                ) : null
            ),
        ),
      ),
    );
  }
}
