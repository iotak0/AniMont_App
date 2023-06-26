import 'package:anime_mont_test/Screens/signup&login/lognin.dart';
import 'package:anime_mont_test/Screens/signup&login/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';

class CustTextField extends StatefulWidget {
  const CustTextField({
    Key? key,
    required this.controller,
    required this.text,
    required this.valid,
    required this.withValid,
    required this.ar,
    required this.LengthLimiting,
    required this.maxLines,
  }) : super(key: key);
  final String text;
  final bool withValid;
  final bool ar;
  final int maxLines;
  final TextEditingController controller;
  final int LengthLimiting;

  final String? Function(String?) valid;

  @override
  State<CustTextField> createState() => _CustTextFieldState();
}

class _CustTextFieldState extends State<CustTextField> {
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconTheme = Theme.of(context).iconTheme.color!;
    return widget.withValid
        ? Padding(
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => widget.valid(value),
                    onChanged: (value) => setState(() {}),
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(widget.LengthLimiting),
                      FilteringTextInputFormatter.allow(!widget.ar
                          ? RegExp(r'[a-zA-Z0-9!$%*@_?&+-.]')
                          : RegExp('.*'))
                    ],
                    maxLines: widget.maxLines, minLines: 1,
                    style: TextStyle(color: primaryColor),
                    cursorColor: Colors.blueAccent,
                    //autocorrect: true,
                    //enableSuggestions: true,
                    //textCapitalization: TextCapitalization.sentences,
                    controller: widget.controller,
                    enabled: !SignUpState.loading && !LoginState.loading,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      //filled: true,
                      hintText: widget.text,
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
          )
        : Padding(
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLines: 3, minLines: 1,
                    style: TextStyle(color: primaryColor),
                    cursorColor: Colors.blueAccent,
                    //autocorrect: true,
                    //enableSuggestions: true,
                    //textCapitalization: TextCapitalization.sentences,
                    controller: widget.controller,

                    decoration: InputDecoration(
                      border: InputBorder.none,
                      //filled: true,
                      hintText: widget.text,
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
