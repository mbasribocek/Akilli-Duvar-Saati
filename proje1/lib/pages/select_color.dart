import 'package:flutter/material.dart';
class SelectColorPage extends StatefulWidget {
  final int selectedColor;
  final ValueChanged<int> onColorChanged;

  const SelectColorPage({
    Key? key,
    required this.selectedColor,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  SelectColorPageState createState() => SelectColorPageState();
}

class SelectColorPageState extends State<SelectColorPage> {
  List<ColorData> colorList = [
    ColorData(name: 'Pembe', color: Color(0xFFFF80AB), kod: 0xFFFF80AB),
    ColorData(name: 'Kırmızı', color: Color(0xFFAA2234), kod: 0xFFAA2234),
    ColorData(name: 'Turuncu', color: Color(0xFFFF7043), kod: 0xFFFF7043),
    ColorData(name: 'Sarı', color: Color(0xFFFFF176), kod: 0xFFFFF176),
    ColorData(name: 'Yeşil', color: Color(0xFF64DD17), kod: 0xFF64DD17),
    ColorData(name: 'Mavi', color: Color(0xFF80D8FF), kod: 0xFF80D8FF),
    ColorData(name: 'Lacivert', color: Color(0xFF0D47A1), kod: 0xFF0D47A1),
    ColorData(name: 'Mor', color: Color(0xFFAB47BC), kod: 0xFFAB47BC),
    //ColorData(name: 'Gri', color: Color(0xFFB0BEC5), kod: 0xFFB0BEC5),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButtonFormField<int>(
            value: widget.selectedColor,
            onChanged: (int? value) {
              widget.onColorChanged(value!);
            },
            items: colorList.map((ColorData colorData) {
              return DropdownMenuItem<int>(
                value: colorData.kod,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 20,
                      height: 20,
                      color: colorData.color,
                    ),
                    SizedBox(width: 8),
                    Text(colorData.name),
                  ],
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class ColorData {
  final String name;
  final Color color;
  final int kod;

  ColorData({required this.name, required this.color, required this.kod});
}
