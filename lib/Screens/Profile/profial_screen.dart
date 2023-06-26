import 'dart:convert';
import 'package:anime_mont_test/Screens/Posts/posts_user.dart';
import 'package:anime_mont_test/Screens/Profile/bio_sec.dart';
import 'package:anime_mont_test/Screens/Profile/profile_app_bar.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/provider/user_model.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:anime_mont_test/widgets/alart_internet.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfialPage extends StatefulWidget {
  const ProfialPage(
      {super.key,
      required this.id,
      required this.isMyProfile,
      required this.myId});
  final int id;
  final int myId;
  final bool isMyProfile;
  @override
  State<ProfialPage> createState() => _ProfialPageState();
}

class _ProfialPageState extends State<ProfialPage>
    with SingleTickerProviderStateMixin {
  static Future<List<Anime2>>? anime;
  UserProfial? account;
  UserProfial? profail;

  bool offline = false;

  late int myId;
  bool error = false;
  bool loading = false;
  bool done = false;
  getAccount() async {
    setState(() {
      error = false;
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //print("wwwwww    widget.id    wwwwwww${widget.id}");
    String? userPref = prefs.getString('userData');
    final body = json.decode(userPref!);
    account = UserProfial.fromJson(body);
    final user = json.decode(userPref!);
    myId = int.parse(user['id'].toString());

    final response = (await http.post(Uri.parse(my_profail), body: {
      "my_id": myId.toString(),
      "f_id": '${widget.id}'
    }).catchError((e) {
      loading = false;

      setState(() {});
      if (widget.isMyProfile) {
        setState(() {});
        String? userPref = prefs.getString('userData');
        final body = json.decode(userPref!);
        profail = UserProfial.fromJson(body);
      } else
        error = true;

      return Response('jjj', 200);
    }).then((value) {
      final body = json.decode(value.body);

      print('body ${body.toString()}');
      if (widget.isMyProfile) {
        UserModel.setAcount(body);
      }
      setState(() {
        profail = UserProfial.fromJson(body);
        loading = false;

        done = true;
      });
    }));
  }

  // complete() async {
  //   await response.whenComplete(() => done = true);
  //   setState(() {});
  //   var result = await response.timeout(const Duration(seconds: 2));
  //   print('tttttttttttt $result');
  //   var e =  response.catchError.toString();
  //   print('eeeee$e');
  // }

  @override
  void initState() {
    super.initState();
    //anime = getAnime(139);
    getAccount();
  }

  Future refresh() async {
    getAccount();
  }

  selectPage(Size size) {
    if (error) {
      return AlartInternet(onTap: () {
        loading ? null : getAccount();
      });
    } else if (!loading && !error) {
      return RefreshIndicator(
        onRefresh: refresh,
        child: Profial(
          profail: profail!,
          myId: myId,
          myProfile: widget.isMyProfile ? true : false,
          size: size,
          account: account!,
        ),
      );
    } else if (loading) {
      return LoadingGif(
        logo: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(extendBodyBehindAppBar: true, body: selectPage(size));
    // backgroundColor: Colors.pink,
  }
}

class Profial extends StatefulWidget {
  Profial({
    required this.account,
    Key? key,
    required this.size,
    required this.myId,
    required this.myProfile,
    required this.profail,
  }) : super(key: key);
  final UserProfial account;
  final UserProfial profail;

  final Size size;
  final bool myProfile;
  final int myId;
  @override
  State<Profial> createState() => _ProfialState();
}

class _ProfialState extends State<Profial> {
  InterstitialAd? myInterstitialAd;

  late final AnimationController _animationController;
  Future refresh() async {
    await SharedPreferences.getInstance().then((value) {
      value.setInt('index', 4);
      // widget.pageController.animateToPage(0,
      //     duration: const Duration(microseconds: 200), curve: Curves.easeIn);

      Navigator.restorablePushReplacementNamed(context, '/Home');
    });
  }

  Color _colors = Colors.black;
  getColor(String link) async {
    var paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(image + link),
    );
    _colors = paletteGenerator.dominantColor!.color;
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool down = true;
  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    final profail = widget.profail;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: customColors.backgroundColor,
          expandedHeight: 250,
          toolbarHeight: 50,
          title: null,
          //floating: ,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            expandedTitleScale: 1,
            centerTitle: true,
            collapseMode: CollapseMode.parallax,
            background: ProfileAppBar(
                account: widget.account,
                myId: '${widget.myId}',
                profail: profail,
                myProfile: widget.myProfile),
            title: Name(profail: profail),
          ),
        ),

        SliverToBoxAdapter(
          child: BioSec(
            profile: profail,
            myId: '${widget.myId}',
          ),
        ),
        SliverToBoxAdapter(
            child:
                PostsUserPage(myId: widget.myId, userId: int.parse(profail.id)))
        //SliverToBoxAdapter(child: PostsFrendsPage()),

        ///%0D%0A
      ],
    );
  }
}

