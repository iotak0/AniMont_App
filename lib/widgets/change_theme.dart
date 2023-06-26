import 'package:anime_mont_test/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:anime_mont_test/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeThime extends StatefulWidget {
  const ChangeThime({super.key});

  @override
  State<ChangeThime> createState() => _ChangeThimeState();
}

class _ChangeThimeState extends State<ChangeThime> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /* Switch.adaptive(
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              final provider =
                  Provider.of<ThemeProvider>(context, listen: false);
              provider.toggleTheme(value);
            }),*/
        GestureDetector(
          onTap: () async {
            final provider = Provider.of<ThemeProvider>(context, listen: false);
            provider.toggleTheme('dark');
            setState(() {});
            final SharedPreferences pref =
                await SharedPreferences.getInstance();

            pref.setString('theme', 'dark');
            return;
          },
          child: Text('Dark'),
        ),
        GestureDetector(
          onTap: () async {
            final provider = Provider.of<ThemeProvider>(context, listen: false);
            provider.toggleTheme('light');
            setState(() {});
            final SharedPreferences pref =
                await SharedPreferences.getInstance();

            pref.setString('theme', 'light');
          },
          child: Text('light'),
        ),
        GestureDetector(
          onTap: () async {
            final SharedPreferences pref =
                await SharedPreferences.getInstance();
            final provider = Provider.of<ThemeProvider>(context, listen: false);

            pref.setString('theme', 'system');

            provider.toggleTheme('system');

            setState(() {});
          },
          child: Text('sestem'),
        ),
      ],
    );
  }
}
