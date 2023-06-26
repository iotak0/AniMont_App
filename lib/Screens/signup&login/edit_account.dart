// import 'dart:convert';
// import 'dart:io';
// import 'package:anime_mont_test/pages/signup&login/check_email.dart';
// import 'package:anime_mont_test/provider/custom_colors.dart';
// import 'package:anime_mont_test/server/server_php.dart';
// import 'package:anime_mont_test/widget/profile/avatar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_locales/flutter_locales.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:jiffy/jiffy.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../provider/user_model.dart';
// import '../../server/urls_php.dart';
// import '../../utils/image_helper.dart';
// import '../../utils/textField.dart';

// class EditAccount extends StatefulWidget {
//   const EditAccount({super.key, required this.profile});
//   final UserProfial profile;
//   @override
//   State<EditAccount> createState() => _EditAccountState();
// }

// class _EditAccountState extends State<EditAccount> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController birthdayController = TextEditingController();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController otpController = TextEditingController();

//   String ar = "عربي";
//   String en = "English ";
//   bool isEn = true;
//   bool hidePssword = true;
//   bool username = false;
//   List images = ['images/avatar.jpg', 'images/cover 2.png'];
//   bool loading = false;
//   File? _profile;
//   File? _bGround;

//   String dateTime = '1960';

//   final Server _server = Server();

//   bool loading2 = false;

//   checkUsernume(String user) async {
//     final response =
//         await http.post(Uri.parse(check_username), body: {"user": user});
//     final body = json.decode(response.body);
//     print('body   $body');
//     if (body['status'] == 'true') {
//       username = true;
//       setState(() {});
//     } else {
//       username = false;
//       setState(() {});
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     CustomColors customColors = CustomColors(context);

//     Future<DateTime?> pickDate() => showDatePicker(
//         context: context,
//         initialDate: DateTime(2000),
//         firstDate: DateTime(1970),
//         lastDate: DateTime(2010));
//     final GoogleSignIn google = GoogleSignIn();

//     return Scaffold(
//         backgroundColor: customColors.backgroundColor,
//         body: SafeArea(
//           child: ListView(
//             children: [
//               Container(
//                 height: 260,
//                 child: Stack(
//                   children: [
//                     GestureDetector(
//                         onTap: () async {
//                           final ImageHelper imageHelper = ImageHelper(
//                             source: ImageSource.gallery,
//                           );
//                           final files = await imageHelper.pickImage();
//                           if (files.isNotEmpty) {
//                             final croppedFile = await imageHelper.crop(
//                                 file: files.first!,
//                                 cropStyle: CropStyle.rectangle);
//                             if (croppedFile != null) {
//                               setState(() {
//                                 _bGround = File(croppedFile.path);
//                               });
//                             }
//                           }
//                         },
//                         child: Container(
//                           height: 200,
//                           child: _bGround != null
//                               ? ClipRRect(
//                                   borderRadius: BorderRadius.only(
//                                       bottomLeft: Radius.circular(20),
//                                       bottomRight: Radius.circular(20)),
//                                   child: Image.file(_bGround!))
//                               : Container(
//                                   height: 200,
//                                   decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         image: NetworkImage(
//                                             image2 + widget.profile.backGroung),
//                                         fit: BoxFit.cover),
//                                     // color: Color.fromARGB(255, 0, 83, 79),
//                                     borderRadius: BorderRadius.only(
//                                         bottomLeft: Radius.circular(20),
//                                         bottomRight: Radius.circular(20)),
//                                     border: Border.all(
//                                       width: 2,
//                                       color: customColors.iconTheme,
//                                     ),
//                                   ),
//                                 ),
//                         )),
//                     //
//                     _profile == null
//                         ? Avatar(
//                             profail: widget.profile,
//                             isEn: context.currentLocale.toString() == 'en'
//                                 ? true
//                                 : false)
//                         : context.currentLocale.toString() == 'en'
//                             ? Positioned(
//                                 top: 100,
//                                 bottom: -10,
//                                 left: 15,
//                                 child: CircleAvatar(
//                                   foregroundImage: _profile != null
//                                       ? FileImage(_profile!, scale: .9)
//                                       : null,
//                                   radius: 50,
//                                   backgroundColor: customColors.iconTheme,
//                                 ),
//                               )
//                             : Positioned(
//                                 top: 100,
//                                 bottom: -10,
//                                 right: 15,
//                                 child: CircleAvatar(
//                                   foregroundImage: _profile != null
//                                       ? FileImage(_profile!, scale: .9)
//                                       : null,
//                                   radius: 50,
//                                   backgroundColor: customColors.iconTheme,
//                                 ),
//                               ),
//                     context.currentLocale.toString() == 'en'
//                         ? Positioned(
//                             top: 200,
//                             bottom: 5,
//                             left: 15,
//                             child: GestureDetector(
//                               onTap: () async {
//                                 final ImageHelper imageHelper = ImageHelper(
//                                   source: ImageSource.gallery,
//                                 );
//                                 final files = await imageHelper.pickImage();
//                                 if (files.isNotEmpty) {
//                                   final croppedFile = await imageHelper.crop(
//                                       file: files.first!,
//                                       cropStyle: CropStyle.circle);
//                                   if (croppedFile != null) {
//                                     setState(() {
//                                       _profile = File(croppedFile.path);
//                                     });
//                                   }
//                                 }
//                               },
//                               child: CircleAvatar(
//                                 child: Image.asset(
//                                   'images/Light/Edit.png',
//                                   fit: BoxFit.contain,
//                                   color: customColors.bottomUp,
//                                 ),
//                                 radius: 15,
//                                 backgroundColor: customColors.iconTheme,
//                               ),
//                             ))
//                         : Positioned(
//                             top: 200,
//                             bottom: 5,
//                             right: 15,
//                             child: GestureDetector(
//                               onTap: () async {
//                                 final ImageHelper imageHelper = ImageHelper(
//                                   source: ImageSource.gallery,
//                                 );
//                                 final files = await imageHelper.pickImage();
//                                 if (files.isNotEmpty) {
//                                   final croppedFile = await imageHelper.crop(
//                                       file: files.first!,
//                                       cropStyle: CropStyle.circle);
//                                   if (croppedFile != null) {
//                                     setState(() {
//                                       _profile = File(croppedFile.path);
//                                     });
//                                   }
//                                 }
//                               },
//                               child: CircleAvatar(
//                                 child: Image.asset(
//                                   'images/Light/Edit.png',
//                                   fit: BoxFit.contain,
//                                   color: customColors.bottomUp,
//                                 ),
//                                 radius: 15,
//                                 backgroundColor: customColors.iconTheme,
//                               ),
//                             )),
//                   ],
//                 ),
//               ),
//               Column(
//                 children: [
//                   Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
//                     child: Container(
//                       // constraints: BoxConstraints(minHeight: 49),
//                       // height: 48.5,
//                       decoration: BoxDecoration(
//                         color: customColors.iconTheme,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Column(
//                                   children: [
//                                     TextField(
//                                       //maxLines: 5,
//                                       style: TextStyle(
//                                         color: customColors.primaryColor,
//                                       ),
//                                       cursorColor: Colors.blueAccent,
//                                       controller: usernameController,

