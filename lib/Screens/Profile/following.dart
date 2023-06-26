import 'dart:convert';
import 'package:anime_mont_test/Screens/Profile/profial_screen.dart';
import 'package:anime_mont_test/Screens/signup&login/edit_account.dart';
import 'package:anime_mont_test/helper/constans.dart';
import 'package:anime_mont_test/widgets/alart.dart';
import 'package:anime_mont_test/widgets/alart_internet.dart';
import 'package:anime_mont_test/widgets/custom_listTile.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/provider/user_model.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Followings extends StatefulWidget {
  final String myId;
  const Followings({super.key, required this.myId});

  @override
  State<Followings> createState() => _FollowingsState();
}

class _FollowingsState extends State<Followings> {
  late ScrollController _scrollController;
  final int _maxLength = 15;
  bool isLoading = false;
  bool hasErorr = false;
  bool hasMore = true;
  bool done = false;
  int page = 1;
  List<UserProfial> users = [];
  UserProfial? account;
  getMyAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userPref = prefs.getString('userData');
    final body = json.decode(userPref!);
    account = UserProfial.fromJson(body);
  }

  getUsers() async {
    setState(() {
      isLoading = true;
      hasErorr = false;
    });
    Response response = await http
        .get(Uri.parse("$following?my_id=${widget.myId}&page=$page"))
        .catchError((error) {
      isLoading = false;
      hasErorr = true;
      setState(() {});
      return Response('error', 400);
    });
    if (response.statusCode == 200) {
      var data;
      try {
        data = jsonDecode(response.body);
      } catch (e) {
        setState(() {
          done = true;
          isLoading = false;
        });
      }
      data != null ? page++ : page;
      for (var e in data) {
        users.add(UserProfial.fromJson(e));
      }
      setState(() {
        isLoading = false;

        hasMore = (data.length >= _maxLength) ? true : false;
      });
    } else {
      setState(() {
        hasErorr = true;
        isLoading = false;
      });
    }
    done = true;
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    page = 1;

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    getUsers();

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.95 &&
          !isLoading &&
          hasMore) {
        getUsers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColor = CustomColors(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: LocaleText(
            'following',
            style: TextStyle(
                fontFamily: 'SFPro',
                fontWeight: FontWeight.bold,
                color: customColor.primaryColor),
          ),
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: customColor.primaryColor,
            ),
          ),
          backgroundColor: customColor.backgroundColor,
          elevation: 1,
        ),
        body: RefreshIndicator(
            onRefresh: () => getUsers(),
            child: (isLoading && !hasErorr && users.isEmpty)
                ? LoadingGif(logo: true,)
                : (hasErorr && users.isEmpty)
                    ? AlartInternet(onTap: () => isLoading ? null : getUsers())
                    : (done && users.isEmpty)
                        ? Alart(body: 'no_users_found', icon: noUsers)
                        : ListView.separated(
                            controller: _scrollController,
                            itemCount: users.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 10,
                                ),
                            itemBuilder: (context, index) {
                              bool isFollowed = true;
                              bool following = false;
                              users[index].avatar = users[index]
                                      .avatar
                                      .toString()
                                      .startsWith('http')
                                  ? users[index].avatar
                                  : image + users[index].avatar;
                              try {
                                if (account!.id != users[index].id) {
                                  CachedNetworkImage.evictFromCache(
                                      users[index].avatar);
                                }
                                //
                              } catch (e) {}
                              if (index == users.length - 1 &&
                                  isLoading &&
                                  users.isNotEmpty) {
                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      CustomLListTile(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfialPage(
                                                        myId: int.parse(
                                                            widget.myId),
                                                        id: int.parse(
                                                            users[index].id),
                                                        isMyProfile: false))),
                                        body: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              users[index].name.toString(),
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  fontSize: 16.5,
                                                  color:
                                                      customColor.primaryColor),
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              users[index].userName.toString(),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color:
                                                      customColor.primaryColor),
                                            ),
                                          ],
                                        ),
                                        trailing: GestureDetector(
                                          onTap: () async {
                                            if (!following) {
                                              following = true;
                                              setState(() {});
                                              if (isFollowed) {
                                                // final value =
                                                //     await UserModel.unFollow(
                                                //         widget.myId
                                                //             .toString(),
                                                //         post.userId
                                                //             .toString());
                                                // setState(() {
                                                //   isFollowed = value
                                                //       ? value
                                                //       : false;
                                                //   following = false;
                                                // });
                                              } else {
                                                following = true;
                                                setState(() {});

                                                await UserModel.follow(
                                                        widget.myId.toString(),
                                                        users[index]
                                                            .id
                                                            .toString())
                                                    .then((value) {
                                                  setState(() {
                                                    if (value) {
                                                      isFollowed = true;
                                                    } else {}
                                                    following = false;
                                                  });
                                                });
                                              }
                                            }
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: isFollowed
                                                    ? Colors.transparent
                                                    : customColor.bottomDown),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0,
                                                      vertical: 2),
                                              child: following
                                                  ? SizedBox(
                                                      height: 30,
                                                      width: 30,
                                                      child: LoadingGif(logo: false,),
                                                    )
                                                  : isFollowed
                                                      ? SizedBox()
                                                      : LocaleText(
                                                          'follow',
                                                          style: TextStyle(
                                                            fontFamily: 'SFPro',
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                            ),
                                          ),
                                        ),
                                        icon: users[index].avatar,
                                      ),
                                      LoadingGif(logo: false,)
                                    ]);
                              }
                              return CustomLListTile(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfialPage(
                                            myId: int.parse(widget.myId),
                                            id: int.parse(users[index].id),
                                            isMyProfile: false))),
                                body: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      users[index].name.toString(),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 16.5,
                                          color: customColor.primaryColor),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      users[index].userName.toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: customColor.primaryColor),
                                    ),
                                  ],
                                ),
                                trailing: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (!following) {
                                          following = true;
                                          setState(() {});
                                          if (isFollowed) {
                                          } else {
                                            following = true;
                                            setState(() {});

                                            await UserModel.follow(
                                                    widget.myId.toString(),
                                                    users[index].id.toString())
                                                .then((value) {
                                              setState(() {
                                                if (value) {
                                                  isFollowed = true;
                                                } else {}
                                                following = false;
                                              });
                                            });
                                          }
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: isFollowed
                                                ? Colors.transparent
                                                : customColor.bottomDown),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 2),
                                          child: following
                                              ? SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child: LoadingGif(logo: false,),
                                                )
                                              : isFollowed
                                                  ? SizedBox()
                                                  : LocaleText(
                                                      'follow',
                                                      style: TextStyle(
                                                        fontFamily: 'SFPro',
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                        ),
                                      ),
                                    )),
                                icon: users[index].avatar,
                              );
                            })));
  }
}
