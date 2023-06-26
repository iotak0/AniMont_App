import 'dart:io';

import 'package:anime_mont_test/helper/image_helper.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/server/server_php.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:anime_mont_test/widgets/cust_snak_bar.dart';
import '../../../helper/constans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AddAvatar extends StatefulWidget {
  const AddAvatar({super.key});

  @override
  State<AddAvatar> createState() => _AddAvatarState();
}

class _AddAvatarState extends State<AddAvatar> {
  File? _image;
  bool isLoading = false;
  Server _server = Server();
  AddAvatarM(String username) async {
    isLoading = true;
    setState(() {});

    final r = await Server.postRequestWithFiles(
        signup,
        {
          "username": username,
        },
        _image!);
    if (r != false) {
      isLoading = false;
      setState(() {});
    } else {
      isLoading = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustSnackBar(
            color: Color(0xFFC72C41),
            image: danger,
            headLine: 'Error',
            erorr: "Connection Erorr"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColor = CustomColors(context);
    return Scaffold(
      appBar: AppBar(
        title: LocaleText(
          'newpost',
          style: TextStyle(fontFamily: 'SFPro', fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.string(
                '<?xml version="1.0" encoding="UTF-8"?> <svg xmlns="http://www.w3.org/2000/svg" id="Слой_1" data-name="Слой 1" viewBox="0 0 783 783"><path d="M911,170.5a362.21,362.21,0,1,1-141.48,28.55A361.31,361.31,0,0,1,911,170.5m0-28c-216.22,0-391.5,175.28-391.5,391.5S694.78,925.5,911,925.5,1302.5,750.22,1302.5,534,1127.22,142.5,911,142.5Z" transform="translate(-519.5 -142.5)"></path><path d="M651.5,487.5a363.14,363.14,0,0,1,34.75,16.12c11.35,5.91,22.43,12.3,33.34,19s21.61,13.63,32.17,20.8c5.29,3.57,10.49,7.25,15.71,10.92l7.75,5.6c2.59,1.86,5.18,3.73,7.72,5.64,20.48,15.16,40.38,31.05,59.83,47.44l14.48,12.42c4.8,4.18,9.55,8.4,14.31,12.63s9.44,8.54,14.14,12.86l7,6.52c2.35,2.22,4.6,4.35,7.06,6.74l-50.45,6.8,3.27-7.16c1-2.28,2.13-4.51,3.22-6.73,2.19-4.44,4.36-8.86,6.66-13.2s4.6-8.66,7-13,4.82-8.52,7.28-12.75Q891.62,592.86,908.8,569c11.5-15.87,23.72-31.27,36.77-46a528.87,528.87,0,0,1,41.74-42.18,429.2,429.2,0,0,1,47.08-36.94,342.92,342.92,0,0,1,52.66-29.4,259.29,259.29,0,0,1,57.55-18.23c4.94-.93,9.91-1.68,14.88-2.23s10-1,14.94-1.1c2.48-.1,5-.12,7.44-.13s5,.12,7.43.23A136.28,136.28,0,0,1,1204,394.5c-4.46,2.1-8.83,4.19-13.12,6.31l-3.2,1.6-3.16,1.65c-2.1,1.08-4.19,2.16-6.24,3.31q-12.36,6.76-23.84,14.2a437.23,437.23,0,0,0-43.34,32.19c-27.31,22.92-52.11,48.31-75.82,75q-17.76,20-34.66,41T967.35,612.2Q951,633.79,935.22,655.94q-4,5.52-7.86,11.09c-2.62,3.7-5.23,7.4-7.79,11.12s-5.16,7.42-7.66,11.14l-7.26,10.77-24.78,36.77-25.67-30L842.3,693l-12.16-14-12.25-14-12.29-14q-24.66-27.9-49.71-55.54c-16.74-18.4-33.61-36.73-50.9-54.75-8.64-9-17.33-18-26.25-26.88S660.77,496.28,651.5,487.5Z" transform="translate(-519.5 -142.5)"></path></svg>',
                height: 25,
                width: 25,
                color: customColor.bottomDown,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      final ImageHelper imageHelper = ImageHelper(
                        source: ImageSource.gallery,
                        context: context,
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
                          CircleAvatar(
                            foregroundImage: _image != null
                                ? FileImage(_image!, scale: .9)
                                : null,
                            child: Image.asset(
                              'images/Light/Profile.png',
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              color: customColor.backgroundColor,
                            ),
                            radius: 80,
                            backgroundColor: customColor.iconTheme,
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
                                  color: customColor.bottomUp,
                                ),
                                radius: 18,
                                backgroundColor: customColor.iconTheme,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 8),
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : GestureDetector(
                            onTap: () => AddAvatarM("mont"),
                            child: LocaleText(
                              "add",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily:
                                      context.currentLocale.toString() == 'ar'
                                          ? 'SFPro'
                                          : 'Angie',
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 8),
                    child: GestureDetector(
                      onTap: () {
                        isLoading = false;
                        setState(() {});
                      },
                      child: LocaleText(
                        "skip",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: context.currentLocale.toString() == 'ar'
                                ? 'SFPro'
                                : 'Angie',
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              )
            ]),
      ),
    );
  }
}
