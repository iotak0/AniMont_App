import 'dart:convert';
import 'package:anime_mont_test/helper/constans.dart';

import 'package:anime_mont_test/Screens/Profile/edit_account.dart';
import 'package:anime_mont_test/Screens/settings/circleBotton.dart';
import 'package:anime_mont_test/Screens/settings/more_items.dart';
import 'package:anime_mont_test/Screens/settings/settings.dart';
import 'package:anime_mont_test/Screens/settings/show_more_widget.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/provider/user_model.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

class FollowSec extends StatefulWidget {
  const FollowSec({
    Key? key,
    required this.profile,
    required this.myId,
    required this.account,
  }) : super(key: key);
  final String myId;
  final UserProfial profile;
  final UserProfial account;

  @override
  State<FollowSec> createState() => _FollowSecState();
}

class _FollowSecState extends State<FollowSec> {
  late bool imfollowing;
  late bool loading;
  late UserProfial profial;
  @override
  void initState() {
    profial = widget.profile;
    imfollowing = widget.profile.imfollowing;
    loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColor = CustomColors(context);
    final Size size = MediaQuery.of(context).size;

    bool myAccount = false;

    if (widget.myId == widget.profile.id) {
      myAccount = true;
    }

    editProfile() async {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => EditAccount()));
      // var response = await http.post(Uri.parse(my_account_link), body: {
      //   "my_id": widget.myId.toString(),
      //   "f_id": widget.myId.toString()
      // });

      // final body = json.decode(response.body);
      // print('body ${body.toString()}');
    }

    click() async {
      if (myAccount) {
        editProfile();
      } else if (imfollowing) {
        setState(() {
          loading = true;
        });
        final response =
            await UserModel.unFollow(widget.myId, widget.profile.id);
        if (response) {
          setState(() {
            imfollowing = false;
            //   BioSecState(false, true);
          });
        }
        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          loading = true;
        });
        final response = await UserModel.follow(widget.myId, widget.profile.id);
        if (response) {
          setState(() {
            imfollowing = true;
            // BioSecState(true, true);
          });
        }
        setState(() {
          loading = false;
        });
      }
    }

    return SizedBox(
      width: size.width / 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    border:
                        Border.all(width: .5, color: customColor.primaryColor),
                    borderRadius: BorderRadius.circular(50)),
                child: AccountBotton(
                  profial: widget.profile,
                  accountId: widget.profile.id,
                  myAccount: myAccount,
                  myId: widget.myId,
                  account: widget.account,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () async {
                click();
              },
              child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: customColor.bottomDown,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: loading
                      ? Center(
                          child: LoadingGif(
                            logo: false,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Center(
                            child: (imfollowing && !myAccount)
                                ? Botton(string: "unfollow")
                                : !imfollowing && !myAccount
                                    ? Botton(string: 'follow')
                                    : Botton(string: 'edite'),
                          ),
                        )),
            ),
          ],
        ),
      ),
    );
  }
}

class Botton extends StatelessWidget {
  const Botton({
    Key? key,
    required this.string,
  }) : super(key: key);
  final String string;

  @override
  Widget build(BuildContext context) {
    return LocaleText(
      string,
      style: TextStyle(
          color: Colors.white,
          fontFamily: 'SFPro',
          fontWeight: FontWeight.bold,
          fontSize: 15),
    );
  }
}

class AccountBotton extends StatefulWidget {
  const AccountBotton({
    Key? key,
    required this.myAccount,
    required this.myId,
    required this.accountId,
    required this.account,
    required this.profial,
    //required this.customColors,
  }) : super(key: key);
  final bool myAccount;
  final String myId;
  final String accountId;
  final UserProfial account;
  final UserProfial profial;
  @override
  State<AccountBotton> createState() => _AccountBottonState();
}

