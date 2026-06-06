import 'package:flutter/material.dart';

enum TextMode {
  paragraph,
  header,
  subheader,
  subheaderbesar
}

class AppText extends StatefulWidget {
  final String text;
  final TextMode mode;
 

  /// Custom AppText 
  /// 
  /// Parameter:
  /// - **required text**: variabel TextEditingControl yang dibuat di page
  /// - **mode**: Mode tampilannya mau kayak gimana dari enum TextMode (paragraph, header, subheader) (default: TextMode.paragraph)
  const AppText(
    {
      super.key, 
      required this.text,
      this.mode = TextMode.paragraph
    }
  );

  @override
  State<AppText> createState() => _DropDownState();
}

class _DropDownState extends State<AppText> {

  @override
  void initState() {
    super.initState();
  }

  double _tentukanUkuran() {
    return switch (widget.mode) {
      TextMode.paragraph => 13,
      TextMode.subheader => 16,
      TextMode.header => 26,
      TextMode.subheaderbesar => 20
    };
  }

  FontWeight _tentukanWeight() {
    return switch (widget.mode) {
      TextMode.paragraph => FontWeight.w400,
      TextMode.subheader => FontWeight.w500,
      TextMode.subheaderbesar => FontWeight.w500,
      TextMode.header => FontWeight.w700
    };
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text, 
      style: TextStyle(
        fontSize: _tentukanUkuran(),
        fontWeight: _tentukanWeight()
      )
    ,);
  }
}
