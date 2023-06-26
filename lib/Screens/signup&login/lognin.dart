import 'dart:convert';
import 'package:anime_mont_test/Screens/Profile/pass_text_field.dart';
import 'package:anime_mont_test/Screens/signup&login/GetHelp/access_ur_account.dart';
import 'package:anime_mont_test/Screens/signup&login/GetHelp/login_help.dart';
import 'package:anime_mont_test/helper/constans.dart';
import 'package:anime_mont_test/provider/user_model.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:anime_mont_test/widgets/cust_snak_bar.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:anime_mont_test/widgets/textField.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool hidePssword = true;

  static bool loading = false;
  bool loading2 = false;
  GlobalKey<FormState> fromstate0 = GlobalKey();

  checkControllers() {
    if (passwordController.text.isNotEmpty &&
        userController.text.isNotEmpty &&
        fromstate0.currentState!.validate()) {
      setState(() {});
      return true;
    } else {
      setState(() {});
      return false;
    }
  }

  // check() {
  //   if (passwordController.text.length > 7 && userController.text.isNotEmpty) {
  //     setState(() {});
  //     return true;
  //   } else {
  //     setState(() {});
  //     return false;
  //   }
  // }

  // validInput(String text, String type, int min, int max) {
  //   if (text.isEmpty || text.length < min) {
  //     return "$type ${context.localeString('minlength')}$min ${context.localeString('characters')}";
  //     //"Please enter a valid $type";
  //     //'ادخل كلمة مرور لا تقل عن  4 حروف '
  //   } else if (text.length > max) {
  //     "$type ${context.localeString('maxlength')}$max ${context.localeString('characters')}";
  //   }
  //   // if (text.length < min) {
  //   //   ;
  //   // }
  //   // else {
  //   //   return "Please enter a valid $type";
  //   // }
  // }

  Login(bool google, BuildContext context) async {
    if (google) {
      loading2 = true;
      final response = await http.post(Uri.parse(signup_google), body: {
        "email": account.email.toString(),
        "name": account.displayName.toString(),
        "avatar": account.photoUrl.toString()
      });
      final body = json.decode(response.body);
      print('body   $body');
      if (body[0]['status'] == 'true') {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        loading2 = false;
        setState(() {});

        prefs.setBool('logIn', true);
        FirebaseMessaging.instance.subscribeToTopic('All');
        FirebaseMessaging.instance
            .subscribeToTopic('${body[0]['account']["id"]}');
        UserModel.setAcount(body[0]['account']);
        Navigator.restorablePushReplacementNamed(context, '/MyApp');
        // Navigator.pushReplacement(
        //   (context),
        //   MaterialPageRoute(
        //       builder: (context) => MyApp()),
        // );
      } else {
        loading2 = false;
        setState(() {});
        print('error');
      }
      loading2 = false;
    } else {
      getAccount(context);
    }
  }

  LoginWithGoogle(BuildContext context) async {
    loading2 = true;
    setState(() {});
    //account = (await google.signIn())!;
    account = (await google.signIn().onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustSnackBar(
            color: Color(0xFFC72C41),
            image: danger,
            headLine: context.localeString('erorr'),
            erorr: context.localeString("try_again")),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
      loading2 = false;
      setState(() {});
      return null;
    }))!;
    if (account.displayName!.isNotEmpty) {
      print(account);
      await Login(true, context);
      loading2 = false;
      setState(() {});
    } else {
      loading2 = false;
      setState(() {});
    }
    // loading2 = true;
    // final response = await http.post(Uri.parse(signin_google), body: {
    //   "email": account.email.toString(),
    //   "name": account.displayName.toString(),
    //   "avatar": account.photoUrl.toString()
    // });
    // final body = json.decode(response.body);
    // print('body   $body');
    // if (body['status'] == 'true') {
    //   loading2 = false;
    //   setState(() {});
    //   try {
    //     UserModel.setAcount(body['account']);
    //     final SharedPreferences prefs = await SharedPreferences.getInstance();
    //     prefs.setBool('logIn', true);
    //   } catch (e) {}

    //   Navigator.restorablePushReplacementNamed(context, '/Home');
    // } else {
    //   loading2 = false;
    //   setState(() {});

    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content:
    //         CustSnackBar(headLine: 'Connection', erorr: "Connection Erorr"),
    //     behavior: SnackBarBehavior.floating,
    //     backgroundColor: Colors.transparent,
    //     elevation: 0,
    //   ));
    // }
    // loading2 = false;
  }

  //late Account account;
  getAccount(BuildContext context) async {
    setState(() {
      loading = true;
    });
    var response;
    try {
      response = await http.post(Uri.parse(log_in),
          body: {"user": userController.text, 'pass': passwordController.text});
    } catch (e) {
      loading = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustSnackBar(
            color: Color(0xFFC72C41),
            image: danger,
            headLine: context.localeString('no_internet'),
            erorr: context.localeString("try_again")),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    }
    final body = json.decode(response.body);
    print("body :" + body.toString());
    if (body['OK'] == 'OK') {
      setState(() {
        loading = false;
      });
      print(body);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      UserModel.setAcount(body['user']);
      FirebaseMessaging.instance.subscribeToTopic('All');
      FirebaseMessaging.instance.subscribeToTopic('${body['user']["id"]}');
      UserModel.setAcount(body['user']);
      //Navigator.restorablePushReplacementNamed(context, '/Home');

      prefs.setBool('logIn', true);

      Navigator.restorablePushReplacementNamed(context, '/MyApp');
      //Restart.restartApp();

      // print('logIn ${prefs.getBool('logIn').toString()}');
      //  print('User Acocunt ${UserModel.getAcount().toString()}');
      setState(() {});
      // return true;
    } else if (body['OK'] == 'Account') {
      loading = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustSnackBar(
            color: Color(0xFFC72C41),
            image: danger,
            headLine: context.localeString("invalidusername") +
                " / " +
                context.localeString("email").toLowerCase(),
            erorr: context.localeString("re_enter_it_correctly")),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
      return null;
    } else if (body['OK'] == 'Password') {
      loading = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustSnackBar(
            color: Color(0xFFC72C41),
            image: danger,
            headLine: context.localeString('invalidpass'),
            erorr: context.localeString("re_enter_it_correctly")),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));

      //     return false;
    } else {
      loading = false;
      setState(() {});
      //    return null;
    }

    setState(() {
      loading = false;
    });
  }

  //  static Future<Account> getAccount(String email, String pass) async {
  //   final response = await http
  //       .post(Uri.parse(linkLogin), body: {"user": '$email', 'pass': pass});
  //   final body = json.decode(response.body);
  //   print('Acooooont  ${body.toString()}    ////');
  //   print('Acooooont /// ${body.Account.fromJson()}');
  //   return body.Account.fromJson();
  // }
  late GoogleSignIn google;
  late GoogleSignInAccount account;
  delete() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.setBool('logIn', false);
  }

  @override
  void initState() {
    super.initState();
    //delete();

    google = GoogleSignIn();
    userController.addListener(() {
      checkControllers();
    });
    passwordController.addListener(() {
      if (passwordController.text.isNotEmpty) {
        checkControllers();
      }
    });
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
    return Scaffold(
      body: Form(
        //autovalidateMode: AutovalidateMode.onUserInteraction,
        key: fromstate0,
        child: ListView(
          children: [
            Container(
              height: size.height - 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 110,
                          ),
                          Container(
                              child: LocaleText(
                            "welcome",
                            style: TextStyle(
                                fontSize: 25,
                                fontFamily:
                                    context.currentLocale.toString() == 'ar'
                                        ? 'SFPro'
                                        : 'Angie',
                                fontWeight: FontWeight.w500),
                          )),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              child: LocaleText(
                            "welcome2",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily:
                                    context.currentLocale.toString() == 'ar'
                                        ? 'SFPro'
                                        : 'Angie',
                                fontWeight: FontWeight.w200),
                          )),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      CustTextField(
                          maxLines: 1,
                          LengthLimiting: 50,
                          ar: false,
                          valid: (value) {
                            if (!GetUtils.hasMatch(value!, r'[a-zA-Z0-9_.]')) {
                              return context.localeString("invalidusername") +
                                  " / " +
                                  context.localeString("email").toLowerCase();
                            }
                            if (GetUtils.isLengthLessThan(value, 3)) {
                              return context.localeString("minlength") +
                                  " 3 " +
                                  context.localeString("characters");
                            }
                            if (GetUtils.isLengthGreaterThan(value, 50)) {
                              return context.localeString("maxlength") +
                                  " 50 " +
                                  context.localeString("characters");
                            }
                            return null;
                          },
                          withValid: true,
                          controller: userController,
                          text: context.localeString('useremail')),
                      PassTextFeild(
                          valid: (value) {
                            if (!GetUtils.hasMatch(
                                value!, r'[a-zA-Z0-9!$%*@_?&+-]')) {
                              return context.localeString("invalidpass");
                            }
                            if (GetUtils.isLengthLessThan(value, 8)) {
                              return context.localeString("minlength") +
                                  " 8 " +
                                  context.localeString("characters");
                            }
                            if (GetUtils.isLengthGreaterThan(value, 30)) {
                              return context.localeString("maxlength") +
                                  " 30 " +
                                  context.localeString("characters");
                            }
                            return null;
                          },
                          passwordController: passwordController,
                          password: context.localeString('password')),
                      GestureDetector(
                        onTap: (() async {
                          FocusScope.of(context).unfocus();
                          if (fromstate0.currentState!.validate()) {
                            Login(false, context);
                          } else {
                            return;
                          }
                          // if (fromstate.currentState!.validate()) {
                          //   var get =
                          //       await (loading == false && check() == true)
                          //           ? await getAccount(userController.text,
                          //               passwordController.text, context)
                          //           : '';
                          //   if (get == true) {
                          //     print("True");

                          //     Navigator.pushNamedAndRemoveUntil(
                          //         context, '/Home', (route) => false);
                          //   } else {
                          //     print("no");
                          //   }
                          // } else {}
                        }),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            child: Container(
                              height: 48,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: !checkControllers()
                                      ? Colors.transparent
                                      : bottomDown,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                child: !loading
                                    ? LocaleText(
                                        "logIn",
                                        style: TextStyle(
                                            color: (!checkControllers())
                                                ? primaryColor
                                                : Colors.white,
                                            fontSize: 18,
                                            fontFamily: 'SFPro',
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Container(
                                        height: 35,
                                        child: LoadingGif(
                                          logo: false,
                                        )),
                              ),
                            )),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginHelp(
                                    text: userController.text,
                                  )),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          child: Wrap(children: [
                            LocaleText(
                              "forgot_your_login_details",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 10,
                                  fontFamily: 'SFPro',
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            LocaleText(
                              "get_help_logging_in",
                              style: TextStyle(
                                  color: bottomUp.withAlpha(150),
                                  fontSize: 12,
                                  fontFamily: 'SFPro',
                                  fontWeight: FontWeight.bold),
                            )
                          ]),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 2,
                          color: iconTheme,
                        ),
                        Container(
                            width: 50,
                            color: backgroundColor,
                            child: Center(
                                child: LocaleText('or',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'SFPro',
                                        color: primaryColor,
                                        fontWeight: FontWeight.w400))))
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            LoginWithGoogle(context);
                          },
                          child: Container(
                            child: loading2
                                ? SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: LoadingGif(
                                      logo: true,
                                    ),
                                  )
                                : LocaleText("logingoogle",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'SFPro',
                                        color: primaryColor,
                                        fontWeight: FontWeight.w400)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Container(
                        child: GestureDetector(
                      // onTap: () => Navigator.pushReplacementNamed(
                      //     context, 'SignUp'),

                      onTap: () => Navigator.restorablePushReplacementNamed(
                          context, '/SignUp'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LocaleText("havenot",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'SFPro',
                                  color: primaryColor,
                                  fontWeight: FontWeight.w400)),
                          LocaleText(
                            "signup",
                            style: TextStyle(
                                fontSize: 15,
                                color: bottomDown,
                                fontFamily:
                                    context.currentLocale.toString() == 'ar'
                                        ? 'SFPro'
                                        : 'Angie',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// class Account {
//   final String username;
//   final String email;
//   final String password;
//   Account(
//     this.username,
//     this.email,
//     this.password,
//     //upload/image.png
//   );
//   static Account fromJson(json) => Account(
//         json['username'],
//         json['email'],
//         json['password'],
//       );
// }
