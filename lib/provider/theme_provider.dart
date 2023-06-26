import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode? themeMode;
  ThemeProvider(String theme) {
    if (theme == 'dark') {
      this.themeMode = ThemeMode.dark;
    } else if (theme == 'light') {
      this.themeMode = ThemeMode.light;
    } else {
      this.themeMode = ThemeMode.system;
    }
  }

  bool get isDarkMode =>
      themeMode == ThemeMode.dark || themeMode == ThemeMode.system;
  void toggleTheme(String theme) {
    if (theme == 'dark') {
      this.themeMode = ThemeMode.dark;
    } else if (theme == 'light') {
      this.themeMode = ThemeMode.light;
    } else {
      this.themeMode = ThemeMode.system;
    }
    notifyListeners();
  }
}

class ColorProvider extends ChangeNotifier {
  static String? color;
  ColorProvider(String color2) {
    print("Color###################### $color");
    if (color2 == 'green') {
      color = 'green';
    }
    if (color2 == 'blue') {
      color = 'blue';
    }
    if (color2 == 'purple') {
      color = 'purple';
    }
    if (color2 == 'pink') {
      color = 'pink';
    }
  }
  void toggleColor(String color2) {
    if (color2 == 'green') {
      color = 'green';
    }
    if (color2 == 'blue') {
      color = 'blue';
    }
    if (color2 == 'purple') {
      color = 'purple';
    }
    if (color2 == 'pink') {
      color = 'pink';
    }

    notifyListeners();
  }

  static Color darkBlack = Color(0xFF212121);
  static Color lightBlack = Colors.grey.shade800;
  static Color white = const Color.fromRGBO(228, 240, 255, 1);
  static Color black = Color.fromARGB(255, 0, 0, 0);
  static Color darkGreen = Color.fromRGBO(29, 179, 164, 1);
  static Color darkPink = Color.fromARGB(255, 192, 112, 231);
  static Color lightGreen = Color.fromRGBO(29, 229, 243, 1);

  static Color darkBlue = Colors.blue;
  static Color lightBlue = Colors.blueAccent;
  static Color lightWhite = Color(0xFFE2E1E1);
  static Color darkWhite = Color.fromARGB(255, 210, 209, 209);

  static Color lightPink = const Color.fromRGBO(221, 172, 245, 1);
  static Color lightPurple = const Color.fromRGBO(100, 0, 255, 1);
  static Color darkPurple = const Color.fromRGBO(70, 0, 179, 1);

  ThemeData darkTheme = ThemeData(
      backgroundColor: darkBlack,
      indicatorColor: color == "blue"
          ? darkBlue
          : color == "green"
              ? darkGreen
              : color == "purple"
                  ? darkPurple
                  : darkPink,
      scaffoldBackgroundColor: darkBlack,
      primaryColorDark: color == "blue"
          ? darkBlue
          : color == "green"
              ? darkGreen
              : color == "purple"
                  ? darkPurple
                  : darkPink,
      primaryColorLight: color == "blue"
          ? lightBlue
          : color == "green"
              ? lightGreen
              : color == "purple"
                  ? lightPurple
                  : lightPink,
      colorScheme: ColorScheme.dark(),
      iconTheme: IconThemeData(color: lightBlack),
      primaryColor: white);
  ThemeData lightTheme = ThemeData(indicatorColor: color == "blue"
          ? darkBlue
          : color == "green"
              ? darkGreen
              : color == "purple"
                  ? darkPurple
                  : darkPink,
      scaffoldBackgroundColor: lightWhite,
      primaryColorLight: color == "blue"
          ? darkBlue
          : color == "green"
              ? darkGreen
              : color == "purple"
                  ? darkPurple
                  : darkPink,
      primaryColorDark: color == "blue"
          ? lightBlue
          : color == "green"
              ? lightGreen
              : color == "purple"
                  ? lightPurple
                  : lightPink,
      colorScheme: ColorScheme.light(),
      iconTheme: IconThemeData(color: darkWhite),
      primaryColor: black);
}

class VideoLoopProvider extends ChangeNotifier {
  bool? looping;
  VideoLoopProvider(bool looping) {
    if (looping) {
      this.looping = true;
    } else {
      this.looping = false;
    }
  }

  bool get isLooping => looping == false;
  void toggleLoop(bool looping) {
    if (looping) {
      this.looping = true;
    } else {
      this.looping = false;
    }
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
  static String color = 'blue';
  MyThemes(String color) {
    MyThemes.color = color;
  }
}
