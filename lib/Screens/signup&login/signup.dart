import 'dart:convert';
import 'dart:io';
import 'package:anime_mont_test/Screens/Profile/pass_text_field.dart';
import 'package:anime_mont_test/Screens/signup&login/check_email.dart';
import 'package:anime_mont_test/helper/constans.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/provider/user_model.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:anime_mont_test/widgets/cust_snak_bar.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:anime_mont_test/widgets/textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
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
  static bool loading = false;
  File? _image;
  bool hasErorr = false;
  String dateTime = '1980-01-01 20:18:04Z';
  String barthday = '1980-01-01 20:18:04Z';

  static GlobalKey<FormState> fromstate = GlobalKey();
  checkControllers() {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        fromstate.currentState!.validate() &&
        barthday != '1980-01-01 20:18:04Z') {
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
    final response = await http.post(Uri.parse(signup_google), body: {
      "email": account.email.toString(),
      "name": account.displayName.toString(),
      "avatar": account.photoUrl.toString()
    });
    final body = json.decode(response.body);
    print('body   $body');
    if (body[0]['status'] == 'true') {
      loading2 = false;
      setState(() {});

      UserModel.setAcount(body[0]['account']);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('logIn', true);

      Navigator.restorablePushReplacementNamed(context, '/MyApp');
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
      loading2 = false;
      setState(() {});
      Login();
    } else {
      loading2 = false;
      setState(() {});
    }
  }

  sendOTP(String email, String username) async {
    loading = true;
    setState(() {});
    Response response = await http.post(Uri.parse(send_email), body: {
      "email": email,
      'username': nameController.text,
      "lang": context.currentLocale!.languageCode.toString()
    }).catchError((error) {
      loading = false;
      hasErorr = true;
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
      return Response('error', 400);
    });

    final body = json.decode(response.body);
    if (response.statusCode == 400) {
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
    } else {}
    try {
      print(body);
      if (body['status'] == 'true') {
        loading = false;
        setState(() {});
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CheckEmail(
                      birthday: barthday,
                      passwordController: passwordController,
                      emailController: emailController,
                      nameController: nameController,
                      otpController: otpController,
                    )));
      } else {
        loading = false;
        setState(() {});
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
  }

 
  late GoogleSignIn google;
 

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

    Future<DateTime?> pickDate() {
      FocusScope.of(context).unfocus();
      return showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1980),
          lastDate: DateTime(2015));
    }

    final GoogleSignIn google = GoogleSignIn();

    return Scaffold(
        backgroundColor: backgroundColor,
        body: Form(
          key: fromstate,
          child: Center(
            child: SingleChildScrollView(
              reverse: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: SizedBox(
                      height: 100,
                      child: Center(
                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          'images/animont.png',
                          fit: BoxFit.cover,
                          height: 80,
                          width: 80,
                        ),
                      )),
                    ),
                  ),
                  /*Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
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
                              foregroundImage: _image != null
                                  ? FileImage(_image!, scale: .9)
                                  : null,
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
                  ), */

                  CustTextField(
                      maxLines: 1,
                      LengthLimiting: 35,
                      ar: false,
                      withValid: true,
                      valid: (value) {
                        if (!GetUtils.isEmail(value!)) {
                          return context.localeString("invalidemail");
                        }
                        if (GetUtils.isLengthLessThan(value, 6)) {
                          return context.localeString("minlength") +
                              " 6 " +
                              context.localeString("characters");
                        }
                        if (GetUtils.isLengthGreaterThan(value, 50)) {
                          return context.localeString("maxlength") +
                              " 50 " +
                              context.localeString("characters");
                        }
                        return null;
                      },
                      text: context.localeString('email'),
                      controller: emailController),
                  /* Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 7),
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
                                        TextFormField(
                                          autovalidateMode:
                                              AutovalidateMode.onUserInteraction,
                                          validator: (value) {
                                            if (!GetUtils.isUsername(value!)) {
                                              return context.localeString(
                                                  "invalidusername");
                                            }
                                            if (GetUtils.isLengthLessThan(
                                                value, 3)) {
                                              return context
                                                      .localeString("minlength") +
                                                  " 3 " +
                                                  context
                                                      .localeString("characters");
                                            }
                                            if (GetUtils.isLengthGreaterThan(
                                                value, 10)) {
                                              return context
                                                      .localeString("maxlength") +
                                                  " 10 " +
                                                  context
                                                      .localeString("characters");
                                            }
                                            return null;
                                          },
            
                                          //maxLines: 5,
                                          style: TextStyle(
                                            color: primaryColor,
                                          ),
            
                                          cursorColor: Colors.blueAccent,
                                          controller: usernameController,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(50),
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[a-zA-Z0-9!$%*@_?&+-]'))
                                          ],
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
                      ), */
                  CustTextField(
                      maxLines: 1,
                      LengthLimiting: 20,
                      ar: true,
                      withValid: true,
                      valid: (value) {
                        // if (!GetUtils.hasMatch(value!, r'[a-zA-Z0-9!$%*@_?&+-]')) {
                        //   return "invalidusername";
                        // }
                        if (GetUtils.isLengthLessThan(value, 1)) {
                          return context.localeString("minlength") +
                              " 1 " +
                              context.localeString("characters");
                        }
                        if (GetUtils.isLengthGreaterThan(value, 25)) {
                          return context.localeString("maxlength") +
                              " 25 " +
                              context.localeString("characters");
                        }
                        return null;
                      },
                      text: context.localeString('name'),
                      controller: nameController),
                  PassTextFeild(
                      valid: (value) {
                        if (!GetUtils.hasMatch(
                            value!, r'[a-zA-Z0-9!$%*@_?&+-]')) {
                          return "Invalid userName";
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
                    onTap: () async {
                      final date = await pickDate();
                      if (date == null) return;
                      setState(() {
                        barthday = barthday.substring(0, barthday.indexOf(' '));

                        dateTime = Jiffy(date).yMMMMEEEEd.toString();
                        //'${date.year.toString()}-${date.month.toString()}-${date.day.toString()}';
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 7),
                      child: Container(
                          height: 48,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: iconTheme,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: (dateTime != '1980-01-01 20:18:04Z'
                                ? Text(
                                    dateTime,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )
                                : LocaleText(
                                    'birthday',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SFPro'),
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
                          ? sendOTP(
                              emailController.text, usernameController.text)
                          : null;
                    }),
                    child: Button(
                        check: checkControllers(),
                        bottomUp: bottomUp,
                        bottomDown: bottomDown,
                        boolean: loading),
                  ),
                  SizedBox(
                    height: 40,
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
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () => LoginWithGoogle(),
                    child: loading2
                        ? SizedBox(
                            height: 50,
                            width: 50,
                            child: LoadingGif(
                              logo: true,
                            ),
                          )
                        : Container(
                            height: 20,
                            child: LocaleText("logingoogle",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'SFPro',
                                    color: primaryColor,
                                    fontWeight: FontWeight.w400)
                                // style: TextStyle(
                                //   color: textColor,
                                // ),
                                ),
                          ),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      loading = false;
                      // Navigator.pushNamedAndRemoveUntil(
                      //     context, 'LogIn', (route) => true);
                      Navigator.restorablePushReplacementNamed(
                          context, '/LogIn');
                    },
                    child: Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LocaleText("have",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'SFPro',
                                    color: primaryColor,
                                    fontWeight: FontWeight.w400)
                                // style: TextStyle(
                                //   color: textColor,
                                //),
                                ),
                            LocaleText(
                              "login",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'SFPro',
                                  color: bottomDown,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  )
                ],
              ),
            ),
          ),
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
            color: check == false ? Colors.transparent : bottomDown,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: boolean == false
                ? LocaleText(
                    "signup",
                    style: TextStyle(
                        color: check == false
                            ? CustomColors(context).primaryColor
                            : Colors.white,
                        fontSize: 18,
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold),
                  )
                : Container(
                    height: 35,
                    child: LoadingGif(
                      logo: false,
                    ),
                  ),
          ),
        ));
  }
}
