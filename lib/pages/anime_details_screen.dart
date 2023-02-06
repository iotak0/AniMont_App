import 'dart:convert';

import 'package:anime_mont_test/pages/all_anime.dart';
import 'package:anime_mont_test/pages/anime_player.dart';
import 'package:anime_mont_test/pages/chat.dart';
import 'package:anime_mont_test/utils/anime_scrollview.dart';
import 'package:anime_mont_test/utils/buttons/arrow_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../server/urls_php.dart';
import 'genres_page.dart';
import 'home_page.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class AnimeDetailsScreen extends StatefulWidget {
  final String url;
  const AnimeDetailsScreen({super.key, required this.url});

  @override
  State<AnimeDetailsScreen> createState() => AnimeDetailsScreenState();
}

class AnimeDetailsScreenState extends State<AnimeDetailsScreen>
    with SingleTickerProviderStateMixin {
  List<Anime2> anime = [];
  static late List allEPName;
  var color = [
    Colors.black,
    Colors.white,
  ];

  getColor(String link) async {
    var paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(link),
    );
    setState(() {
      color[0] = paletteGenerator.darkVibrantColor!.color.toString().isNotEmpty
          ? paletteGenerator.darkVibrantColor!.color
          : Colors.black;
      color[1] = paletteGenerator.lightVibrantColor!.color.toString().isNotEmpty
          ? paletteGenerator.lightVibrantColor!.color
          : Colors.white;
    });
  }

  Future getAnime(String link) async {
    final url = Uri.parse(link);
    final response = await http.get(url);
    dom.Document html = dom.Document.html(utf8.decode(response.bodyBytes));
    final backgroundImage = html
        .querySelectorAll('div.bixbox.animefull > div.bigcover > div > img')
        .map((e) => e.attributes['src']!)
        .toString();
    final poster = html
        .querySelectorAll(' div.thumbook > div.thumb > img')
        .map((e) => e.attributes['src']!)
        .toString();
    final name = html
        .querySelectorAll(' div.infox > h1')
        .map((e) => e.innerHtml.trim())
        .toString();
    final rating = html
        .querySelectorAll(
            ' div.thumbook > div.rt > div.rating > div > meta:nth-child(1)')
        .map((e) => e.attributes['content']!)
        .toString();
    final info = html
        .querySelectorAll(
            'div.bixbox.animefull > div.bigcontent > div.infox > div > div.info-content > div.spe > span (text)')
        .map((e) => e.innerHtml.trim())
        .toList();
    List<String> infoList = [];
    for (int i = 0; i < info.length; i++) {
      String urlLast = info[i];
      try {
        urlLast = info[i].substring(
                info[i].indexOf('<b>') + 3, info[i].indexOf('</b>')) +
            info[i].substring(
                info[i].indexOf('"updated">') + 10, info[i].indexOf('</time>'));
      } catch (e) {
        print(e);
      }
      try {
        urlLast = info[i].substring(
                info[i].indexOf('<b>') + 5, info[i].indexOf('</b>')) +
            info[i].substring(
                info[i].indexOf('"tag"') + 6, info[i].indexOf('</a>'));
      } catch (e) {
        print(e);
      }
      if (info[i].isNotEmpty) {
        infoList.add(urlLast.replaceAll('<b>', '').replaceAll('</b>', ''));
      }
      print(
          'info //////// ${urlLast.replaceAll('<b>', '').replaceAll('</b>', '')}');
    }

    final category = html
        .querySelectorAll(
            ' div.infox > div > div.info-content > div.genxed > a')
        .map((e) => e.innerHtml.trim())
        .toList();
    final description = html
        .querySelectorAll(' div.entry-content > p')
        .map((e) => e.innerHtml.trim())
        .toString();
    try {
      var description2 = description.substring(
          description.indexOf('">') + 2, description.indexOf('</a>'));
      print('description2 $description2');
      //    +
      // description.substring(
      //     description.indexOf('"updated">') + 10, description.indexOf('</time>'));
    } catch (e) {
      print(e);
    }
    var youtube = '';
    try {
      youtube = html
          .querySelectorAll(
              'div.bixbox.animefull > div.bigcontent > div.thumbook > div.rt > a')
          .map((e) => e.attributes['href']!)
          .toString();
    } catch (e) {}

    final epLink = html
        .querySelectorAll(' div.eplister > ul > li > a')
        .map((e) => e.attributes['href']!)
        .toList();
    final epNum = html
        .querySelectorAll('div.eplister > ul > li > a > div.epl-num')
        .map((e) => e.innerHtml.trim())
        .toList();

    setState(() {
      anime.add(Anime2(
          name.replaceAll('(', '').replaceAll(')', ''),
          poster.replaceAll('(', '').replaceAll(')', ''),
          backgroundImage
              .replaceAll('(', '')
              .replaceAll(')', '')
              .replaceAll('i0.wp.com/', '')
              .replaceAll('i1.wp.com/', '')
              .replaceAll('i2.wp.com/', '')
              .replaceAll('i3.wp.com/', '')
              .replaceAll('i4.wp.com/', '')
              .replaceAll('i5.wp.com/', '')
              .replaceAll('i6.wp.com/', '')

              //https://i2.wp.com/animetitans.comhttps://animetitans.com/wp-content/
              // https://animetitans.com/wp-content//Blue-Lock-
              .replaceAll("/wp-content/", "https://animetitans.com/wp-content/")
              .replaceAll(
                  'https://animetitans.comhttps://animetitans.com/wp-content/',
                  'https://animetitans.com/wp-content/'),
          description.replaceAll('(', '').replaceAll(')', ''),
          rating.replaceAll('(', '').replaceAll(')', ''),
          youtube.replaceAll('(', '').replaceAll(')', ''),
          category,
          infoList));
      setState(() {
        getColor(anime[0].animePoster);
      });
    });
    print('pppppppppppppppppppppppppppppppppp$youtube');
  }

  @override
  void initState() {
    getAnime(widget.url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: anime.isNotEmpty
          ? Profial(
              color: color,
              link: widget.url,
              size: size,
              anime: anime[0],
            )
          : Center(child: const CircularProgressIndicator()),
    );
  }
}

