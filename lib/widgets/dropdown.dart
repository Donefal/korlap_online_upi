import 'package:flutter/material.dart';

enum DdIcon {
  none,
  gedung,
  lantai,
  status,
}

class AppDropDown extends StatefulWidget {
  final TextEditingController ddCtrl;
  final String ddLabel;
  final int size;
  final double margin;
  final DdIcon iconChoice;
  final List<String> data;

  /// Custom AppDropDown 
  /// 
  /// Parameter:
  /// - **required ddCtrl**: variabel TextEditingControl yang dibuat di page
  /// - **required data**: List string data-data yang dapat dipilih pada dropdown
  /// - **formLabel**: Label identitas form ini itu apa (default: "Form")
  /// - **size**: ukuran formBar untuk keperluan tertentu (default: 2)
  ///   - size=1 : Untuk satu row muat 3 widget 
  ///   - size=2 : Untuk satu row muat 2 widget
  ///   - size=3 : Untuk satu row muat 1 widget
  /// - **iconChoice** : Pilih icon sesuai kebutuhan dengan iconChoice.pilihan (default: iconChoice.none)
  const AppDropDown(
    {
      super.key, 
      required this.ddCtrl,
      required this.data,
      this.ddLabel = "Form",
      this.size = 2,
      this.margin = 5,
      this.iconChoice = DdIcon.none
      }
  );

  @override
  State<AppDropDown> createState() => _DropDownState();
}

class _DropDownState extends State<AppDropDown> {
  late List<String> _ddData;

  @override
  void initState() {
    super.initState();
    _ddData = widget.data;
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
    return switch (widget.iconChoice) {
      DdIcon.none => null,
      DdIcon.gedung  => const Icon(Icons.home_work_sharp),
      DdIcon.lantai => const Icon(Icons.flourescent_outlined),
      DdIcon.status => const Icon(Icons.line_style)
    };
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _cariWidth(context),
      child: Container(
        margin: EdgeInsets.all(widget.margin),

        child: DropdownMenu<String>(
            controller: widget.ddCtrl,
            label: widget.size == 1 ? null : Text(widget.ddLabel),
            leadingIcon: _tentukanIcon(),
            width: _cariWidth(context) - (widget.margin * 2),
            dropdownMenuEntries: _ddData.map((item) => DropdownMenuEntry<String>(
              value: item,
              label: item,
            )
            ).toList(),
          ),
        )
    );
  }
}
