import 'package:anime_mont_test/pages/signup&login/signup.dart';
import 'package:anime_mont_test/utils/textField.dart';
import 'package:flutter/material.dart';

import 'my_button.dart';

class DialogBox extends StatefulWidget {
  final TextEditingController controller;
  Future<dynamic> onCheck;
  Future<dynamic> onResend;

  DialogBox({
    super.key,
    required this.controller,
    required this.onCheck,
    required this.onResend,
  });

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  static validInput(String text, String type, int min, int max) {
    if (text.isNotEmpty) {
      return "Please enter a valid $type";
      //'ادخل كلمة مرور لا تقل عن  4 حروف '
    }
    if (text.length < min) {
      "$type must be at least 6 characters";
    }
    if (text.length > max) {
      "$type must be at last 20 characters";
    } else {
      return "Please enter a valid $type";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Container(
        height: 130,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 10, 223, 152),
                  Color.fromARGB(255, 255, 255, 255)
                ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // get user input
            CustTextField(
                withValid: false,
                valid: (val) {
                  return validInput(
                    'emailController.text',
                    ' context.localeString(email)',
                    6,
                    30,
                  );
                },
                controller: widget.controller,
                text: "Enter OTP Code"),

            // buttons -> save + cancel

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: MyButton(text: "Resend", onPressed: widget.onResend),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: MyButton(text: "Check", onPressed: widget.onCheck),
                  ),
                ],
              ),

              // cancel button
            ),
          ],
        ),
      ),
    );
  }
}
