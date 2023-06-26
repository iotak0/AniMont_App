import 'dart:io';
import 'dart:math' as math;
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/widgets/alart_internet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late SharedPreferences pref;
  List<Color> colors = [Colors.white, Colors.black];
  getColor(String link) async {
    var paletteGenerator = await PaletteGenerator.fromImageProvider(
      FileImage(File(link)),
    );
    setState(() {
      colors[0] = paletteGenerator.darkVibrantColor!.color.toString().isNotEmpty
          ? paletteGenerator.darkVibrantColor!.color
          : Colors.black;
      colors[1] =
          paletteGenerator.lightVibrantColor!.color.toString().isNotEmpty
              ? paletteGenerator.lightVibrantColor!.color
              : Colors.white;
    });
  }

  chaneLang() {
    if (pref.getString('lange') == 'ar') {
      LocaleNotifier.of(context)!.change('en');
      pref.setString('lange', 'en');
    } else {
      LocaleNotifier.of(context)!.change('ar');
      pref.setString('lange', 'ar');
    }
  }

  prefs() async {
    pref = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    prefs();
    super.initState();

    // getColor('/storage/emulated/0/Download/BG/BG2.jpg');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CustomColors customColors = CustomColors(context);
    return Scaffold(
        body: SizedBox(
      height: size.height,
      child: Stack(
        children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(
                context.currentLocale!.languageCode == 'en'
                    ? math.pi * 2
                    : math.pi),
            child: Container(
                height: size.height,
                width: size.width,
                child: Image.asset(
                  'images/BG/BG2.jpg',
                  fit: BoxFit.cover,
                )),
          ),
          Positioned(
            top: 40,
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset('images/animont.png',
                                fit: BoxFit.cover)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: LocaleText(
                          'logo',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'SFPro',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          /*
          The Animont app offers a wide range of anime, dramas, movies, and original TV programs, with high-quality translation and high-resolution viewing. Users can also download episodes to watch later and access exclusive content, including exclusive episodes, contests, and discounts.

Additionally, users can create a personal account and participate in various forums and communities on the site, where they can post in English and interact with other users and talk about their favorite anime.

Overall, the Animont app is a great choice for anime lovers who want to watch high-quality content and engage with a community that shares their interests.

 يوفر تطبيق  Animont مجموعة واسعة من الأنمي والدراما والأفلام والبرامج التلفزيونية الأصلية، ويتميز بترجمة عالية الجودة ومشاهدة بدقة عالية. يمكن للمستخدمين أيضًا تحميل الحلقات لمشاهدتها في وقت لاحق، والوصول إلى المحتوى المميز بما في ذلك الحلقات الحصرية والمسابقات والخصومات.

بالإضافة إلى ذلك، يمكن للمستخدمين إنشاء حساب شخصي والمشاركة في المنتديات والمجتمعات المختلفة على الموقع، حيث يمكنهم نشر المنشورات  والتفاعل مع المستخدمين الآخرين والتحدث عن أنمي المفضل لديهم.

بشكل عام، يعد تطبيق Animont خيارًا رائعًا لعشاق الأنمي الذين يريدون مشاهدة المحتوى بجودة عالية والتواصل مع المجتمع الذي يشاركهم نفس الاهتمامات.*/
          /* Positioned(
            top: 50,
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: LocaleText(
                    'welcome0',
                    style: TextStyle(
                      shadows: [
                        Shadow(color: colors[0], blurRadius: 2),
                        Shadow(color: colors[0], blurRadius: 12),
                        Shadow(color: colors[1], blurRadius: 50),
                        Shadow(color: colors[0], blurRadius: 24)
                      ],
                      color: colors[1],
                      fontFamily: 'SFPro',
                      wordSpacing: -5,
                      height: 1,
                      fontSize: 40,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/Onboarding');
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: customColors.bottomUp),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      // decoration: BoxDecoration(
                      //     color: customColors.bottomDown,
                      //     borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LocaleText(
                          'agree_and_continue',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'SFPro',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: LocaleText(
                    'click_agree_and_continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(.7),
                      fontFamily: 'SFPro',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        CustomWebView(
                            customColors,
                            context,
                            'privacy_policy',
                            context.currentLocale!.languageCode == 'en'
                                ? 'https://animont.net/animont/privacy_&_policy_en.html'
                                : 'https://animont.net/animont/privacy_&_policy_en.html');
                      },
                      child: LocaleText(
                        'privacy_policy',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'SFPro',
                          decoration: TextDecoration.underline,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Container(
                        child: LocaleText(
                          'and',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(.7),
                            fontFamily: 'SFPro',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        CustomWebView(
                            customColors,
                            context,
                            'terms_&_conditions',
                            'https://animont.net/animont/terms_%26_conditions_en.html');
                      },
                      child: LocaleText(
                        'terms_&_conditions',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontFamily: 'SFPro',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      chaneLang();
                    }),
                    child: Container(
                      child: Text(
                        "${context.localeString('lang')} : ${context.localeString(context.currentLocale!.languageCode == 'ar' ? 'en' : 'ar')}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(.9),
                          fontFamily: 'SFPro',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Future<dynamic> CustomWebView(CustomColors customColors, BuildContext context,
      String title, String url) {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet<dynamic>(
        backgroundColor: customColors.backgroundColor,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        )),
        context: context,
        builder: (context) {
          return Container(
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30))),
              child: DraggableScrollableSheet(
                  expand: false,
                  maxChildSize: 0.9,
                  initialChildSize: 0.9,
                  minChildSize: 0.3,
                  builder: (context, scrollController) {
                    late WebViewController viewController;
                    return Stack(
                        clipBehavior: Clip.none,
                        alignment: AlignmentDirectional.topCenter,
                        children: [
                          Positioned(
                            top: 10,
                            height: 50,
                            child: Column(
                              children: [
                                Container(
                                    height: 8,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: customColors.primaryColor,
                                        borderRadius: BorderRadius.horizontal(
                                            right: Radius.circular(30),
                                            left: Radius.circular(30)))),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: LocaleText(
                                    title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: customColors.primaryColor,
                                      fontFamily: 'SFPro',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 60.0),
                              child: SingleChildScrollView(
                                  //controller: scrollController,
                                  child: Column(
                                children: [
                                  SizedBox(
                                    height: size.height * .9 - 60,
                                    child: WebView(
                                      gestureRecognizers: Set()
                                        ..add(Factory<
                                            VerticalDragGestureRecognizer>(
                                          () => VerticalDragGestureRecognizer(),
                                        )),
                                      onWebViewCreated: (controller) =>
                                          setState(() {
                                        viewController = controller;
                                      }),
                                      debuggingEnabled: true,
                                      zoomEnabled: true,
                                      javascriptMode:
                                          JavascriptMode.unrestricted,
                                      onWebResourceError: (error) =>
                                          AlartInternet(
                                        onTap: () => null,
                                      ),
                                      // backgroundColor: customColors
                                      //     .iconTheme
                                      //     .withOpacity(.5),
                                      initialUrl: url,
                                    ),
                                  ),
                                ],
                              )))
                        ]);
                  }));
        });
  }
}