class Profial extends StatefulWidget {
  Profial({
    required this.anime,
    Key? key,
    required this.size,
    required this.link,
    required this.color,
  }) : super(key: key);
  Anime2 anime;
  final Size size;
  final List<dynamic> color;
  final String link;

  @override
  State<Profial> createState() => _ProfialState();
}

class _ProfialState extends State<Profial> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  List<Episode> allEp = [];
  Future getEpisode() async {
    final url = Uri.parse(widget.link);
    final response = await http.get(url);
    dom.Document html = dom.Document.html(utf8.decode(response.bodyBytes));
    try {
      final allEPUrl1 = html
          .querySelectorAll(' div.eplister > ul > li > a')
          .map((e) => e.attributes['href']!)
          .toList();
      final allEPNumber1 = html
          .querySelectorAll('div.eplister > ul > li > a > div.epl-num')
          .map((e) => e.innerHtml.trim())
          .toList();
      final allEPName1 = html
          .querySelectorAll('div.eplister > ul > li > a > div.epl-title')
          .map((e) => e.innerHtml.trim())
          .toList();
      final allEPSub1 = html
          .querySelectorAll(' div.eplister > ul > li > a > div.epl-date')
          .map((e) => e.innerHtml.trim())
          .toList(); //#dwnLinks > b:nth-child(1)
      print("test 999 ${allEPUrl1[0]}");
      setState(() {
        List.generate(
            allEPNumber1.length,
            (index) => allEp.add(Episode(allEPName1[index], allEPSub1[index],
                allEPUrl1[index], allEPNumber1[index])));
      });

      i = allEPName1.length;
      // plus = i;

      print("${allEp[0].link}");
    } catch (e) {
      print("Loading Error $e");
    }
  }

  ScrollController epController = ScrollController();
  YoutubePlayerController youtubeController =
      YoutubePlayerController(initialVideoId: '');
  youTube(animeYoutube) async {
    youtubeController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(animeYoutube).toString(),
      flags: YoutubePlayerFlags(
          captionLanguage: 'ar',
          autoPlay: false,
          enableCaption: true,
          mute: false,
          disableDragSeek: true),
    );
  }

  int i = 0;
  // int plus = 0;
  // fetch() async {
  //   setState(() {
  //     i += plus;
  //   });
  // }

  getI() {}
  @override
  void initState() {
    getEpisode();
    //fetch();
    epController.addListener(() {
      if (epController.position.maxScrollExtent == epController.offset / 5) {
        // fetch();
      }
    });
    super.initState();
    youTube(widget.anime.animeYoutube);
    _animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    youtubeController.dispose();
    super.dispose();
  }

  bool _animation = false;
  bool down = true;
  @override
  Widget build(BuildContext context) {
    Anime2 anime = widget.anime;
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconTheme = Theme.of(context).iconTheme.color!;
    final Color textColor = Color.fromARGB(255, 160, 146, 167);
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Size size = MediaQuery.of(context).size;
    final Color bottomUp = Theme.of(context).primaryColorDark;
    final Color bottomDown = Theme.of(context).primaryColorLight;
    return Container(
        //decoration: BoxDecoration(
        // gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [
        //   Colors.black,
        //   Colors.black,
        //   Colors.black,
        // ])),
        child: YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: youtubeController,
      ),
      builder: (context, player) => ListView(
        children: [
          Container(
            // decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //         colors: [Colors.pink, Colors.black])),

            child: Column(
              children: [
                Container(
                  height: 300,
                  child: Stack(
                    children: [
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(anime.animeBGroung.isNotEmpty
                                  ? anime.animeBGroung
                                  : anime.animePoster),
                              fit: BoxFit.cover),
                          //color: Color.fromARGB(255, 0, 83, 79),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          border: Border.all(
                            width: 2,
                            color: widget.color[1],
                          ),
                        ),
                      ),
                      Positioned(
                          top: 260,
                          left: 20,
                          child: Row(
                            children: [
                              Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color: widget.color[0],
                                    image: DecorationImage(
                                        image: AssetImage('images/mal.png'),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(25),
                                  )),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                anime.animeRating.isEmpty
                                    ? '?'
                                    : anime.animeRating,
                                style: TextStyle(
                                    fontFamily: Locales.currentLocale(context)
                                                .toString() ==
                                            'en'
                                        ? 'Angie'
                                        : 'SFPro',
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                      Positioned(
                          top: 260,
                          right: 20,
                          child: Row(
                            children: [
                              ImageIcon(
                                AssetImage('images/Light/Heart.png'),
                                color: primaryColor,
                                size: 23,
                              ),
                              Text(
                                "",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),
                      Positioned(
                          top: 100,
                          left: widget.size.width / 3.2,
                          right: widget.size.width / 3.2,
                          height: 200,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChatPage(avatar: anime.animePoster)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(anime.animePoster),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    width: 5,
                                    color: widget.color[0],
                                  )),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: ArrowBackButton(
                          size: MediaQuery.of(context).size,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    anime.animeName.toUpperCase(),
                    style: TextStyle(
                        fontFamily: 'Angie',
                        color: primaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [],
                ),
                ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LocaleText(
                        "summar",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily:
                                Locales.currentLocale(context).toString() ==
                                        'en'
                                    ? 'Angie'
                                    : 'SFPro',
                            fontWeight: FontWeight.bold,
                            color: down ? null : widget.color[1]),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Center(
                          child: down
                              ? ImageIcon(
                                  AssetImage('images/Light/Arrow - Down 2.png'),
                                  size: 20,
                                )
                              : ImageIcon(
                                  AssetImage('images/Light/Arrow - Up 2.png'),
                                  color: widget.color[1],
                                  size: 20,
                                )),
                    ],
                  ),
                  iconColor: widget.color[1],
                  trailing: Icon(
                    Icons.abc,
                    color: Colors.transparent,
                  ),
                  onExpansionChanged: (value) => setState(
                    () => value ? down = false : down = true,
                  ),
                  collapsedTextColor: primaryColor,
                  collapsedIconColor: primaryColor,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 5),
                      child: Text(
                        anime.animeDescription,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontFamily:
                                Locales.currentLocale(context).toString() ==
                                        'en'
                                    ? 'Angie'
                                    : 'SFPro',
                            color: primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          // Titel(size: size, title: "Favorite"),
          // AnimeScrollView2(size: size),
          Titel(size: widget.size, title: "Genre"),
          Category(
              list: anime.animeCategory, isLink: true, color: widget.color),
          Titel(size: widget.size, title: "Info"),
          Category(list: anime.animeInfo, isLink: false, color: widget.color),
          Titel(size: widget.size, title: "Episodes"),
          GestureDetector(
            child: Container(
              width: 30,
              height: 30,
              child: ImageIcon(
                AssetImage('images/Light/More-Circle.png'),
                color: primaryColor,
              ),
            ),
            onTap: () {
              showModalBottomSheet<dynamic>(
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  Size size = MediaQuery.of(context).size;
                  return allEp.isNotEmpty
                      ? DraggableScrollableSheet(
                          initialChildSize: 0.7,
                          minChildSize: 0.3,
                          builder: (context, scrollController) => Container(
                              color: Colors.transparent,
                              child: ListView(
                                  controller: scrollController,
                                  children: <Widget>[
                                    Container(
                                        height: size.height,
                                        padding: EdgeInsets.only(top: 10),
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  widget.color[1],
                                                  iconTheme,
                                                  iconTheme,
                                                  backgroundColor,
                                                ]),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                topRight: Radius.circular(25))),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: ListView(
                                            controller: epController,
                                            children: [
                                              Column(
                                                  children: List.generate(
                                                i,
                                                (index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AnimePlayer(
                                                                      quality:
                                                                          '240',
                                                                      url: allEp[
                                                                              index]
                                                                          .link)));
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Container(
                                                        height: 80,
                                                        child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 30,
                                                                backgroundColor:
                                                                    widget.color[
                                                                        1],
                                                                child: Text(
                                                                  allEp[index]
                                                                      .numb,
                                                                  style: TextStyle(
                                                                      color:
                                                                          widget.color[
                                                                              0],
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily: Locales.currentLocale(context).toString() ==
                                                                              'en'
                                                                          ? 'Angie'
                                                                          : 'SFPro',
                                                                      fontSize:
                                                                          25),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      width: size
                                                                              .width -
                                                                          100,
                                                                      child:
                                                                          Text(
                                                                        allEp[index]
                                                                            .name,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            fontFamily: Locales.currentLocale(context).toString() == 'en'
                                                                                ? 'Angie'
                                                                                : 'SFPro',
                                                                            color:
                                                                                primaryColor,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize: 15.5),
                                                                      ),
                                                                    ),
                                                                    Text(''),
                                                                    Container(
                                                                      width: size
                                                                              .width -
                                                                          100,
                                                                      child:
                                                                          Text(
                                                                        allEp[index]
                                                                            .sub,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            fontFamily: Locales.currentLocale(context).toString() == 'en'
                                                                                ? 'Angie'
                                                                                : 'SFPro',
                                                                            color:
                                                                                primaryColor,
                                                                            fontSize:
                                                                                12.5),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ]),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )),
                                            ],
                                          ),
                                        ))
                                  ])))

                      // } else {
                      //   return Container();
                      //   //     Padding(
                      //   //   padding:
                      //   //       const EdgeInsets.symmetric(vertical: 15),
                      //   //   child:
                      //   //       Center(child: const CircularProgressIndicator()),
                      //   // );
                      // }

                      : Container(
                          height: size.height,
                          width: size.width,
                          color: Colors.transparent,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                },
              );
            },
          ),
          anime.animeYoutube.isNotEmpty
              ? Column(
                  children: [
                    Titel(size: widget.size, title: "Trailer"),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0), child: player)),
                  ],
                )
              : Container()
          //some other widgets
          ,
          SizedBox(
            height: 30,
          )
        ],
      ),
    ));
  }
}

class Category extends StatefulWidget {
  const Category({
    Key? key,
    required this.list,
    required this.isLink,
    required this.color,
  }) : super(key: key);
  final bool isLink;
  final List<dynamic> color;
  final List<String> list;

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: widget.list.asMap().entries.map((e) {
          return GestureDetector(
            onTap: () {
              widget.isLink == true
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllAnime(
                              genre: e.value
                                  .replaceAll(' ', '+')
                                  .replaceAll('-', '+'),
                              headLine: e.value)))
                  : true;
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

class Anime2 {
  final String animeName;
  final String animePoster;
  final String animeBGroung;
  final String animeDescription;
  final String animeRating;
  final String animeYoutube;
  final List<String> animeCategory;
  final List<String> animeInfo;

  Anime2(
    this.animeName,
    this.animePoster,
    this.animeBGroung,
    this.animeDescription,
    this.animeRating,
    this.animeYoutube,
    this.animeCategory,
    this.animeInfo,
  );
}

class Episode {
  final String name;
  final String sub;
  final String link;
  final String numb;

  Episode(this.name, this.sub, this.link, this.numb);
}
