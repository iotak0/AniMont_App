import 'package:anime_mont_test/Screens/signup&login/edit_account.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class CustAppBar extends StatelessWidget {
  const CustAppBar({
    Key? key,
    required this.title,
    required this.isLocalText,
  }) : super(key: key);

  final String title;
  final bool isLocalText;

  @override
  Widget build(BuildContext context) {
    CustomColors customColor = CustomColors(context);
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          // GestureDetector(
          //   onTap: () => Navigator.pop(context),
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 10),
          //     child: Image.asset(
          //       'images/Light/Arrow - Left 3.png',
          //       matchTextDirection: true,
          //       width: 30,
          //       height: 30,
          //       color: customColor.primaryColor,
          //     ),
          //   ),
          // ),
          const SizedBox(
            width: 50,
          ),
          isLocalText
              ? Center(
                  child: LocaleText(
                    title,
                    style: TextStyle(
                        fontSize: 18, color: customColor.primaryColor),
                  ),
                )
              : Center(
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 18, color: customColor.primaryColor),
                  ),
                )
        ],
      ),
    );
  }
}