class Name extends StatelessWidget {
  const Name({
    Key? key,
    required this.profail,
  }) : super(key: key);

  final UserProfial profail;

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        //vertical: 10,
        horizontal: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '@${profail.userName.toLowerCase()}',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: customColors.primaryColor,
                fontFamily:
                    context.localeString('en') == 'en' ? 'Angie' : 'SFPro'),
          ),
          // GestureDetector(
          //     child: Container(
          //       height: 30,
          //       child: ImageIcon(
          //         AssetImage('images/Light/More-Circle.png'),
          //         color: Colors.grey,
          //       ),
          //     ),
          //     onTap: () {
          //       ShowSheet.custShowMenu(context, profail);
          //     }),
        ],
      ),
    );
  }
}

//  Container(
//   // decoration: BoxDecoration(
//   //     gradient: LinearGradient(
//   //         begin: Alignment.topCenter,
//   //         end: Alignment.bottomCenter,
//   //         colors: [
//   //       // Colors.black,
//   //       // Colors.black,
//   //       // Colors.black,
//   //     ])),
//   child: ListView(children: [
//     Container(
//       // decoration: BoxDecoration(
//       //     gradient: LinearGradient(
//       //         begin: Alignment.topCenter,
//       //         end: Alignment.bottomCenter,
//       //         colors: [Colors.pink, Colors.black])),

//       child: Column(
//         children: [
//           Container(
//             height: 280,
//             child: Stack(
//               children: [
//                 Container(
//                   height: 250,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                         image:
//                             NetworkImage(image + profail.backGroung),
//                         fit: BoxFit.cover),
//                     //color: Color.fromARGB(255, 0, 83, 79),
//                     borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(20),
//                         bottomRight: Radius.circular(20)),
//                     border: Border.all(
//                         width: 3, color: _colors.withOpacity(.2)),
//                   ),
//                 ),
//                 Positioned(
//                     top: 130,
//                     left: widget.size.width / 3.2,
//                     right: widget.size.width / 3.2,
//                     height: 150,
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => ChatPage(
//                                     avatar: profail.avatar)));
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                             //color: Color.fromARGB(0, 209, 14, 0),
//                             image: DecorationImage(
//                                 image: NetworkImage(
//                                     image + profail.avatar),
//                                 fit: BoxFit.cover),
//                             borderRadius: BorderRadius.circular(25),
//                             border: Border.all(
//                                 width: 5,
//                                 color: _colors.withOpacity(.2))),
//                       ),
//                     ))
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 5.0),
//             child: Text(
//               '${profail.name.toUpperCase()}',
//               style: TextStyle(
//                   // color: Colors.grey.shade600,
//                   fontSize: 25,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//           Text(
//             '@${profail.userName}',
//             //style: TextStyle(color: Colors.grey, fontSize: 18),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Column(
//                 children: [
//                   Text(
//                     '${profail.followers}',
//                     // style:
//                     //     TextStyle(color: Colors.grey, fontSize: 16),
//                   ),
//                   Text(
//                     'followers',
//                     // style:
//                     //     TextStyle(color: Colors.grey, fontSize: 16),
//                   ),
//                 ],
//               ),
//               Column(
//                 children: [
//                   Text(
//                     '${profail.following}',
//                     // style:
//                     //     TextStyle(color: Colors.grey, fontSize: 16),
//                   ),
//                   Text(
//                     'Anime Watch',
//                     // style:
//                     //     TextStyle(color: Colors.grey, fontSize: 16),
//                   ),
//                 ],
//               ),
//               Column(
//                 children: [
//                   Text(
//                     '${profail.following}',
//                     style:
//                         TextStyle(color: Colors.grey, fontSize: 16),
//                   ),
//                   Text(
//                     'following',
//                     // style:
//                     //     TextStyle(color: Colors.grey, fontSize: 16),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Icon(
//                   Icons.emoji_emotions,
//                 ),
//                 Icon(Icons.emoji_flags_sharp),
//                 Icon(Icons.emoji_events)
//               ]),
//           ExpansionTile(
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "        Bio",
//                   textAlign: TextAlign.end,
//                   style: TextStyle(
//                       fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(
//                   width: 5,
//                 ),
//                 Center(
//                     child: down
//                         ? ImageIcon(
//                             AssetImage(
//                                 'images/Light/Arrow - Up 2.png'),
//                             size: 18,
//                           )
//                         : ImageIcon(
//                             AssetImage(
//                                 'images/Light/Arrow - Down 2.png'),
//                             size: 18,
//                           )),
//               ],
//             ),
//             trailing: Icon(
//               Icons.abc,
//               // color: Colors.transparent,
//             ),
//             onExpansionChanged: (value) => setState(
//               () => value ? down = false : down = true,
//             ),
//             // collapsedTextColor: Colors.grey,
//             // collapsedIconColor: Colors.grey,
//             children: [
//               Text(
//                 "HTTP request failed, statusCode: 404, https://montchat0.000webhostapp.com/Flutter_PHP_Tutorial/upload/images/avatar.jpg",
//                 style: TextStyle(
//                     //      color: Color.fromARGB(218, 131, 131, 131),
//                     fontSize: 18,
//                     fontWeight: FontWeight.w300),
//               ),
//             ],
//           )
//         ],
//       ),
//     ),
//     // Titel(size: size, title: "Favorite"),
//     // AnimeScrollView2(size: size),
//     Titel(size: widget.size, title: "Continue Watching"),
//     AnimeScrollView(size: widget.size),
//   ]),
// );

