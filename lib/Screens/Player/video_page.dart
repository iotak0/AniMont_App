import 'package:anime_mont_test/Screens/Anime/anime_details_screen.dart';
import 'package:anime_mont_test/Screens/Anime/new_player.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/server/download.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:anime_mont_test/widgets/new_comment.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:anime_mont_test/server/server_php.dart';
import 'package:anime_mont_test/server/urls_php.dart';

class NewPlayerPage extends StatefulWidget {
  final int myId;
  const NewPlayerPage({super.key, required this.url, required this.myId});

  final String url;
  @override
  State<NewPlayerPage> createState() => NewPlayerPageState();
}

class NewPlayerPageState extends State<NewPlayerPage> {
  int i = 0;
  bool ok = false;
  bool complet = false;

  List<Episode> allEp = [];
  Future getEpisode(link) async {
    final url = Uri.parse(link);
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
    setState(() {
      complet = true;
    });
  }

  late String epName;
  bool right = true;
  bool isNext = false;
  bool isLast = false;
  late List allEPName;
  late List allEPSub;
  bool loading = true;
  late String animeLink;
  late List allEPImage;
  late String animeName;
  late List allEPUrl;
  static bool fullScreen = false;
  int allEPCount = 0;
  late List<Download> downloadList;
  late int eNP = 0;
  bool webPlayer = false;
  late int epIndex;
  int progressLoading = 0;
  String ifram = '';
  int? animeId;
  final ItemScrollController itemScrollController = ItemScrollController();
  final DraggableScrollableController draggableController =
      DraggableScrollableController();
  List<String> list = ['1080', '720', '480', '360', '240'];
  Future scrollToItem(int index) async {
    await itemScrollController.scrollTo(
        alignment: 0.2,
        index: index,
        duration: Duration(seconds: 1),
        curve: Curves.fastLinearToSlowEaseIn);
  }

  bool done = false;
  getAnimeData(link) async {
    await getAnime(link);

    final url = Uri.parse(link);
    var response = await http.readBytes(url,
        headers: {'Content-type': 'text/html', 'Charset': 'utf-8'});
    print("url ////////////////" + response.toString());

    var html = dom.Document.html(utf8.decode(response).toString());

    final id1 = html
        .querySelectorAll('#content > div > div.postbody')
        .map((e) => e.innerHtml.trim())
        .toString();
    final name = html
        .querySelectorAll(
            'div.single-info.bixbox > div.infox > div.infolimit > h2')
        .map((e) => e.innerHtml.trim())
        .toString();
    var ifram1;
    if (ok == false) {
      ifram1 = html
          .querySelectorAll('iframe')
          .map((e) => e.attributes['src']!)
          .toString();
    }

    final animelink1 = html
        .querySelectorAll(
            'div.megavid > div > div.naveps.bignav > div.nvs.nvsc > a')
        .map((e) => e.attributes['href']!)
        .toString();
    animeLink = animelink1.replaceAll("(", '').replaceAll(")", '');

    //#post-68468 > div.megavid > div > div.naveps.bignav > div.nvs.nvsc > a

    final allEPUrl1 = html
        .querySelectorAll(' div.episodelist > ul > li > a')
        .map((e) => e.attributes['href']!)
        .toList();
    final allEPImage1 = html
        .querySelectorAll(' div.episodelist > ul > li > a > div.thumbnel > img')
        .map((e) => e.attributes['src']!)
        .toList();
    final allEPName1 = html
        .querySelectorAll('  div.episodelist > ul > li > a > div.playinfo > h4')
        .map((e) => e.innerHtml.trim())
        .toList();
    final allEPSub1 = html
        .querySelectorAll(
            ' div.episodelist > ul > li > a > div.playinfo > span')
        .map((e) => e.innerHtml.trim())
        .toList(); //#dwnLinks > b:nth-child(1)
    final epName1 = html
        .querySelectorAll(
            'div.megavid > div > div.item.meta > div.lm > div > h1')
        .map((e) => e.innerHtml.trim())
        .toString();
    epName = epName1.replaceAll("(", '').replaceAll(")", '');

    allEPImage = allEPImage1;
    allEPSub = allEPSub1;
    allEPName = allEPName1;
    allEPUrl = allEPUrl1;
    allEPCount = allEPUrl1.length;

    //
    try {
      String next1 = html
          .querySelectorAll(
              'div.megavid > div > div.naveps.bignav > div:nth-child(1) > a')
          .map((e) => e.attributes['href']!)
          .toString();
      String next2 = html
          .querySelectorAll(
              'div.megavid > div > div.naveps.bignav > div:nth-child(1) > span')
          .map((e) => e.attributes['class']!)
          .toString();
      String last1 = html
          .querySelectorAll(
              '  div.megavid > div > div.naveps.bignav > div:nth-child(3) > a')
          .map((e) => e.attributes['href']!)
          .toString();
      String last2 = html
          .querySelectorAll(
              '   div.megavid > div > div.naveps.bignav > div:nth-child(3) > span')
          .map((e) => e.attributes['class']!)
          .toString();

      final eNP1 = html
          .querySelectorAll(
              ' div.megavid > div > div.item.meta > div.lm > meta')
          .map((e) => e.attributes['content']!)
          .toString();

      setState(() {
        isNext = next1.isNotEmpty || next2 == 'nolink' ? true : false;
        isLast = last1.isNotEmpty || last2.isEmpty ? true : false;
        eNP1.replaceAll("(", '').replaceAll(")", '');
        eNP = int.parse(eNP1.replaceAll("(", '').replaceAll(")", ''));
        print("///////////////////////////////ENP    $eNP");
      });
    } catch (e) {
      print("Next & Previs Error $e");
    }
    setState(() {
      animeName = name.replaceAll("(", '').replaceAll(")", '');
      String id = id1
          .replaceAll("(", '')
          .replaceAll(")", '')
          .substring(0, id1.indexOf('" class'))
          .replaceAll("-", '')
          .replaceAll('<article id="', '')
          .replaceAll("post", '')
          .replaceAll('"', '');
      if (ok == false) {
        ifram1.replaceAll('(', '').replaceAll(')', '');

        ifram = ifram1.replaceAll('(', '').replaceAll(')', '');
      }

      animeId = int.parse(id);

      print('${animeId} animeIdddddddddddddddddddddddddddd');
      final downName1 = html
          .querySelectorAll(
              'div.entry-content > div.bixbox.mctn > div > ul > li > span.q ')
          .map((e) => e.innerHtml.trim())
          .toList();
      final downUrl1 = html
          .querySelectorAll(
              'div.entry-content > div.bixbox.mctn > div > ul > li > span.e > a')
          .map((e) => e.attributes['href']!)
          .toList();
      final downQuality1 = html
          .querySelectorAll(
              'div.entry-content > div.bixbox.mctn > div > ul > li > span.w ')
          .map((e) => e.innerHtml.trim())
          .toList();
      final downImage1 = html
          .querySelectorAll(
              ' div.entry-content > div.bixbox.mctn > div > ul > li > span.q > b > img')
          .map((e) => e.attributes['src']!)
          .toList();
      // downloadList = List.generate(
      //     downUrl1.length,
      //     (index) => Download(downUrl1[index], downName1[index],
      //         downQuality1[index], downImage1[index]));
    });
    await getEpisode(animeLink);
    var response2 = await Server.postRequest(add_anime, {
      "anime_id": '${animeId}',
    });
    setState(() {
      loading = false;
      done = true;
    });
  }

