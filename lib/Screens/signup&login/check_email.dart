import 'dart:convert';
import 'package:anime_mont_test/helper/constans.dart';
import 'package:anime_mont_test/main.dart';
import 'package:anime_mont_test/models/get_x_controller.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/provider/user_model.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:anime_mont_test/widgets/cust_snak_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class CheckEmail extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String birthday;
  final TextEditingController nameController;
  final TextEditingController otpController;
  const CheckEmail({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.birthday,
    required this.nameController,
    required this.otpController,
  });

  @override
  State<CheckEmail> createState() => _CheckEmailState();
}

class _CheckEmailState extends State<CheckEmail> {
  bool loadingSignUp = false;
  bool loadingCheck = false;
  bool loadingRe = false;
  bool resend = false;
  bool hasErorr = false;
  TextEditingController controller = TextEditingController();
  ChatGetX chatGetX = ChatGetX();
  finished() {
    setState(() {
      resend = true;
    });
  }

  reSendOTP(String email, String username) async {
    resend = false;
    loadingRe = true;
    setState(() {});
    final response = await http.post(Uri.parse(send_email), body: {
      "email": email,
      'username': username,
      "lang": context.currentLocale!.languageCode.toString()
    }).catchError((e) {
      loadingRe = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
      return false;
    });
    final body = await json.decode(response.body);
    print(body);
    if (body['status'] == 'true') {
      MyAppState.countdown = MyAppState.countdown + (60 * 2);
      chatGetX.controller.value.restart();
      loadingRe = false;
      setState(() {});
    } else {
      loadingRe = false;
      setState(() {});
    }
  }

  verifyOTP(String code, String username) async {
    loadingCheck = true;

    setState(() {});
    final response = await http.post(Uri.parse(activation_email),
        body: {"code": code, 'username': username}).catchError((error) {
      loadingCheck = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
      return false;
    });
    final body = await json.decode(response.body);

    print(body);

    if (body['status'] == 'true') {
      loadingCheck = false;
      setState(() {});
      //Navigator.pop(context);
      print('Done');
      //setState(() {});
      signUp();
    } else {
      // Navigator.pop(context);
      //setState(() {});
      loadingCheck = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
      print('Fail');
    }
    loadingCheck = false;
    setState(() {});
  }

