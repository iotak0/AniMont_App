import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class CustTextField2 extends StatelessWidget {
  const CustTextField2({
    Key? key,
    required this.controller,
    required this.text,
  }) : super(key: key);
  final String text;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconTheme = Theme.of(context).iconTheme.color!;
    return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Container(
              // constraints: BoxConstraints(minHeight: 48),
              // height: 48,
              decoration: BoxDecoration(
                color: iconTheme,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    //maxLines: 5,
                    style: TextStyle(color: primaryColor),
                    cursorColor: Colors.blueAccent,
                    //autocorrect: true,
                    //enableSuggestions: true,
                    //textCapitalization: TextCapitalization.sentences,
                    controller: controller,

                    decoration: InputDecoration(
                      border: InputBorder.none,
                      //filled: true,
                      hintText: text,
                      hintStyle: TextStyle(
                        fontFamily: context.currentLocale.toString() == 'ar'
                            ? 'SFPro'
                            : 'Angie',
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          
        
              
          );
  }
}