  String play = '';
  String play2 = '';
  Future getAnime(link) async {
    setState(() {
      loading = true;
    });
    try {
      final url = Uri.parse(link);
      final response = await http.get(url);

      dom.Document html = dom.Document.html(response.body);

      final ifram = html
          .querySelectorAll('#pembed > iframe')
          .map((e) => e.attributes['src']!)
          .toString();
      print("Screeebt/////////////////" + ifram);
      //  print("play/////////////////" + widget.quality);
      final url2 = Uri.parse(ifram.replaceAll("(", '').replaceAll(")", ''));
      final response2 = await http.get(url2);
      dom.Document html2 = dom.Document.html(response2.body);
      var play1 = html2
          .querySelectorAll('body > script')
          .map((e) => e.innerHtml.trim())
          .toString();
      play2 = play1
          .substring(0, play1.indexOf('",'))
          .replaceAll('var player = new Clappr.Player(', '')
          .replaceAll('{', '')
          .replaceAll('source: "', '')
          .replaceAll(' ', '')
          .replaceAll("(", '')
          .replaceAll(")", '');

      play = play1
          .substring(0, play1.indexOf('",'))
          .replaceAll('var player = new Clappr.Player(', '')
          .replaceAll('{', '')
          .replaceAll('source: "', '')
          .replaceAll(' ', '')
          //.replaceAll('0p', '${widget.quality}p_1')
          .replaceAll("(", '')
          .replaceAll(")", '');
      print("play/////////////////" + play);
      ok = true;
    } catch (e) {
      ok = false;
    }
    setState(() {
      loading = true;
    });
  }

  @override
  void initState() {
    getAnimeData(widget.url);

    //getAnime(widget.url);
    setState(() {});
    super.initState();
    //getAnimeData(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    Size size = MediaQuery.of(context).size;
    return (!ok && loading && !done)
        ? LoadingGif(
            logo: true,
          )
        : (animeId == null)
            ? LoadingGif(
                logo: true,
              )
            : !complet
                ? LoadingGif(
                    logo: true,
                  )
                : Scaffold(
                    backgroundColor: customColors.backgroundColor,
                    body: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        (ok)
                            ? new NewPlayer(
                                epName: epName,
                                animeLink: widget.url,
                                allEPCount: allEPCount,
                                eNP: eNP,
                                i: i,
                                link: play,
                                myId: widget.myId,
                                allEp: allEp,
                              )
                            : new WebPlayer(
                                epName: epName,
                                ifram: ifram,
                                allEp: allEp,
                                i: i,
                                myId: widget.myId,
                              ),
                        SizedBox(
                          height: size.height - 230,
                          child: new AnimeCommentsPage(
                              myId: widget.myId,
                              pageId: animeId!,
                              isPost: false),
                        )
                      ],
                    ),
                  );
  }
}

