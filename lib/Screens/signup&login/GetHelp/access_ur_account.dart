import 'dart:convert';

import 'package:anime_mont_test/Screens/Profile/avatar.dart';
import 'package:anime_mont_test/Screens/signup&login/GetHelp/activated_page.dart';
import 'package:anime_mont_test/helper/constans.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/provider/user_model.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:anime_mont_test/widgets/cust_snak_bar.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shimmer/shimmer.dart';

class AccessYourAccount extends StatefulWidget {
  const AccessYourAccount({
    super.key,
    required this.account,
    required this.data,
  });
  final UserModel account;
  final data;
  @override
  State<AccessYourAccount> createState() => _AccessYourAccountState();
}

class _AccessYourAccountState extends State<AccessYourAccount> {
  bool loading = false;
  String avatar = '';
  sendOTP() async {
    loading = true;
    setState(() {});
    Response response = await http.post(Uri.parse(rest_password), body: {
      "email": widget.account.email,
      "lang": context.currentLocale!.languageCode.toString()
    }).catchError((error) {
      loading = false;
      //hasErorr = true;
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
                builder: (context) => ActivatedPage(
                      data: widget.data,
                      account: widget.account,
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

  @override
  void initState() {
    avatar = widget.account.avatar.contains('http')
        ? widget.account.avatar
        : image + widget.account.avatar;

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
            'access_your_account',
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
            children: [
              Center(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      height: 90,
                      width: 90,
                      imageUrl: avatar,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: customColors.iconTheme,
                        highlightColor: customColors.bottomDown,
                        child: Container(
                          height: 90,
                          width: 90,
                          color: customColors.primaryColor,
                        ),
                      ),
                      //color: customColors.primaryColor.withOpacity(.3),
                      errorWidget: (context, url, error) => Container(
                        height: 90,
                        width: 90,
                        color: customColors.iconTheme,
                      ),
                    )),
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                  child: Text(
                widget.account.userName.toUpperCase(),
                style: TextStyle(
                    color: customColors.primaryColor,
                    fontSize: 18,
                    fontFamily: 'SFPro',
                    fontWeight: FontWeight.bold),
              )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child: Divider(),
              ),
              GestureDetector(
                onTap: () => loading ? null : sendOTP(),
                child: loading
                    ? SizedBox(
                        height: 30,
                        width: 30,
                        child: LoadingGif(logo: true),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 20,
                            color: loading
                                ? customColors.primaryColor.withOpacity(.5)
                                : customColors.primaryColor,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          LocaleText(
                            'send_an_email',
                            style: TextStyle(
                                color: loading
                                    ? customColors.primaryColor.withOpacity(.5)
                                    : customColors.primaryColor,
                                fontSize: 15,
                                fontFamily: 'SFPro',
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
              )
            ],
          ),
        )));
  }
}
