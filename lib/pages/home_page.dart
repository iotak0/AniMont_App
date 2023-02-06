import 'dart:convert';

import 'package:anime_mont_test/pages/all_genres.dart';
import 'package:anime_mont_test/pages/my_profail.dart';
import 'package:anime_mont_test/pages/profial_screen.dart';
import 'package:anime_mont_test/pages/search_page.dart';
import 'package:anime_mont_test/pages/search_users.dart';
import 'package:anime_mont_test/pages/signup&login/lognin.dart';
import 'package:anime_mont_test/provider/nav_bar.dart';
import 'package:anime_mont_test/provider/user_model.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:anime_mont_test/utils/anime_scrollview.dart';
import 'package:anime_mont_test/utils/navbar.dart';
import 'package:anime_mont_test/server/server_php.dart';
import 'package:anime_mont_test/utils/slider_bar.dart';
import 'package:anime_mont_test/utils/textField.dart';
import 'package:anime_mont_test/widget/keep_page.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import '../provider/theme_provider.dart';
import '../widget/change_theme.dart';
import 'all_anime.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //List images = ['images/avatar.jpg', 'images/cover 2.png'];
  //final TextEditingController _myController = TextEditingController();
  static int index = 0;

  TextEditingController _controller = TextEditingController();
  late PageController pageController;

  Future getIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    index = prefs.getInt('index')!;
    print(prefs.getInt('index').toString());

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getIndex().then((value) {
      setState(() {
        pageController = PageController(keepPage: true, initialPage: index);
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
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
      'خارق للطبيعة',
      'خيال',
      'خيال علمي',
      'دراما',
      'رعب',
      'رومانسي',
      'رياضي',
      'ساخر',
      'ساموراي',
      'سحر',
      'سينين',
      'شريحة من الحياة',
      'شوجو',
      'شونين',
      'شونين اي',
      'شياطين',
      'عسكري',
      'غموض',
      'فضاء',
      'فلسفي',
      'فنون قتال',
      'قوة خارقة',
      'كوميدي',
      'لعبة',
      'مدرسي',
      'مصاصي دماء',
      'مغامرة',
      'موسيقي',
      'ميكا',
      'نفسي',
    ];
    int? myId;
    return Scaffold(
        //backgroundColor: Colors.black, // Color( colorsf rgba(18 26 28)),
        body:
            //    SingleChildScrollView(
            // child:
            // Column(
            //   children: [
            //     Container(
            //       padding: EdgeInsets.only(top: size.height / 25),
            //       alignment: Alignment.topRight,
            //       height: size.height / 2,
            //       // decoration: BoxDecoration(
            //       //     gradient: LinearGradient(
            //       //         begin: Alignment.topCenter,
            //       //         end: Alignment.bottomCenter,
            //       //         colors: [Colors.grey.shade600, Colors.black])),
            //       child: Column(
            //         children: [

            //             //child: Container(
            //               //height: size.height / 2.7,
            //               // child: Swiper(
            //               //   autoplay: true,
            //               //   itemBuilder: (BuildContext context, int index) {
            //               //     return Container(
            //               //       height: size.height / 2.7,
            //               //       decoration: BoxDecoration(
            //               //           image: DecorationImage(
            //               //               image: AssetImage(images[index]),
            //               //               fit: BoxFit.cover)),
            //               //     );
            //               //   },
            //               //   itemCount: images.length,
            //               //   scrollDirection: Axis.horizontal,
            //               // ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            SizedBox(
      height: size.height,
      child: ListView(
        children: [
          Container(
            height: size.height - 80.5,
            child: PageView(
              onPageChanged: (value) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? userPref = prefs.getString('userData');
                final user = json.decode(userPref!);
                try {
                  myId = int.parse(user['id']);
                  prefs.setInt('index', value);
                  index = prefs.getInt('index')!;
                  print(prefs.getInt('index').toString());
                } catch (e) {}
                setState(() {});
              },
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                KeepPage(
                  child: Home(
                      pageController: pageController,
                      iconTheme: iconTheme,
                      primaryColor: primaryColor,
                      size: size),
                ),
                KeepPage(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: SingleChildScrollView(
                      child: Container(
                        //height: size.height - 50,
                        width: double.infinity,
                        child: Wrap(
                          children: List.generate(
                              genralList.length,
                              (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AllGenres(
                                                      genre: genralList[index],
                                                    )));
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: iconTheme,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Text(
                                            genralList[index],
                                            style: TextStyle(
                                                fontFamily: 'SFPro',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                        ),
                      ),
                    ),
                  ),
                ),
                KeepPage(child: SearchPage()),
                KeepPage(
                  child: Home(
                      pageController: pageController,
                      iconTheme: iconTheme,
                      primaryColor: primaryColor,
                      size: size),
                ),
                KeepPage(child: MyProfile())
              ],
            ),
          ),
          NavBar(pageController: pageController),
        ],
      ),
    ));
  }
}

