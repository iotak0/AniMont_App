import 'dart:convert';

import 'package:anime_mont_test/server/inters_ad.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:anime_mont_test/widget/profile/shortcut.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jiffy/jiffy.dart';
import '../../provider/user_model.dart';
import '../../server/banner_ad.dart';

class BioSec extends StatefulWidget {
  const BioSec({
    Key? key,
    required this.profail,
    required this.myId,
  }) : super(key: key);

  final UserProfial profail;
  final String myId;

  @override
  State<BioSec> createState() => _BioSecState();
}

class _BioSecState extends State<BioSec> {
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconTheme = Theme.of(context).iconTheme.color!;
    final Color textColor = Color.fromARGB(255, 160, 146, 167);
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color bottomUp = Theme.of(context).primaryColorDark;
    final Color bottomDown = Theme.of(context).primaryColorLight;
    return SliverToBoxAdapter(
        child: Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Container(
          alignment: context.currentLocale.toString() == "en"
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Text(
            widget.profail.bio,
            style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w400,
                fontSize: 16,
                fontFamily:
                    context.localeString('en') == 'en' ? 'Angie' : 'SFPro'),
          ),
        ),
      ),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Container(
            width: double.infinity,
            child: Row(
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    Shortcut(
                        icon: 'images/Light/Location.png',
                        text: widget.profail.country),
                    Shortcut(
                        icon: 'images/Light/Time Circle.png',
                        text: Jiffy(widget.profail.birthday).MMMd.toString()),
                  ],
                ),
              ],
            )),
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Container(
              width: double.infinity,
              child: Row(children: [
                Text(
                  '${context.localeString('following')} ${widget.profail.following}',
                  style: TextStyle(
                      color: primaryColor.withAlpha(230),
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      fontFamily: context.localeString('en') == 'en'
                          ? 'Angie'
                          : 'SFPro'),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '${context.localeString('followers')} ${widget.profail.followers}',
                  style: TextStyle(
                      color: primaryColor.withAlpha(230),
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      fontFamily: context.localeString('en') == 'en'
                          ? 'Angie'
                          : 'SFPro'),
                )
              ]))),

      widget.myId != widget.profail.id
          ? Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                width: double.infinity,
                child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children:
                        List.generate(widget.profail.matual.length, (index) {
                      final matual = widget.profail.matual[index];

                      if (index == 0 && widget.profail.matual.isNotEmpty) {
                        return Container(
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: LocaleText("followedby"),
                              ),
                              Container(
                                child: Row(children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: CircleAvatar(
                                          radius: 12,
                                          backgroundImage:
                                              AssetImage(matual.avatar))),
                                  Text(matual.name)
                                ]),
                              )
                            ],
                          ),
                        );
                      } else {
                        return widget.profail.matual.isNotEmpty
                            ? Container(
                                child: Row(children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: CircleAvatar(
                                          radius: 12,
                                          backgroundImage: AssetImage(
                                              image2 + matual.avatar))),
                                  Text(matual.name)
                                ]),
                              )
                            : Container();
                      }
                    })),
              ))
          : Container(),
      MyBannerAd(), MyntersAd(),
      SizedBox(
        height: MediaQuery.of(context).size.height - 275,
      ),

      // Titel(size: size, title: "Favorite"),
      // AnimeScrollView2(size: size),
      // SliverToBoxAdapter(
      //     child: Titel(size: widget.size, title: "")),
      // // Category(
      // //     list: anime.animeCategory, isLink: true, color: widget.color),
      // SliverToBoxAdapter(
      //     child: Titel(size: widget.size, title: "Info")),
      // // Category(
      // //     list: anime.animeInfo, isLink: false, color: widget.color),
      // SliverToBoxAdapter(
      //     child: Titel(size: widget.size, title: "Episodes")),
    ]));
  }
}
