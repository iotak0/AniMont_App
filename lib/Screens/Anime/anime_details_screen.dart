import 'dart:convert';
import 'package:anime_mont_test/Screens/Anime/all_genres.dart';
import 'package:anime_mont_test/Screens/Home/home_page.dart';
import 'package:anime_mont_test/Screens/Player/video_page.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class AnimeDetailsScreen extends StatefulWidget {
  final int myId;
  final String url;
  const AnimeDetailsScreen({super.key, required this.url, required this.myId});

  @override
  State<AnimeDetailsScreen> createState() => AnimeDetailsScreenState();
}

class AnimeDetailsScreenState extends State<AnimeDetailsScreen>
    with SingleTickerProviderStateMixin {
  List<Anime2> anime = [];
  bool hasErorr = false;
  bool likeed = false;
  int animeId = 0;
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

  getLiked() async {
    Response response = await http
        .get(Uri.parse(
            "$get_my_anime?anime_id=${animeId}&user_id=${widget.myId}"))
        .catchError((error) {
      hasErorr = true;
      setState(() {});
      return Response('error', 400);
    });
    if (response.statusCode == 200) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (data['status'] == "success") {
        setState(() {
          likeed = true;
        });
      }
    } else {
      setState(() {
        hasErorr = true;
      });
    }
    setState(() {});
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
            ' div.bixbox.animefull > div.bigcontent > div.thumbook > div.rt > div.rating > strong')
        .map((e) => e.innerHtml.trim())
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
      if (kDebugMode) {
        print('description2 $description');
      }
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
    var id1;
    try {
      id1 = html
          .querySelectorAll('#content > div > div.postbody')
          .map((e) => e.innerHtml.trim())
          .toString();
    } catch (e) {}
    setState(() {
      String id = id1
          .replaceAll("(", '')
          .replaceAll(")", '')
          .substring(0, id1.indexOf('" class'))
          .replaceAll("-", '')
          .replaceAll('<article id="', '')
          .replaceAll("post", '')
          .replaceAll('"', '');
      animeId = int.parse(id);
      print("id//////////////////////////$id");
    });
    await getLiked();
    final epLink = html
        .querySelectorAll(' div.eplister > ul > li > a')
        .map((e) => e.attributes['href']!)
        .toList();
    final epNum = html
        .querySelectorAll('div.eplister > ul > li > a > div.epl-num')
        .map((e) => e.innerHtml.trim())
        .toList();
    String replaceALl = '';
    try {
      replaceALl = description.substring(
          description.indexOf('<a href'), description.indexOf('>.'));
    } catch (e) {}

    setState(() {
      anime.add(Anime2(
          name.replaceAll('(', '').replaceAll(')', ''),
          poster.replaceAll('(', '').replaceAll(')', ''),
          backgroundImage.replaceAll('(', '').replaceAll(')', ''),
          // .replaceAll('i0.wp.com/', '')
          // .replaceAll('i1.wp.com/', '')
          // .replaceAll('i2.wp.com/', '')
          // .replaceAll('i3.wp.com/', '')
          // .replaceAll('i4.wp.com/', '')
          // .replaceAll('i5.wp.com/', '')
          // .replaceAll('i6.wp.com/', '')

          //https://i2.wp.com/animetitans.comhttps://animetitans.com/wp-content/
          // https://animetitans.com/wp-content//Blue-Lock-
          // .replaceAll("/wp-content/", "https://animetitans.com/wp-content/")
          // .replaceAll(
          //     'https://animetitans.comhttps://animetitans.com/wp-content/',
          //     'https://animetitans.com/wp-content/'),
          description
              .replaceAll('(', '')
              .replaceAll(')', '')
              .replaceAll(replaceALl, '')
              .replaceAll('<br>', '')
              .replaceAll('>', ''),
          rating
              .replaceAll('(', '')
              .replaceAll(')', '')
              .replaceAll('التقييم', '')
              .replaceAll(' ', ''),
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
    CustomColors customColors = CustomColors(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios_new,
            shadows: [
              Shadow(
                  color: customColors.primaryColor.withOpacity(.7),
                  blurRadius: 10),
              Shadow(color: Colors.grey, blurRadius: 5),
            ],
            textDirection: context.currentLocale!.languageCode != 'en'
                ? TextDirection.ltr
                : TextDirection.rtl,
            color: customColors.primaryColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: anime.isNotEmpty
          ? Profial(
              animeUrl: widget.url,
              animeId: animeId,
              isLiked: likeed,
              myId: widget.myId,
              color: color,
              link: widget.url,
              size: size,
              anime: anime[0],
            )
          : LoadingGif(
              logo: true,
            ),
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
    required this.myId,
    required this.isLiked,
    required this.animeId,
    required this.animeUrl,
  }) : super(key: key);
  Anime2 anime;
  final int animeId;
  final String animeUrl;
  final Size size;
  final List<dynamic> color;
  final int myId;
  final String link;
  final bool isLiked;

  @override
  State<Profial> createState() => _ProfialState();
}

class _ProfialState extends State<Profial> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late bool isLiked;
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
    isLiked = widget.isLiked;
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

  like() async {
    final response = await http.get(Uri.parse(
        "$add_my_anime?user_id=${widget.myId}&anime_id=${widget.animeId.toString()}&anime_url=${widget.animeUrl}&anime_name=${widget.anime.animeName}&anime_poster=${widget.anime.animePoster}"));
    print(response.body);
    var data = jsonDecode(response.body);

    print(data);
  }

  unLike() async {
    final response = await http.get(Uri.parse(
        "$unlink_my_anime?user_id=${widget.myId}&anime_id=${widget.animeId}"));
    var data = jsonDecode(response.body);

    print(data);
  }

  @override
  void dispose() {
    _animationController.dispose();
    youtubeController.dispose();
    super.dispose();
  }

  null0() {
    return null;
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
            builder: (context, player) => SlidingUpPanel(
                  parallaxEnabled: true,
                  parallaxOffset: .5,
                  body: Column(
                    children: [
                      Container(
                        height: 220,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(anime.animeBGroung.isNotEmpty
                                  ? anime.animeBGroung
                                  : anime.animePoster),
                              fit: BoxFit.cover),
                          //color: Color.fromARGB(255, 0, 83, 79),
                        ),
                      ),
                    ],
                  ),
                  maxHeight: size.height,
                  minHeight: size.height - 220,
                  panelBuilder: (sc) => Material(
                    child: ListView(
                      controller: sc,
                      children: [
                        Container(
                          // decoration: BoxDecoration(
                          //     gradient: LinearGradient(
                          //         begin: Alignment.topCenter,
                          //         end: Alignment.bottomCenter,
                          //         colors: [Colors.pink, Colors.black])),

                          child:
                              /* SlidingUpPanel(
                                body: Container(
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
                                panelBuilder: (sc) => ListView(
                                  controller: sc,
                                  children: [
                    /*Container(
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
                            top: 200,
                            width: 120,
                            left:
                                Locales.currentLocale(context).toString() == 'en'
                                    ? 20
                                    : 0,
                            height: 100,
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(anime.animePoster),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(30),
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
                                  ),*/*/
                              Column(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 150,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  anime.animePoster),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            width: 1,
                                            color: widget.color[1],
                                          )),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height: 150,
                                        child: Column(
                                          children: [
                                            Spacer(),
                                            Spacer(),
                                            SizedBox(
                                              height: 120,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: Text(
                                                  anime.animeName.toUpperCase(),
                                                  softWrap: true,
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.fade,
                                                  style: TextStyle(
                                                      fontFamily: 'Angie',
                                                      color: primaryColor,
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50),
                                              child: Row(children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                        height: 20,
                                                        width: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              widget.color[0],
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  'images/mal.png'),
                                                              fit:
                                                                  BoxFit.cover),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(25),
                                                        )),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      anime.animeRating.isEmpty
                                                          ? '?'
                                                          : anime.animeRating,
                                                      style: TextStyle(
                                                          fontFamily: Locales.currentLocale(
                                                                          context)
                                                                      .toString() ==
                                                                  'en'
                                                              ? 'Angie'
                                                              : 'SFPro',
                                                          color: primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        isLiked
                                                            ? unLike()
                                                            : like();
                                                        isLiked = isLiked
                                                            ? false
                                                            : true;
                                                      });
                                                    },
                                                    child: SvgPicture.string(
                                                      isLiked
                                                          ? '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                          <title>Iconly/Bold/Heart</title>
                          <g id="Iconly/Bold/Heart" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                              <g id="Heart" transform="translate(1.999783, 2.500540)" fill="#000000" fill-rule="nonzero">
                                  <path d="M6.28001656,3.46389584e-14 C6.91001656,0.0191596721 7.52001656,0.129159672 8.11101656,0.330159672 L8.11101656,0.330159672 L8.17001656,0.330159672 C8.21001656,0.349159672 8.24001656,0.370159672 8.26001656,0.389159672 C8.48101656,0.460159672 8.69001656,0.540159672 8.89001656,0.650159672 L8.89001656,0.650159672 L9.27001656,0.820159672 C9.42001656,0.900159672 9.60001656,1.04915967 9.70001656,1.11015967 C9.80001656,1.16915967 9.91001656,1.23015967 10.0000166,1.29915967 C11.1110166,0.450159672 12.4600166,-0.00984032788 13.8500166,3.46389584e-14 C14.4810166,3.46389584e-14 15.1110166,0.0891596721 15.7100166,0.290159672 C19.4010166,1.49015967 20.7310166,5.54015967 19.6200166,9.08015967 C18.9900166,10.8891597 17.9600166,12.5401597 16.6110166,13.8891597 C14.6800166,15.7591597 12.5610166,17.4191597 10.2800166,18.8491597 L10.2800166,18.8491597 L10.0300166,19.0001597 L9.77001656,18.8391597 C7.48101656,17.4191597 5.35001656,15.7591597 3.40101656,13.8791597 C2.06101656,12.5301597 1.03001656,10.8891597 0.390016562,9.08015967 C-0.739983438,5.54015967 0.590016562,1.49015967 4.32101656,0.269159672 C4.61101656,0.169159672 4.91001656,0.0991596721 5.21001656,0.0601596721 L5.21001656,0.0601596721 L5.33001656,0.0601596721 C5.61101656,0.0191596721 5.89001656,3.46389584e-14 6.17001656,3.46389584e-14 L6.17001656,3.46389584e-14 Z M15.1900166,3.16015967 C14.7800166,3.01915967 14.3300166,3.24015967 14.1800166,3.66015967 C14.0400166,4.08015967 14.2600166,4.54015967 14.6800166,4.68915967 C15.3210166,4.92915967 15.7500166,5.56015967 15.7500166,6.25915967 L15.7500166,6.25915967 L15.7500166,6.29015967 C15.7310166,6.51915967 15.8000166,6.74015967 15.9400166,6.91015967 C16.0800166,7.08015967 16.2900166,7.17915967 16.5100166,7.20015967 C16.9200166,7.18915967 17.2700166,6.86015967 17.3000166,6.43915967 L17.3000166,6.43915967 L17.3000166,6.32015967 C17.3300166,4.91915967 16.4810166,3.65015967 15.1900166,3.16015967 Z"></path>
                              </g>
                          </g>
                      </svg>'''
                                                          : '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Light-Outline/Heart</title>
    <g id="Iconly/Light-Outline/Heart" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
        <g id="Heart" transform="translate(2.000000, 3.000000)" fill="#000000">
            <path d="M10.2347,1.039 C11.8607,0.011 14.0207,-0.273 15.8867,0.325 C19.9457,1.634 21.2057,6.059 20.0787,9.58 C18.3397,15.11 10.9127,19.235 10.5977,19.408 C10.4857,19.47 10.3617,19.501 10.2377,19.501 C10.1137,19.501 9.9907,19.471 9.8787,19.41 C9.5657,19.239 2.1927,15.175 0.3957,9.581 C0.3947,9.581 0.3947,9.58 0.3947,9.58 C-0.7333,6.058 0.5227,1.632 4.5777,0.325 C6.4817,-0.291 8.5567,-0.02 10.2347,1.039 Z M5.0377,1.753 C1.7567,2.811 0.9327,6.34 1.8237,9.123 C3.2257,13.485 8.7647,17.012 10.2367,17.885 C11.7137,17.003 17.2927,13.437 18.6497,9.127 C19.5407,6.341 18.7137,2.812 15.4277,1.753 C13.8357,1.242 11.9787,1.553 10.6967,2.545 C10.4287,2.751 10.0567,2.755 9.7867,2.551 C8.4287,1.53 6.6547,1.231 5.0377,1.753 Z M14.4677,3.7389 C15.8307,4.1799 16.7857,5.3869 16.9027,6.8139 C16.9357,7.2269 16.6287,7.5889 16.2157,7.6219 C16.1947,7.6239 16.1747,7.6249 16.1537,7.6249 C15.7667,7.6249 15.4387,7.3279 15.4067,6.9359 C15.3407,6.1139 14.7907,5.4199 14.0077,5.1669 C13.6127,5.0389 13.3967,4.6159 13.5237,4.2229 C13.6527,3.8289 14.0717,3.6149 14.4677,3.7389 Z" id="Combined-Shape"></path>
        </g>
    </g>
</svg>''',
                                                      color: isLiked
                                                          ? Colors.red
                                                          : primaryColor,
                                                      height: 23,
                                                    )),
                                              ]),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ExpansionTile(
                                tilePadding: null,
                                title: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      LocaleText(
                                        "summar",
                                        //textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontFamily:
                                                Locales.currentLocale(context)
                                                            .toString() ==
                                                        'en'
                                                    ? 'Angie'
                                                    : 'SFPro',
                                            shadows: down
                                                ? null
                                                : [
                                                    Shadow(
                                                        color: widget.color[0],
                                                        blurRadius: 12)
                                                  ],
                                            fontWeight: FontWeight.bold,
                                            color:
                                                down ? null : widget.color[1]),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Center(
                                          child: down
                                              ? ImageIcon(
                                                  AssetImage(
                                                      'images/Light/Arrow - Down 2.png'),
                                                  size: 20,
                                                )
                                              : ImageIcon(
                                                  AssetImage(
                                                      'images/Light/Arrow - Up 2.png'),
                                                  color: widget.color[1],
                                                  size: 20,
                                                )),
                                    ],
                                  ),
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
                                          fontFamily: 'SFPro',
                                          color: primaryColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),

                        // Titel(size: size, title: "Favorite"),
                        // AnimeScrollView2(size: size),
                        Titel(
                          function: () => null0(),
                          size: widget.size,
                          title: "Genre",
                          more: false,
                        ),
                        Category(
                            myId: widget.myId,
                            list: anime.animeCategory,
                            isLink: true,
                            color: widget.color),
                        Titel(
                          function: () => null0(),
                          size: widget.size,
                          title: "Info",
                          more: false,
                        ),
                        Category(
                            myId: widget.myId,
                            list: anime.animeInfo,
                            isLink: false,
                            color: widget.color),
                        Titel(
                          function: () => null0(),
                          size: widget.size,
                          title: "Episodes",
                          more: false,
                        ),
                        GestureDetector(
                          child: SvgPicture.string(
                            '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Light/Play</title>
    <g id="Iconly/Light/Play" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round">
        <g id="Play" transform="translate(2.500000, 2.500000)" stroke="#000000" stroke-width="1.5">
            <path d="M9.5,0 C14.7459,0 19,4.25315 19,9.5 C19,14.74685 14.7459,19 9.5,19 C4.25315,19 0,14.74685 0,9.5 C0,4.25315 4.25315,0 9.5,0 Z" id="Stroke-1"></path>
            <path d="M12.5,9.49514457 C12.5,8.68401476 8.34252742,6.08911717 7.87091185,6.55569627 C7.39929629,7.02227536 7.35394864,11.9240477 7.87091185,12.4345929 C8.38787507,12.9469326 12.5,10.3062744 12.5,9.49514457 Z" id="Stroke-3"></path>
        </g>
    </g>
</svg>''',
                            height: 50,
                            width: 50,
                            color: primaryColor,
                          ),
                          onTap: () {
                            showModalBottomSheet<dynamic>(
                              backgroundColor: widget.color[1],
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              )),
                              context: context,
                              builder: (context) {
                                Size size = MediaQuery.of(context).size;
                                return allEp.isNotEmpty
                                    ? Container(
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
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(30))),
                                        child: DraggableScrollableSheet(
                                            expand: false,
                                            maxChildSize: 0.95,
                                            initialChildSize: 0.7,
                                            minChildSize: 0.3,
                                            builder:
                                                (context, scrollController) =>
                                                    Stack(
                                                      clipBehavior: Clip.none,
                                                      alignment:
                                                          AlignmentDirectional
                                                              .topCenter,
                                                      children: [
                                                        Positioned(
                                                          top: 10,
                                                          child: Container(
                                                              height: 8,
                                                              width: 60,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius: BorderRadius.horizontal(
                                                                      right: Radius
                                                                          .circular(
                                                                              30),
                                                                      left: Radius
                                                                          .circular(
                                                                              30)))),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 20.0),
                                                          child:
                                                              SingleChildScrollView(
                                                                  controller:
                                                                      scrollController,
                                                                  child: Column(
                                                                      children:
                                                                          List.generate(
                                                                    i,
                                                                    (index) {
                                                                      return GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => NewPlayerPage(myId: widget.myId, url: allEp[index].link)));
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(5.0),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                80,
                                                                            child:
                                                                                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                                                              CircleAvatar(
                                                                                radius: 30,
                                                                                backgroundColor: widget.color[1],
                                                                                child: Text(
                                                                                  allEp[index].numb,
                                                                                  style: TextStyle(color: widget.color[0], fontWeight: FontWeight.bold, fontFamily: Locales.currentLocale(context).toString() == 'en' ? 'Angie' : 'SFPro', fontSize: 25),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Container(
                                                                                      width: size.width - 100,
                                                                                      child: Text(
                                                                                        allEp[index].name,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        style: TextStyle(fontFamily: Locales.currentLocale(context).toString() == 'en' ? 'Angie' : 'SFPro', color: primaryColor, fontWeight: FontWeight.w600, fontSize: 15.5),
                                                                                      ),
                                                                                    ),
                                                                                    Text(''),
                                                                                    Container(
                                                                                      width: size.width - 100,
                                                                                      child: Text(
                                                                                        allEp[index].sub,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        style: TextStyle(fontFamily: Locales.currentLocale(context).toString() == 'en' ? 'Angie' : 'SFPro', color: primaryColor, fontSize: 12.5),
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
                                                                  ))),
                                                        ),
                                                      ],
                                                    )),
                                      )

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
                                  Titel(
                                    function: () => null0(),
                                    size: widget.size,
                                    title: "Trailer",
                                    more: false,
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: player)),
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
                  ),
                )));
  }
}

class Category extends StatefulWidget {
  const Category({
    Key? key,
    required this.list,
    required this.isLink,
    required this.color,
    required this.myId,
  }) : super(key: key);
  final bool isLink;
  final List<dynamic> color;
  final int myId;
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
                          builder: (context) => AllGenres(
                                myId: widget.myId,
                                genre: e.value,
                              )))
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
                  child: widget.isLink == true
                      ? LocaleText(
                          '${e.value.trim()}',
                          style: TextStyle(
                              fontFamily:
                                  Locales.currentLocale(context).toString() ==
                                          'en'
                                      ? 'Angie'
                                      : 'SFPro',
                              color: widget.isLink != true
                                  ? widget.color[1]
                                  : widget.color[0],
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          '${e.value.trim()}',
                          style: TextStyle(
                              fontFamily:
                                  Locales.currentLocale(context).toString() ==
                                          'en'
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