class WebPlayer extends StatefulWidget {
  const WebPlayer({
    Key? key,
    required this.ifram,
    required this.allEp,
    required this.i,
    required this.myId,
    required this.epName,
  }) : super(key: key);
  final List<Episode> allEp;
  final int myId;
  final String epName;

  final int i;
  final String ifram;

  @override
  State<WebPlayer> createState() => _WebPlayerState();
}

class _WebPlayerState extends State<WebPlayer> {
  bool show = true;
  @override
  void dispose() {
    NewPlayerPageState.fullScreen = false;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CustomColors customColors = CustomColors(context);
    return GestureDetector(
      child: SizedBox(
        height: NewPlayerPageState.fullScreen ? size.height : 200,
        child: Stack(
          children: [
            WebView(
                backgroundColor: CustomColors(context).primaryColor,
                allowsInlineMediaPlayback: true,
                initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy
                    .require_user_action_for_all_media_types,
                debuggingEnabled: true,
                gestureNavigationEnabled: true,
                initialUrl: widget.ifram,
                javascriptMode: JavascriptMode.unrestricted),
            Positioned(
                bottom: 0,
                child: show
                    ? SizedBox()
                    : GestureDetector(
                        onTap: () => setState(() {
                          if (!NewPlayerPageState.fullScreen) {
                            NewPlayerPageState.fullScreen = true;
                            NewPlayerPageState.fullScreen = true;

                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.landscapeLeft,
                              DeviceOrientation.landscapeRight
                            ]);
                            SystemChrome.setEnabledSystemUIMode(
                                SystemUiMode.immersiveSticky);
                          } else {
                            NewPlayerPageState.fullScreen = false;
                            NewPlayerPageState.fullScreen = false;

                            SystemChrome.setPreferredOrientations(
                                [DeviceOrientation.portraitUp]);
                            SystemChrome.setEnabledSystemUIMode(
                                SystemUiMode.edgeToEdge);
                          }
                        }),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          child: Icon(
                            Icons.fullscreen,
                            size: 38,
                            color: Colors.white,
                          ),
                        ),
                      )),
            Positioned(
                child: show
                    ? SizedBox()
                    : GestureDetector(
                        onTap: () async {
                          showModalBottomSheet<dynamic>(
                            // backgroundColor: widget.color[1],
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            )),
                            context: context,
                            builder: (context) {
                              Size size = MediaQuery.of(context).size;
                              return widget.allEp.isNotEmpty
                                  ? Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                CustomColors(context)
                                                    .backgroundColor,
                                                CustomColors(context).iconTheme,
                                                CustomColors(context).iconTheme,
                                                CustomColors(context)
                                                    .backgroundColor,
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
                                                                    children: List
                                                                        .generate(
                                                                  widget.i,
                                                                  (index) {
                                                                    return GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                        Navigator.pop(
                                                                            context);
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => NewPlayerPage(
                                                                                      url: widget.allEp[index].link,
                                                                                      myId: widget.myId,
                                                                                    )));
                                                                        // Navigator.push(
                                                                        //     context,
                                                                        //     MaterialPageRoute(
                                                                        //         builder: (context) =>
                                                                        //             AnimePlayer(
                                                                        //                 quality:
                                                                        //                     '240',
                                                                        //                 url: allEp[index]
                                                                        //                     .link)));
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(5.0),
                                                                        child:
                                                                            Container(
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(12),
                                                                              color: widget.epName == widget.allEp[index].name ? customColors.bottomDown.withOpacity(.7) : Colors.transparent),
                                                                          height:
                                                                              80,
                                                                          child: Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                CircleAvatar(
                                                                                  radius: 30,
                                                                                  backgroundColor: CustomColors(context).iconTheme,
                                                                                  child: Text(
                                                                                    widget.allEp[index].numb,
                                                                                    style: TextStyle(color: CustomColors(context).primaryColor, fontWeight: FontWeight.bold, fontFamily: Locales.currentLocale(context).toString() == 'en' ? 'Angie' : 'SFPro', fontSize: 25),
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
                                                                                          widget.allEp[index].name,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: TextStyle(fontFamily: Locales.currentLocale(context).toString() == 'en' ? 'Angie' : 'SFPro', color: CustomColors(context).primaryColor, fontWeight: FontWeight.w600, fontSize: 15.5),
                                                                                        ),
                                                                                      ),
                                                                                      Text(''),
                                                                                      Container(
                                                                                        width: size.width - 100,
                                                                                        child: Text(
                                                                                          widget.allEp[index].sub,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: TextStyle(fontFamily: Locales.currentLocale(context).toString() == 'en' ? 'Angie' : 'SFPro', color: CustomColors(context).primaryColor, fontSize: 12.5),
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
                        child: Container(
                            child: Icon(
                          Icons.playlist_play_rounded,
                          color: Colors.white,
                          size: 30,
                        )),
                      )),
            GestureDetector(
                onTap: () => setState(() {
                      show = show ? false : true;
                    }),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(100)),
                    width: 90,
                    height: 90,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
