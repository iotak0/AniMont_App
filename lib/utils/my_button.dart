import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final String text;
  Future<dynamic> onPressed;
  MyButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await widget.onPressed;
        setState(() {});
      },
      child: Container(
          constraints: BoxConstraints(maxWidth: 80),
          height: 35,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.purple.shade300,
              borderRadius: BorderRadius.circular(12)),
          child: Center(
              child: Text(
            widget.text,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ))),
    );
  }
}