  signUp() async {
    loadingSignUp = true;
    setState(() {});
    var response = await http.post(
      Uri.parse(signup),
      body: {
        "email": widget.emailController.text,
        "pass": widget.passwordController.text,
        "birthday": widget.birthday,
        "name": widget.nameController.text,
      },
    ).catchError((error) {
      loadingSignUp = false;
      hasErorr = true;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustSnackBar(
          color: Color(0xFFC72C41),
          image: danger,
          headLine: context.localeString('error'),
          erorr: context.localeString("try_again"),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
      return Response('error', 400);
    });
    print(response.toString());
    print('response     ${response.body.toString()}');
    if (response.statusCode == 200) {
      var data;
      try {
        data = jsonDecode(response.body);
      } catch (e) {
        loadingSignUp = false;
        hasErorr = true;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: CustSnackBar(
            color: Color(0xFFC72C41),
            image: danger,
            headLine: context.localeString('no_internet'),
            erorr: context.localeString("try_again"),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ));
        return;
      }

      if (data['status'] == "success") {
        loadingSignUp = false;
        setState(() {});
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        FirebaseMessaging.instance.subscribeToTopic('All');
        FirebaseMessaging.instance.subscribeToTopic('${data['account']["id"]}');
        UserModel.setAcount(data['account']);
        prefs.setBool('logIn', true);
        Navigator.pushReplacementNamed(context, '/MyApp');
        loadingSignUp = false;
        setState(() {});
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: CustSnackBar(
            color: Color(0xFFC72C41),
            image: danger,
            headLine: context.localeString('email'),
            erorr: context.localeString("email_is_already_used"),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ));
        loadingSignUp = false;
        setState(() {});
        return false;
      }
    }
  }

  checkControllers() {
    if (widget.emailController.text.isNotEmpty &&
        widget.passwordController.text.isNotEmpty &&
        widget.nameController.text.isNotEmpty &&
        widget.birthday.toString().isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    Size size = MediaQuery.of(context).size;
    var width = size.width / 7;
    return Scaffold(
      appBar: AppBar(
        // title: LocaleText(
        //   'followers',
        //   style: TextStyle(
        //       fontFamily: 'SFPro',
        //       fontWeight: FontWeight.bold,
        //       color: customColors.primaryColor),
        // ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: customColors.primaryColor,
          ),
        ),
        backgroundColor: customColors.backgroundColor,
        elevation: 1,
      ),
      body: Stack(
        children: [
          Center(
            child: SizedBox(
                width: size.width,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LocaleText(
                                'verification_code',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily:
                                        context.currentLocale.toString() == 'en'
                                            ? 'Angie'
                                            : 'SFPro',
                                    color: customColors.primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              LocaleText(
                                'we_have_send_the_code_to',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily:
                                        context.currentLocale.toString() == 'en'
                                            ? 'Angie'
                                            : 'SFPro',
                                    color: customColors.primaryColor
                                        .withOpacity(.8),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${widget.emailController.text}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: context.currentLocale
                                                      .toString() ==
                                                  'en'
                                              ? 'Angie'
                                              : 'SFPro',
                                          color: customColors.primaryColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Text(
                                        '${context.localeString('change_email')}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontFamily: context.currentLocale
                                                        .toString() ==
                                                    'en'
                                                ? 'Angie'
                                                : 'SFPro',
                                            color: customColors.bottomDown,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  ])
                            ]),
                      ),
                      Spacer(),
                      Form(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: customColors.iconTheme,
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  )),
                              height: width,
                              child: Center(
                                child: TextFormField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: context
                                          .localeString('verification_code'),
                                      hintStyle: TextStyle(
                                          fontSize: 20,
                                          color: customColors.primaryColor
                                              .withOpacity(.8),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'SFPro')),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: customColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SFPro'),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(6),
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                              )

                              // CustTextField(
                              //     valid: (val) {
                              //       return validInput(
                              //         widget.otpController.text,
                              //         context.localeString('OTP'),
                              //         5,
                              //         30,
                              //       );
                              //     },
                              //     controller: widget.otpController,
                              //     text: "Enter OTP Code"),
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${context.localeString('resend_code_after')}',
                              style: TextStyle(
                                  fontFamily:
                                      context.currentLocale.toString() == 'en'
                                          ? 'Angie'
                                          : 'SFPro',
                                  color:
                                      customColors.primaryColor.withOpacity(.8),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Countdown(
                              seconds: chatGetX.countdown.value,
                              build: (p0, p1) {
                                if (MyAppState.countdown > 0) {
                                  MyAppState.countdown--;
                                }
                                return Text(
                                  p1.toString(),
                                  style: TextStyle(
                                      fontFamily:
                                          context.currentLocale.toString() ==
                                                  'en'
                                              ? 'Angie'
                                              : 'SFPro',
                                      color: customColors.bottomUp,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                );
                              },
                              onFinished: () => finished(),
                              controller: chatGetX.controller.value,
                              interval: Duration(seconds: 1),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    (loadingSignUp == false &&
                                            loadingCheck == false &&
                                            loadingRe == false &&
                                            resend)
                                        ? await reSendOTP(
                                            widget.emailController.text,
                                            widget.nameController.text)
                                        : null;
                                    setState(() {});
                                  },
                                  child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: size.width / 2 - 25),
                                      height: 50,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: customColors.backgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              width: .2,
                                              color:
                                                  customColors.primaryColor)),
                                      child: Center(
                                          child: (loadingRe == false)
                                              ? LocaleText(
                                                  'resend',
                                                  style: TextStyle(
                                                      fontFamily: context
                                                                  .currentLocale
                                                                  .toString() ==
                                                              'en'
                                                          ? 'Angie'
                                                          : 'SFPro',
                                                      color: !resend
                                                          ? customColors
                                                              .primaryColor
                                                              .withOpacity(.3)
                                                          : customColors
                                                              .primaryColor,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              : Container(
                                                  height: 25,
                                                  width: 25,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                            color:
                                                                Colors.white),
                                                  ),
                                                ))),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        (loadingSignUp == false &&
                                                loadingCheck == false &&
                                                loadingRe == false &&
                                                controller.text.length > 5 &&
                                                controller.text.isNotEmpty)
                                            ? await verifyOTP(
                                                controller.text,
                                                widget.emailController.text,
                                              )
                                            : null;
                                        setState(() {});
                                      },
                                      child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: size.width / 2 - 25),
                                          height: 50,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: customColors.bottomUp,
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Center(
                                              child: (loadingCheck == false)
                                                  ? LocaleText(
                                                      'confront',
                                                      style: TextStyle(
                                                          fontFamily: context
                                                                      .currentLocale
                                                                      .toString() ==
                                                                  'en'
                                                              ? 'Angie'
                                                              : 'SFPro',
                                                          color: customColors
                                                              .primaryColor,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : Container(
                                                      height: 25,
                                                      width: 25,
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ))),
                                    ),
                                  ],
                                )
                              ])),
                      Spacer(),
                      Spacer(),
                    ])),
          ),
          loadingSignUp
              ? Container(
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height,
                  child: Center(child: CircularProgressIndicator()),
                )
              : Container()
        ],
      ),
    );
  }
}
