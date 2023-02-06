import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/user_model.dart';
import '../../server/server_php.dart';
import '../../server/urls_php.dart';

class CheckEmail extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController usernameController;
  final String birthday;
  final TextEditingController nameController;
  final TextEditingController otpController;
  final File? image;
  const CheckEmail(
      {super.key,
      required this.emailController,
      required this.passwordController,
      required this.usernameController,
      required this.birthday,
      required this.nameController,
      required this.otpController,
      required this.image});

  @override
  State<CheckEmail> createState() => _CheckEmailState();
}

class _CheckEmailState extends State<CheckEmail> {
  final Server _server = Server();
  bool loadingSignUp = false;
  bool loadingCheck = false;
  bool loadingRe = false;
  static validInput(String text, String type, int min, int max) {
    if (text.isNotEmpty) {
      return "Please enter a valid $type";
      //'ادخل كلمة مرور لا تقل عن  4 حروف '
    }
    if (text.length < min) {
      "$type must be at least 6 characters";
    }
    if (text.length > max) {
      "$type must be at last 20 characters";
    } else {
      return "Please enter a valid $type";
    }
  }

  reSendOTP(String email, String username) async {
    loadingRe = true;
    setState(() {});
    final response = await http.post(Uri.parse(checkEmail),
        body: {"email": email, 'username': username});
    final body = await json.decode(response.body);
    print(body);
    if (body['status'] == 'true') {
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
        body: {"code": code, 'username': username});
    final body = await json.decode(response.body);

    print(body);

    if (body['status'] == 'true') {
      loadingCheck = false;
      setState(() {});
      //Navigator.pop(context);
      print('Done');
      //setState(() {});
      signUp(
        widget.usernameController.text,
        widget.emailController.text,
        widget.passwordController.text,
        widget.birthday.toString(),
        widget.nameController.text,
        widget.image!,
      );
    } else {
      // Navigator.pop(context);
      //setState(() {});
      loadingCheck = false;
      setState(() {});
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: CustSnackBar()));
      print('Fail');
    }
    loadingCheck = false;
    setState(() {});
  }

  signUp(String username, String email, String pass, String birthday,
      String name, File image) async {
    loadingSignUp = true;
    setState(() {});
    var response = await _server.postRequestWithFiles(
        linkSignup,
        {
          "username": username,
          "email": email,
          "pass": pass,
          "birthday": birthday,
          "name": name,
        },
        image);

    print('response     ${response.toString()}');
    if (response['status'] == "success") {
      loadingSignUp = false;
      setState(() {});
      UserModel.setAcount(response['account']);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('logIn', true);
      Navigator.restorablePushReplacementNamed(context, '/Home');
      return true;
    } else {
      //Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: CustSnackBar()));
      loadingSignUp = false;
      setState(() {});
      return false;
    }
  }

  checkControllers() {
    if (widget.emailController.text.isNotEmpty &&
        widget.passwordController.text.isNotEmpty &&
        widget.usernameController.text.isNotEmpty &&
        widget.nameController.text.isNotEmpty &&
        widget.birthday.toString().isNotEmpty &&
        widget.image != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconTheme = Theme.of(context).iconTheme.color!;
    final Color textColor = Color.fromARGB(255, 160, 146, 167);
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color bottomUp = Theme.of(context).primaryColorDark;
    final Color bottomDown = Theme.of(context).primaryColorLight;
    Size size = MediaQuery.of(context).size;
    var width = size.width / 7;
    List<int> pinCode = [0, 0, 0, 0, 0, 0];
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
                width: size.width,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // get user input
                      Form(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              6,
                              (index) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: iconTheme,
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      )),
                                  height: width,
                                  width: width,
                                  child: Center(
                                    child: TextFormField(
                                      onChanged: (value) {
                                        print('$value');
                                        pinCode[index] = int.parse(value);
                                        print('${pinCode}');
                                        if (value.length == 1) {
                                          FocusScope.of(context).nextFocus();
                                        } else {
                                          FocusScope.of(context)
                                              .previousFocus();
                                        }
                                      },
                                      onSaved: (pin) {
                                        print('$pin');
                                        //pinCode = int.parse(pin!);
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: context.currentLocale
                                                      .toString() ==
                                                  'en'
                                              ? 'Angie'
                                              : 'SFPro'),
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
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
                      SizedBox(
                        height: 50,
                      ),
                      // buttons -> save + cancel

                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    (loadingSignUp == false &&
                                            loadingCheck == false &&
                                            loadingRe == false)
                                        ? await reSendOTP(
                                            widget.emailController.text,
                                            widget.usernameController.text)
                                        : null;
                                    setState(() {});
                                  },
                                  child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: size.width / 2 - 25),
                                      height: 50,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: backgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              width: .2, color: primaryColor)),
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
                                                      color: primaryColor,
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
                                        print("PinCode$pinCode");
                                        (loadingSignUp == false &&
                                                loadingCheck == false &&
                                                loadingRe == false)
                                            ? await verifyOTP(
                                                pinCode.join(''),
                                                widget.usernameController.text,
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
                                              color: bottomUp,
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
                                                          color: primaryColor,
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
                              ]))
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

class CustSnackBar extends StatelessWidget {
  const CustSnackBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
        content: Stack(
      clipBehavior: Clip.none,
      children: [Text('Error')],
    ));
  }
}
