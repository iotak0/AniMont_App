import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class Shortcut extends StatelessWidget {
  const Shortcut({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);
  final String icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconTheme = Theme.of(context).iconTheme.color!;
    final Color textColor = Color.fromARGB(255, 160, 146, 167);
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color bottomUp = Theme.of(context).primaryColorDark;
    final Color bottomDown = Theme.of(context).primaryColorLight;
    return Row(
      children: [
        Container(
            height: 20,
            width: 20,
            child: Image.asset(
              icon,
              color: bottomDown.withOpacity(.7),
            )),
        SizedBox(
          width: 5,
        ),
        Text(
          text,
          style: TextStyle(
              color: primaryColor.withAlpha(210),
              fontFamily:
                  context.localeString('en') == 'en' ? 'Angie' : 'SFPro'),
        )
      ],
    );
  }
}