import 'dart:convert';

import 'package:anime_mont_test/Screens/signup&login/GetHelp/access_ur_account.dart';
import 'package:anime_mont_test/helper/constans.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/provider/user_model.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:anime_mont_test/widgets/cust_snak_bar.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:anime_mont_test/widgets/textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginHelp extends StatefulWidget {
  const LoginHelp({super.key, required this.text});
  final String text;
  @override
  State<LoginHelp> createState() => _LoginHelpState();
}

class _LoginHelpState extends State<LoginHelp> {
  late TextEditingController controller;
  bool loading = false;
  getAccount(BuildContext context) async {
    setState(() {
      loading = true;
    });
    var response;

    response = await http.post(Uri.parse(check_account), body: {
      "user": controller.text,
    }).catchError((e) {
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
    });
    final body = json.decode(response.body);
    if (body['status'] == 'success') {
      final account = await UserModel.fromJson(body['user']);
      setState(() {
        loading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AccessYourAccount(account: account,data: body['user'],)),
      );
    } else if (body['status'] == 'Account') {
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
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    controller = TextEditingController();
    controller.text = widget.text;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);

    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: customColors.primaryColor,
            ),
          ),
          backgroundColor: customColors.backgroundColor,
          elevation: 1,
          title: LocaleText(
            'login_help',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontFamily: 'SFPro',
                fontWeight: FontWeight.bold,
                color: customColors.primaryColor),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LocaleText(
                        'find_your_account',
                        style: TextStyle(
                            color: customColors.primaryColor,
                            fontSize: 18,
                            fontFamily: 'SFPro',
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      LocaleText(
                        'enter_email_or_pass',
                        // localize: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            textBaseline: TextBaseline.alphabetic,
                            color: customColors.primaryColor.withOpacity(.5),
                            fontSize: 15,
                            fontFamily: 'SFPro',
                            fontWeight: FontWeight.bold),
                      ),
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
                          controller: controller,
                          text: context.localeString('useremail')),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: loading
                            ? SizedBox(
                                height: 50,
                                width: 50,
                                child: LoadingGif(logo: true))
                            : ElevatedButton(
                                onPressed: () {
                                  loading ? null : getAccount(context);
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
                                      'next',
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
                    ]))));
  }
}

/* checkUsernume(String user) async {
    final response =
        await http.post(Uri.parse(check_username_email), body: {"user": user});
    final body = json.decode(response.body);
    print('body   $body');
    if (body['status'] == 'true') {
      username = true;
      setState(() {});
    } else {
      username = false;
      setState(() {});
    }
  } */


