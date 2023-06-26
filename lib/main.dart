import 'dart:convert';
import 'package:anime_mont_test/Screens/Home/home_page.dart';
import 'package:anime_mont_test/Screens/settings/settings.dart';
import 'package:anime_mont_test/Screens/signup&login/onboarding_page.dart';
import 'package:anime_mont_test/Screens/signup&login/lognin.dart';
import 'package:anime_mont_test/Screens/signup&login/signup.dart';
import 'package:anime_mont_test/models/get_x_controller.dart';
import 'package:anime_mont_test/provider/theme_provider.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:anime_mont_test/widgets/alart_internet.dart';
import 'package:anime_mont_test/widgets/alart_update.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:timer_count_down/timer_controller.dart';
import 'Screens/signup&login/welcome.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("${message.data}");
  ChatGetX.noitificationCount.value++;
}

Future initialization() async {
  await Future.delayed(Duration(seconds: 3));
  FlutterNativeSplash.remove();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'pushnotificationl',
//   'pushnotificationchannel',
//   importance: Importance.max,
//   playSound: true,
// );
//int? myId;
String? lang;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();

  final SharedPreferences pref = await SharedPreferences.getInstance();
  // pref.clear();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  await Firebase.initializeApp();
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print(message.notification!.body);
  });
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    ChatGetX.noitificationCount.value++;
    bool? post;
    post = message.data["post"] == "true" ? true : false;
    final avatar = message.data["avatar"];
    final postImage = message.data["image"];
    final responseAvatar = await http.get(Uri.parse(avatar));
    final responsePost = await http.get(Uri.parse(postImage));
    BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
            ByteArrayAndroidBitmap.fromBase64String(
                base64Encode(responsePost.bodyBytes)),
            hideExpandedLargeIcon: !post,
            largeIcon: ByteArrayAndroidBitmap.fromBase64String(
                base64Encode(responseAvatar.bodyBytes)));
    RemoteNotification notification = message.notification!;
    AndroidNotification android = message.notification!.android!;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          "Animont-انيمونت",
          message.notification!.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  'FCMNnotification', 'pushnotificationchannel',
                  importance: Importance.max,
                  priority: Priority.max,
                  icon: '@drawable/ic_notification',
                  styleInformation: !post ? null : bigPictureStyleInformation,
                  sound: RawResourceAndroidNotificationSound(
                      'notification_sound'))));
    }
  });

  try {
    String? userPref = pref.getString('userData');

    final user = json.decode(userPref!);
    final myId = int.tryParse(user['id'].toString());
    //FirebaseMessaging.instance.unsubscribeFromTopic('All');
    FirebaseMessaging.instance.subscribeToTopic('All');

    FirebaseMessaging.instance.subscribeToTopic("$myId");
  } catch (e) {}

  await Locales.init(['ar', 'en']);
  //await (Jiffy.locale()).then((value) => null);

  // await FirebaseMessaging.instance
  //     .getToken()
  //     .then((v) => pref.setString('token', v!));

  try {
    lang = await pref.getString('lange');
  } catch (e) {
    pref.setString('lange', 'ar');
    lang = "ar";
  }
  // if (lang == "en") {
  //   await Jiffy.locale("en");
  // } else {
  //   await Jiffy.locale("ar");
  // }

  // print("Is LognIn $isLogin");
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  initialization();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int? myId;
  int? index;
  bool? isLogin = true;
  String? theme;
  bool isReady = false;
  bool? welcome;
  String? color;
  String? season;
  bool isLoading = false;
  bool error = false;
  late SharedPreferences pref;
  static int countdown = 60;
  getMyId() async {
    pref = await SharedPreferences.getInstance();
    //pref.clear();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    try {
      String? userPref = pref.getString('userData');
      final user = json.decode(userPref!);
      myId = int.parse(user['id'].toString());
    } catch (e) {}
    setState(() {
      index = pref.getInt('index') ?? 0;
      welcome = pref.getBool('welcome') ?? true;
      isLogin = pref.getBool('logIn') ?? false;
      color = pref.getString('color') ?? 'blue';
      theme = pref.getString('theme') ?? 'system';
    });
    await getVersion();
  }

  getVersion() async {
    isLoading = true;
    error = false;
    setState(() {});
    final response = await http.get(Uri.parse(version)).catchError((onError) {
      error = true;
      isLoading = false;
      setState(() {});
    });
    var body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      error = true;
      isLoading = false;
      setState(() {});
    }
    if (body['version'] == '1.0.3') {
      season = body['seasson'];
      isReady = true;
      isLoading = false;
      setState(() {});
    }
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    isLoading = true;
    setState(() {});
    getMyId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.getToken().then((value) => print(value));

    return theme == null
        ? LoadingGif(
            logo: true,
          )
        : LocaleBuilder(builder: (Locale) {
            return ChangeNotifierProvider(
                create: (context) => ThemeProvider(theme ?? 'system'),
                builder: (context, _) {
                  final provider =
                      Provider.of<ThemeProvider>(context, listen: true);

                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                    systemNavigationBarColor: Colors.transparent,
                    //  provider.isDarkMode
                    //     ? MyThemes.darkBlack
                    //     : MyThemes.lightWhite,
                    statusBarColor: Colors.transparent,
                    // provider.isDarkMode
                    //     ? MyThemes.darkBlack
                    //     : MyThemes.lightWhite
                  ));
                  return ChangeNotifierProvider(
                      create: (context) => ColorProvider(color ?? 'blue'),
                      builder: (context, _) {
                        // final colorProvider =
                        //     Provider.of<ColorProvider>(context, listen: true);
                        ColorProvider colorProvider = ColorProvider(color!);
                        return MaterialApp(
                            locale: Locale,
                            localizationsDelegates: Locales.delegates,
                            supportedLocales: Locales.supportedLocales,
                            debugShowCheckedModeBanner: false,
                            routes: {
                              '/Home': (context) => HomePage(
                                  index: index!, myId: myId!, season: season!),
                              '/MyApp': (context) => MyApp(),
                              '/LogIn': (context) => Login(),
                              '/SignUp': (context) => SignUp(),
                              '/Settings': (context) => SettingsPage(),
                              '/Onboarding': (context) => OnboardingPage()
                            },
                            themeMode: provider.themeMode,
                            darkTheme: colorProvider.darkTheme,
                            theme: colorProvider.lightTheme,
                            home: Scaffold(
                                body: isLoading
                                    ? LoadingGif(
                                        logo: true,
                                      )
                                    : error
                                        ? HomeInternetError(
                                            onTap: () => getVersion(),
                                          )
                                        : !isReady
                                            ? AlartUpdate(onTap: () => null)
                                            : welcome ?? true
                                                ? WelcomePage()
                                                : isLogin!
                                                    ? (myId != null)
                                                        ? HomePage(
                                                            index: index!,
                                                            myId: myId!,
                                                            season: season!,
                                                          )
                                                        : LoadingGif(
                                                            logo: true,
                                                          )
                                                    : Login()));
                      });
                });
          });
  }
}

class HomeInternetError extends StatelessWidget {
  const HomeInternetError({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            AlartInternet(onTap: onTap),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child:
                          Image.asset('images/animont.png', fit: BoxFit.cover)),
                ),
                SizedBox(
                  width: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: LocaleText(
                    'logo',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SFPro',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
