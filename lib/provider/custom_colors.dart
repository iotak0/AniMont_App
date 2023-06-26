import 'package:flutter/material.dart';

class CustomColors {
  late Color primaryColor;
  late Color iconTheme;
  late Color backgroundColor;
  late Color bottomUp;
  late Color bottomDown;
  CustomColors(context) {
    primaryColor = Theme.of(context).primaryColor;
    iconTheme = Theme.of(context).iconTheme.color!;

    backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    bottomUp = Theme.of(context).primaryColorDark;
    bottomDown = Theme.of(context).primaryColorLight;
  }
}
