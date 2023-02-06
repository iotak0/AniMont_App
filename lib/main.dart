import 'package:anime_mont_test/pages/anime_details_screen.dart';
import 'package:anime_mont_test/pages/chat.dart';
import 'package:anime_mont_test/pages/home_page.dart';
import 'package:anime_mont_test/pages/post_comments.dart';
import 'package:anime_mont_test/pages/posts.dart';
import 'package:anime_mont_test/pages/search_users.dart';
import 'package:anime_mont_test/pages/signup&login/check_email.dart';
import 'package:anime_mont_test/pages/signup&login/google.dart';
import 'package:anime_mont_test/pages/signup&login/lognin.dart';
import 'package:anime_mont_test/pages/signup&login/signup.dart';
import 'package:anime_mont_test/pages/testComment.dart';
import 'package:anime_mont_test/player.dart';
import 'package:anime_mont_test/provider/theme_provider.dart';
import 'package:anime_mont_test/provider/user_model.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/anime_player.dart';
import 'server/download.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.getToken().then((value) => print(value));
  WidgetsFlutterBinding.ensureInitialized();
  await Locales.init(['en', 'ar']);
  final SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('lange', 'en');
  final val = pref.getInt('index');
  if (val == null) {
    pref.setInt('index', 0);
  }
  final isLogin = pref.getBool('logIn') ?? false;
  print("Is LognIn $isLogin");
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  runApp(MyApp(isLogin: isLogin));
}

class MyApp extends StatefulWidget {
  final bool isLogin;

  const MyApp({super.key, required this.isLogin});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.getToken().then((value) => print(value));
    return LocaleBuilder(
        builder: (Locale) => ChangeNotifierProvider(
            create: (context) => ThemeProvider(),
            builder: (context, _) {
              final themeProvider =
                  Provider.of<ThemeProvider>(context, listen: true);
              return MaterialApp(
                  locale: Locale,
                  localizationsDelegates: Locales.delegates,
                  supportedLocales: Locales.supportedLocales,
                  debugShowCheckedModeBanner: false,
                  routes: {
                    '/Home': (context) => HomePage(),
                    '/LogIn': (context) => Login(),
                    '/SignUp': (context) => SignUp(),
                  },
                  themeMode: themeProvider.themeMode,
                  darkTheme: MyThemes.darkTheme,
                  theme: MyThemes.lightTheme,
                  home: widget.isLogin == true ? HomePage() : Login());
            }));
  }
}
             