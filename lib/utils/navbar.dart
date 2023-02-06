import 'dart:convert';

import 'package:anime_mont_test/provider/nav_bar.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  final PageController pageController;

  const NavBar({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int idx = 2;
  String avatar = '';

  getIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      idx = prefs.getInt('index')!;
    } catch (e) {
      idx = 0;
    }
    String? userPref = prefs.getString('userData');
    final user = json.decode(userPref!);
    try {
      if (user['avatar'].toString().startsWith("https")) {
        avatar = user['avatar'];
      } else {
        avatar = image2 + user['avatar'].toString();
      }
    } catch (e) {
      avatar = image2 + 'avatar.jpg';
    }

    print(idx);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(() {
      getIndex();
      print('object');
    });
    getIndex();
  }

  @override
  Widget build(BuildContext context) {
    final Color bottomUp = Theme.of(context).primaryColor;

    final Color bottomDown = Theme.of(context).primaryColorLight;

    return Align(
      child: Column(
        children: [
          Container(
            height: .5,
            width: double.infinity,
            color: Colors.grey,
          ),
          Container(
            height: 50,
            child: Row(
                children: List.generate(
              itemNavBarList.length,
              (index) {
                return Expanded(
                    child: ValueListenableBuilder<int>(
                        valueListenable: ValueNotifier<int>(idx),
                        builder: (_, value, __) {
                          return GestureDetector(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await getIndex();
                              prefs.setInt('index', index);
                              await getIndex();
                              print(prefs.getInt('index').toString());
                              widget.pageController.animateToPage(index,
                                  duration: const Duration(microseconds: 200),
                                  curve: Curves.easeIn);
                              setState(() {});
                            },
                            child: Material(
                              color: Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: (index == idx) ? 38 : 32,
                                    width: (index == idx) ? 38 : 32,
                                    child: index != 4
                                        ? Image.asset(
                                            itemNavBarList[index].image,
                                            color: (index == idx)
                                                ? bottomDown
                                                : bottomUp,
                                          )
                                        : CircleAvatar(
                                            backgroundColor: (index == idx)
                                                ? bottomDown
                                                : bottomUp,
                                            child: CircleAvatar(
                                              radius: (index == idx) ? 17 : 15,
                                              backgroundImage:
                                                  NetworkImage(avatar),
                                            ),
                                          ),
                                  ),
                                  SizedBox(
                                    height: 0,
                                  ),
                                  // Text(
                                  //   itemNavBarList[index].name,
                                  //   style: TextStyle(
                                  //     color:
                                  //         (index == value) ? bottomDown : bottomUp,
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                          );
                        }));
              },
            )),
          ),
        ],
      ),
    );
  }
}
