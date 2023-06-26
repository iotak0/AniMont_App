import 'package:anime_mont_test/provider/custom_colors.dart';
import '../../../../helper/constans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlartInternet extends StatelessWidget {
  const AlartInternet({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    return Center(
      child: GestureDetector(
        onTap: onTap,
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
                      border: Border.all(
                          width: 2, color: customColors.primaryColor)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: SvgPicture.string(
                        noConnectaion,
                        height: 100,
                        color: customColors.primaryColor,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                LocaleText(
                  'no_internet',
                  style: TextStyle(
                      fontFamily: 'SFPro',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                LocaleText(
                  'tap_to_refresh',
                  style: TextStyle(
                      fontFamily: 'SFPro',
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
