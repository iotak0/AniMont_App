import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class CircBotton extends StatelessWidget {
  const CircBotton({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final String title;
  @override
  Widget build(BuildContext context) {
    CustomColors customColor = CustomColors(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: customColor.iconTheme),
                borderRadius: BorderRadius.circular(50)),
            child: child),
        SizedBox(
          height: 15,
        ),
        LocaleText(
          title,
          style: TextStyle(fontFamily: 'SFPro', fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
