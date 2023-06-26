import 'dart:io';

import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late PageController _pageController;
  int pageIndex = 0;
  late SharedPreferences pref;
  prefs() async {
    pref = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    prefs();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                dragStartBehavior: DragStartBehavior.down,
                scrollBehavior: ScrollBehavior(),
                controller: _pageController,
                itemCount: onboardList.length,
                onPageChanged: (index) => setState(() {
                  pageIndex = index;
                }),
                itemBuilder: (context, index) {
                  Onboard onboard = onboardList[index];
                  return OnboardingCard(
                    image: onboard.image.replaceAll("?", "${index + 1}"),
                    subtitle: onboard.subtitle.replaceAll("?", "${index + 1}"),
                    title: onboard.title.replaceAll("?", "${index + 1}"),
                  );
                },
              ),
            ),
            Row(
              children: [
                ...List.generate(
                    onboardList.length,
                    (index) => Padding(
                          padding: EdgeInsets.only(
                              right: context.currentLocale!.languageCode == 'en'
                                  ? 4.0
                                  : 0,
                              left: context.currentLocale!.languageCode == 'en'
                                  ? 0
                                  : 4.0),
                          child: DotIndicator(
                            isActive: index == pageIndex,
                          ),
                        )),
                Spacer(),
                SizedBox(
                  height: 55,
                  width: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (pageIndex == onboardList.length - 1) {
                        pref.setBool('welcome', false);
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/LogIn');
                      } else
                        _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease);
                    },
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: customColors.bottomDown),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(
                          context.currentLocale!.languageCode != 'en'
                              ? math.pi * 2
                              : math.pi),
                      child: Center(
                        child: SvgPicture.string(
                          '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                        <title>Iconly/Light/Arrow - Left 2</title>
                        <g id="Iconly/Light/Arrow---Left-2" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round">
                            <g id="Arrow---Left-2" transform="translate(12.000000, 12.000000) rotate(-270.000000) translate(-12.000000, -12.000000) translate(5.000000, 8.500000)" stroke="#000000" stroke-width="1.5">
                                  <polyline id="Stroke-1" points="14 0 7 7 0 0"></polyline>
                            </g>
                        </g>
                    </svg>''',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}

class DotIndicator extends StatelessWidget {
  final bool isActive;
  const DotIndicator({
    Key? key,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isActive ? 12 : 4,
      width: 4,
      decoration: BoxDecoration(
          color: !isActive
              ? customColors.bottomDown.withOpacity(.4)
              : customColors.bottomDown,
          borderRadius: BorderRadius.circular(12)),
    );
  }
}

class Onboard {
  final String title, subtitle, image;

  Onboard({required this.title, required this.subtitle, required this.image});
}

final List<Onboard> onboardList = [
  Onboard(
      title: "onboard_title_?",
      subtitle: "onboard_subtitle_?",
      image: "images/OBS?.jpg"),
  Onboard(
      title: "onboard_title_?",
      subtitle: "onboard_subtitle_?",
      image: "images/OBS?.jpg"),
  Onboard(
      title: "onboard_title_?",
      subtitle: "onboard_subtitle_?",
      image: "images/OBS?.jpg"),
  // Onboard(
  //     title: "تواصل مع الكل",
  //     subtitle: "ينىترىتببلا",
  //     image: "images/BG/BG7.jpg"),
];

class OnboardingCard extends StatelessWidget {
  const OnboardingCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.image,
  }) : super(key: key);
  final String title, subtitle, image;
  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    return Column(
      children: [
        Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              image,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Spacer(),
        LocaleText(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'SFPro',
              fontSize: 25,
              color: customColors.primaryColor),
        ),
        SizedBox(
          height: 16,
        ),
        LocaleText(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w300,
              fontFamily: 'SFPro',
              fontSize: 18,
              color: customColors.primaryColor.withOpacity(.8)),
        ),
        Spacer(),
      ],
    );
  }
}
