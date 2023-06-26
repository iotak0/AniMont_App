import 'dart:convert';
import 'dart:io';
import 'package:anime_mont_test/Screens/Profile/pass_text_field.dart';
import 'package:anime_mont_test/Screens/Profile/shortcut.dart';
import 'package:anime_mont_test/helper/constans.dart';
import 'package:anime_mont_test/helper/image_helper.dart';
import 'package:anime_mont_test/server/server_php.dart';
import 'package:anime_mont_test/widgets/cust_snak_bar.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:anime_mont_test/widgets/textField.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:http/http.dart' as http;
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/provider/user_model.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({super.key});

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  UserProfial? account;
  bool updating = false;
  bool usernameLoading = false;
  bool uploadingAvatar = false;
  bool uploadingBGround = false;

  File? avatar;
  File? bGround;
  TextEditingController name = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController email = TextEditingController();
  static GlobalKey<FormState> fromstate = GlobalKey();
  bool trueUsername = true;
  bool edit = false;

  checkControllers() {
    if (account!.userName.isNotEmpty &&
            account!.name.isNotEmpty &&
            (pass.text.length == 0 ||
                (pass.text.length > 7 && pass.text.length < 31))
        //&&fromstate.currentState!.validate()
        ) {
      setState(() {});
      return true;
    } else {
      setState(() {});
      return false;
    }
  }

  checkUsernume() async {
    setState(() {
      usernameLoading = true;
    });
    final response = await http.post(Uri.parse(check_username_email),
        body: {"user": username.text}).catchError((erorr) {
      setState(() {
        usernameLoading = false;
        trueUsername = false;
      });
    });
    final body = json.decode(response.body);
    print('body   $body');
    if (body['status'] == 'true' &&
        username.text.length > 2 &&
        username.text.length < 11) {
      setState(() {
        usernameLoading = false;
        trueUsername = true;
      });
    } else {
      setState(() {
        usernameLoading = false;
        trueUsername = false;
      });
    }
  }

  getAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString('userData');
    final body = json.decode(userPref!);
    account = UserProfial.fromJson(body);
    account!.avatar = account!.avatar.startsWith('http')
        ? account!.avatar
        : image + account!.avatar;
    setState(() {});
  }

  Future<DateTime?> pickDate() {
    edit = true;
    setState(() {});
    return showDatePicker(
        context: context,
        initialDate: DateTime.parse(account!.birthday),
        firstDate: DateTime(1980),
        lastDate: DateTime(2015));
  }

  update() async {
    setState(() {
      updating = true;
    });

    var response = await http.post(Uri.parse(edit_account), body: {
      "user_id": account!.id,
      "bio": account!.bio.toString(),
      "username": account!.userName.toString(),
      "email": account!.email.toString(),
      "city": account!.country.toString(),
      "name": account!.name.toString(),
      "pass": pass.text.toString(),
      "birthday": account!.birthday.toString(),
    }).catchError((e) {
      updating = false;
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

      return Response('jjj', 400);
    });
    print(response.body);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body["status"] == "success") {
        setState(() {
          updating = false;
          Navigator.pushReplacementNamed(context, '/MyApp');
        });
      } else {
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
        setState(() {});
      }
    } else {
      updating = false;
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
      setState(() {});
    }
  }

  updateImage(bool isAvatar, File image2) async {
    isAvatar ? uploadingAvatar = true : uploadingBGround = true;
    setState(() {});
    await Server.postRequestWithFiles(
            upload_image,
            {
              "user_id": account!.id.toString(),
              "isAvatar": isAvatar.toString(),
            },
            image2)
        .then((value) async {
      print(value.toString());
      if (value != false) {
        await CachedNetworkImage.evictFromCache(
            isAvatar ? account!.avatar : image + account!.backGroung);
        setState(() {
          isAvatar ? avatar = image2 : bGround = image2;
          isAvatar ? uploadingAvatar = false : uploadingBGround = false;
        });
      } else {
        isAvatar ? uploadingAvatar = false : uploadingBGround = false;

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
    });
  }

  @override
  void initState() {
    getAccount();
    super.initState();
    name.addListener(() {
      if (name.text.isNotEmpty) {
        setState(() {
          account!.name = name.text;
          edit = true;
        });
      } else {
        setState(() {
          account!.name = '';
        });
      }
    });
    email.addListener(() {
      if (email.text.isNotEmpty) {
        setState(() {
          account!.email = email.text;
          edit = true;
        });
      } else {
        setState(() {
          account!.email = '';
        });
      }
    });
    username.addListener(() {
      if (username.text.isNotEmpty) {
        setState(() {
          account!.userName = username.text;
          checkUsernume();
          edit = true;
        });
      } else {
        setState(() {
          account!.userName = '';
        });
      }
    });
    bio.addListener(() {
      if (bio.text.isNotEmpty) {
        setState(() {
          account!.bio = bio.text;
          edit = true;
        });
      } else {
        setState(() {
          account!.bio = '';
        });
      }
    });
    city.addListener(() {
      if (city.text.isNotEmpty) {
        setState(() {
          account!.country = city.text;
          edit = true;
        });
      } else {
        setState(() {
          account!.country = '';
        });
      }
    });
    pass.addListener(() {
      setState(() {
        edit = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    return WillPopScope(
      onWillPop: () async {
        if (!updating && !usernameLoading) {
          return true;
        } else
          return false;
      },
      /**checkControllers */
      child: Scaffold(
        appBar: AppBar(
          title: LocaleText(
            'edit',
            style: TextStyle(
                color: customColors.primaryColor,
                fontFamily: 'SFPro',
                fontWeight: FontWeight.bold),
          ),
          leading: updating
              ? SizedBox()
              : GestureDetector(
                  onTap: () {
                    if (!updating && !usernameLoading) {
                      Navigator.pop(context);
                    }
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: customColors.primaryColor,
                  ),
                ),
          backgroundColor: customColors.backgroundColor,
          elevation: 1,
          actions: [
            GestureDetector(
              onTap: () {
                (trueUsername &&
                        !updating &&
                        !usernameLoading &&
                        edit &&
                        checkControllers())
                    ? {
                        FocusScope.of(context).requestFocus(FocusNode()),
                        update(),
                      }
                    : FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: (updating)
                    ? SizedBox(
                        height: 30,
                        width: 30,
                        child: LoadingGif(
                          logo: false,
                        ))
                    : SvgPicture.string(
                        '<?xml version="1.0" encoding="UTF-8"?> <svg xmlns="http://www.w3.org/2000/svg" id="Слой_1" data-name="Слой 1" viewBox="0 0 783 783"><path d="M911,170.5a362.21,362.21,0,1,1-141.48,28.55A361.31,361.31,0,0,1,911,170.5m0-28c-216.22,0-391.5,175.28-391.5,391.5S694.78,925.5,911,925.5,1302.5,750.22,1302.5,534,1127.22,142.5,911,142.5Z" transform="translate(-519.5 -142.5)"></path><path d="M651.5,487.5a363.14,363.14,0,0,1,34.75,16.12c11.35,5.91,22.43,12.3,33.34,19s21.61,13.63,32.17,20.8c5.29,3.57,10.49,7.25,15.71,10.92l7.75,5.6c2.59,1.86,5.18,3.73,7.72,5.64,20.48,15.16,40.38,31.05,59.83,47.44l14.48,12.42c4.8,4.18,9.55,8.4,14.31,12.63s9.44,8.54,14.14,12.86l7,6.52c2.35,2.22,4.6,4.35,7.06,6.74l-50.45,6.8,3.27-7.16c1-2.28,2.13-4.51,3.22-6.73,2.19-4.44,4.36-8.86,6.66-13.2s4.6-8.66,7-13,4.82-8.52,7.28-12.75Q891.62,592.86,908.8,569c11.5-15.87,23.72-31.27,36.77-46a528.87,528.87,0,0,1,41.74-42.18,429.2,429.2,0,0,1,47.08-36.94,342.92,342.92,0,0,1,52.66-29.4,259.29,259.29,0,0,1,57.55-18.23c4.94-.93,9.91-1.68,14.88-2.23s10-1,14.94-1.1c2.48-.1,5-.12,7.44-.13s5,.12,7.43.23A136.28,136.28,0,0,1,1204,394.5c-4.46,2.1-8.83,4.19-13.12,6.31l-3.2,1.6-3.16,1.65c-2.1,1.08-4.19,2.16-6.24,3.31q-12.36,6.76-23.84,14.2a437.23,437.23,0,0,0-43.34,32.19c-27.31,22.92-52.11,48.31-75.82,75q-17.76,20-34.66,41T967.35,612.2Q951,633.79,935.22,655.94q-4,5.52-7.86,11.09c-2.62,3.7-5.23,7.4-7.79,11.12s-5.16,7.42-7.66,11.14l-7.26,10.77-24.78,36.77-25.67-30L842.3,693l-12.16-14-12.25-14-12.29-14q-24.66-27.9-49.71-55.54c-16.74-18.4-33.61-36.73-50.9-54.75-8.64-9-17.33-18-26.25-26.88S660.77,496.28,651.5,487.5Z" transform="translate(-519.5 -142.5)"></path></svg>',
                        height: 25,
                        width: 25,
                        color: trueUsername && checkControllers() && edit
                            ? customColors.bottomDown
                            : customColors.primaryColor.withOpacity(.3),
                      ),
              ),
            )
          ],
        ),
        //extendBodyBehindAppBar: true,
        body: account == null
            ? LoadingGif(
                logo: false,
              )
            : Form(
                key: fromstate,
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final ImageHelper imageHelper = ImageHelper(
                                  context: context,
                                  source: ImageSource.gallery,
                                );
                                final files = await imageHelper.pickImage();
                                if (files.isNotEmpty) {
                                  final croppedFile = await imageHelper.crop(
                                      file: files.first!,
                                      cropAspectRatio: CropAspectRatio(
                                          ratioX: 16, ratioY: 9),
                                      cropStyle: CropStyle.rectangle);
                                  if (croppedFile != null) {
                                    setState(() {
                                      updateImage(
                                          false, File(croppedFile.path));
                                    });
                                  }
                                }
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(12)),
                                    child: uploadingBGround
                                        ? LoadingGif(
                                            logo: true,
                                          )
                                        : bGround != null
                                            ? Image.file(
                                                bGround!,
                                                height: 150,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              )
                                            : CachedNetworkImage(
                                                height: 150,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  height: 150,
                                                  color: customColors.iconTheme
                                                      .withAlpha(100),
                                                ),
                                                width: double.infinity,
                                                key: UniqueKey(),
                                                imageUrl:
                                                    image + account!.backGroung,
                                                fit: BoxFit.cover,
                                              ),
                                  ),
                                  uploadingBGround
                                      ? SizedBox()
                                      : EditProfileImages(
                                          isEmpty:
                                              (account!.backGroung.isEmpty &&
                                                  bGround == null),
                                        ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: -50,
                              height: 110,
                              width: 110,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    final ImageHelper imageHelper = ImageHelper(
                                      context: context,
                                      source: ImageSource.gallery,
                                    );
                                    final files = await imageHelper.pickImage();
                                    if (files.isNotEmpty) {
                                      final croppedFile =
                                          await imageHelper.crop(
                                              file: files.first!,
                                              cropStyle: CropStyle.circle);
                                      if (croppedFile != null) {
                                        updateImage(
                                            true, File(croppedFile.path));
                                      }
                                    }
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: uploadingAvatar
                                            ? LoadingGif(
                                                logo: true,
                                              )
                                            : avatar != null
                                                ? Image.file(avatar!)
                                                : CachedNetworkImage(
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Container(
                                                      height: 110,
                                                      color: customColors
                                                          .iconTheme,
                                                    ),
                                                    //height: 50,
                                                    //width: double.infinity,
                                                    key: UniqueKey(),
                                                    imageUrl: account!.avatar,
                                                    fit: BoxFit.cover,
                                                  ),
                                      ),
                                      uploadingAvatar
                                          ? SizedBox()
                                          : EditProfileImages(
                                              isEmpty:
                                                  (account!.avatar.isEmpty &&
                                                      avatar == null)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            account!.name,
                            style: TextStyle(
                                fontFamily: 'SFPro',
                                color: customColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "@" + account!.userName.toLowerCase(),
                            style: TextStyle(
                                fontFamily: 'SFPro',
                                color:
                                    customColors.primaryColor.withOpacity(.7),
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            account!.bio,
                            style: TextStyle(
                                fontFamily: 'SFPro',
                                color:
                                    customColors.primaryColor.withOpacity(.7),
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Container(
                              width: double.infinity,
                              child: Row(
                                //

                                children: [
                                  Wrap(
                                    spacing: 0,
                                    runSpacing: 8,
                                    alignment: WrapAlignment.center,
                                    children: [
                                      account!.country.isEmpty ||
                                              account!.country == 0
                                          ? SizedBox()
                                          : Shortcut(
                                              height: 20.0,
                                              icon:
                                                  '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                  <title>Iconly/Light-Outline/Location</title>
                  <g id="Iconly/Light-Outline/Location" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                      <g id="Location" transform="translate(4.000000, 1.000000)" fill="#000000">
                  <path d="M8.2495,1 C12.7985,1 16.4995,4.729 16.4995,9.313 C16.4995,14.948 10.0435,20.5 8.2495,20.5 C6.4555,20.5 -0.0005,14.948 -0.0005,9.313 C-0.0005,4.729 3.7005,1 8.2495,1 Z M8.2495,2.5 C4.5275,2.5 1.4995,5.557 1.4995,9.313 C1.4995,14.092 7.1235,18.748 8.2495,18.996 C9.3755,18.747 14.9995,14.091 14.9995,9.313 C14.9995,5.557 11.9715,2.5 8.2495,2.5 Z M8.2505,6 C10.0425,6 11.5005,7.458 11.5005,9.251 C11.5005,11.043 10.0425,12.5 8.2505,12.5 C6.4585,12.5 5.0005,11.043 5.0005,9.251 C5.0005,7.458 6.4585,6 8.2505,6 Z M8.2505,7.5 C7.2855,7.5 6.5005,8.285 6.5005,9.251 C6.5005,10.216 7.2855,11 8.2505,11 C9.2155,11 10.0005,10.216 10.0005,9.251 C10.0005,8.285 9.2155,7.5 8.2505,7.5 Z" id="Combined-Shape"></path>
                      </g>
                  </g>
              </svg>''',
                                              text: account!.country),
                                      GestureDetector(
                                        onTap: () async {
                                          FocusScope.of(context).unfocus();
                                          final date = await pickDate();
                                          if (date == null) return;
                                          setState(() {
                                            account!.birthday = date
                                                .toString()
                                                .substring(
                                                    0,
                                                    date
                                                        .toString()
                                                        .indexOf(' '));
                                          });
                                        },
                                        child: Shortcut(
                                            height: 15.0,
                                            icon:
                                                '''<svg width="24px" height="24px" version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 122.88 122.88" style="enable-background:new 0 0 122.88 122.88" xml:space="preserve"><g><path d="M81.61,4.73c0-2.61,2.58-4.73,5.77-4.73c3.19,0,5.77,2.12,5.77,4.73v20.72c0,2.61-2.58,4.73-5.77,4.73 c-3.19,0-5.77-2.12-5.77-4.73V4.73L81.61,4.73z M66.11,103.81c-0.34,0-0.61-1.43-0.61-3.2c0-1.77,0.27-3.2,0.61-3.2H81.9 c0.34,0,0.61,1.43,0.61,3.2c0,1.77-0.27,3.2-0.61,3.2H66.11L66.11,103.81z M15.85,67.09c-0.34,0-0.61-1.43-0.61-3.2 c0-1.77,0.27-3.2,0.61-3.2h15.79c0.34,0,0.61,1.43,0.61,3.2c0,1.77-0.27,3.2-0.61,3.2H15.85L15.85,67.09z M40.98,67.09 c-0.34,0-0.61-1.43-0.61-3.2c0-1.77,0.27-3.2,0.61-3.2h15.79c0.34,0,0.61,1.43,0.61,3.2c0,1.77-0.27,3.2-0.61,3.2H40.98 L40.98,67.09z M66.11,67.09c-0.34,0-0.61-1.43-0.61-3.2c0-1.77,0.27-3.2,0.61-3.2H81.9c0.34,0,0.61,1.43,0.61,3.2 c0,1.77-0.27,3.2-0.61,3.2H66.11L66.11,67.09z M91.25,67.09c-0.34,0-0.61-1.43-0.61-3.2c0-1.77,0.27-3.2,0.61-3.2h15.79 c0.34,0,0.61,1.43,0.61,3.2c0,1.77-0.27,3.2-0.61,3.2H91.25L91.25,67.09z M15.85,85.45c-0.34,0-0.61-1.43-0.61-3.2 c0-1.77,0.27-3.2,0.61-3.2h15.79c0.34,0,0.61,1.43,0.61,3.2c0,1.77-0.27,3.2-0.61,3.2H15.85L15.85,85.45z M40.98,85.45 c-0.34,0-0.61-1.43-0.61-3.2c0-1.77,0.27-3.2,0.61-3.2h15.79c0.34,0,0.61,1.43,0.61,3.2c0,1.77-0.27,3.2-0.61,3.2H40.98 L40.98,85.45z M66.11,85.45c-0.34,0-0.61-1.43-0.61-3.2c0-1.77,0.27-3.2,0.61-3.2H81.9c0.34,0,0.61,1.43,0.61,3.2 c0,1.77-0.27,3.2-0.61,3.2H66.11L66.11,85.45z M91.25,85.45c-0.34,0-0.61-1.43-0.61-3.2c0-1.77,0.27-3.2,0.61-3.2h15.79 c0.34,0,0.61,1.43,0.61,3.2c0,1.77-0.27,3.2-0.61,3.2H91.25L91.25,85.45z M15.85,103.81c-0.34,0-0.61-1.43-0.61-3.2 c0-1.77,0.27-3.2,0.61-3.2h15.79c0.34,0,0.61,1.43,0.61,3.2c0,1.77-0.27,3.2-0.61,3.2H15.85L15.85,103.81z M40.98,103.81 c-0.34,0-0.61-1.43-0.61-3.2c0-1.77,0.27-3.2,0.61-3.2h15.79c0.34,0,0.61,1.43,0.61,3.2c0,1.77-0.27,3.2-0.61,3.2H40.98 L40.98,103.81z M29.61,4.73c0-2.61,2.58-4.73,5.77-4.73s5.77,2.12,5.77,4.73v20.72c0,2.61-2.58,4.73-5.77,4.73 s-5.77-2.12-5.77-4.73V4.73L29.61,4.73z M6.4,45.32h110.07V21.47c0-0.8-0.33-1.53-0.86-2.07c-0.53-0.53-1.26-0.86-2.07-0.86H103 c-1.77,0-3.2-1.43-3.2-3.2c0-1.77,1.43-3.2,3.2-3.2h10.55c2.57,0,4.9,1.05,6.59,2.74c1.69,1.69,2.74,4.02,2.74,6.59v27.06v65.03 c0,2.57-1.05,4.9-2.74,6.59c-1.69,1.69-4.02,2.74-6.59,2.74H9.33c-2.57,0-4.9-1.05-6.59-2.74C1.05,118.45,0,116.12,0,113.55V48.52 V21.47c0-2.57,1.05-4.9,2.74-6.59c1.69-1.69,4.02-2.74,6.59-2.74H20.6c1.77,0,3.2,1.43,3.2,3.2c0,1.77-1.43,3.2-3.2,3.2H9.33 c-0.8,0-1.53,0.33-2.07,0.86c-0.53,0.53-0.86,1.26-0.86,2.07V45.32L6.4,45.32z M116.48,51.73H6.4v61.82c0,0.8,0.33,1.53,0.86,2.07 c0.53,0.53,1.26,0.86,2.07,0.86h104.22c0.8,0,1.53-0.33,2.07-0.86c0.53-0.53,0.86-1.26,0.86-2.07V51.73L116.48,51.73z M50.43,18.54 c-1.77,0-3.2-1.43-3.2-3.2c0-1.77,1.43-3.2,3.2-3.2h21.49c1.77,0,3.2,1.43,3.2,3.2c0,1.77-1.43,3.2-3.2,3.2H50.43L50.43,18.54z"/></g></svg>''',
                                            text: Jiffy(DateTime.parse(
                                                    account!.birthday))
                                                .MMMd
                                                .toString()),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 7),
                          child: Container(
                            // constraints: BoxConstraints(minHeight: 49),
                            // height: 48.5,
                            decoration: BoxDecoration(
                              color: customColors.iconTheme,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            onEditingComplete: () =>
                                                FocusScope.of(context)
                                                    .nextFocus(),
                                            onChanged: (value) =>
                                                setState(() {}),
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (value) {
                                              if (GetUtils.isLengthLessThan(
                                                  value, 3)) {
                                                return context.localeString(
                                                        "minlength") +
                                                    " 3 " +
                                                    context.localeString(
                                                        "characters");
                                              }
                                              if (GetUtils.isLengthGreaterThan(
                                                  value, 10)) {
                                                return context.localeString(
                                                        "maxlength") +
                                                    " 10 " +
                                                    context.localeString(
                                                        "characters");
                                              }
                                              return null;
                                            },

                                            //maxLines: 5,
                                            style: TextStyle(
                                              color: customColors.primaryColor,
                                              fontFamily: context.currentLocale
                                                          .toString() ==
                                                      'ar'
                                                  ? 'SFPro'
                                                  : 'Angie',
                                            ),

                                            cursorColor: Colors.blueAccent,
                                            controller: username,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  10),
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[a-z0-9._]'))
                                            ],
                                            decoration: InputDecoration(
                                              hintText: context
                                                  .localeString('userName'),
                                              hintStyle: TextStyle(
                                                color:
                                                    customColors.primaryColor,
                                                fontFamily: context
                                                            .currentLocale
                                                            .toString() ==
                                                        'ar'
                                                    ? 'SFPro'
                                                    : 'Angie',
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
                                    child: usernameLoading
                                        ? SizedBox(
                                            height: 20,
                                            child: LoadingGif(
                                              logo: false,
                                            ))
                                        : SvgPicture.string(
                                            (trueUsername &&
                                                    username.text.length > 2)
                                                ? '<?xml version="1.0" encoding="UTF-8"?> <svg xmlns="http://www.w3.org/2000/svg" id="Слой_1" data-name="Слой 1" viewBox="0 0 783 783"><path d="M911,170.5a362.21,362.21,0,1,1-141.48,28.55A361.31,361.31,0,0,1,911,170.5m0-28c-216.22,0-391.5,175.28-391.5,391.5S694.78,925.5,911,925.5,1302.5,750.22,1302.5,534,1127.22,142.5,911,142.5Z" transform="translate(-519.5 -142.5)"></path><path d="M651.5,487.5a363.14,363.14,0,0,1,34.75,16.12c11.35,5.91,22.43,12.3,33.34,19s21.61,13.63,32.17,20.8c5.29,3.57,10.49,7.25,15.71,10.92l7.75,5.6c2.59,1.86,5.18,3.73,7.72,5.64,20.48,15.16,40.38,31.05,59.83,47.44l14.48,12.42c4.8,4.18,9.55,8.4,14.31,12.63s9.44,8.54,14.14,12.86l7,6.52c2.35,2.22,4.6,4.35,7.06,6.74l-50.45,6.8,3.27-7.16c1-2.28,2.13-4.51,3.22-6.73,2.19-4.44,4.36-8.86,6.66-13.2s4.6-8.66,7-13,4.82-8.52,7.28-12.75Q891.62,592.86,908.8,569c11.5-15.87,23.72-31.27,36.77-46a528.87,528.87,0,0,1,41.74-42.18,429.2,429.2,0,0,1,47.08-36.94,342.92,342.92,0,0,1,52.66-29.4,259.29,259.29,0,0,1,57.55-18.23c4.94-.93,9.91-1.68,14.88-2.23s10-1,14.94-1.1c2.48-.1,5-.12,7.44-.13s5,.12,7.43.23A136.28,136.28,0,0,1,1204,394.5c-4.46,2.1-8.83,4.19-13.12,6.31l-3.2,1.6-3.16,1.65c-2.1,1.08-4.19,2.16-6.24,3.31q-12.36,6.76-23.84,14.2a437.23,437.23,0,0,0-43.34,32.19c-27.31,22.92-52.11,48.31-75.82,75q-17.76,20-34.66,41T967.35,612.2Q951,633.79,935.22,655.94q-4,5.52-7.86,11.09c-2.62,3.7-5.23,7.4-7.79,11.12s-5.16,7.42-7.66,11.14l-7.26,10.77-24.78,36.77-25.67-30L842.3,693l-12.16-14-12.25-14-12.29-14q-24.66-27.9-49.71-55.54c-16.74-18.4-33.61-36.73-50.9-54.75-8.64-9-17.33-18-26.25-26.88S660.77,496.28,651.5,487.5Z" transform="translate(-519.5 -142.5)"></path></svg>'
                                                : '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                  <title>Iconly/Light-Outline/Shield Fail</title>
                  <g id="Iconly/Light-Outline/Shield-Fail" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                      <g id="Shield-Fail" transform="translate(4.000000, 2.000000)" fill="#000000">
                  <path d="M8.4837,0 C9.6167,0 15.5627,2.041 16.3487,2.828 C17.0047,3.484 16.9947,4.014 16.9487,6.557 C16.9307,7.575 16.9057,8.962 16.9057,10.879 C16.9057,17.761 9.0357,20.223 8.7007,20.324 C8.6297,20.346 8.5567,20.356 8.4837,20.356 C8.4107,20.356 8.3377,20.346 8.2667,20.324 C7.9317,20.223 0.0617,17.761 0.0617,10.879 C0.0617,8.959 0.0367,7.572 0.0187,6.554 C0.0104857143,6.10042857 0.00341938776,5.71095153 0.00108269862,5.37340598 L0.000778125,4.9925 C0.0092625,3.741125 0.12645,3.32 0.6177,2.828 C1.4047,2.041 7.3507,0 8.4837,0 Z M8.4837,1.5 C7.6357,1.5 2.2847,3.384 1.6677,3.899 C1.54935385,4.018 1.50539527,4.19514201 1.49976503,4.89807789 L1.49931066,5.16876667 C1.5005003,5.51181805 1.50746923,5.95334615 1.5177,6.526 C1.5367,7.552 1.5617,8.947 1.5617,10.879 C1.5617,16.08 7.2837,18.389 8.4827,18.814 C9.6807,18.387 15.4057,16.065 15.4057,10.879 C15.4057,8.949 15.4307,7.555 15.4487,6.529 C15.4592,5.95580769 15.4663657,5.51388609 15.4674649,5.1703325 L15.4668577,4.8991807 C15.4605669,4.19482396 15.4138923,4.01519231 15.2877,3.889 C14.6817,3.384 9.3317,1.5 8.4837,1.5 Z M7.1346,7.5372 L8.48377813,8.887 L9.8328,7.5372 C10.1258,7.2442 10.5998,7.2442 10.8928,7.5372 C11.1858,7.8302 11.1858,8.3042 10.8928,8.5972 L9.54377813,9.947 L10.8926,11.2952 C11.1856,11.5882 11.1856,12.0622 10.8926,12.3552 C10.7466,12.5022 10.5546,12.5752 10.3626,12.5752 C10.1706,12.5752 9.9786,12.5022 9.8326,12.3552 L8.48377813,11.007 L7.1348,12.3552 C6.9888,12.5022 6.7968,12.5752 6.6048,12.5752 C6.4128,12.5752 6.2208,12.5022 6.0748,12.3552 C5.7818,12.0622 5.7818,11.5882 6.0748,11.2952 L7.42377813,9.947 L6.0746,8.5972 C5.7816,8.3042 5.7816,7.8302 6.0746,7.5372 C6.3676,7.2442 6.8416,7.2442 7.1346,7.5372 Z" id="Combined-Shape"></path>
                      </g>
                  </g>
              </svg>''',
                                            height: 20,
                                            color: (trueUsername &&
                                                    username.text.length > 2)
                                                ? Color.fromARGB(
                                                    255, 69, 209, 155)
                                                : username.text.isEmpty
                                                    ? Colors.transparent
                                                    : Color.fromARGB(
                                                        255, 226, 65, 65),
                                          ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        CustTextField(
                            maxLines: 1,
                            LengthLimiting: 25,
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
                            controller: name),
                        CustTextField(
                            maxLines: 5,
                            LengthLimiting: 150,
                            ar: true,
                            withValid: true,
                            valid: (value) {
                              // if (!GetUtils.hasMatch(value!, r'[a-zA-Z0-9!$%*@_?&+-]')) {
                              //   return "invalidusername";
                              // }
                              if (GetUtils.isLengthGreaterThan(value, 150)) {
                                return context.localeString("maxlength") +
                                    " 150 " +
                                    context.localeString("characters");
                              }
                              return null;
                            },
                            text: context.localeString('bio'),
                            controller: bio),
                        CustTextField(
                            maxLines: 1,
                            LengthLimiting: 15,
                            ar: true,
                            withValid: true,
                            valid: (value) {
                              // if (!GetUtils.hasMatch(value!, r'[a-zA-Z0-9!$%*@_?&+-]')) {
                              //   return "invalidusername";
                              // }
                              if (GetUtils.isLengthGreaterThan(value, 15)) {
                                return context.localeString("maxlength") +
                                    " 15 " +
                                    context.localeString("characters");
                              }
                              return null;
                            },
                            text: context.localeString('city'),
                            controller: city),
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
                            passwordController: pass,
                            password: context.localeString('password')),
                      ]),
                ),
              ),
      ),
    );
  }
}

class EditProfileImages extends StatelessWidget {
  const EditProfileImages({
    Key? key,
    required this.isEmpty,
  }) : super(key: key);
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
          border: Border.all(
              width: 2, color: customColors.primaryColor.withOpacity(.6)),
          borderRadius: BorderRadius.circular(100)),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Center(
          child: SvgPicture.string(
            isEmpty ? plus : editSvg,
            height: 45,
            width: 45,
            color: customColors.primaryColor.withOpacity(.9),
          ),
        ),
      ),
    );
  }
}
