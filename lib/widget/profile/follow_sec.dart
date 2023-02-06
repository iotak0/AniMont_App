import 'dart:convert';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:http/http.dart' as http;
import '../../provider/user_model.dart';
import '../../server/inters_ad.dart';

class FollowSec extends StatefulWidget {
  const FollowSec({
    Key? key,
    required this.isEn,
    required this.profile,
    required this.myId,
  }) : super(key: key);
  final bool isEn;
  final String myId;
  final UserProfial profile;

  @override
  State<FollowSec> createState() => _FollowSecState();
}

class _FollowSecState extends State<FollowSec> {
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconTheme = Theme.of(context).iconTheme.color!;
    final Color textColor = Color.fromARGB(255, 160, 146, 167);
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color bottomUp = Theme.of(context).primaryColorDark;
    final Color bottomDown = Theme.of(context).primaryColorLight;
    final Size _size = MediaQuery.of(context).size;
    String followBool = '';
    if (widget.profile.imfollowing) {
      followBool = 'unfollow';
    }
    if (widget.profile.imfollowing == false) {
      followBool = 'follow';
    }
    if (widget.profile.id == widget.myId) {
      followBool = 'edite';
    }

    follow() async {
      MyntersAd();
      var response = await http.post(Uri.parse(add_Follow), body: {
        "my_id": widget.myId.toString(),
        "f_id": widget.profile.id.toString()
      });
      final body = json.decode(response.body);
      if (body['status'] == 'success') {
        setState(() {
          followBool = 'unfollow';
        });
        setState(() {});
        print('body ${body.toString()}');
      }
    }

    unFollow() async {
      var response = await http.post(Uri.parse(un_Follow), body: {
        "my_id": widget.myId.toString(),
        "f_id": widget.profile.id.toString()
      });
      final body = json.decode(response.body);
      if (body['status'] == 'success') {
        setState(() {
          followBool = 'follow';
        });
      }
      print('body ${body.toString()}');
    }

    editProfile() async {
      // var response = await http.post(Uri.parse(my_account_link), body: {
      //   "my_id": widget.myId.toString(),
      //   "f_id": widget.myId.toString()
      // });

      // final body = json.decode(response.body);
      // print('body ${body.toString()}');
    }

    return widget.isEn
        ? Positioned(
            top: 210,
            right: 20,
            width: _size.width / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      border: Border.all(width: .5, color: primaryColor),
                      borderRadius: BorderRadius.circular(50)),
                  child: ImageIcon(
                      AssetImage(
                        'images/Light/More Square.png',
                      ),
                      color: primaryColor),
                )),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    if (followBool == 'unfollow') {
                      unFollow()
                        ..then((value) => setState(() {
                              followBool = 'follow';
                            }));
                    } else {
                      setState(() {});
                    }
                    if (followBool == 'follow') {
                      follow()
                        ..then((value) => setState(() {
                              followBool == 'unfollow';
                            }));
                    } else {
                      setState(() {});
                    }
                    if (followBool == 'edite') {
                      editProfile()..then((value) => setState(() {}));
                    } else {
                      setState(() {});
                    }
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 30,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 3, 165, 97),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        context.localeString(followBool),
                        style: TextStyle(
                            fontFamily: 'Angie',
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ))
        : Positioned(
            top: 210,
            left: 20,
            width: _size.width / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      border: Border.all(width: .5, color: primaryColor),
                      borderRadius: BorderRadius.circular(50)),
                  child: ImageIcon(
                      AssetImage(
                        'images/Light/More Square.png',
                      ),
                      color: primaryColor),
                )),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    if (followBool == 'unfollow') {
                      unFollow()
                        ..then((value) => setState(() {
                              followBool = 'follow';
                            }));
                    } else {
                      setState(() {});
                    }
                    if (followBool == 'follow') {
                      follow()
                        ..then((value) => setState(() {
                              followBool == 'unfollow';
                            }));
                    } else {
                      setState(() {});
                    }
                    if (followBool == 'edite') {
                      editProfile()..then((value) => setState(() {}));
                    } else {
                      setState(() {});
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.centerRight,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 3, 165, 97),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        context.localeString(followBool),
                        style: TextStyle(
                            fontFamily: 'SFPro',
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ));
  }
}
