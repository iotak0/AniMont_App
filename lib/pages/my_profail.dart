import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:http/http.dart' as http;
import 'package:palette_generator/palette_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/user_model.dart';
import '../server/urls_php.dart';
import '../widget/profile/bio_sec.dart';
import '../widget/profile/follow_sec.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile>
    with SingleTickerProviderStateMixin {
  static Future<List<Anime2>>? anime;
  UserProfial? account;

  static Future<List<Anime2>> getAnime(int userId) async {
    final response = await http.post(Uri.parse('${my_anime_link}'), body: {
      "user_id": "${userId}",
    });
    final body = json.decode(response.body);

    return body.map<Anime2>(Anime2.fromJson).toList();
  }

  static bool offline = false;
  static var response;
  String? myId;
  getAccount() async {
    // try {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString('userData');
    final user = json.decode(userPref!);

    myId = user['id'].toString();

    setState(() {});

    response = await http.post(Uri.parse(my_account_link),
        body: {"my_id": myId.toString(), "f_id": myId.toString()});
    final body = json.decode(response.body);
    print('body ${body.toString()}');

    setState(() {
      account = UserProfial.fromJson(body);
      done = true;
      setState(() {});
    });
    // } catch (e) {
    //   offline = true;
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   String? userPref = prefs.getString('userData');
    //   final body = json.decode(userPref!);
    //   account = UserProfial.fromJson(body);
    //   done = true;
    //   setState(() {});
    // }
  }

  bool done = false;
  Done() async {
    await response.whenComplete(() => done = true);
    setState(() {});
    var result = await response.timeout(const Duration(seconds: 2));
    print('tttttttttttt $result');
    var e = await response.catchError.toString();
    print('eeeee$e');
  }

  @override
  void initState() {
    super.initState();
    //anime = getAnime(139);
    getAccount();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return
        // backgroundColor: Colors.pink,
        done == true
            ? Profial(
                myId: myId!,
                size: size,
                account: account!,
              )
            : Center(child: const CircularProgressIndicator());
  }
}

class Profial extends StatefulWidget {
  Profial({
    required this.account,
    Key? key,
    required this.size,
    required this.myId,
  }) : super(key: key);
  UserProfial account;
  final Size size;
  final String myId;
  @override
  State<Profial> createState() => _ProfialState();
}

class _ProfialState extends State<Profial> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  Color _colors = Colors.black;
  getColor(String link) async {
    var paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(image + link),
    );
    _colors = paletteGenerator.dominantColor!.color;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _animation = false;
  bool down = true;
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconTheme = Theme.of(context).iconTheme.color!;
    final Color textColor = Color.fromARGB(255, 160, 146, 167);
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color bottomUp = Theme.of(context).primaryColorDark;
    final Color bottomDown = Theme.of(context).primaryColorLight;
    final profail = widget.account;
    final birthday = DateTime.tryParse(profail.birthday);
    return Scaffold(
      // getColor(profail.backGroung);

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 320,
            toolbarHeight: 30,
            title: null,
            //floating: ,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1,
              centerTitle: true,
              collapseMode: CollapseMode.parallax,
              background: AppBar(myId: widget.myId, profail: profail),
              title: Name(profail: profail),
            ),
          ),
          BioSec(
            profail: profail,
            myId: widget.myId,
          )
        ],
      ),
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
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconTheme = Theme.of(context).iconTheme.color!;
    final Color textColor = Color.fromARGB(255, 160, 146, 167);
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color bottomUp = Theme.of(context).primaryColorDark;
    final Color bottomDown = Theme.of(context).primaryColorLight;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        //  margin: const EdgeInsets.only(bottom: 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '@${profail.userName.toLowerCase()}',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: Colors.grey,
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
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({
    Key? key,
    required this.profail,
    required this.myId,
  }) : super(key: key);

  final UserProfial profail;
  final String myId;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconTheme = Theme.of(context).iconTheme.color!;
    final Color textColor = Color.fromARGB(255, 160, 146, 167);
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color bottomUp = Theme.of(context).primaryColorDark;
    final Color bottomDown = Theme.of(context).primaryColorLight;
    String bgImage = '';
    if (profail.backGroung.startsWith("http")) {
      bgImage = profail.backGroung;
    } else {
      bgImage = image2 + profail.backGroung.toString();
    }
    return Container(
      height: 350,
      child: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(bgImage), fit: BoxFit.cover),
              // color: Color.fromARGB(255, 0, 83, 79),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              border: Border.all(
                width: 2,
                color: backgroundColor,
              ),
            ),
          ),

          NameSec(
              profail: profail,
              isEn: context.currentLocale.toString() == 'en' ? true : false),
          FollowSec(
              myId: myId,
              profile: profail,
              isEn: context.currentLocale.toString() == 'en' ? true : false),
          Avatar(
              profail: profail,
              isEn: context.currentLocale.toString() == 'en' ? true : false),
          // Padding(
          //   padding: const EdgeInsets.only(top: 5.0),
          //   child: ArrowBackButton(
          //     size: MediaQuery.of(context).size,
          //   ),
          // )
        ],
      ),
    );
  }
}

