import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Shortcut extends StatelessWidget {
  const Shortcut({
    Key? key,
    required this.icon,
    required this.text,
    required this.height,
  }) : super(key: key);
  final String icon;
  final String text;
  final double height;
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconTheme = Theme.of(context).iconTheme.color!;
    final Color textColor = Color.fromARGB(255, 160, 146, 167);
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color bottomUp = Theme.of(context).primaryColorDark;
    final Color bottomDown = Theme.of(context).primaryColorLight;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: height,
          width: height,
          child: Center(
            child: SvgPicture.string(
              icon,
              color: bottomDown.withOpacity(.7),
            ),
          ),
        ),
        SizedBox(
          width: 3,
        ),
        Text(
          text,
          style: TextStyle(
              color: primaryColor.withOpacity(.9), fontFamily: 'SFPro'),
        ),
        SizedBox(
          width: 5,
        ),
      ],
    );
  }
}