class Anime2 {
  final int id;
  final int animeId;
  final int userId;
  final String animeName;
  final String animePoster;
  Anime2(
    this.id,
    this.animeId,
    this.userId,
    this.animeName,
    this.animePoster,
  );
  static Anime2 fromJson(json) => Anime2(
        json['id'],
        json['anime_id'],
        json['user_id'],
        json['anime_name'],
        json['anime_poster'],
      );
}

class ShowSheet {
  static custShowMenu(BuildContext context, var profail) async {
    return await showModalBottomSheet<dynamic>(
        backgroundColor: Colors.red,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          Size size = MediaQuery.of(context).size;
          return profail.avatar.isNotEmpty
              ? DraggableScrollableSheet(
                  initialChildSize: 0.7,
                  minChildSize: 0.3,
                  builder: (context, scrollController) => Container(
                      color: Colors.cyan,
                      child: ListView(
                        controller: scrollController,
                        children: <Widget>[
                          Container(
                            height: size.height,
                            padding: const EdgeInsets.only(top: 10),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25))),
                          ),
                        ],
                      )))
              : Container();
        });
  }
}

class UserInfo extends StatefulWidget {
  const UserInfo({
    Key? key,
    required this.list,
    required this.isLink,
    required this.color,
  }) : super(key: key);
  final bool isLink;
  final List<dynamic> color;
  final Map<String, dynamic> list;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  // State<Category> createState() => _CategoryState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: widget.list.entries.map((e) {
          return GestureDetector(
            onTap: () {
              // widget.isLink == true
              //     ? Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => AllAnime(
              //                 genre: e.value
              //                     .replaceAll(' ', '+')
              //                     .replaceAll('-', '+'),
              //                 headLine: e.value)))
              //     : true;
            },
            child: GestureDetector(
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                    gradient: widget.isLink != true
                        ? LinearGradient(colors: [
                            widget.color[0].withOpacity(0.5),
                            widget.color[0]
                          ])
                        : LinearGradient(colors: [
                            widget.color[1],
                            widget.color[1].withOpacity(0.5)
                          ]),
                    borderRadius: widget.isLink == true
                        ? BorderRadius.circular(13)
                        : BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '${e.value.trim()}',
                    style: TextStyle(
                        fontFamily:
                            Locales.currentLocale(context).toString() == 'en'
                                ? 'Angie'
                                : 'SFPro',
                        color: widget.isLink != true
                            ? widget.color[1]
                            : widget.color[0],
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
