import 'dart:convert';
import 'dart:io';
import 'package:anime_mont_test/pages/chat.dart';
import 'package:anime_mont_test/pages/home_page.dart';
import 'package:anime_mont_test/pages/profial_screen.dart';
import 'package:anime_mont_test/pages/signup&login/check_email.dart';
import 'package:anime_mont_test/pages/signup&login/lognin.dart';
import 'package:anime_mont_test/server/server_php.dart';
import 'package:anime_mont_test/utils/loading.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/user_model.dart';
import '../../server/urls_php.dart';
import '../../utils/dialog_box.dart';
import '../../utils/image_helper.dart';
import '../../utils/my_button.dart';
import '../../utils/pass_text_field.dart';
import '../../utils/textField.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  String ar = "عربي";
  String en = "English ";
  bool isEn = true;
  bool hidePssword = true;
  bool username = false;
  List images = ['images/avatar.jpg', 'images/cover 2.png'];
  bool loading = false;
  File? _image;

  String dateTime = '1960';

  final Server _server = Server();

  checkControllers() {
    if (emailController.text.isNotEmpty &&
        validateEmail(emailController.text) == true &&
        passwordController.text.isNotEmpty &&
        usernameController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        dateTime != '1960' &&
        _image != null) {
      setState(() {});
      return true;
    } else {
      setState(() {});
      return false;
    }
  }

  bool loading2 = false;
  Login() async {
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

  late GoogleSignInAccount account;
  LoginWithGoogle() async {
    loading2 = true;
    setState(() {});
    account = (await google.signIn())!;

    if (account.displayName!.isNotEmpty) {
      print(account);
      loading2 = false;
      setState(() {});
      Login();
    } else {
      loading2 = false;
      setState(() {});
      print('Google login error');
    }
  }

  sendOTP(String email, String username) async {
    loading = true;
    setState(() {});
    final response = await http.post(Uri.parse(checkEmail),
        body: {"email": email, 'username': username});
    final body = json.decode(response.body);
    try {
      print(body);
      if (body['status'] == 'true') {
        loading = false;
        setState(() {});
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CheckEmail(
                      birthday: dateTime,
                      emailController: emailController,
                      nameController: nameController,
                      otpController: otpController,
                      passwordController: passwordController,
                      usernameController: usernameController,
                      image: _image,
                    )));
      } else {
        loading = false;
        setState(() {});
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return DialogBox(
        //         onCheck: verifyOTP(otpController.text, usernameController.text),
        //         onResend:
        //             reSendOTP(emailController.text, usernameController.text),
        //         controller: otpController,
        //       );
        //     });
        print("error");
      }
    } catch (e) {
      loading = false;
      setState(() {});
    }
  }

  cancel() {
    Navigator.pop(context);
  }

  checkUsernume(String user) async {
    final response =
        await http.post(Uri.parse(check_username), body: {"user": user});
    final body = json.decode(response.body);
    print('body   $body');
    if (body['status'] == 'true') {
      username = true;
      setState(() {});
    } else {
      username = false;
      setState(() {});
    }
  }

  //late Account account;
  // Future getAccount(String email, String pass) async {
  //   loading = true;
  //   setState(() {});
  //   final response = await http
  //       .post(Uri.parse(linkLogin), body: {"user": email, 'pass': pass});
  //   final body = json.decode(response.body);

  //   if (body['OK'] == 'OK') {
  //     loading = false;
  //     setState(() {});
  //     return true;
  //   } else if (body['OK'] == 'Account') {
  //     loading = false;
  //     setState(() {});
  //     return null;
  //   } else if (body['OK'] == 'Password') {
  //     loading = false;
  //     setState(() {});
  //     return false;
  //   } else {
  //     loading = false;
  //     setState(() {});
  //     return null;
  //   }
  // }

  //  static Future<Account> getAccount(String email, String pass) async {
  //   final response = await http
  //       .post(Uri.parse(linkLogin), body: {"user": '$email', ' pass': pass});
  //   final body = json.decode(response.body);
  //   print('Acooooont  ${body.toString()}    ////');
  //   print('Acooooont /// ${body.Account.fromJson()}');
  //   return body.Account.fromJson();
  // }
  late GoogleSignIn google;
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

  validateEmail(String email) {
    var pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regexp = RegExp(pattern);
    return (!regexp.hasMatch(email)) ? false : true;
  }

  @override
  void initState() {
    super.initState();
    google = GoogleSignIn();
    usernameController.addListener(() {
      checkUsernume(usernameController.text);
      checkControllers();
    });
    passwordController.addListener(() {
      checkControllers();
    });
    emailController.addListener(() {
      checkControllers();
    });
    nameController.addListener(() {
      checkControllers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconTheme = Theme.of(context).iconTheme.color!;
    final Color textColor = Color.fromARGB(255, 160, 146, 167);
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Size size = MediaQuery.of(context).size;
    final Color bottomUp = Theme.of(context).primaryColorDark;
    final Color bottomDown = Theme.of(context).primaryColorLight;
    bool check = checkControllers();

    Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: DateTime(2000),
        firstDate: DateTime(1970),
        lastDate: DateTime(2010));
    final GoogleSignIn google = GoogleSignIn();

    return Scaffold(
        backgroundColor: backgroundColor,
        body: ListView(
          children: [
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () async {
                final ImageHelper imageHelper = ImageHelper(
                  source: ImageSource.gallery,
                );
                final files = await imageHelper.pickImage();
                if (files.isNotEmpty) {
                  final croppedFile = await imageHelper.crop(
                      file: files.first!, cropStyle: CropStyle.circle);
                  if (croppedFile != null) {
                    setState(() {
                      _image = File(croppedFile.path);
                    });
                  }
                }
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 80.5,
                child: Stack(
                  children: [
                    // Positioned(
                    //     bottom: 5,
                    //     left: 5,
                    //     child: CircleAvatar(
                    //       backgroundColor: Colors.grey,
                    //       radius: 25,
                    //       child: CircleAvatar(
                    //         child: Image.asset(
                    //           'images/Light/Profile.png',
                    //           fit: BoxFit.cover,
                    //           color: backgroundColor,
                    //         ),
                    //         radius: 24.5,
                    //         backgroundColor: iconTheme,
                    //       ),
                    //     )),
                    CircleAvatar(
                      foregroundImage:
                          _image != null ? FileImage(_image!, scale: .9) : null,
                      child: Image.asset(
                        'images/Light/Profile.png',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        color: backgroundColor,
                      ),
                      radius: 80,
                      backgroundColor: iconTheme,
                    ),
                    Positioned(
                        bottom: 5,
                        left: 5,
                        child: CircleAvatar(
                          child: Image.asset(
                            _image == null
                                ? 'images/Light/Plus.png'
                                : 'images/Light/Edit.png',
                            fit: BoxFit.contain,
                            color: bottomUp,
                          ),
                          radius: 18,
                          backgroundColor: iconTheme,
                        ))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Column(
              children: [
                CustTextField(
                    withValid: false,
                    valid: (val) {
                      return validInput(
                        emailController.text,
                        context.localeString('email'),
                        5,
                        30,
                      );
                    },
                    text: context.localeString('email'),
                    controller: emailController),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  child: Container(
                    // constraints: BoxConstraints(minHeight: 49),
                    // height: 48.5,
                    decoration: BoxDecoration(
                      color: iconTheme,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                children: [
                                  TextField(
                                    //maxLines: 5,
                                    style: TextStyle(
                                      color: primaryColor,
                                    ),
                                    cursorColor: Colors.blueAccent,
                                    controller: usernameController,

                                    decoration: InputDecoration(
                                      hintText:
                                          context.localeString('userName'),
                                      hintStyle: TextStyle(
                                        color: primaryColor,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: ImageIcon(
                              AssetImage(username == true &&
                                      usernameController.text.length > 4
                                  ? 'images/Light/Shield Done.png'
                                  : 'images/Light/Shield Fail.png'),
                              size: 20,
                              color: username == true &&
                                      usernameController.text.length > 4
                                  ? Color.fromARGB(255, 69, 209, 155)
                                  : usernameController.text.isEmpty
                                      ? Colors.transparent
                                      : Color.fromARGB(255, 226, 65, 65),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                CustTextField(
                    withValid: false,
                    valid: (val) {
                      return validInput(
                        nameController.text,
                        context.localeString('name'),
                        5,
                        30,
                      );
                    },
                    text: context.localeString('name'),
                    controller: nameController),
                PassTextFeild(
                    valid: (val) {
                      return validInput(
                          val!, context.localeString('password'), 6, 25);
                    },
                    passwordController: passwordController,
                    password: context.localeString('password')),
                GestureDetector(
                  onTap: () async {
                    final date = await pickDate();
                    if (date == null) return;
                    setState(() {
                      dateTime =
                          '${date.year.toString()}-${date.month.toString()}-${date.day.toString()}';
                    });
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    child: Container(
                        height: 48,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: iconTheme,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: (dateTime != '1960'
                              ? Text(dateTime.toString())
                              : LocaleText(
                                  'birthday',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: (() async {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => CheckEmail(
                    //               birthdayController:
                    //                   birthdayController,
                    //               emailController:
                    //                   emailController,
                    //               nameController: nameController,
                    //               otpController: otpController,
                    //               passwordController:
                    //                   passwordController,
                    //               usernameController:
                    //                   usernameController,
                    //               image: _image,
                    //             )));
                    checkControllers()
                        ? sendOTP(emailController.text, usernameController.text)
                        : null;
                  }),
                  child: Button(
                      check: check,
                      bottomUp: bottomUp,
                      bottomDown: bottomDown,
                      boolean: loading),
                )
              ],
            ),
            SizedBox(
              height: 80,
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () => LoginWithGoogle(),
                  child: Container(
                    height: 20,
                    child: LocaleText(
                      "logingoogle",
                      // style: TextStyle(
                      //   color: textColor,
                      // ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
            GestureDetector(
              onTap: () {
                loading = false;
                // Navigator.pushNamedAndRemoveUntil(
                //     context, 'LogIn', (route) => true);
                Navigator.restorablePushReplacementNamed(context, '/LogIn');
              },
              child: Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LocaleText(
                        "have",
                        // style: TextStyle(
                        //   color: textColor,
                        //),
                      ),
                      LocaleText(
                        "login",
                        style: TextStyle(
                            fontSize: 15,
                            color: bottomDown,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
            )
          ],
        ));
  }
}

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.check,
    required this.bottomUp,
    required this.bottomDown,
    required this.boolean,
  }) : super(key: key);

  final bool check;
  final Color bottomUp;
  final Color bottomDown;
  final bool boolean;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Container(
          height: 48,
          width: double.infinity,
          decoration: BoxDecoration(
            color: check == false ? bottomUp : bottomDown,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: boolean == false
                ? LocaleText(
                    "signup",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )
                : Container(
                    height: 35,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
        ));
  }
}
