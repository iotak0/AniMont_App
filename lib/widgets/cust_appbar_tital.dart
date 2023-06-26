import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class CustAppBarTital extends StatelessWidget {
  const CustAppBarTital({
    Key? key,
    required this.tital,
  }) : super(key: key);

  final String tital;

  @override
  Widget build(BuildContext context) {
    CustomColors customColor = CustomColors(context);
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          LocaleText(
            tital,
            textAlign: TextAlign.justify,
            localize: false,
            // textDirection: ,
            style: TextStyle(
                fontSize: 20,
                color: customColor.primaryColor,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