class NameSec extends StatelessWidget {
  const NameSec({
    Key? key,
    required this.profail,
    required this.isEn,
  }) : super(key: key);
  final bool isEn;
  final UserProfial profail;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconTheme = Theme.of(context).iconTheme.color!;
    final Color textColor = Color.fromARGB(255, 160, 146, 167);
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color bottomUp = Theme.of(context).primaryColorDark;
    final Color bottomDown = Theme.of(context).primaryColorLight;
    return isEn
        ? Positioned(
            height: 52,
            top: 250,
            left: 20,
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  //alignment: Alignment.centerLeft,

                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    profail.name.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: context.localeString('en') == 'en'
                            ? 'Angie'
                            : 'SFPro'),
                  ),
                ),
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  // child: Text(
                  //   '@${profail.userName.toLowerCase()}',
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.w400,
                  //       fontSize: 15,
                  //       fontFamily: context.localeString('en') == 'en'
                  //           ? 'Angie'
                  //           : 'SFPro'),
                  // ),
                )
              ],
            ))
        : Positioned(
            height: 52,
            top: 250,
            right: 20,
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  //alignment: Alignment.centerLeft,

                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    profail.name.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: context.localeString('en') == 'en'
                            ? 'Angie'
                            : 'SFPro'),
                  ),
                ),
                // Container(
                //   width: 200,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(25),
                //   ),
                //   child: Text(
                //     '@${profail.userName.toLowerCase()}',
                //     style: TextStyle(
                //         fontWeight: FontWeight.w400,
                //         fontSize: 15,
                //         fontFamily: context.localeString('en') == 'en'
                //             ? 'Angie'
                //             : 'SFPro'),
                //   ),
                // )
              ],
            ));
  }
}

class Avatar extends StatelessWidget {
  const Avatar({
    Key? key,
    required this.profail,
    required this.isEn,
  }) : super(key: key);
  final bool isEn;
  final UserProfial profail;

  @override
  Widget build(BuildContext context) {
    String avatar = '';
    if (profail.avatar.startsWith("http")) {
      avatar = profail.avatar;
    } else {
      avatar = image2 + profail.avatar.toString();
    }

    return isEn
        ? Positioned(
            top: 100,
            left: 10,
            width: 125,
            height: 135,
            child: GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             ChatPage(avatar: profail.avatar)));
              },
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                      decoration: BoxDecoration(
                    // color: Color.fromARGB(0, 209, 14, 0),
                    image: DecorationImage(
                        image: AssetImage(
                          'images/3q62.gif',
                        ),
                        onError: (exception, stackTrace) => print('hhhh'),
                        //invertColors: true,
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(100),
                    // border: Border.all(
                    //   width: 2,
                    // color: widget.color[0],
                  )),
                  // ),
                  Positioned(
                    width: 90,
                    height: 90,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          // color: Color.fromARGB(0, 209, 14, 0),
                          image: DecorationImage(
                              image: NetworkImage(
                                avatar,
                              ),
                              onError: (exception, stackTrace) => print('hhhh'),
                              //invertColors: true,
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(100
                              // border: Border.all(
                              //   width: 2,
                              // color: widget.color[0],
                              )),
                    ),
                  ),
                ],
              ),
            ))
        : Positioned(
            top: 145,
            right: 20,
            width: 100,
            height: 100,
            child: GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             ChatPage(avatar: profail.avatar)));
              },
              child: Container(
                decoration: BoxDecoration(
                    // color: Color.fromARGB(0, 209, 14, 0),
                    image: DecorationImage(
                        image: NetworkImage(avatar), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      width: 2,
                      // color: widget.color[0],
                    )),
              ),
            ));
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
