import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class MyButton extends StatefulWidget {
  final String text;
  final Color color;
  final Color textColor;
  MyButton({
    super.key,
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    return GestureDetector(
      onTap: () async {
        Navigator.pop(context);
      },
      child: Container(
          constraints: BoxConstraints(maxWidth: 80),
          height: 35,
          width: double.infinity,
          decoration: BoxDecoration(
              color: widget.color, borderRadius: BorderRadius.circular(12)),
          child: Center(
              child: LocaleText(
            widget.text,
            style: TextStyle(
                color: widget.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ))),
    );
  }
}
