import 'dart:io';

import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:flutter/services.dart';
import '../../../../helper/constans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AlartUpdate extends StatelessWidget {
  const AlartUpdate({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
                color: customColors.iconTheme,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocaleText(
                      'update_tile',
                      //textAlign: TextAlign.center,

                      style: TextStyle(
                        color: customColors.primaryColor,
                        fontFamily: 'SFPro',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    LocaleText('update_subtile',
                        //textAlign: TextAlign.center,

                        style: TextStyle(
                          fontFamily: 'SFPro',
                          fontWeight: FontWeight.w500,
                          color: customColors.primaryColor..withOpacity(.1),
                          fontSize: 15,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () => launchUrlString('https://animont.net',
                                mode: LaunchMode.externalNonBrowserApplication),
                            child: Card(
                              color: customColors.bottomDown,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: LocaleText(
                                    'update'.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'SFPro',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              if (Platform.isAndroid) {
                                SystemChannels.platform
                                    .invokeMethod('SystemNavigator.pop');
                              } else {
                                exit(0);
                              }
                            },
                            child: Card(
                              color: customColors.backgroundColor,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: LocaleText(
                                    'quit'.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: customColors.primaryColor,
                                      fontFamily: 'SFPro',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