//                                       decoration: InputDecoration(
//                                         hintText: widget.profile.userName,
//                                         hintStyle: TextStyle(
//                                           color: customColors.primaryColor,
//                                         ),
//                                         border: InputBorder.none,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               margin: EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 5),
//                               child: ImageIcon(
//                                 AssetImage(username == true &&
//                                         usernameController.text.length > 4
//                                     ? 'images/Light/Shield Done.png'
//                                     : 'images/Light/Shield Fail.png'),
//                                 size: 20,
//                                 color: username == true &&
//                                         usernameController.text.length > 4
//                                     ? Color.fromARGB(255, 69, 209, 155)
//                                     : usernameController.text.isEmpty
//                                         ? Colors.transparent
//                                         : Color.fromARGB(255, 226, 65, 65),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   CustTextField(
//                       ar: true,
//                       withValid: false,
//                       valid: (val) {
//                         return null;
//                       },
//                       text: widget.profile.name,
//                       controller: nameController),
//                   GestureDetector(
//                     onTap: () async {
//                       final date = await pickDate();
//                       if (date == null) return;
//                       setState(() {
//                         dateTime =
//                             '${date.year.toString()}-${date.month.toString()}-${date.day.toString()}';
//                       });
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 7),
//                       child: Container(
//                           height: 48,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             color: customColors.iconTheme,
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Center(
//                             child: (dateTime != '1960'
//                                 ? Text(Jiffy(dateTime.toString()).yMMMMd)
//                                 : Text(
//                                     Jiffy(widget.profile.birthday).yMMMMd,
//                                     style: TextStyle(
//                                         color: customColors.primaryColor,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold),
//                                   )),
//                           )),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: (() async {
//                       // Navigator.push(
//                       //     context,
//                       //     MaterialPageRoute(
//                       //         builder: (context) => CheckEmail(
//                       //               birthdayController:
//                       //                   birthdayController,
//                       //               emailController:
//                       //                   emailController,
//                       //               nameController: nameController,
//                       //               otpController: otpController,
//                       //               passwordController:
//                       //                   passwordController,
//                       //               usernameController:
//                       //                   usernameController,
//                       //               image: _profile,
//                       //             )));
//                     }),
//                     //   child: Button(
//                     //      // check: check,
//                     //       bottomUp: bottomUp,
//                     //       bottomDown: bottomDown,
//                     //       boolean: loading),
//                     // )
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 80,
//               ),
//             ],
//           ),
//         ));
//   }
// }

// class Button extends StatelessWidget {
//   const Button({
//     Key? key,
//     required this.check,
//     required this.bottomUp,
//     required this.bottomDown,
//     required this.boolean,
//   }) : super(key: key);

//   final bool check;
//   final Color bottomUp;
//   final Color bottomDown;
//   final bool boolean;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
//         child: Container(
//           height: 48,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: check == false ? bottomUp : bottomDown,
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Center(
//             child: boolean == false
//                 ? LocaleText(
//                     "edite",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold),
//                   )
//                 : Container(
//                     height: 35,
//                     child: Center(
//                       child: CircularProgressIndicator(
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//           ),
//         ));
//   }
// }
