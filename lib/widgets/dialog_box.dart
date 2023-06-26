import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/widgets/my_button.dart';
import 'package:flutter/material.dart';

class DialogBox extends StatefulWidget {
  final TextEditingController controller;
  final String text;

  DialogBox({
    super.key,
    required this.controller,
    required this.text,
  });

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    return AlertDialog(
      elevation: 5,
      backgroundColor: Colors.transparent,
      content: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
                child: Container(
                    // constraints: BoxConstraints(minHeight: 48),
                    // height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: customColors.iconTheme,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLines: 9,
                        minLines: 1,
                        style: TextStyle(color: customColors.primaryColor),
                        cursorColor: Colors.blueAccent, maxLength: 100,
                        //autocorrect: true,
                        //enableSuggestions: true,
                        //textCapitalization: TextCapitalization.sentences,
                        controller: widget.controller,

                        decoration: InputDecoration(
                          border: InputBorder.none,
                          //filled: true,
                          hintText: widget.text,
                          hintStyle: TextStyle(
                            fontFamily: 'SFPro',
                            color: customColors.primaryColor,
                          ),
                        ),
                      ),
                    ))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: MyButton(
                      textColor: customColors.primaryColor,
                      color: customColors.iconTheme,
                      text: "back",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: MyButton(
                      textColor: Colors.white,
                      color: customColors.bottomDown,
                      text: "done",
                    ),
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