class _AccountBottonState extends State<AccountBotton> {
  bool reporting = false;
  reportAccount(String type) async {
    setState(() {
      reporting = true;
      Navigator.pop(context);
    });

    final response = await http.post(
        Uri.parse(
          report_account,
        ),
        body: {
          "user_id": '${widget.myId}',
          "account_id": '${widget.accountId}',
          "report": type.toString()
        }).catchError((e) {
      setState(() {
        reporting = false;
      });
    });
    var data;
    try {
      data = jsonDecode(response.body);
    } catch (e) {
      data = {"status": "hi"};
    }
    if (data['status'] == "success") {
      setState(() {
        reporting = false;
      });
      type != 'report'
          ? null
          : showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    backgroundColor: Colors.transparent,
                    content: Container(
                      //height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: CustomColors(context).backgroundColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                child: SvgPicture.string(
                                  '<?xml version="1.0" encoding="UTF-8"?> <svg xmlns="http://www.w3.org/2000/svg" id="Слой_1" data-name="Слой 1" viewBox="0 0 783 783"><path d="M911,170.5a362.21,362.21,0,1,1-141.48,28.55A361.31,361.31,0,0,1,911,170.5m0-28c-216.22,0-391.5,175.28-391.5,391.5S694.78,925.5,911,925.5,1302.5,750.22,1302.5,534,1127.22,142.5,911,142.5Z" transform="translate(-519.5 -142.5)"></path><path d="M651.5,487.5a363.14,363.14,0,0,1,34.75,16.12c11.35,5.91,22.43,12.3,33.34,19s21.61,13.63,32.17,20.8c5.29,3.57,10.49,7.25,15.71,10.92l7.75,5.6c2.59,1.86,5.18,3.73,7.72,5.64,20.48,15.16,40.38,31.05,59.83,47.44l14.48,12.42c4.8,4.18,9.55,8.4,14.31,12.63s9.44,8.54,14.14,12.86l7,6.52c2.35,2.22,4.6,4.35,7.06,6.74l-50.45,6.8,3.27-7.16c1-2.28,2.13-4.51,3.22-6.73,2.19-4.44,4.36-8.86,6.66-13.2s4.6-8.66,7-13,4.82-8.52,7.28-12.75Q891.62,592.86,908.8,569c11.5-15.87,23.72-31.27,36.77-46a528.87,528.87,0,0,1,41.74-42.18,429.2,429.2,0,0,1,47.08-36.94,342.92,342.92,0,0,1,52.66-29.4,259.29,259.29,0,0,1,57.55-18.23c4.94-.93,9.91-1.68,14.88-2.23s10-1,14.94-1.1c2.48-.1,5-.12,7.44-.13s5,.12,7.43.23A136.28,136.28,0,0,1,1204,394.5c-4.46,2.1-8.83,4.19-13.12,6.31l-3.2,1.6-3.16,1.65c-2.1,1.08-4.19,2.16-6.24,3.31q-12.36,6.76-23.84,14.2a437.23,437.23,0,0,0-43.34,32.19c-27.31,22.92-52.11,48.31-75.82,75q-17.76,20-34.66,41T967.35,612.2Q951,633.79,935.22,655.94q-4,5.52-7.86,11.09c-2.62,3.7-5.23,7.4-7.79,11.12s-5.16,7.42-7.66,11.14l-7.26,10.77-24.78,36.77-25.67-30L842.3,693l-12.16-14-12.25-14-12.29-14q-24.66-27.9-49.71-55.54c-16.74-18.4-33.61-36.73-50.9-54.75-8.64-9-17.33-18-26.25-26.88S660.77,496.28,651.5,487.5Z" transform="translate(-519.5 -142.5)"></path></svg>',
                                  height: 50,
                                  width: 50,
                                  color: CustomColors(context).bottomDown,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              LocaleText(
                                'thax_report',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: CustomColors(context).primaryColor,
                                  //   fontFamily: 'SFPro',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Divider(
                                height: 1,
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: LocaleText(
                                    'close',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: CustomColors(context)
                                          .primaryColor
                                          .withOpacity(.6),
                                      //   fontFamily: 'SFPro',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            ]),
                      ),
                    ));
              });
      return true;
    } else {
      setState(() {
        reporting = false;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColor = CustomColors(context);
    return GestureDetector(
        onTap: () => !widget.myAccount
            ? reporting
                ? null
                : showMore(
                    customColor,
                    context,
                    MoreItems(children: [
                      Center(
                        child: GestureDetector(
                            onTap: () => reportAccount('report'),
                            child: CircBotton(
                              title: 'report',
                              child: Center(
                                child: SvgPicture.string(
                                  report,
                                  color: customColor.primaryColor,
                                ),
                              ),
                            )),
                      ),
                      widget.profial.admin
                          ? SizedBox()
                          : !widget.account.admin
                              ? SizedBox()
                              : Center(
                                  child: GestureDetector(
                                      onTap: () => reportAccount('1'),
                                      child: CircBotton(
                                        title: 'ban',
                                        child: Center(
                                          child: SvgPicture.string(
                                            ban,
                                            color: customColor.primaryColor,
                                          ),
                                        ),
                                      )),
                                )
                    ]))
            : Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsPage())),
        child: SizedBox(
            height: 30,
            child: reporting
                ? LoadingGif(
                    logo: false,
                  )
                : Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SvgPicture.string(
                        widget.myAccount
                            ? '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
        <title>Iconly/Light-Outline/Setting</title>
        <g id="Iconly/Light-Outline/Setting" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
        <g id="Setting" transform="translate(2.000000, 1.000000)" fill="#000000">
            <path d="M10.2672,1.0005 C10.9832,1.0005 11.6792,1.2945 12.1782,1.8055 C12.6762,2.3195 12.9512,3.0245 12.9302,3.7395 C12.9322,3.9005 12.9852,4.0865 13.0812,4.2495 C13.2402,4.5195 13.4912,4.7095 13.7892,4.7875 C14.0872,4.8615 14.3992,4.8215 14.6642,4.6645 C15.9442,3.9335 17.5732,4.3715 18.3042,5.6415 L18.9272,6.7205 C18.9432,6.7495 18.9572,6.7775 18.9692,6.8065 C19.6312,8.0575 19.1892,9.6325 17.9592,10.3515 C17.7802,10.4545 17.6352,10.5985 17.5352,10.7725 C17.3802,11.0415 17.3372,11.3615 17.4152,11.6555 C17.4952,11.9555 17.6862,12.2045 17.9552,12.3585 C18.5622,12.7075 19.0152,13.2955 19.1962,13.9745 C19.3772,14.6525 19.2782,15.3885 18.9252,15.9955 L18.2612,17.1015 C17.5302,18.3575 15.9012,18.7925 14.6342,18.0605 C14.4652,17.9635 14.2702,17.9105 14.0762,17.9055 L14.0702,17.9055 C13.7812,17.9055 13.4842,18.0285 13.2682,18.2435 C13.0492,18.4625 12.9292,18.7545 12.9312,19.0645 C12.9242,20.5335 11.7292,21.7215 10.2672,21.7215 L9.0142,21.7215 C7.5452,21.7215 6.3502,20.5275 6.3502,19.0585 C6.3482,18.8775 6.2962,18.6895 6.1992,18.5265 C6.0422,18.2525 5.7882,18.0565 5.4952,17.9785 C5.2042,17.9005 4.8852,17.9435 4.6232,18.0955 C3.9952,18.4455 3.2562,18.5305 2.5802,18.3405 C1.9052,18.1495 1.3222,17.6855 0.9802,17.0705 L0.3552,15.9935 C-0.3758,14.7255 0.0592,13.1005 1.3252,12.3685 C1.6842,12.1615 1.9072,11.7755 1.9072,11.3615 C1.9072,10.9475 1.6842,10.5605 1.3252,10.3535 C0.0582,9.6175 -0.3758,7.9885 0.3542,6.7205 L1.0322,5.6075 C1.7532,4.3535 3.3832,3.9115 4.6542,4.6415 C4.8272,4.7445 5.0152,4.7965 5.2062,4.7985 C5.8292,4.7985 6.3502,4.2845 6.3602,3.6525 C6.3562,2.9555 6.6312,2.2865 7.1322,1.7815 C7.6352,1.2775 8.3032,1.0005 9.0142,1.0005 L10.2672,1.0005 Z M10.2672,2.5005 L9.0142,2.5005 C8.7042,2.5005 8.4142,2.6215 8.1952,2.8395 C7.9772,3.0585 7.8582,3.3495 7.8602,3.6595 C7.8392,5.1215 6.6442,6.2985 5.1972,6.2985 C4.7332,6.2935 4.2862,6.1685 3.8982,5.9365 C3.3532,5.6265 2.6412,5.8175 2.3222,6.3725 L1.6452,7.4855 C1.3352,8.0235 1.5252,8.7345 2.0772,9.0555 C2.8962,9.5295 3.4072,10.4135 3.4072,11.3615 C3.4072,12.3095 2.8962,13.1925 2.0752,13.6675 C1.5262,13.9855 1.3362,14.6925 1.6542,15.2425 L2.2852,16.3305 C2.4412,16.6115 2.6962,16.8145 2.9912,16.8975 C3.2852,16.9795 3.6092,16.9445 3.8792,16.7945 C4.2762,16.5615 4.7382,16.4405 5.2022,16.4405 C5.4312,16.4405 5.6602,16.4695 5.8842,16.5295 C6.5602,16.7115 7.1472,17.1635 7.4952,17.7705 C7.7212,18.1515 7.8462,18.5965 7.8502,19.0505 C7.8502,19.7005 8.3722,20.2215 9.0142,20.2215 L10.2672,20.2215 C10.9062,20.2215 11.4282,19.7035 11.4312,19.0645 C11.4272,18.3585 11.7032,17.6875 12.2082,17.1825 C12.7062,16.6845 13.4022,16.3855 14.0982,16.4055 C14.5542,16.4165 14.9932,16.5395 15.3802,16.7595 C15.9372,17.0785 16.6482,16.8885 16.9702,16.3385 L17.6342,15.2315 C17.7822,14.9765 17.8252,14.6565 17.7462,14.3615 C17.6682,14.0665 17.4722,13.8105 17.2082,13.6595 C16.5902,13.3035 16.1492,12.7295 15.9662,12.0415 C15.7852,11.3665 15.8842,10.6295 16.2372,10.0225 C16.4672,9.6225 16.8042,9.2855 17.2082,9.0535 C17.7502,8.7365 17.9402,8.0275 17.6252,7.4755 C17.6122,7.4535 17.6002,7.4305 17.5902,7.4065 L17.0042,6.3905 C16.6852,5.8355 15.9752,5.6445 15.4182,5.9615 C14.8162,6.3175 14.1002,6.4195 13.4122,6.2385 C12.7252,6.0605 12.1492,5.6255 11.7902,5.0115 C11.5602,4.6275 11.4352,4.1805 11.4312,3.7255 C11.4402,3.3835 11.3202,3.0765 11.1022,2.8515 C10.8852,2.6275 10.5802,2.5005 10.2672,2.5005 Z M9.6451,7.9746 C11.5121,7.9746 13.0311,9.4946 13.0311,11.3616 C13.0311,13.2286 11.5121,14.7466 9.6451,14.7466 C7.7781,14.7466 6.2591,13.2286 6.2591,11.3616 C6.2591,9.4946 7.7781,7.9746 9.6451,7.9746 Z M9.6451,9.4746 C8.6051,9.4746 7.7591,10.3216 7.7591,11.3616 C7.7591,12.4016 8.6051,13.2466 9.6451,13.2466 C10.6851,13.2466 11.5311,12.4016 11.5311,11.3616 C11.5311,10.3216 10.6851,9.4746 9.6451,9.4746 Z" id="Combined-Shape"></path>
        </g>
        </g>
</svg>'''
                            : '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Light/Danger Triangle</title>
    <g id="Iconly/Light/Danger-Triangle" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round">
        <g id="Danger-Triangle" transform="translate(2.000000, 3.000000)" stroke="#000000">
            <path d="M2.814,17.4368 L17.197,17.4368 C18.779,17.4368 19.772,15.7268 18.986,14.3528 L11.8,1.7878 C11.009,0.4048 9.015,0.4038 8.223,1.7868 L1.025,14.3518 C0.239,15.7258 1.231,17.4368 2.814,17.4368 Z" id="Stroke-1" stroke-width="1.5"></path>
            <line x1="10.0025" y1="10.4148" x2="10.0025" y2="7.3148" id="Stroke-3" stroke-width="1.5"></line>
            <line x1="9.995" y1="13.5" x2="10.005" y2="13.5" id="Stroke-2" stroke-width="2"></line>
        </g>
    </g>
</svg>''',
                        color: CustomColors(context).primaryColor),
                  )));
  }
}
