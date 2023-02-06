import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

@override
class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  bool get isDarkMode => themeMode == ThemeMode.dark;
  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class Index extends ChangeNotifier {
  int index = 0;
  void getIndex(int ind) {
    index = ind;
    notifyListeners();
  }
}

class MyThemes {
  static Color darkBlack = Colors.grey.shade900;
  static Color lightBlack = Colors.grey.shade800;
  static Color white = const Color.fromRGBO(228, 240, 255, 1);
  static Color black = Color.fromARGB(255, 0, 0, 0);
  static Color darkGreen = Color.fromRGBO(29, 179, 164, 1);
  static Color darkPurple = const Color.fromRGBO(152, 84, 203, 1);

  static Color lightGreen = Color.fromRGBO(42, 255, 235, 1);
  static Color lightWhite = Color.fromARGB(255, 226, 225, 225);
  static Color darkWhite = Color.fromARGB(255, 210, 209, 209);
  // Color.fromARGB(255, 241, 241, 241);

  static Color lightPurple = const Color.fromRGBO(221, 172, 245, 1);
  static Color lightPurple2 = const Color.fromRGBO(70, 0, 179, 1);
  static Color darkPurple2 = const Color.fromRGBO(100, 0, 255, 1);

  static final darkTheme = ThemeData(
      backgroundColor: darkBlack,
      scaffoldBackgroundColor: darkBlack,
      primaryColorDark: darkGreen,
      primaryColorLight: lightGreen,

      // Colors.grey.shade900,
      colorScheme: ColorScheme.dark(),
      iconTheme: IconThemeData(color: lightBlack),
      //Colors.white),
      primaryColor: white);
  // Colors.black);
  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: lightWhite,
      primaryColorDark: lightGreen,
      primaryColorLight: darkGreen,
      colorScheme: ColorScheme.light(),
      iconTheme: IconThemeData(color: darkWhite),
      primaryColor: black);
}
