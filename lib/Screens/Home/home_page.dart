import 'dart:convert';
import 'package:anime_mont_test/Screens/Anime/all_genres.dart';
import 'package:anime_mont_test/Screens/Anime/anime_scrollview.dart';
import 'package:anime_mont_test/Screens/Home/Search/search_page.dart';
import 'package:anime_mont_test/Screens/Home/navbar.dart';
import 'package:anime_mont_test/Screens/Posts/posts.dart';
import 'package:anime_mont_test/Screens/Profile/profial_screen.dart';
import 'package:anime_mont_test/Screens/Home/episode_dates.dart';
import 'package:anime_mont_test/Screens/Home/notification_page.dart';
import 'package:anime_mont_test/models/get_x_controller.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/server/Chat-Server-master/lib/Model/ChatModel.dart';
import 'package:anime_mont_test/server/Chat-Server-master/lib/Screens/IndividualPage.dart';
import 'package:anime_mont_test/server/ads.dart';
import 'package:anime_mont_test/server/banner_ad.dart';
import 'package:anime_mont_test/widgets/keep_page.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:anime_mont_test/widgets/slider_bar.dart';
import 'package:badges/badges.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:anime_mont_test/provider/user_model.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:anime_mont_test/server/server_php.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.index,
    required this.myId,
    required this.season,
  });
  final int index;
  final int myId;
  final String season;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //List images = ['images/avatar.jpg', 'images/cover 2.png'];
  //final TextEditingController _myController = TextEditingController();
  late int index;
  TextEditingController _controller = TextEditingController();
  SharedPreferences? prefs;

  changeJiffy() async {
    if (Locales.lang == "ar") {
      await Jiffy.locale("ar");
    } else {
      await Jiffy.locale("en");
    }
    setState(() {});
  }

  Future getIdex() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      index = prefs!.getInt('index') ?? 0;
      pageController = PageController(keepPage: true, initialPage: index);
    });
    await AllAds.loadAppOpenAd();
    await changeJiffy();
  }

  PageController? pageController;
  @override
  void initState() {
    getIdex();
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    pageController!.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconTheme = Theme.of(context).iconTheme.color!;
    final Color textColor = Color.fromARGB(255, 160, 146, 167);
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color bottomUp = Theme.of(context).primaryColorDark;
    final Color bottomDown = Theme.of(context).primaryColorLight;
    List<String> genralList = [
      'أكشن',
      'إثارة',
      'ايتشي',
      'بوليسي',
      'تاريخي',
      'جوسي',
      'حريم',
      'خارق_للطبيعة',
      'خيال',
      'خيال_علمي',
      'دراما',
      'رعب',
      'رومانسي',
      'رياضي',
      'ساخر',
      'ساموراي',
      'سحر',
      'سينين',
      'شريحة_من_الحياة',
      'شوجو',
      'شونين',
      //'شونين_اي',
      'شياطين',
      'عسكري',
      'غموض',
      'فضاء',
      'فلسفي',
      'فنون_قتال',
      'قوة_خارقة',
      'كوميدي',
      'لعبة',
      'مدرسي',
      'مصاصي_دماء',
      'مغامرة',
      'موسيقي',
      'ميكا',
      'نفسي',
    ];
    CustomColors customColor = CustomColors(context);
    return Scaffold(
        body: pageController == null
            ? LoadingGif(
                logo: true,
              )
            : Column(
                children: [
                  SizedBox(
                    height: size.height - 50.5,
                    child: PageView(
                      onPageChanged: (value) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        try {
                          prefs.setInt('index', value);
                          index = value;
                          print(prefs.getInt('index').toString());
                        } catch (e) {}
                        setState(() {});
                      },
                      physics: NeverScrollableScrollPhysics(),
                      controller: pageController,
                      children: [
                        KeepPage(
                          child: Home(
                              season: widget.season,
                              index: widget.index,
                              myId: widget.myId,
                              pageController: pageController!,
                              size: size),
                        ),
                        KeepPage(
                          child: Scaffold(
                              appBar: AppBar(
                                elevation: 1,
                                backgroundColor: customColor.backgroundColor,
                                title: LocaleText(
                                  'categories',
                                  style: TextStyle(
                                      fontFamily: 'SFPro',
                                      color: customColor.primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              body: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 10),
                                      child: const MyBannerAd(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: List.generate(
                                              genralList.length,
                                              (index) => GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      AllGenres(
                                                                        myId: widget
                                                                            .myId,
                                                                        genre: genralList[
                                                                            index],
                                                                      )));
                                                    },
                                                    child: Container(
                                                      height: 60,
                                                      width: 160,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: iconTheme,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child: LocaleText(
                                                          genralList[index],
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'SFPro',
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        SafeArea(
                          child: KeepPage(
                              child: SearchPage(
                            myId: widget.myId,
                          )),
                        ),
                        KeepPage(
                          child: PostsPage(myId: widget.myId),
                        ),
                        KeepPage(
                            child: ProfialPage(
                          myId: widget.myId,
                          isMyProfile: true,
                          id: widget.myId,
                        ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                        height: 50,
                        child: NavBar(pageController: pageController!)),
                  ),
                ],
              ));
  }
}

class Home extends StatefulWidget {
  const Home({
    Key? key,
    required this.pageController,
    required this.size,
    required this.myId,
    required this.index,
    required this.season,
  }) : super(key: key);
  final PageController pageController;
  final Size size;
  final int myId;
  final String season;
  final int index;

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  var isReady;
  bool isLoading = false;
  bool error = false;
  UserModel? account;
  // TODO: Add _interstitialAd
  InterstitialAd? _interstitialAd;

  // TODO: Implement _loadInterstitialAd()
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.intersAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              // Navigator.pop(context);
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  // Future getNotifi() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? userPref = prefs.getString('userData');
  //   final user = json.decode(userPref!);
  //   account = UserModel.fromJson(user);
  //   isLoading = true;
  //   setState(() {});
  //   http.Response response = await http
  //       .get(Uri.parse(
  //           "${my_notification_count}?user_id=${widget.myId}"))
  //       .catchError((error) {
  //     setState(() {
  //       error = true;
  //       isReady = true;
  //       isLoading = false;
  //       return;
  //     });
  //   });
  //   if (response.statusCode == 200) {
  //     var body;
  //     try {
  //       body = jsonDecode(response.body);
  //     } catch (e) {
  //       isLoading = false;
  //       error = true;
  //       isReady = true;
  //       setState(() {});
  //       return;
  //     }
  //     notifiCount = body["count"];
  //     isReady = true;
  //     setState(() {});
  //   } else {
  //     print("Connecation Error ${response.statusCode}");
  //     isReady = true;
  //     error = true;
  //     setState(() {});
  //   }
  //   isLoading = false;
  //   setState(() {});
  // }

  Future refresh() async {
    await SharedPreferences.getInstance().then((value) {
      value.setInt('index', 0);
      widget.pageController.animateToPage(0,
          duration: const Duration(microseconds: 200), curve: Curves.easeIn);

      Navigator.restorablePushReplacementNamed(context, '/Home');
    });

    //
    // Navigator.restorablePushReplacement(
    //     context,
    //     (context, arguments) => MaterialPageRoute(
    //           builder: (context) => Home(
    //               iconTheme: widget.iconTheme,
    //               primaryColor: widget.primaryColor,
    //               pageController: widget.pageController,
    //               size: widget.size),
    //         ));
  }

  getNotifi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString('userData');
    final body = json.decode(userPref!);
    UserProfial account = await UserProfial.fromJson(body);
    http.Response response = await http
        .get(Uri.parse("${my_notification_count}?user_id=${account.id}"))
        .catchError((error) {});
    if (response.statusCode == 200) {
      var body;
      try {
        body = jsonDecode(response.body);
      } catch (e) {
        return;
      }
      ChatGetX.noitificationCount.value = body["count"];
    } else {
      print("Connecation Error ${response.statusCode}");
    }
  }

  late Server server;
  @override
  void initState() {
    server = Server();
    getNotifi();
    _loadInterstitialAd();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    CustomColors customColors = CustomColors(context);

    return RefreshIndicator(
      onRefresh: refresh,
      child: SizedBox(
        height: size.height,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                centerTitle: true,
                collapseMode: CollapseMode.parallax,

                background: Container(
                  color: customColors.backgroundColor,
                ),
                //background: ProfileAppBar(myId: widget.myId, profail: profail),
                titlePadding: EdgeInsets.symmetric(vertical: 5),
                title: Material(
                  child: Container(
                    color: customColors.backgroundColor,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              // onTap: () {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) =>));
                              // },
                              child: Container(
                                  child: LocaleText(
                                "logo",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontFamily:
                                        context.currentLocale.toString() == 'ar'
                                            ? 'SFPro'
                                            : 'Angie',
                                    fontWeight: FontWeight.w900),
                              )),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EpisodeDates(
                                                  myId: widget.myId,
                                                )));
                                  },
                                  child: CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Colors.transparent,
                                    // backgroundColor: customColors.iconTheme,
                                    child: SvgPicture.string(
                                      '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Light-Outline/Time Circle</title>
    <g id="Iconly/Light-Outline/Time-Circle" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
        <g id="Time-Circle" transform="translate(2.000000, 2.000000)" fill="#000000">
            <path d="M10,0 C15.514,0 20,4.486 20,10 C20,15.514 15.514,20 10,20 C4.486,20 0,15.514 0,10 C0,4.486 4.486,0 10,0 Z M10,1.5 C5.313,1.5 1.5,5.313 1.5,10 C1.5,14.687 5.313,18.5 10,18.5 C14.687,18.5 18.5,14.687 18.5,10 C18.5,5.313 14.687,1.5 10,1.5 Z M9.6612,5.0954 C10.0762,5.0954 10.4112,5.4314 10.4112,5.8454 L10.4112,10.2674 L13.8162,12.2974 C14.1712,12.5104 14.2882,12.9704 14.0762,13.3264 C13.9352,13.5614 13.6862,13.6924 13.4312,13.6924 C13.3002,13.6924 13.1682,13.6584 13.0472,13.5874 L9.2772,11.3384 C9.0512,11.2024 8.9112,10.9574 8.9112,10.6934 L8.9112,5.8454 C8.9112,5.4314 9.2472,5.0954 9.6612,5.0954 Z" id="Combined-Shape"></path>
        </g>
    </g>
</svg>''',
                                      color: customColors.primaryColor,
                                      height: 35,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // 1 == 1
                                //     ? SizedBox()
                                //     :
                                SizedBox(
                                  width: 8,
                                ),
                                // 1 == 1
                                //     ? SizedBox()
                                //     :
                                GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SizedBox(
                                                child: IndividualPage())));
                                  },
                                  child: CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Colors.transparent,
                                    // backgroundColor: customColors.iconTheme,
                                    child: SvgPicture.string(
                                      '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Light-Outline/Chat</title>
    <g id="Iconly/Light-Outline/Chat" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
        <g id="Chat" transform="translate(1.000000, 1.000000)" fill="#000000">
            <path d="M10.7484,0.0003 C13.6214,0.0003 16.3214,1.1173 18.3494,3.1463 C22.5414,7.3383 22.5414,14.1583 18.3494,18.3503 C16.2944,20.4063 13.5274,21.4943 10.7244,21.4943 C9.1964,21.4943 7.6584,21.1713 6.2194,20.5053 C5.7954,20.3353 5.3984,20.1753 5.1134,20.1753 C4.7854,20.1773 4.3444,20.3293 3.9184,20.4763 C3.0444,20.7763 1.9564,21.1503 1.1514,20.3483 C0.3494,19.5453 0.7194,18.4603 1.0174,17.5873 C1.1644,17.1573 1.3154,16.7133 1.3154,16.3773 C1.3154,16.1013 1.1824,15.7493 0.9784,15.2423 C-0.8946,11.1973 -0.0286,6.3223 3.1484,3.1473 C5.1764,1.1183 7.8754,0.0003 10.7484,0.0003 Z M10.7494,1.5003 C8.2764,1.5003 5.9534,2.4623 4.2084,4.2083 C1.4744,6.9403 0.7304,11.1353 2.3554,14.6483 C2.5894,15.2273 2.8154,15.7913 2.8154,16.3773 C2.8154,16.9623 2.6144,17.5513 2.4374,18.0713 C2.2914,18.4993 2.0704,19.1453 2.2124,19.2873 C2.3514,19.4313 3.0014,19.2043 3.4304,19.0573 C3.9454,18.8813 4.5294,18.6793 5.1084,18.6753 C5.6884,18.6753 6.2354,18.8953 6.8144,19.1283 C10.3614,20.7683 14.5564,20.0223 17.2894,17.2903 C20.8954,13.6823 20.8954,7.8133 17.2894,4.2073 C15.5434,2.4613 13.2214,1.5003 10.7494,1.5003 Z M14.6963,10.163 C15.2483,10.163 15.6963,10.61 15.6963,11.163 C15.6963,11.716 15.2483,12.163 14.6963,12.163 C14.1443,12.163 13.6923,11.716 13.6923,11.163 C13.6923,10.61 14.1353,10.163 14.6873,10.163 L14.6963,10.163 Z M10.6875,10.163 C11.2395,10.163 11.6875,10.61 11.6875,11.163 C11.6875,11.716 11.2395,12.163 10.6875,12.163 C10.1355,12.163 9.6835,11.716 9.6835,11.163 C9.6835,10.61 10.1255,10.163 10.6785,10.163 L10.6875,10.163 Z M6.6783,10.163 C7.2303,10.163 7.6783,10.61 7.6783,11.163 C7.6783,11.716 7.2303,12.163 6.6783,12.163 C6.1263,12.163 5.6743,11.716 5.6743,11.163 C5.6743,10.61 6.1173,10.163 6.6693,10.163 L6.6783,10.163 Z" id="Combined-Shape"></path>
        </g>
    </g>
</svg>''',
                                      color: customColors.primaryColor,
                                      height: 35,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    Map<String, dynamic> user =
                                        await UserModel.getAcount();
                                    int myId = int.parse(user['id']);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NotifiPage(myId: myId)));
                                  },
                                  child: CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Colors.transparent,
                                    // backgroundColor: customColors.iconTheme,
                                    child: Badge(
                                      badgeContent: Obx(
                                        () => Text(
                                          ChatGetX.noitificationCount.value == 0
                                              ? ''
                                              : ChatGetX.noitificationCount
                                                          .value >
                                                      9
                                                  ? "+9"
                                                  : "${ChatGetX.noitificationCount.value}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Angie',
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ),
                                      badgeStyle: BadgeStyle(
                                        badgeColor:
                                            ChatGetX.noitificationCount.value ==
                                                    0
                                                ? Colors.transparent
                                                : customColors.bottomDown,
                                      ),
                                      badgeAnimation: BadgeAnimation.fade(),
                                      child: SvgPicture.string(
                                        '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
            <title>Iconly/Light-Outline/Notification</title>
            <g id="Iconly/Light-Outline/Notification" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                <g id="Notification" transform="translate(3.000000, 1.000000)" fill="#000000">
                    <path d="M7.3243,19.106 C7.8423,19.683 8.5073,20 9.1973,20 L9.1983,20 C9.8913,20 10.5593,19.683 11.0783,19.105 C11.3563,18.798 11.8303,18.773 12.1373,19.05 C12.4453,19.327 12.4703,19.802 12.1933,20.109 C11.3853,21.006 10.3223,21.5 9.1983,21.5 L9.1963,21.5 C8.0753,21.499 7.0143,21.005 6.2093,20.108 C5.9323,19.801 5.9573,19.326 6.2653,19.05 C6.5733,18.772 7.0473,18.797 7.3243,19.106 Z M9.2471,0 C13.6921,0 16.6781,3.462 16.6781,6.695 C16.6781,8.358 17.1011,9.063 17.5501,9.811 C17.9941,10.549 18.4971,11.387 18.4971,12.971 C18.1481,17.018 13.9231,17.348 9.2471,17.348 C4.5711,17.348 0.3451,17.018 8.66453236e-05,13.035 C-0.0029,11.387 0.5001,10.549 0.9441,9.811 L1.10084456,9.54715551 C1.48677474,8.88385813 1.8161,8.16235294 1.8161,6.695 C1.8161,3.462 4.8021,0 9.2471,0 Z M9.2471,1.5 C5.7521,1.5 3.3161,4.238 3.3161,6.695 C3.3161,8.774 2.7391,9.735 2.2291,10.583 C1.8201,11.264 1.4971,11.802 1.4971,12.971 C1.6641,14.857 2.9091,15.848 9.2471,15.848 C15.5501,15.848 16.8341,14.813 17.0001,12.906 C16.9971,11.802 16.6741,11.264 16.2651,10.583 C15.7551,9.735 15.1781,8.774 15.1781,6.695 C15.1781,4.238 12.7421,1.5 9.2471,1.5 Z" id="Combined-Shape"></path>
                </g>
            </g>
        </svg>''',
                                        color: customColors.primaryColor,
                                        height: 35,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.push(context,
                    //         MaterialPageRoute(builder: (context) => SearchPage()));
                    //   },
                    // ),
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        prefs.setInt('index', 2);
                        widget.pageController.jumpToPage(2);
                        //index = prefs.getInt('index')!;
                        print(prefs.getInt('index').toString());
                        setState(() {});
                      },
                      child: SearchBar(
                          iconTheme: customColors.iconTheme,
                          primaryColor: customColors.primaryColor),
                    ),
                    //('isReady == true || isReady == null')
                    //  isLoading != true ?
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 5),
                          child: const MyBannerAd(),
                        ),
                        Titel(
                          function: () {
                            _interstitialAd?.show();
                            UserModel.goTo("new", '', widget.myId, context);
                          },
                          size: widget.size,
                          title: "new",
                          more: false,
                        ),
                        SliderBar(
                          myId: widget.myId,
                          size: widget.size,
                        ),
                        Titel(
                          function: () {
                            _interstitialAd?.show();
                            UserModel.goTo("season", '${widget.season}',
                                widget.myId, context);
                          },
                          size: size,
                          title: "season",
                          more: true,
                        ),
                        AnimeScrollView(
                            myId: widget.myId,
                            size: size,
                            url:
                                'https://animetitans.com/anime/?${widget.season}'),
                        Titel(
                          function: () {
                            _interstitialAd?.show();
                            UserModel.goTo(
                                "movies",
                                'status=&type=movie&order=',
                                widget.myId,
                                context);
                          },
                          size: widget.size,
                          title: "movies",
                          more: true,
                        ),
                        AnimeScrollView(
                            myId: widget.myId,
                            size: widget.size,
                            url:
                                'https://animetitans.com/anime/?status=&type=movie&order='),
                        Titel(
                          function: () {
                            _interstitialAd?.show();
                            UserModel.goTo(
                                "dub", '?type=&sub=dub', widget.myId, context);
                          },
                          size: widget.size,
                          title: "dub",
                          more: true,
                        ),
                        AnimeScrollView(
                            myId: widget.myId,
                            size: widget.size,
                            url:
                                'https://animetitans.com/anime/?type=&sub=dub'),
                        Titel(
                          function: () {
                            _interstitialAd?.show();
                            UserModel.goTo(
                                "special",
                                '?status=&type=special&order=',
                                widget.myId,
                                context);
                          },
                          size: widget.size,
                          title: "special",
                          more: true,
                        ),
                        AnimeScrollView(
                            myId: widget.myId,
                            size: widget.size,
                            url:
                                'https://animetitans.com/anime/?status=&type=special&order='),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    )
                    // : SizedBox()
                    /*  : isReady = false
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Center(
                                        child: LocaleText(
                                      'no',
                                    )),
                                    GestureDetector(
                                      onTap: () => getRequest(),
                                      child: Text('reconnect'),
                                    )
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: MediaQuery.of(context).size.height - 220,
                                child: Center(
                                    child: LocaleText(
                                  'erorr',
                                )))
                                */
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    required this.iconTheme,
    required this.primaryColor,
  }) : super(key: key);

  final Color iconTheme;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          color: iconTheme,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              SizedBox(
                  child: SvgPicture.string(
                '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Light-Outline/Search</title>
    <g id="Iconly/Light-Outline/Search" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
        <g id="Search" transform="translate(2.000000, 2.000000)" fill="#000000">
            <path d="M9.7388,8.8817842e-14 C15.1088,8.8817842e-14 19.4768,4.368 19.4768,9.738 C19.4768,12.2715459 18.5045194,14.5822774 16.9134487,16.3164943 L20.0442,19.4407 C20.3372,19.7337 20.3382,20.2077 20.0452,20.5007 C19.8992,20.6487 19.7062,20.7217 19.5142,20.7217 C19.3232,20.7217 19.1312,20.6487 18.9842,20.5027 L15.8156604,17.3430042 C14.1488713,18.6778412 12.0354764,19.477 9.7388,19.477 C4.3688,19.477 -0.0002,15.108 -0.0002,9.738 C-0.0002,4.368 4.3688,8.8817842e-14 9.7388,8.8817842e-14 Z M9.7388,1.5 C5.1958,1.5 1.4998,5.195 1.4998,9.738 C1.4998,14.281 5.1958,17.977 9.7388,17.977 C14.2808,17.977 17.9768,14.281 17.9768,9.738 C17.9768,5.195 14.2808,1.5 9.7388,1.5 Z" id="Combined-Shape"></path>
        </g>
    </g>
</svg>''',
                height: 30,
                color: primaryColor,
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: LocaleText(
                  'search',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 13,
                    fontFamily: context.currentLocale.toString() == 'ar'
                        ? 'SFPro'
                        : 'SFPro',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Titel extends StatelessWidget {
  const Titel({
    Key? key,
    required this.size,
    required this.title,
    required this.more,
    required this.function,
  }) : super(key: key);

  final Size size;
  final bool more;
  final GestureTapCallback function;
  final String title;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LocaleText(
              title,
              style: TextStyle(
                  fontSize: 22,
                  fontFamily: context.currentLocale.toString() == 'ar'
                      ? 'SFPro'
                      : 'Angie',
                  fontWeight: FontWeight.w500,
                  color: primaryColor),
            ),
            more
                ? SizedBox(
                    child: GestureDetector(
                      onTap: function,
                      child: LocaleText(
                        "more",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: context.currentLocale.toString() == 'ar'
                                ? 'SFPro'
                                : 'Angie',
                            fontWeight: FontWeight.w300,
                            color: primaryColor),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class NotifiCounter extends StatefulWidget {
  const NotifiCounter({super.key});

  @override
  State<NotifiCounter> createState() => _NotifiCounterState();
}

class _NotifiCounterState extends State<NotifiCounter> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
