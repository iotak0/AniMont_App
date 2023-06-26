import 'package:anime_mont_test/Screens/Anime/all_my_anime.dart';
import 'package:anime_mont_test/Screens/Posts/posts.dart';
import 'package:anime_mont_test/Screens/settings/circleBotton.dart';
import 'package:anime_mont_test/Screens/settings/more_items.dart';
import 'package:anime_mont_test/Screens/settings/show_more_widget.dart';
import 'package:anime_mont_test/helper/constans.dart';
import 'package:anime_mont_test/models/get_x_controller.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/provider/theme_provider.dart';
import 'package:anime_mont_test/provider/user_model.dart';
import 'package:anime_mont_test/widgets/cust_snak_bar.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool loading = false;
  String? _quality;
  bool loadingHome = true;
  late SharedPreferences pref;
  String? color;
  getSettings() async {
    pref = await SharedPreferences.getInstance();
    _quality = pref.getString('quality') ?? '720p';
    color = await pref.getString('color') ?? 'blue';
    setState(() {
      loadingHome = false;
    });
  }

  @override
  void initState() {
    getSettings();
    super.initState();
  }

  changeJiffy() async {
    if (Locales.lang == "ar") {
      await Jiffy.locale("ar");
    } else {
      await Jiffy.locale("en");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    List<DropdownMenuItem> _qualityOptions = [
      DropdownMenuItem(
          value: '240p',
          child: Text('240p',
              style: TextStyle(
                  fontSize: 18,
                  color: customColors.primaryColor.withOpacity(.7),
                  shadows: [
                    Shadow(color: customColors.iconTheme, blurRadius: 12)
                  ],
                  fontWeight: FontWeight.bold))),
      DropdownMenuItem(
          value: '360p',
          child: Text('360p',
              style: TextStyle(
                  fontSize: 18,
                  color: customColors.primaryColor.withOpacity(.7),
                  shadows: [
                    Shadow(color: customColors.iconTheme, blurRadius: 12)
                  ],
                  fontWeight: FontWeight.bold))),
      DropdownMenuItem(
          value: '480p',
          child: Text('480p',
              style: TextStyle(
                  fontSize: 18,
                  color: customColors.primaryColor.withOpacity(.7),
                  shadows: [
                    Shadow(color: customColors.iconTheme, blurRadius: 12)
                  ],
                  fontWeight: FontWeight.bold))),
      DropdownMenuItem(
          value: '720p',
          child: Text('720p',
              style: TextStyle(
                  fontSize: 18,
                  color: customColors.primaryColor.withOpacity(.7),
                  shadows: [
                    Shadow(color: customColors.iconTheme, blurRadius: 12)
                  ],
                  fontWeight: FontWeight.bold))),
      DropdownMenuItem(
          value: '1080p',
          child: Text('1080p',
              style: TextStyle(
                  fontSize: 18,
                  color: customColors.primaryColor.withOpacity(.7),
                  shadows: [
                    Shadow(color: customColors.iconTheme, blurRadius: 12)
                  ],
                  fontWeight: FontWeight.bold))),
    ];

    return WillPopScope(
      onWillPop: () async {
        if (!loading) {
          return true;
        } else
          return false;
      },
      child: Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () => loading ? null : Navigator.pop(context),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: customColors.primaryColor,
              ),
            ),
            backgroundColor: customColors.backgroundColor,
            elevation: 1,
            title: LocaleText(
              'settings',
              style: TextStyle(
                  fontFamily: 'SFPro',
                  fontWeight: FontWeight.bold,
                  color: customColors.primaryColor),
            ),
          ),
          body: loadingHome
              ? LoadingGif(
                  logo: true,
                )
              : Column(mainAxisSize: MainAxisSize.max, children: [
                  GestureDetector(
                      onTap: () => showMore(
                          customColors,
                          context,
                          MoreItems(children: [
                            GestureDetector(
                              onTap: () async {
                                Navigator.pop(context);
                                final provider = Provider.of<ThemeProvider>(
                                    context,
                                    listen: false);
                                provider.toggleTheme('dark');
                                setState(() {});
                                final SharedPreferences pref =
                                    await SharedPreferences.getInstance();

                                pref.setString('theme', 'dark');
                              },
                              //☀️⭐🌑🌗🌗🌙🌕
                              child: CircBotton(
                                title: 'darkmode',
                                child: Center(
                                  child: Text("🌑",
                                      style: TextStyle(
                                          fontFamily: 'SFPro',
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                Navigator.pop(context);
                                final provider = Provider.of<ThemeProvider>(
                                    context,
                                    listen: false);
                                provider.toggleTheme('light');
                                setState(() {});
                                final SharedPreferences pref =
                                    await SharedPreferences.getInstance();

                                pref.setString('theme', 'light');
                              },
                              child: CircBotton(
                                title: 'lightmode',
                                child: Center(
                                  child: Text("☀️",
                                      style: TextStyle(
                                          fontFamily: 'SFPro',
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                Navigator.pop(context);
                                final SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                final provider = Provider.of<ThemeProvider>(
                                    context,
                                    listen: false);

                                pref.setString('theme', 'system');

                                provider.toggleTheme('system');

                                setState(() {});
                              },
                              child: CircBotton(
                                title: 'systemmode',
                                child: Center(
                                  child: Text("🌗",
                                      style: TextStyle(
                                          fontFamily: 'SFPro',
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ])),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(children: [
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.color_lens_outlined,
                                size: 35,
                                color:
                                    customColors.primaryColor.withOpacity(.7),
                              ),
                            ),
                          ),
                          LocaleText('theme',
                              style: TextStyle(
                                fontFamily: 'SFPro',
                                fontWeight: FontWeight.bold,
                                color:
                                    customColors.primaryColor.withOpacity(.7),
                                fontSize: 20,
                              )),
                        ]),
                      )),
                  /////////////////////////// Colors ////////////////
                  GestureDetector(
                      onTap: () {
                        loading
                            ? null
                            : showMore(
                                customColors,
                                context,
                                MoreItems(children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);

                                      if (color != 'blue') {
                                        final provider =
                                            Provider.of<ColorProvider>(context,
                                                listen: false);

                                        pref.setString('color', 'blue');
                                        provider.toggleColor('blue');
                                        setState(() {});
                                        Navigator.pop(context);
                                        Navigator.pushReplacementNamed(
                                            context, '/MyApp');
                                      }
                                    },
                                    //☀️⭐🌑🌗🌗🌙🌕
                                    child: CircBotton(
                                      title: 'blue',
                                      child: Center(
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: CircleAvatar(
                                                backgroundColor: Colors.blue,
                                              ),
                                            ),
                                            color != 'blue'
                                                ? SizedBox()
                                                : Center(
                                                    child: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        child: Icon(
                                                          Icons
                                                              .done_outline_rounded,
                                                          color: Colors.white,
                                                        )),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      if (color != 'green') {
                                        final provider =
                                            Provider.of<ColorProvider>(context,
                                                listen: false);

                                        pref.setString('color', 'green');
                                        provider.toggleColor('green');

                                        setState(() {});
                                        Navigator.pop(context);
                                        Navigator.pushReplacementNamed(
                                            context, '/MyApp');
                                      }
                                    },
                                    child: CircBotton(
                                      title: 'green',
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  ColorProvider.darkGreen,
                                            ),
                                          ),
                                          color != 'green'
                                              ? SizedBox()
                                              : Center(
                                                  child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      child: Icon(
                                                        Icons
                                                            .done_outline_rounded,
                                                        color: Colors.white,
                                                      )),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      if (color != 'purple') {
                                        final provider =
                                            Provider.of<ColorProvider>(context,
                                                listen: false);

                                        pref.setString('color', 'purple');

                                        provider.toggleColor('purple');

                                        setState(() {});
                                        Navigator.pop(context);
                                        Navigator.pushReplacementNamed(
                                            context, '/MyApp');
                                      }
                                    },
                                    child: CircBotton(
                                      title: 'purple',
                                      child: Center(
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    ColorProvider.darkPurple,
                                              ),
                                            ),
                                            color != 'purple'
                                                ? SizedBox()
                                                : Center(
                                                    child: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        child: Icon(
                                                          Icons
                                                              .done_outline_rounded,
                                                          color: Colors.white,
                                                        )),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      if (color != 'pink') {
                                        final provider =
                                            Provider.of<ColorProvider>(context,
                                                listen: false);

                                        pref.setString('color', 'pink');

                                        provider.toggleColor('pink');

                                        setState(() {});
                                        Navigator.pop(context);
                                        Navigator.pushReplacementNamed(
                                            context, '/MyApp');
                                      }
                                    },
                                    child: CircBotton(
                                      title: 'pink',
                                      child: Center(
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    ColorProvider.lightPink,
                                              ),
                                            ),
                                            color != 'pink'
                                                ? SizedBox()
                                                : Center(
                                                    child: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        child: Icon(
                                                          Icons
                                                              .done_outline_rounded,
                                                          color: Colors.white,
                                                        )),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ]));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(children: [
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.invert_colors_rounded,
                                size: 35,
                                color:
                                    customColors.primaryColor.withOpacity(.7),
                              ),
                            ),
                          ),
                          LocaleText('primary_color',
                              style: TextStyle(
                                fontFamily: 'SFPro',
                                fontWeight: FontWeight.bold,
                                color:
                                    customColors.primaryColor.withOpacity(.7),
                                fontSize: 20,
                              )),
                        ]),
                      )),
                  GestureDetector(
                      onTap: () => showMore(
                          customColors,
                          context,
                          MoreItems(children: [
                            GestureDetector(
                              onTap: () async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                if (prefs.getString('lange') == 'ar') {
                                  LocaleNotifier.of(context)!.change('en');
                                  prefs.setString('lange', 'en');
                                } else {
                                  LocaleNotifier.of(context)!.change('ar');
                                  prefs.setString('lange', 'ar');
                                }
                                changeJiffy();
                                //   Restart.restartApp();
                                Navigator.pop(context);
                              },
                              child: CircBotton(
                                title:
                                    context.currentLocale!.languageCode == 'ar'
                                        ? 'en'
                                        : 'ar',
                                child: Center(
                                  child: Text(
                                      context.currentLocale!.languageCode !=
                                              'ar'
                                          ? "ar"
                                          : "en",
                                      style: TextStyle(
                                          fontFamily: 'SFPro',
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ])),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(children: [
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.language_outlined,
                                size: 35,
                                color:
                                    customColors.primaryColor.withOpacity(.7),
                              ),
                            ),
                          ),
                          LocaleText('lang',
                              style: TextStyle(
                                fontFamily: 'SFPro',
                                fontWeight: FontWeight.bold,
                                color:
                                    customColors.primaryColor.withOpacity(.7),
                                fontSize: 20,
                              )),
                        ]),
                      )),
                  Row(children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.settings,
                          size: 35,
                          color: customColors.primaryColor.withOpacity(.7),
                        ),
                      ),
                    ),
                    LocaleText('quality',
                        style: TextStyle(
                          fontFamily: 'SFPro',
                          fontWeight: FontWeight.bold,
                          color: customColors.primaryColor.withOpacity(.7),
                          fontSize: 20,
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: DropdownButton(
                        value: _quality,
                        icon: Icon(
                          Icons.arrow_drop_down_circle_outlined,
                          color: customColors.primaryColor,
                        ),
                        itemHeight: 50,
                        underline: SizedBox(),
                        menuMaxHeight: 300,
                        style: TextStyle(
                            color: customColors.primaryColor.withOpacity(.7)),
                        dropdownColor: customColors.iconTheme.withOpacity(.99),
                        elevation: 20,
                        focusColor: customColors.primaryColor.withOpacity(.7),
                        items: _qualityOptions,
                        borderRadius: BorderRadius.circular(12),
                        isExpanded: false,
                        onChanged: (value) async {
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();

                          if (_quality != value) {
                            setState(() {
                              _quality = value.toString();
                              pref.setString('quality', value.toString());
                            });
                          }
                        },
                      ),
                    )
                  ]),
                  //AllMyAnime
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllMyAnime(
                                      headLine: 'favorite',
                                    )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(children: [
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: SvgPicture.string(
                                '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                        <title>Iconly/Bold/Heart</title>
                        <g id="Iconly/Bold/Heart" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                            <g id="Heart" transform="translate(1.999783, 2.500540)" fill="#000000" fill-rule="nonzero">
                                <path d="M6.28001656,3.46389584e-14 C6.91001656,0.0191596721 7.52001656,0.129159672 8.11101656,0.330159672 L8.11101656,0.330159672 L8.17001656,0.330159672 C8.21001656,0.349159672 8.24001656,0.370159672 8.26001656,0.389159672 C8.48101656,0.460159672 8.69001656,0.540159672 8.89001656,0.650159672 L8.89001656,0.650159672 L9.27001656,0.820159672 C9.42001656,0.900159672 9.60001656,1.04915967 9.70001656,1.11015967 C9.80001656,1.16915967 9.91001656,1.23015967 10.0000166,1.29915967 C11.1110166,0.450159672 12.4600166,-0.00984032788 13.8500166,3.46389584e-14 C14.4810166,3.46389584e-14 15.1110166,0.0891596721 15.7100166,0.290159672 C19.4010166,1.49015967 20.7310166,5.54015967 19.6200166,9.08015967 C18.9900166,10.8891597 17.9600166,12.5401597 16.6110166,13.8891597 C14.6800166,15.7591597 12.5610166,17.4191597 10.2800166,18.8491597 L10.2800166,18.8491597 L10.0300166,19.0001597 L9.77001656,18.8391597 C7.48101656,17.4191597 5.35001656,15.7591597 3.40101656,13.8791597 C2.06101656,12.5301597 1.03001656,10.8891597 0.390016562,9.08015967 C-0.739983438,5.54015967 0.590016562,1.49015967 4.32101656,0.269159672 C4.61101656,0.169159672 4.91001656,0.0991596721 5.21001656,0.0601596721 L5.21001656,0.0601596721 L5.33001656,0.0601596721 C5.61101656,0.0191596721 5.89001656,3.46389584e-14 6.17001656,3.46389584e-14 L6.17001656,3.46389584e-14 Z M15.1900166,3.16015967 C14.7800166,3.01915967 14.3300166,3.24015967 14.1800166,3.66015967 C14.0400166,4.08015967 14.2600166,4.54015967 14.6800166,4.68915967 C15.3210166,4.92915967 15.7500166,5.56015967 15.7500166,6.25915967 L15.7500166,6.25915967 L15.7500166,6.29015967 C15.7310166,6.51915967 15.8000166,6.74015967 15.9400166,6.91015967 C16.0800166,7.08015967 16.2900166,7.17915967 16.5100166,7.20015967 C16.9200166,7.18915967 17.2700166,6.86015967 17.3000166,6.43915967 L17.3000166,6.43915967 L17.3000166,6.32015967 C17.3300166,4.91915967 16.4810166,3.65015967 15.1900166,3.16015967 Z"></path>
                            </g>
                        </g>
                    </svg>''',
                                height: 35,
                                width: 35,
                                color:
                                    customColors.primaryColor.withOpacity(.7),
                              ),
                            ),
                          ),
                          LocaleText('favorite',
                              style: TextStyle(
                                fontFamily: 'SFPro',
                                fontWeight: FontWeight.bold,
                                color:
                                    customColors.primaryColor.withOpacity(.7),
                                fontSize: 20,
                              )),
                        ]),
                      )),
                  GestureDetector(
                      onTap: () {
                        launchUrlString('https://animont.net',
                            mode: LaunchMode.externalNonBrowserApplication);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(children: [
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.info_outlined,
                                size: 35,
                                color:
                                    customColors.primaryColor.withOpacity(.7),
                              ),
                            ),
                          ),
                          LocaleText('about_us',
                              style: TextStyle(
                                fontFamily: 'SFPro',
                                fontWeight: FontWeight.bold,
                                color:
                                    customColors.primaryColor.withOpacity(.7),
                                fontSize: 20,
                              )),
                        ]),
                      )),

                  loading
                      ? LoadingGif(
                          logo: false,
                        )
                      : GestureDetector(
                          onTap: () async {
                            setState(() {
                              loading = true;
                            });
                            await UserModel.logOut(context).then((value) {
                              if (value) {
                                setState(() {
                                  loading = false;
                                });
                                ChatGetX.posts.clear();
                                Navigator.pop(context);
                                Navigator.pushReplacementNamed(
                                    context, '/MyApp');
                              } else {
                                setState(() {
                                  loading = false;
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: CustSnackBar(
                                    color: Color(0xFFC72C41),
                                    image: danger,
                                    headLine: context.localeString('erorr'),
                                    erorr: context.localeString("try_again"),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                ));
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Icon(
                                    Icons.logout_rounded,
                                    size: 35,
                                    color: Colors.red.withOpacity(.7),
                                  ),
                                ),
                              ),
                              LocaleText('logout',
                                  style: TextStyle(
                                    fontFamily: 'SFPro',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.withOpacity(.7),
                                    fontSize: 20,
                                  )),
                            ]),
                          )),
                  /*  GestureDetector(
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                backgroundColor: Colors.transparent,
                                content: Container(
                                  //height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: customColors.backgroundColor,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                    width: 3,
                                                    color: customColors
                                                        .primaryColor
                                                        .withOpacity(.5))),
                                            child: Center(
                                              child: Text(
                                                '💀',
                                                style: TextStyle(
                                                    fontSize: 50,
                                                    shadows: [
                                                      Shadow(
                                                          color: customColors
                                                              .primaryColor,
                                                          blurRadius: 15)
                                                    ],
                                                    color:
                                                        customColors.bottomDown),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            'هل انت متأكد ؟!',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: customColors.primaryColor,
                                              fontFamily: 'SFPro',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              'في حال الضغط على زر التأكيد فسيتم حذف حسابك وجميع بياناتك بما في ذلك المشورات والتعليقات وغيرها .',
                                              textAlign: TextAlign.center,
                                              softWrap: true,
                                              locale: Locale.fromSubtags(),
                                              style: TextStyle(
                                                fontFamily: 'SFPro',
                                                fontWeight: FontWeight.bold,
                                                color: customColors.primaryColor
                                                  ..withOpacity(.1),
                                                fontSize: 18,
                                              )),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Divider(
                                            height: 1,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      Navigator.pop(context),
                                                  child: Card(
                                                    color: customColors
                                                        .backgroundColor,
                                                    child: SizedBox(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                8.0),
                                                        child: LocaleText(
                                                          'confront',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.red
                                                                .withOpacity(.9),
                                                            fontFamily: 'SFPro',
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      Navigator.pop(context),
                                                  child: Card(
                                                    color: customColors
                                                        .backgroundColor,
                                                    child: SizedBox(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                8.0),
                                                        child: LocaleText(
                                                          'back',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: customColors
                                                                .primaryColor
                                                                .withOpacity(.6),
                                                            fontFamily: 'SFPro',
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w500,
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
                                )));
                        //  await UserModel.logOut(context);
                        // Navigator.restorablePushReplacementNamed(
                        //     widget.context, '/MyApp');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.delete_outline_rounded,
                                size: 35,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          LocaleText('delete_account',
                              style: TextStyle(
                                fontFamily: 'SFPro',
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 20,
                              )),
                        ]),
                      )),*/
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
                    child: GestureDetector(
                        onTap: () {
                          launchUrlString('https://animetitans.net/',
                              mode: LaunchMode.externalNonBrowserApplication);
                        },
                        child: Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.horizontal,
                              children: [
                                // Image.network(
                                //   "https://i0.wp.com/animetitans.net/wp-content/uploads/2021/10/icon-A-150x150.png",
                                //   height: 30,
                                //   width: 30,
                                //   errorBuilder: (context, error, stackTrace) =>
                                //       SizedBox(
                                //     height: 30,
                                //     width: 30,
                                //   ),
                                //   color: customColors.primaryColor.withOpacity(.7),
                                // ),
                                LocaleText('animetitans_copyrights',
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'SFPro',
                                      fontWeight: FontWeight.bold,
                                      color: customColors.primaryColor
                                          .withOpacity(.5),
                                      fontSize: 13,
                                    )),
                              ]),
                        )),
                  ),
                ])),
    );
  }
}