class Home extends StatefulWidget {
  const Home({
    Key? key,
    required this.iconTheme,
    required this.primaryColor,
    required this.pageController,
    required this.size,
  }) : super(key: key);
  final PageController pageController;
  final Color iconTheme;

  final Color primaryColor;
  final Size size;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var isReady;

  Future getRequest() async {
    var response = await http.get(Uri.parse('https://www.google.com'));
    if (response.statusCode == 200) {
      isReady = true;
      setState(() {});
    } else {
      print("Connecation Error ${response.statusCode}");
      isReady = false;
      setState(() {});
    }
  }

  Future refresh() async {
    Navigator.restorablePushReplacementNamed(context, '/Home');
    ;
  }

  late Server server;
  @override
  void initState() {
    server = Server();
    getRequest();

    print('object');
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return RefreshIndicator(
      onRefresh: refresh,
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          child: LocaleText(
                        "logo",
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: context.currentLocale.toString() == 'ar'
                                ? 'SFPro'
                                : 'Angie',
                            fontWeight: FontWeight.w900),
                      )),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              if (prefs.getString('lange') == 'ar') {
                                LocaleNotifier.of(context)!.change('en');
                                prefs.setString('lange', 'en');
                                setState(() {});
                              } else {
                                LocaleNotifier.of(context)!.change('ar');
                                prefs.setString('lange', 'ar');
                                setState(() {});
                              }
                            },
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: widget.iconTheme,
                              child: Image.asset(
                                'images/Light/Swap.png',
                                color: widget.primaryColor,
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
                              UserModel.logOut(context);
                            },
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: widget.iconTheme,
                              child: Image.asset(
                                'images/Light/Logout.png',
                                color: widget.primaryColor,
                                height: 35,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          ChangeThime(),
                          SizedBox(
                            width: 8,
                          ),
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: widget.iconTheme,
                            child: Image.asset(
                              'images/Light/Notification.png',
                              color: widget.primaryColor,
                              height: 35,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
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
                    iconTheme: widget.iconTheme,
                    primaryColor: widget.primaryColor),
              ),
              //('isReady == true || isReady == null')
              isReady == true
                  ? Column(
                      children: [
                        Titel(size: widget.size, title: "new"),
                        SliderBar(
                          size: widget.size,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllAnime(
                                            headLine: "Movies",
                                            genre: '',
                                          )));
                            },
                            child: Titel(size: widget.size, title: "top")),
                        AnimeScrollView(
                            size: widget.size,
                            url:
                                'https://animetitans.com/anime/?status=&type=&order=update'),
                        Titel(size: widget.size, title: "movies"),
                        AnimeScrollView(
                            size: widget.size,
                            url:
                                'https://animetitans.com/anime/?status=&type=movie&order='),
                        Titel(size: widget.size, title: "dubla"),
                        AnimeScrollView(
                            size: widget.size,
                            url:
                                'https://animetitans.com/anime/?type=&sub=dub'),
                        Titel(size: widget.size, title: "special"),
                        AnimeScrollView(
                            size: widget.size,
                            url:
                                'https://animetitans.com/anime/?status=&type=special&order='),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    )
                  : isReady == false
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
                          ))),
            ]),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
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
                  child: Image.asset(
                'images/Light/Search.png',
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
  }) : super(key: key);

  final Size size;
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
            SizedBox(
              child: Text(" "),
            ),
          ],
        ),
      ),
    );
  }
}
