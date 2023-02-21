import 'dart:convert';
import 'package:anime_mont_test/pages/chat.dart';
import 'package:anime_mont_test/pages/home_page.dart';
import 'package:anime_mont_test/pages/profial_screen.dart';
import 'package:anime_mont_test/pages/signup&login/lognin.dart';
import 'package:anime_mont_test/pages/signup&login/signup.dart';
import 'package:anime_mont_test/provider/user_model.dart';
import 'package:anime_mont_test/utils/loading.dart';
import 'package:anime_mont_test/utils/pass_text_field.dart';
import 'package:anime_mont_test/utils/textField.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../server/urls_php.dart';
import '../../widget/cust_snak_bar.dart';
import '../../widget/cust_textfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String ar = "عربي";
  String en = "English ";
  bool isEn = true;
  bool hidePssword = true;
  List images = ['images/avatar.jpg', 'images/cover 2.png'];
  bool loading = false;
  bool loading2 = false;

  static GlobalKey<FormState> fromstate = GlobalKey();

  check() {
    if (passwordController.text.length > 7 && userController.text.isNotEmpty) {
      setState(() {});
      return true;
    } else {
      setState(() {});
      return false;
    }
  }

  validInput(String text, String type, int min, int max) {
    if (text.isEmpty || text.length < min) {
      return "$type ${context.localeString('minlength')}$min ${context.localeString('characters')}";
      //"Please enter a valid $type";
      //'ادخل كلمة مرور لا تقل عن  4 حروف '
    } else if (text.length > max) {
      "$type ${context.localeString('maxlength')}$max ${context.localeString('characters')}";
    }
    // if (text.length < min) {
    //   ;
    // }
    // else {
    //   return "Please enter a valid $type";
    // }
  }

  Login(bool google) async {
    if (google) {
      loading2 = true;
      final response = await http.post(Uri.parse(signin_google), body: {
        "email": account.email.toString(),
        "name": account.displayName.toString(),
        "avatar": account.photoUrl.toString()
      });
      final body = json.decode(response.body);
      print('body   $body');
      if (body['status'] == 'true') {
        loading2 = false;
        setState(() {});
        UserModel.setAcount(body['account']);
        Navigator.restorablePushReplacementNamed(context, '/Home');
      } else {
        loading2 = false;
        setState(() {});
        print('error');
      }
      loading2 = false;
    } else {
      if (fromstate.currentState!.validate()) {
        loading2 = true;
        final response = await http.post(Uri.parse(signin_google), body: {
          "email": account.email.toString(),
          "name": account.displayName.toString(),
          "avatar": account.photoUrl.toString()
        });
        final body = json.decode(response.body);
        print('body   $body');
        if (body['status'] == 'true') {
          loading2 = false;
          setState(() {});
          UserModel.setAcount(body['account']);
          Navigator.restorablePushReplacementNamed(context, '/Home');
        } else {
          loading2 = false;
          setState(() {});
          print('error');
        }
        loading2 = false;
      }
    }
  }

  late GoogleSignInAccount account;
  LoginWithGoogle() async {
    loading2 = true;
    setState(() {});
    account = (await google.signIn())!;

    if (account.displayName!.isNotEmpty) {
      print(account);
      loading2 = false;
      setState(() {});
      Login(true);
    } else {
      loading2 = false;
      setState(() {});
      AlertDialog(
        actions: [Text("Google Error")],
      );
    }
    loading2 = true;
    final response = await http.post(Uri.parse(signin_google), body: {
      "email": account.email.toString(),
      "name": account.displayName.toString(),
      "avatar": account.photoUrl.toString()
    });
    final body = json.decode(response.body);
    print('body   $body');
    if (body['status'] == 'true') {
      loading2 = false;
      setState(() {});
      try {
        UserModel.setAcount(body['account']);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('logIn', true);
      } catch (e) {}
      Navigator.restorablePushReplacementNamed(context, '/Home');
    } else {
      loading2 = false;
      setState(() {});
      print('error');
    }
    loading2 = false;
  }

  //late Account account;
  getAccount(String email, String pass, BuildContext context) async {
    if (fromstate.currentState!.validate()) {
      loading = true;
      var response;
      setState(() {});

      try {
        response = await http
            .post(Uri.parse(linkLogin), body: {"user": email, 'pass': pass});
      } catch (e) {
        loading = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              CustSnackBar(headLine: 'Connection', erorr: "Connection Erorr"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ));
      }
      final body = json.decode(response.body);
      print("body :" + body.toString());
      if (body['OK'] == 'OK') {
        loading = false;
        print(body);
        UserModel.setAcount(body['user']);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('logIn', true);

        print('logIn ${prefs.getBool('logIn').toString()}');
        print('User Acocunt ${UserModel.getAcount().toString()}');
        setState(() {});
        return true;
      } else if (body['OK'] == 'Account') {
        loading = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: CustSnackBar(headLine: 'Account', erorr: "Account"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ));
        return null;
      } else if (body['OK'] == 'Password') {
        loading = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: CustSnackBar(headLine: 'Password', erorr: "Password"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ));

        return false;
      } else {
        loading = false;
        setState(() {});
        return null;
      }
    } else {
      print('erorr');
    }
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

  @override
  void initState() {
    super.initState();
    google = GoogleSignIn();
    userController.addListener(() {
      check();
    });
    passwordController.addListener(() {
      if (passwordController.text.isNotEmpty) {
        check();
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: fromstate,
        child: SingleChildScrollView(
          child: Container(
            child: Container(
              height: size.height,
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
                      CustTextField2(
                          controller: userController,
                          text: context.localeString('useremail')),
                      PassTextFeild(
                          valid: (val) {
                            return validInput(
                                val!, context.localeString('password'), 8, 20);
                          },
                          passwordController: passwordController,
                          password: context.localeString('password')),
                      GestureDetector(
                        onTap: (() async {
                          var get = await (loading == false && check() == true)
                              ? await getAccount(userController.text,
                                  passwordController.text, context)
                              : '';
                          if (get == true) {
                            print("True");

                            Navigator.pushNamedAndRemoveUntil(
                                context, '/Home', (route) => false);
                          } else {
                            print("no");
                          }
                        }),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            child: Container(
                              height: 48,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color:
                                      check() != true ? bottomUp : bottomDown,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                child: loading == false
                                    ? LocaleText(
                                        "logIn",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontFamily: context.currentLocale
                                                        .toString() ==
                                                    'ar'
                                                ? 'SFPro'
                                                : 'Angie',
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Container(
                                        height: 35,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                              ),
                            )),
                      ),
                    ],
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            LoginWithGoogle();
                          },
                          child: Container(
                            child: loading2
                                ? SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircularProgressIndicator(),
                                  )
                                : LocaleText("logingoogle"),
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
                          LocaleText("havenot"),
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
          ),
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
