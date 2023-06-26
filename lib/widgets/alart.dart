import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Alart extends StatelessWidget {
  const Alart({
    Key? key,
    required this.icon,
    required this.body,
  }) : super(key: key);
  final String icon;
  final String body;

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    return Center(
      child: SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border:
                        Border.all(width: 2, color: customColors.primaryColor)),
                child: Center(
                  child: SvgPicture.string(
                    icon,
                    height: 75,
                    color: customColors.primaryColor,
                    width: 75,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              LocaleText(
                body,
                style: TextStyle(
                    fontFamily: 'SFPro',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
