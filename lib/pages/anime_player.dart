import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:anime_mont_test/pages/post_comments.dart';
import 'package:anime_mont_test/pages/profial_screen.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:chewie/chewie.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:convert';
import 'package:anime_mont_test/server/server_php.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'dart:isolate';
import 'dart:ui';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

import '../provider/user_model.dart';
import '../utils/anime_video_player.dart';

class AnimePlayer extends StatefulWidget {
  const AnimePlayer({super.key, required this.url, required this.quality});
  @override
  State<AnimePlayer> createState() => _AnimePlayerState();
  final String url;
  final String quality;
}

class _AnimePlayerState extends State<AnimePlayer> {
  // download(String url, String fileName) async {
  //   bool isInstalled = await DeviceApps.isAppInstalled('com.dv.adm');
  //   final Uri _url =
  //       Uri.parse('https://play.google.com/store/apps/details?id=com.dv.adm');
  //   if (isInstalled) {
  //     final AndroidIntent intent = AndroidIntent(
  //       action: 'action_main',
  //       package: 'com.dv.adm',
  //       componentName: 'com.dv.adm.AEditor',
  //       arguments: <String, dynamic>{
  //         'android.intent.extra.TEXT': url,
  //         'com.android.extra.filename': "$fileName.mp4",
  //       },
  //     );
  //     await intent.launch().then((value) => null).catchError((e) => print(e));
  //   } else {
  //     await launchUrl(_url);
  //     // ask user to install the app
  //   }
  // }
  late bool _editReply;
  late String epName;
  bool right = true;
  bool isNext = false;
  bool isLast = false;
  late List allEPName;
  late List allEPSub;
  bool loading = true;
  late List allEPImage;
  late String animeName;
  late List allEPUrl;
  int allEPCount = 0;
  late List<Download> downloadList;
  late int eNP = 0;
  bool webPlayer = false;
  late int epIndex;
  int progressLoading = 0;
  String ifram = '';
  late int animeId;
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

  Future getAnimeData(link) async {
    print("url ////////////////" + link);
    await getAnime(link);
    final url = Uri.parse(link);
    var response = await http.readBytes(url,
        headers: {'Content-type': 'text/html', 'Charset': 'utf-8'});

    //var m = utf8.encode(response);
    // var m = Uri.encodeFull(response);
    // response.

    print("url ////////////////" + response.toString());
    //print("url ////////////////" + utf8.decode(m).toString());

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

    final allEPUrl1 = html
        .querySelectorAll('#singlepisode > div.episodelist > ul > li > a')
        .map((e) => e.attributes['href']!)
        .toList();
    final allEPImage1 = html
        .querySelectorAll(
            ' #singlepisode > div.episodelist > ul > li > a > div.thumbnel > img')
        .map((e) => e.attributes['src']!)
        .toList();
    final allEPName1 = html
        .querySelectorAll(
            ' #singlepisode > div.episodelist > ul > li > a > div.playinfo > h4')
        .map((e) => e.innerHtml.trim())
        .toList();
    final allEPSub1 = html
        .querySelectorAll(
            '#singlepisode > div.episodelist > ul > li > a > div.playinfo > span')
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
      //#singlepisode > div.episodelist > ul > li.selected > a
      //#singlepisode > div.episodelist > ul > li.selected > a > div.playinfo > h4
      //#singlepisode > div.episodelist > ul > li.selected > a > div.playinfo > span

      //late List allEPImage;

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
      commentsFuture = getComments(animeId, myId);
      getComments(animeId, myId);
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
      downloadList = List.generate(
          downUrl1.length,
          (index) => Download(downUrl1[index], downName1[index],
              downQuality1[index], downImage1[index]));
      loading = false;
      addAnime();
    });
  }

/////////////////////////////
  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory =
            Directory('/storage/emulated/0/Download/AniMont/Anime/$animeName');
        print('???????????$animeName');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

///////////   A  D  M     D  O  N  W  L  O  A  D   ////////////
  admOpen(String url, String fileName) async {
    if (Platform.isAndroid) {
      AndroidIntent intent = AndroidIntent(
        action: 'action_main',
        package: 'com.dv.adm',
        componentName: 'com.dv.adm.AEditor',
        // data: 'https://play.google.com/store/apps/details?'
        //     'id=com.google.android.apps.myapp',
        arguments: <String, dynamic>{
          'android.intent.extra.TEXT': url,
          'com.android.extra.filename': "$fileName.mp4"
        },
      );
      await intent
          .launch()
          .then((value) => null)
          .catchError((e) => print("ADM Erorr $e"));
    }
  }

///////////////////////
  Future download(String url) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      var directory = await Directory(
              '/storage/emulated/0/Download/AniMont/Anime/$animeName')
          .create(recursive: true);
      final baseStorage = await getDownloadPath();
      await FlutterDownloader.enqueue(
        //fileName: epName + '.mp4',
        url: url,
        headers: {}, // optional: header send with url (auth token etc)
        savedDir: baseStorage!,
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
    }
  }

  ReceivePort _port = ReceivePort();

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  addComment() async {
    getAnimeData(widget.url);
    print(animeId);
    addAnime();
    var response = await _server.postRequest(addComment_link, {
      "comment_anime": '${animeId}',
      "comment_cont": '${_myController.text}',
      "comment_user": '$myId',
      "comment_fair": _myCommentFire == false ? "0" : "1",
      "reply_of": "NULL"
    });
    if (response['status'] == "success") {
      print("successsssssssssssssssssssssssssssssssssssssssss");
    } else {
      print("add comment fail");
    }
    setState(() {
      addAnime();
      refresh();
    });
  }

//////////////////////////
  int myId = 0;
  bool isFullText = false;
  List<Comments> comments3 = [];
  Future<List<Comments>>? commentsFuture;
  bool allReplies = false;
  bool isEdit = false;
  bool isRepling = false;
  final Server _server = Server();

  addAnime() async {
    //print('${animeId} 000000000000000000000000000');
    var response = await _server.postRequest(addAnime_link, {
      "anime_id": '${animeId}',
    });

    if (response['status'] == "success") {
      print("successsssssssssssssssssssssssssssssssssssssssss");
    } else {
      print("add comment fail");
    }
    setState(() {
      refresh();
    });
  }

  like(int id) async {
    var response = await _server.postRequest(like_link, {
      "user_id": '${myId}',
      "comment_id": '$id',
      "comment_anime": '${animeId}',
    });

    if (response['status'] == "success") {
      return true;
    } else {
      return false;
    }
  }

  unLike(int id) async {
    var response = await _server.postRequest(unLike_link, {
      "user_id": '${myId}',
      "comment_id": '$id',
    });

    if (response['status'] == "success") {
      return true;
    } else {
      return false;
    }
  }

  refreshPage(String quality) {
    print('refreshPage');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AnimePlayer(
                  url: widget.url,
                  quality: quality,
                )));
  }

  Future refresh() async {
    setState(() {
      comments3.clear();
      getComments(animeId, myId);
      commentsFuture = getComments(animeId, myId);
      addAnime();
    });
  }

  refresh2() {
    setState(() {
      test = 200 - _myController.text.length;
    });
  }

  fetch() async {}

  static Future<List<Comments>> getComments(int animeId, int myId) async {
    final response = await http.post(Uri.parse('${comments_link}'),
        body: {"comment_anime": '${animeId}', "my_id": '${myId}'});

    final body = json.decode(response.body);

    return body.map<Comments>(Comments.fromJson).toList();
  }

  int test = 200;
  final listController = ScrollController();
  final listController2 = ScrollController();

  bool _isComment = true;
  bool _myCommentFire = false;
  String _replyTo = '';
  bool isAdmin = true;
  bool showIcons = true;
  int? _replyToId;
  String? commentTime;
  bool isFullScrean = false;
  bool allowBack = true;
  int fullScrean = 10;
  var draggableSize = 0.0;
  bool isMyComment = false;

  final TextEditingController _myController = TextEditingController();

  addReplay(int id) async {
    var response = await _server.postRequest(addComment_link, {
      "comment_anime": '${animeId}',
      "comment_cont": '${_myController.text}',
      "comment_user": "$myId",
      "comment_fair": _myCommentFire == true ? "1" : "0",
      "reply_of": '$id'
    });

    if (response['status'] == "success") {
      print("successsssssssssssssssssssssssssssssssssssssssss");
    } else {
      print("add comment fail");
    }
    setState(() {
      refresh();
    });
  }

  Future deleteComment(int id) async {
    var response = await _server.postRequest(deleteComment_link, {
      "comment_anime": '${animeId}',
      "comment_id": '$id',
    });

    if (response['status'] == "success") {
      print("successsssssssssssssssssssssssssssssssssssssssss");
      final SnackBar snackBar = SnackBar(
          content: Row(
        children: [Text("Comment has been deleted"), Icon(Icons.done)],
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      setState(() {});
      return true;
    } else {
      final SnackBar snackBar = SnackBar(
          content: Row(
        children: [
          Text("Comment has not been removed"),
          Icon(Icons.remove_circle)
        ],
      ));
      print("add comment fail");
      return false;
    }
  }

  late int _myCommentIndex;
  late int _myReplyIndex;
  Future editComment(int id, String time) async {
    var response = await _server.postRequest(editComment_link, {
      "comment_anime": '${animeId}',
      "comment_cont": '${_myController.text}',
      "comment_fair": _myCommentFire == true ? "1" : "0",
      "comment_id": '$id',
      "comment_time": '$time',
      "is_edited": '1'
    });

    if (response['status'] == "success") {
      print("successsssssssssssssssssssssssssssssssssssssssss");
      final SnackBar snackBar = SnackBar(
          content: Row(
        children: [Text("Comment has been edited"), Icon(Icons.done)],
      ));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {});
      return true;
    } else {
      final SnackBar snackBar = SnackBar(
          content: Row(
        children: [
          Text("Comment has not been edited"),
          Icon(Icons.remove_circle)
        ],
      ));
      print("add comment fail");
      return false;
    }
  }

  getMyId() async {
    Map<String, dynamic> user = await UserModel.getAcount();
    myId = int.parse(user['id']);
    print('${myId} MyIddddddddddddddddddddddddddd');
  }

  String id = '';
  bool ok = false;
  String play = '';
  Future getAnime(link) async {
    try {
      final url = Uri.parse(link);
      final response = await http.get(url);

      dom.Document html = dom.Document.html(response.body);

      final ifram = html
          .querySelectorAll('#pembed > iframe')
          .map((e) => e.attributes['src']!)
          .toString();
      print("Screeebt/////////////////" + ifram);
      print("play/////////////////" + widget.quality);
      final url2 = Uri.parse(ifram.replaceAll("(", '').replaceAll(")", ''));
      final response2 = await http.get(url2);
      dom.Document html2 = dom.Document.html(response2.body);
      var play1 = html2
          .querySelectorAll('body > script')
          .map((e) => e.innerHtml.trim())
          .toString();

      play = play1
          .substring(0, play1.indexOf('",'))
          .replaceAll('var player = new Clappr.Player(', '')
          .replaceAll('{', '')
          .replaceAll('source: "', '')
          .replaceAll(' ', '')
          .replaceAll('0p', '${widget.quality}p_1')
          .replaceAll("(", '')
          .replaceAll(")", '');
      print("play/////////////////" + play);
      ok = true;
    } catch (e) {
      ok = false;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getMyId();
    draggableController.addListener(() {
      draggableSize =
          (MediaQuery.of(context).size.height / draggableController.size) -
              MediaQuery.of(context).size.height;
      setState(() {});
      print(
          'Size eeeeee ddddd $draggableController.size   medi eeeeee ddddd ${MediaQuery.of(context).size.height}   == ${(MediaQuery.of(context).size.height / draggableController.size) - MediaQuery.of(context).size.height}');
    });
    _myController.addListener(() {
      if (_myController.text.length < 3) {
        refresh2();
      } else {
        refresh2();
      }
    });

    getAnimeData(widget.url);

    //addAnime();
    listController2.addListener(() {
      if (listController2.position.keepScrollOffset == true) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });

    listController.addListener(() {
      if (listController.position.keepScrollOffset == true) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
      if (listController.position.maxScrollExtent == listController.offset) {
        refresh2();
      }
    });
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      if (status == DownloadTaskStatus.complete) {
        print(
            "///////////////////////////////  complete  ///////////////////////////////");
      }
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  Future reply(int commentId, String username) async {
    setState(() {
      isEdit = false;
      _isComment = false;
      isRepling = true;
      if (isRepling = true) {
        _myController.text = username;
        _replyTo = username;
        _replyToId = commentId;
      }
    });
  }

  @override
  void dispose() {
    // _videoPlayerController.dispose();
    // _chewieController!.dispose();
    draggableController.dispose();
    listController.dispose();
    listController2.dispose();

    _myController.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconTheme = Theme.of(context).iconTheme.color!;
    final Color textColor = Color.fromARGB(255, 160, 146, 167);
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color bottomUp = Theme.of(context).primaryColorDark;
    final Color bottomDown = Theme.of(context).primaryColorLight;
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          allowBack = isFullScrean;
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          isFullScrean = false;
        });
        return allowBack != false ? false : true;
      },
      child: Scaffold(
          body: (ifram.isNotEmpty || ok)
              ? ListView(controller: listController2, children: [
                  //AnimeVideoPlayer(size: size, chewieController: _chewieController),
                  Container(
                      height: isFullScrean == true ? size.height : 280,
                      width: size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25)),
                        // gradient: LinearGradient(
                        //     begin: Alignment.centerLeft,
                        //     end: Alignment.centerRight,
                        //     colors: [
                        //       Color.fromARGB(255, 56, 56, 56),
                        //       Color.fromARGB(255, 0, 0, 0),
                        //       Color.fromARGB(255, 56, 56, 56),
                        //     ])
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              ok
                                  ? AnimeVideoPlayer(
                                      url: play,
                                      context: context,
                                    )
                                  : Container(
                                      height: isFullScrean == true
                                          ? size.height
                                          : 240,
                                      width: isFullScrean == true
                                          ? size.width
                                          : size.width,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(25),
                                            bottomRight: Radius.circular(25)),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (showIcons) {
                                            setState(() {
                                              showIcons = false;
                                              print('***************** false');
                                            });
                                          } else {
                                            setState(() {
                                              showIcons = true;
                                              print('***************** true');
                                            });
                                          }
                                        },
                                        child: WebView(
                                            backgroundColor: primaryColor,
                                            onProgress: (progress) {
                                              setState(() {
                                                progressLoading = progress;
                                              });
                                              print('progress $progress');
                                            },
                                            initialUrl: ifram,
                                            javascriptMode:
                                                JavascriptMode.unrestricted),
                                      )),
                              Positioned(
                                child: isFullScrean == true
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            SystemChrome
                                                .setPreferredOrientations([
                                              DeviceOrientation.portraitUp
                                            ]);
                                            isFullScrean = false;
                                          });
                                        },
                                        child: showIcons == true
                                            ? Container(
                                                color: Color.fromARGB(
                                                    64, 158, 158, 158),
                                                child: ImageIcon(
                                                    AssetImage(
                                                        'images/Light/Arrow - Left Circle.png'),
                                                    size: 30),
                                              )
                                            : Container())
                                    : SizedBox(),
                                left: 30,
                                top: 20,
                              ),
                              Positioned(
                                child: isFullScrean == true
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (right == true) {
                                              SystemChrome
                                                  .setPreferredOrientations([
                                                DeviceOrientation.landscapeLeft
                                              ]);
                                              right = false;
                                            } else {
                                              SystemChrome
                                                  .setPreferredOrientations([
                                                DeviceOrientation.landscapeRight
                                              ]);
                                              right = true;
                                            }
                                          });
                                        },
                                        child: Container(
                                          color:
                                              Color.fromARGB(64, 158, 158, 158),
                                          child: Icon(
                                            Icons.screen_rotation,
                                            size: 30,
                                          ),
                                        ))
                                    : SizedBox(),
                                right: 30,
                                top: 20,
                              ),
                              progressLoading == 100
                                  ? Container()
                                  : Center(
                                      child: Text(
                                        '',
                                        //'$progressLoading',
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                            ],
                          ),
                          isFullScrean == false
                              ? Container(
                                  height: size.height / 23,
                                  decoration: BoxDecoration(
                                    color: iconTheme,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(25),
                                        bottomRight: Radius.circular(25)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            width: 27,
                                            height: 27,
                                            child: ImageIcon(
                                              AssetImage(
                                                  'images/Light/Arrow-Left.png'),
                                              color: primaryColor,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              String url = widget.url;
                                              String ep = (eNP - 1).toString();
                                              String urlLast = url.substring(
                                                  0,
                                                  url.indexOf(
                                                      '-%d8%a7%d9%84%d8%ad%d9%84%d9%82%d8%a9-'));
                                              urlLast =
                                                  '$urlLast-%d8%a7%d9%84%d8%ad%d9%84%d9%82%d8%a9-$ep';

                                              print(
                                                  '///////////////////////////// $urlLast');
                                              eNP > 1
                                                  ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AnimePlayer(
                                                                url: urlLast,
                                                                quality: widget
                                                                    .quality,
                                                              )))
                                                  : true;
                                            },
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Stack(children: [
                                                    Positioned(
                                                        right: 5,
                                                        child: ImageIcon(
                                                            AssetImage(
                                                                'images/Light/Arrow-Left 2.png'),
                                                            color: eNP > 1
                                                                ? bottomDown
                                                                : Colors.grey)),
                                                    Positioned(
                                                        child: ImageIcon(
                                                            AssetImage(
                                                                'images/Light/Arrow-Left 2.png'),
                                                            color: eNP > 1
                                                                ? bottomDown
                                                                : Colors.grey))
                                                  ]),
                                                ],
                                              ),
                                            )),
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet<dynamic>(
                                              backgroundColor:
                                                  Colors.transparent,
                                              isScrollControlled: true,
                                              context: context,
                                              builder: (context) {
                                                Size size =
                                                    MediaQuery.of(context).size;
                                                return GestureDetector(
                                                  onTap: () =>
                                                      Navigator.pop(context),
                                                  child:
                                                      DraggableScrollableSheet(
                                                          initialChildSize: 0.3,
                                                          minChildSize: 0.3,
                                                          builder: (context,
                                                                  scrollController) =>
                                                              Container(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child: ListView(
                                                                      //controller: scrollController,
                                                                      children: <Widget>[
                                                                        Container(
                                                                          padding:
                                                                              EdgeInsets.only(top: 10),
                                                                          decoration: BoxDecoration(
                                                                              // gradient: LinearGradient(
                                                                              //     begin: Alignment
                                                                              //         .topCenter,
                                                                              //     end: Alignment
                                                                              //         .bottomCenter,
                                                                              //     colors: [

                                                                              //     ]),
                                                                              color: iconTheme,
                                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
                                                                          height:
                                                                              size.height / 3,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 8.0),
                                                                            child: ListView.builder(
                                                                                itemCount: 3,
                                                                                itemBuilder: (context, index) {
                                                                                  final str = downloadList[index].server;
                                                                                  final start = '">';
                                                                                  final end = '</b>';

                                                                                  final startIndex = str.indexOf(start);
                                                                                  final endIndex = str.indexOf(end);
                                                                                  final result = str.substring(startIndex + start.length, endIndex).trim();
                                                                                  return GestureDetector(
                                                                                    onLongPress: () {
                                                                                      final _url = downloadList[index - 1].url.replaceAll("(", '').replaceAll(")", '');
                                                                                      admOpen(_url, '$epName[${downloadList[index].quality}]');
                                                                                    },
                                                                                    onTap: () async {
                                                                                      Navigator.pop(context);
                                                                                      final _url = downloadList[index - 1].url.replaceAll("(", '').replaceAll(")", '');

                                                                                      download(_url);
                                                                                    },
                                                                                    /*download(
                                                                  downloadList[
                                                                          index]
                                                                      .url
                                                                      .replaceAll(
                                                                          "(", '')
                                                                      .replaceAll(
                                                                          ")",
                                                                          ''),
                                                                  epName
                                                                      .replaceAll(
                                                                          "(",
                                                                          '')
                                                                      .replaceAll(
                                                                          ")",
                                                                          ''));
                                                            },*/
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(5.0),
                                                                                      child: downloadList[index].quality.replaceAll("(", '').replaceAll(")", '').replaceAll('"', '') == '1080p' || downloadList[index].quality.replaceAll("(", '').replaceAll(")", '').replaceAll('"', '') == '720p'
                                                                                          ? Row(children: [
                                                                                              Padding(
                                                                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                                                                child: Column(
                                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Container(
                                                                                                      width: size.width / 1.8,
                                                                                                      child: Text(
                                                                                                        result.replaceAll("(", '').replaceAll(")", '').replaceAll('"', ''),
                                                                                                        style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 15.5),
                                                                                                      ),
                                                                                                    ),
                                                                                                    Text(''),
                                                                                                    Container(
                                                                                                      width: size.width / 1.8,
                                                                                                      child: Text(
                                                                                                        downloadList[index].quality,
                                                                                                        style: TextStyle(color: primaryColor, fontSize: 12.5),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              )
                                                                                            ])
                                                                                          : Container(),
                                                                                    ),
                                                                                  );
                                                                                }),
                                                                          ),
                                                                        )
                                                                      ]))),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: 25,
                                            height: 25,
                                            child: ImageIcon(
                                              AssetImage(
                                                  'images/Light/Download.png'),
                                              color: primaryColor,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet<dynamic>(
                                              backgroundColor:
                                                  Colors.transparent,
                                              isScrollControlled: true,
                                              context: context,
                                              builder: (context) {
                                                return DraggableScrollableSheet(
                                                  controller:
                                                      draggableController,
                                                  initialChildSize: 0.7,
                                                  minChildSize: 0.3,
                                                  builder: (context,
                                                          scrollController) =>
                                                      Container(
                                                          child: ListView(
                                                    controller:
                                                        scrollController,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () {
                                                          scrollToItem(epIndex);
                                                        },
                                                        child: Center(
                                                          child: Container(
                                                            width: 35,
                                                            height: 35,
                                                            child: ImageIcon(
                                                              AssetImage(
                                                                  'images/Light/Location.png'),
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                                color:
                                                                    backgroundColor,
                                                                // gradient: LinearGradient(
                                                                //     begin: Alignment
                                                                //         .topCenter,
                                                                //     end: Alignment
                                                                //         .bottomCenter,
                                                                //     colors: []),
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            25),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            25))),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 8.0),
                                                          child: SizedBox(
                                                            height: size.height,
                                                            child: ScrollablePositionedList
                                                                .builder(
                                                                    padding: EdgeInsets.only(
                                                                        bottom: draggableSize +
                                                                            100),
                                                                    itemScrollController:
                                                                        itemScrollController,
                                                                    itemCount:
                                                                        allEPName
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      if (allEPName[
                                                                              index] ==
                                                                          epName) {
                                                                        epIndex =
                                                                            index;
                                                                      }
                                                                      if (allEPName[
                                                                              index] ==
                                                                          allEPName.length -
                                                                              1) {}

                                                                      // if (index <
                                                                      //     allEPName
                                                                      //         .length) {
                                                                      return GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          allEPName[index] != epName
                                                                              ? Navigator.push(context, MaterialPageRoute(builder: (context) => AnimePlayer(url: allEPUrl[index], quality: widget.quality)))
                                                                              : true;
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(5.0),
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(color: allEPName[index] == epName && allEPCount > 1 ? iconTheme : Colors.transparent, borderRadius: BorderRadius.circular(10)),
                                                                            child:
                                                                                Row(children: [
                                                                              Container(
                                                                                height: size.width / 4,
                                                                                width: size.width / 2.75,
                                                                                decoration: BoxDecoration(
                                                                                    image: DecorationImage(
                                                                                        image: NetworkImage(
                                                                                          allEPImage[index],
                                                                                        ),
                                                                                        fit: BoxFit.cover),
                                                                                    borderRadius: BorderRadius.circular(10)),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                      width: size.width / 1.8,
                                                                                      child: Text(
                                                                                        allEPName[index],
                                                                                        style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 15.5),
                                                                                      ),
                                                                                    ),
                                                                                    Text(''),
                                                                                    Container(
                                                                                      width: size.width / 1.8,
                                                                                      child: Text(
                                                                                        allEPSub[index],
                                                                                        style: TextStyle(color: primaryColor, fontSize: 12.5),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ]),
                                                                          ),
                                                                        ),
                                                                      );
                                                                      // } else {
                                                                      //   return Container();
                                                                      //   //     Padding(
                                                                      //   //   padding:
                                                                      //   //       const EdgeInsets.symmetric(vertical: 15),
                                                                      //   //   child:
                                                                      //   //       Center(child: const CircularProgressIndicator()),
                                                                      //   // );
                                                                      // }
                                                                    }),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: 25,
                                            height: 25,
                                            child: ImageIcon(
                                              AssetImage(
                                                  'images/Light/More-Circle.png'),
                                              color: primaryColor,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              String url = widget.url;
                                              String ep = (eNP + 1).toString();
                                              String urlNext = url.substring(
                                                  0,
                                                  url.indexOf(
                                                      '-%d8%a7%d9%84%d8%ad%d9%84%d9%82%d8%a9-'));
                                              urlNext =
                                                  '$urlNext-%d8%a7%d9%84%d8%ad%d9%84%d9%82%d8%a9-$ep';

                                              print(
                                                  '///////////////////////////// $urlNext');
                                              allEPCount > eNP
                                                  ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AnimePlayer(
                                                                  quality: widget
                                                                      .quality,
                                                                  url:
                                                                      urlNext)))
                                                  : true;
                                            },
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Stack(children: [
                                                    Positioned(
                                                        child: ImageIcon(
                                                            AssetImage(
                                                                'images/Light/Arrow - Right 2.png'),
                                                            color: allEPCount >
                                                                    eNP
                                                                ? bottomDown
                                                                : Colors.grey)),
                                                    Positioned(
                                                        left: 5,
                                                        child: ImageIcon(
                                                            AssetImage(
                                                                'images/Light/Arrow - Right 2.png'),
                                                            color: allEPCount >
                                                                    eNP
                                                                ? bottomDown
                                                                : Colors.grey))
                                                  ]),
                                                ],
                                              ),
                                            )),
                                        GestureDetector(
                                          onTap: () async {
                                            if (ok != false) {
                                              // AnimeVideoPlayerState
                                              //         .videoPlayerController =await
                                              //     VideoPlayerController.network(
                                              //         play.replaceAll(
                                              //             '240', '360p_1'));

                                              //.replaceAll('240p', '${widget.quality}p_1')
                                              showModalBottomSheet<dynamic>(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  isScrollControlled: true,
                                                  context: context,
                                                  builder: (context) {
                                                    Size size =
                                                        MediaQuery.of(context)
                                                            .size;
                                                    return DraggableScrollableSheet(
                                                        initialChildSize: 0.3,
                                                        minChildSize: 0.3,
                                                        builder: (context,
                                                                scrollController) =>
                                                            Container(
                                                                color: Colors
                                                                    .transparent,
                                                                child: Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            8.0),
                                                                    child: ListView.builder(
                                                                        itemCount: 5,
                                                                        itemBuilder: (context, index) {
                                                                          return GestureDetector(
                                                                            onTap: () =>
                                                                                refreshPage(list[index]),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                                                              child: Container(
                                                                                  child: Text(
                                                                                list[index] + "P",
                                                                                style: TextStyle(fontSize: 22),
                                                                              )),
                                                                            ),
                                                                          );
                                                                        }))));
                                                  });
                                            } else {
                                              if (isFullScrean == false) {
                                                SystemChrome
                                                    .setPreferredOrientations([
                                                  DeviceOrientation
                                                      .landscapeLeft
                                                ]);
                                                SystemChrome
                                                    .setEnabledSystemUIMode(
                                                        SystemUiMode
                                                            .immersiveSticky);
                                                allowBack = true;
                                                isFullScrean = true;
                                              } else {
                                                allowBack = false;
                                                isFullScrean = false;
                                              }
                                            }
                                          },
                                          child: ok == false
                                              ? Icon(
                                                  Icons.fullscreen,
                                                  color: primaryColor,
                                                )
                                              : Container(
                                                  width: 25,
                                                  height: 25,
                                                  child: ImageIcon(
                                                    AssetImage(
                                                        'images/Light/Setting.png'),
                                                    color: primaryColor,
                                                  ),
                                                ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container()
                        ],
                      )),

                  // ////// T E X T   F I L E  D

                  // isFullScrean == false
                  //     ? Padding(
                  //         padding:
                  //             const EdgeInsets.only(left: 8, right: 8, top: 5),
                  //         child: Container(
                  //           color: Colors.transparent,
                  //           height: _isComment == true
                  //               ? size.height / 15
                  //               : size.height / 11,
                  //           child: Stack(children: [
                  //             Container(
                  //               margin: EdgeInsets.only(right: 75),
                  //               padding: EdgeInsets.only(left: 8),
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(15),
                  //                 // gradient: LinearGradient(
                  //                 //     colors: [Colors.black, Colors.grey])
                  //               ),
                  //             ),
                  //             Column(
                  //               mainAxisAlignment: _isComment == false
                  //                   ? MainAxisAlignment.end
                  //                   : MainAxisAlignment.start,
                  //               children: [
                  //                 _isComment == false
                  //                     ? Container(
                  //                         decoration: BoxDecoration(
                  //                           // gradient: LinearGradient(colors: [
                  //                           //   Colors.black,
                  //                           //   Colors.grey
                  //                           // ]),
                  //                           borderRadius: BorderRadius.only(
                  //                               topLeft: Radius.circular(15),
                  //                               topRight: Radius.circular(15)),
                  //                         ),
                  //                         margin: EdgeInsets.only(right: 75),
                  //                         padding: EdgeInsets.only(left: 8),
                  //                         height: size.height / 45,
                  //                         child: Row(
                  //                           mainAxisAlignment:
                  //                               MainAxisAlignment.spaceBetween,
                  //                           children: [
                  //                             Padding(
                  //                               padding: EdgeInsets.only(
                  //                                 left: 5,
                  //                               ),
                  //                               child: Text(
                  //                                 isEdit == true
                  //                                     ? "Edit comment"
                  //                                     : _isComment != true
                  //                                         ? 'Reply to ${_replyTo}'
                  //                                         : '',
                  //                                 style: TextStyle(
                  //                                     color:
                  //                                         Colors.grey.shade100),
                  //                               ),
                  //                             ),
                  //                             GestureDetector(
                  //                               onTap: () {
                  //                                 setState(() {
                  //                                   _isComment = true;
                  //                                   isEdit = false;
                  //                                   _myController.clear();
                  //                                 });
                  //                               },
                  //                               child: Padding(
                  //                                 padding: EdgeInsets.only(
                  //                                     left: 16, right: 12),
                  //                                 child: Icon(
                  //                                   Icons.cancel,
                  //                                   size: 17,
                  //                                   color: Colors.white,
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       )
                  //                     : Container(),
                  //                 Row(
                  //                   children: [
                  //                     Expanded(
                  //                         child: Container(
                  //                       height: size.height / 15,
                  //                       decoration: BoxDecoration(
                  //                           // gradient: LinearGradient(colors: [
                  //                           //   Colors.black,
                  //                           //   Colors.grey
                  //                           // ]),
                  //                           borderRadius: _isComment == true
                  //                               ? BorderRadius.circular(15)
                  //                               : BorderRadius.only(
                  //                                   bottomLeft:
                  //                                       Radius.circular(15),
                  //                                   bottomRight:
                  //                                       Radius.circular(15))),
                  //                       child: Row(
                  //                         children: [
                  //                           Padding(
                  //                             padding: EdgeInsets.only(
                  //                                 left: 16, right: 12),
                  //                             child: Icon(
                  //                               Icons.emoji_emotions,
                  //                               color: primaryColor,
                  //                             ),
                  //                           ),
                  //                           Expanded(
                  //                               child: GestureDetector(
                  //                             onTap: () {
                  //                               setState(() {});
                  //                             },
                  //                             child: TextField(
                  //                               style: TextStyle(
                  //                                   color: primaryColor),
                  //                               cursorColor: primaryColor,
                  //                               textInputAction:
                  //                                   TextInputAction.send,
                  //                               controller: _myController,
                  //                               decoration: InputDecoration(
                  //                                 hintText: _isComment != true
                  //                                     ? 'Edit the comment...'
                  //                                     : 'Add a comment ...',
                  //                                 hintStyle: TextStyle(
                  //                                   color: primaryColor,
                  //                                 ),
                  //                                 border: InputBorder.none,
                  //                               ),
                  //                             ),
                  //                           )),
                  //                           Padding(
                  //                               padding: EdgeInsets.only(
                  //                                   left: 1, right: 1),
                  //                               child: Text(
                  //                                 '${test}',
                  //                                 style: TextStyle(
                  //                                   fontSize: 15,
                  //                                   color: test < 0
                  //                                   ? Colors.red
                  //                                   : Colors.grey.shade700,
                  //                             ),
                  //                           )),
                  //                       //_myController.text.isNotEmpty
                  //                       1 == 1
                  //                           ? GestureDetector(
                  //                               onTap: () {
                  //                                 setState(() {
                  //                                   if (_myCommentFire ==
                  //                                       true) {
                  //                                     _myCommentFire =
                  //                                         false;
                  //                                   } else {
                  //                                     _myCommentFire = true;
                  //                                   }
                  //                                 });
                  //                               },
                  //                               child: Padding(
                  //                                 padding: EdgeInsets.only(
                  //                                     left: 5, right: 12),
                  //                                 child: CircleAvatar(
                  //                                   maxRadius: 16,
                  //                                   backgroundColor:
                  //                                       _myCommentFire ==
                  //                                               true
                  //                                           ? Colors.red
                  //                                           : Colors.grey
                  //                                               .shade700,
                  //                                   child: Text(
                  //                                     '🔥',
                  //                                     style: TextStyle(
                  //                                         fontSize: 18),
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                             )
                  //                           : Container(),
                  //                     ],
                  //                   ),
                  //                 )),
                  //                 Container(
                  //                     margin:
                  //                         const EdgeInsets.only(left: 16),
                  //                     width: size.height / 15,
                  //                     height: size.height / 15,
                  //                     decoration: BoxDecoration(
                  //                         // gradient: LinearGradient(colors: [
                  //                         //   Colors.grey,
                  //                         //   Colors.grey.shade800
                  //                         // ]),
                  //                         borderRadius:
                  //                             BorderRadius.circular(14)),
                  //                     child: GestureDetector(
                  //                         onTap: () {
                  //                           setState(() {
                  //                             FocusScope.of(context)
                  //                                 .requestFocus(
                  //                                     FocusNode());
                  //                           });
                  //                           if (_isComment == true) {
                  //                             setState(() {
                  //                               addComment();
                  //                               _myController.clear();
                  //                               _myCommentFire = false;
                  //                             });
                  //                           } else if (isEdit == true) {
                  //                             if (_myController
                  //                                 .text.isNotEmpty) {
                  //                               setState(() async {
                  //                                 setState(() {
                  //                                   isEdit = true;
                  //                                   _isComment = false;
                  //                                   if (_isComment ==
                  //                                       false) {
                  //                                     _replyTo = "";
                  //                                   }
                  //                                 });
                  //                                 if (await editComment(
                  //                                     _replyToId!,
                  //                                     commentTime!)) {
                  //                                   _editReply == false
                  //                                       ? setState(() {
                  //                                           comments3[_myCommentIndex]
                  //                                                   .commentCont =
                  //                                               _myController
                  //                                                   .text;
                  //                                           isEdit = false;
                  //                                           _isComment =
                  //                                               true;
                  //                                           _myController
                  //                                               .clear();
                  //                                         })
                  //                                       : setState(() {
                  //                                           comments3[_myCommentIndex]
                  //                                                   .replies[
                  //                                                       _myReplyIndex]
                  //                                                   .commentCont =
                  //                                               _myController
                  //                                                   .text;
                  //                                           isEdit = false;
                  //                                           _isComment =
                  //                                               true;
                  //                                           _editReply =
                  //                                               false;
                  //                                           _myController
                  //                                               .clear();
                  //                                         });
                  //                                 }
                  //                               });
                  //                               setState(() {
                  //                                 isEdit = false;
                  //                                 _editReply = false;
                  //                                 _isComment = true;
                  //                                 _myController.clear();
                  //                                 _myCommentFire = false;
                  //                               });
                  //                             }
                  //                           } else if (isRepling == true) {
                  //                             if (_myController
                  //                                 .text.isNotEmpty) {
                  //                               setState(() {
                  //                                 addReplay(_replyToId!);
                  //                                 _isComment = true;
                  //                                 _myController.clear();
                  //                                 _myCommentFire = false;
                  //                               });
                  //                             }
                  //                           }
                  //                         },
                  //                         child: Container(
                  //                           height: 30,
                  //                           width: 30,
                  //                           child: Center(
                  //                             child: ImageIcon(
                  //                               AssetImage(
                  //                                   'images/Light/Send.png'),
                  //                               size: 30,
                  //                               color: primaryColor,
                  //                             ),
                  //                           ),
                  //                         )))
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       ]),
                  //     ),
                  //   )
                  // : Container(),

                  //////// C O M M E N T S   S I C
                  isFullScrean == false
                      ? Container(
                          height: size.height - 360,
                          child: loading != true
                              ? PostComments(myId: myId, animeId: animeId)
                              : Container())
                      // ? Padding(
                      //     padding: const EdgeInsets.only(top: 5),
                      //     child: SizedBox(
                      //       height: size.height / 2.04,
                      //       child: Padding(
                      //           padding: const EdgeInsets.all(5.0),
                      //           child: FutureBuilder<List<Comments>>(
                      //               future: commentsFuture,
                      //               builder: (context, snapshot) {
                      //                 if (snapshot.connectionState ==
                      //                     ConnectionState.waiting) {
                      //                   return const Center(
                      //                       child: CircularProgressIndicator());
                      //                 } else if (snapshot.hasError) {
                      //                   //${snapshot.error}
                      //                   return Center(
                      //                       child: Text('No Connection',
                      //                           style: TextStyle(
                      //                               color: Colors.red)));
                      //                 } else if (snapshot.hasData) {
                      //                   final comments = snapshot.data!;
                      //                   comments3 = comments;
                      //                   return comments.isEmpty
                      //                       ? RefreshIndicator(
                      //                           onRefresh: refresh,
                      //                           child: Center(
                      //                               child: Text(
                      //                                   'No Comments yet',
                      //                                   style: TextStyle(
                      //                                       color: Colors.red))
                      //                               // CircularProgressIndicator()
                      //                               ),
                      //                         )
                      //                       : GestureDetector(
                      //                           onTap: () {
                      //                             FocusScope.of(context)
                      //                                 .requestFocus(
                      //                                     FocusNode());
                      //                             SystemChrome
                      //                                 .setEnabledSystemUIMode(
                      //                                     SystemUiMode
                      //                                         .immersiveSticky);
                      //                           },
                      //                           child: RefreshIndicator(
                      //                             onRefresh: refresh,
                      //                             child: ListView.builder(
                      //                                 controller:
                      //                                     listController,
                      //                                 itemCount:
                      //                                     comments.length + 1,
                      //                                 itemBuilder:
                      //                                     (context, index) {
                      //                                   if (index <
                      //                                       comments.length) {
                      //                                     return GestureDetector(
                      //                                       onTap: () {
                      //                                         FocusScope.of(
                      //                                                 context)
                      //                                             .requestFocus(
                      //                                                 FocusNode());
                      //                                       },
                      //                                       child: Stack(
                      //                                           children: [
                      //                                             Container(
                      //                                               // height: comments[index]
                      //                                               //             .replies
                      //                                               //             .length ==
                      //                                               //         0
                      //                                               //     ? size.height / 8
                      //                                               //     : size.height / 5.5,
                      //                                               decoration:
                      //                                                   BoxDecoration(
                      //                                                 borderRadius:
                      //                                                     BorderRadius.circular(
                      //                                                         14),
                      //                                               ),
                      //                                               child:
                      //                                                   Column(
                      //                                                 mainAxisAlignment:
                      //                                                     MainAxisAlignment
                      //                                                         .end,
                      //                                                 crossAxisAlignment:
                      //                                                     CrossAxisAlignment
                      //                                                         .start,
                      //                                                 children: [
                      //                                                   Row(
                      //                                                     crossAxisAlignment:
                      //                                                         CrossAxisAlignment.start,
                      //                                                     children: [
                      //                                                       Padding(
                      //                                                         padding: const EdgeInsets.only(top: 0, left: 8, right: 8),
                      //                                                         child: GestureDetector(
                      //                                                           onTap: () {
                      //                                                             // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfialPage()));
                      //                                                           },
                      //                                                           child: Container(
                      //                                                               width: 55,
                      //                                                               height: 55,
                      //                                                               decoration: BoxDecoration(
                      //                                                                 image: DecorationImage(
                      //                                                                     fit: BoxFit.cover,
                      //                                                                     image: NetworkImage(
                      //                                                                       image + comments[index].avatar,
                      //                                                                     )),
                      //                                                                 borderRadius: BorderRadius.circular(12),
                      //                                                                 //color: const Color.fromARGB(223, 119, 106, 106),
                      //                                                               )),
                      //                                                         ),
                      //                                                       ),
                      //                                                       Expanded(
                      //                                                         flex: 4,
                      //                                                         child: Padding(
                      //                                                           padding: const EdgeInsets.only(right: 8.0),
                      //                                                           child: Container(
                      //                                                             padding: const EdgeInsets.only(left: 10),
                      //                                                             decoration: BoxDecoration(
                      //                                                               color: const Color.fromARGB(223, 24, 23, 23),
                      //                                                               borderRadius: BorderRadius.circular(12),
                      //                                                             ),
                      //                                                             child: Column(
                      //                                                               crossAxisAlignment: CrossAxisAlignment.start,
                      //                                                               mainAxisAlignment: MainAxisAlignment.start,
                      //                                                               children: [
                      //                                                                 Container(
                      //                                                                   child: Row(
                      //                                                                     children: [
                      //                                                                       Text(
                      //                                                                         comments[index].name,
                      //                                                                         style: const TextStyle(
                      //                                                                           fontWeight: FontWeight.bold,
                      //                                                                           color: Color.fromARGB(218, 228, 222, 222),
                      //                                                                           fontSize: 15,
                      //                                                                         ),
                      //                                                                       ),
                      //                                                                       const SizedBox(
                      //                                                                         width: 10,
                      //                                                                       ),
                      //                                                                       Text(
                      //                                                                         '@${comments[index].username}',
                      //                                                                         style: const TextStyle(
                      //                                                                           color: Color.fromARGB(106, 228, 222, 222),
                      //                                                                           fontSize: 12,
                      //                                                                         ),
                      //                                                                       ),
                      //                                                                       const SizedBox(
                      //                                                                         width: 10,
                      //                                                                       ),
                      //                                                                       Container(
                      //                                                                         margin: const EdgeInsets.only(right: 10),
                      //                                                                         child: comments[index].isAdmin == true
                      //                                                                             ? ImageIcon(
                      //                                                                                 AssetImage('images/Light/Star.png'),
                      //                                                                                 color: Colors.amber,
                      //                                                                                 size: 14,
                      //                                                                               )
                      //                                                                             : Container(),
                      //                                                                       ),
                      //                                                                       Container(
                      //                                                                         margin: const EdgeInsets.only(right: 15),
                      //                                                                         child: comments[index].isEdited == true
                      //                                                                             ? ImageIcon(
                      //                                                                                 AssetImage('images/Light/Edit Square.png'),
                      //                                                                                 color: Colors.grey,
                      //                                                                                 size: 14,
                      //                                                                               )
                      //                                                                             : Container(),
                      //                                                                       ),
                      //                                                                       const Expanded(
                      //                                                                           child: SizedBox(
                      //                                                                         child: Text(''),
                      //                                                                       )),
                      //                                                                       myId.toString() == comments[index].commentUser || isAdmin == true
                      //                                                                           ? GestureDetector(
                      //                                                                               onTap: () {
                      //                                                                                 setState(() {
                      //                                                                                   FocusScope.of(context).requestFocus(FocusNode());
                      //                                                                                 });
                      //                                                                                 showModalBottomSheet(
                      //                                                                                   context: context,
                      //                                                                                   builder: (context) {
                      //                                                                                     return Container(
                      //                                                                                       color: Color.fromARGB(255, 19, 18, 18),
                      //                                                                                       height: size.height / 6,
                      //                                                                                       child: Padding(
                      //                                                                                         padding: const EdgeInsets.all(8.0),
                      //                                                                                         child: Column(
                      //                                                                                           children: [
                      //                                                                                             GestureDetector(
                      //                                                                                               onTap: () async {
                      //                                                                                                 Navigator.pop(context);
                      //                                                                                                 if (await deleteComment(int.parse(comments[index].commentId))) {
                      //                                                                                                   setState(() async {
                      //                                                                                                     comments3.removeAt(index);
                      //                                                                                                   });
                      //                                                                                                 } else {
                      //                                                                                                   true;
                      //                                                                                                 }
                      //                                                                                                 setState(() {
                      //                                                                                                   isEdit = false;
                      //                                                                                                   _isComment = true;
                      //                                                                                                   isRepling = false;
                      //                                                                                                   _myController.clear();
                      //                                                                                                 });
                      //                                                                                               },
                      //                                                                                               child: Padding(
                      //                                                                                                 padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                      //                                                                                                 child: Container(
                      //                                                                                                   color: Color.fromARGB(255, 19, 18, 18),
                      //                                                                                                   width: double.infinity,
                      //                                                                                                   child: Row(
                      //                                                                                                     children: const [
                      //                                                                                                       Text(
                      //                                                                                                         'Delete  ',
                      //                                                                                                         style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
                      //                                                                                                       ),
                      //                                                                                                       ImageIcon(AssetImage('images/Light/Delete.png'), color: Colors.grey, size: 20)
                      //                                                                                                     ],
                      //                                                                                                   ),
                      //                                                                                                 ),
                      //                                                                                               ),
                      //                                                                                             ),
                      //                                                                                             myId.toString() == comments[index].commentUser
                      //                                                                                                 ? GestureDetector(
                      //                                                                                                     onTap: () {
                      //                                                                                                       commentTime = comments[index].commentTime;
                      //                                                                                                       _replyToId = int.parse(comments[index].commentId);
                      //                                                                                                       setState(() {
                      //                                                                                                         setState(() {
                      //                                                                                                           isEdit = true;
                      //                                                                                                           _isComment = false;
                      //                                                                                                           if (_isComment == false) {
                      //                                                                                                             _replyTo = "";
                      //                                                                                                           }
                      //                                                                                                         });
                      //                                                                                                         _myCommentIndex = index;
                      //                                                                                                         print('iiiiiiiiiiiiiiiiiiiiindex $index');
                      //                                                                                                       });

                      //                                                                                                       _myController.clear();
                      //                                                                                                       Navigator.pop(context);
                      //                                                                                                     },
                      //                                                                                                     child: Padding(
                      //                                                                                                       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                      //                                                                                                       child: Container(
                      //                                                                                                         color: Color.fromARGB(255, 19, 18, 18),
                      //                                                                                                         width: double.infinity,
                      //                                                                                                         child: Row(
                      //                                                                                                           children: const [
                      //                                                                                                             Text(
                      //                                                                                                               'Edit  ',
                      //                                                                                                               style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
                      //                                                                                                             ),
                      //                                                                                                             ImageIcon(
                      //                                                                                                               AssetImage('images/Light/Edit.png'),
                      //                                                                                                               color: Colors.grey,
                      //                                                                                                               size: 20,
                      //                                                                                                             )
                      //                                                                                                           ],
                      //                                                                                                         ),
                      //                                                                                                       ),
                      //                                                                                                     ),
                      //                                                                                                   )
                      //                                                                                                 : Container()
                      //                                                                                           ],
                      //                                                                                         ),
                      //                                                                                       ),
                      //                                                                                     );
                      //                                                                                   },
                      //                                                                                 );
                      //                                                                               },
                      //                                                                               child: Container(
                      //                                                                                 margin: EdgeInsets.only(top: 3, right: 8),
                      //                                                                                 width: 20,
                      //                                                                                 child: Icon(
                      //                                                                                   Icons.more_horiz,
                      //                                                                                   color: Colors.grey,
                      //                                                                                   size: 20,
                      //                                                                                 ),
                      //                                                                               ),
                      //                                                                             )
                      //                                                                           : const Text(''),
                      //                                                                     ],
                      //                                                                   ),
                      //                                                                 ),
                      //                                                                 Column(
                      //                                                                   children: [
                      //                                                                     Container(
                      //                                                                       margin: EdgeInsets.only(right: 8, bottom: 8),
                      //                                                                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                      //                                                                       child: Container(
                      //                                                                         margin: EdgeInsets.all(5),
                      //                                                                         child: comments[index].fair == true
                      //                                                                             ? GestureDetector(
                      //                                                                                 onDoubleTap: () {
                      //                                                                                   setState(() {
                      //                                                                                     comments[index].fair = false;
                      //                                                                                   });
                      //                                                                                 },
                      //                                                                                 child: Padding(
                      //                                                                                   padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: 8),
                      //                                                                                   child: Container(
                      //                                                                                     decoration: BoxDecoration(
                      //                                                                                       borderRadius: BorderRadius.circular(14),
                      //                                                                                     ),
                      //                                                                                     child: Center(
                      //                                                                                       child: Row(
                      //                                                                                         mainAxisAlignment: MainAxisAlignment.center,
                      //                                                                                         children: [
                      //                                                                                           Text(
                      //                                                                                             'Double tap to view the comment ',
                      //                                                                                             style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.red),
                      //                                                                                           ),
                      //                                                                                           ImageIcon(
                      //                                                                                             AssetImage(
                      //                                                                                               'images/Light/Show.png',
                      //                                                                                             ),
                      //                                                                                             color: Colors.red,
                      //                                                                                             size: 15,
                      //                                                                                           )
                      //                                                                                         ],
                      //                                                                                       ),
                      //                                                                                     ),
                      //                                                                                   ),
                      //                                                                                 ))
                      //                                                                             : Text(
                      //                                                                                 comments[index].commentCont,
                      //                                                                                 style: const TextStyle(
                      //                                                                                   color: Color.fromARGB(218, 228, 222, 222),
                      //                                                                                   fontSize: 15,
                      //                                                                                 ),
                      //                                                                               ),
                      //                                                                       ),
                      //                                                                     ),
                      //                                                                   ],
                      //                                                                 ),
                      //                                                               ],
                      //                                                             ),
                      //                                                           ),
                      //                                                         ),
                      //                                                       )
                      //                                                     ],
                      //                                                   ),
                      //                                                   Padding(
                      //                                                     padding: const EdgeInsets.only(
                      //                                                         top: 5.0,
                      //                                                         right: 10,
                      //                                                         bottom: 5,
                      //                                                         left: 15),
                      //                                                     child:
                      //                                                         Row(
                      //                                                       mainAxisAlignment:
                      //                                                           MainAxisAlignment.spaceAround,
                      //                                                       children: [
                      //                                                         Expanded(
                      //                                                           flex: 2,
                      //                                                           child: Text('   '),
                      //                                                         ),
                      //                                                         Expanded(
                      //                                                           flex: 3,
                      //                                                           child: Text(
                      //                                                             Jiffy(
                      //                                                               comments[index].commentTime,
                      //                                                             ).fromNow(),
                      //                                                             style: const TextStyle(fontSize: 12, color: Colors.grey),
                      //                                                           ),
                      //                                                         ),
                      // Expanded(
                      //   flex: 2,
                      //   child: GestureDetector(
                      //     onTap: () {},
                      //     child: Text(
                      //       comments[index].likes > 1 ? '${comments[index].likes} Likes' : '${comments[index].likes} like',
                      //       style: const TextStyle(fontSize: 12, color: Colors.grey),
                      //     ),
                      //   ),
                      // ),
                      // Expanded(
                      //   flex: 2,
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       setState(() {
                      //         print(comments[index].commentId);
                      //         reply(int.parse(comments[index].commentId), '@${comments[index].username}');
                      //       });
                      //     },
                      //     child: Text(
                      //       comments[index].replies.length > 1 ? '${comments[index].replies.length} Replies' : '${comments[index].replies.length} reply',
                      //       style: const TextStyle(fontSize: 12, color: Colors.grey),
                      //     ),
                      //   ),
                      // ),
                      // Expanded(
                      //   flex: 2,
                      //   child: SizedBox(),
                      // ),
                      // Expanded(
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       if (comments[index].isLiked == true) {
                      //         if (unLike(int.parse(comments[index].commentId)) == true) {
                      //           setState(() {
                      //             comments[index].isLiked = true;
                      //             comments[index].likes += 1;
                      //           });
                      //         } else {
                      //           setState(() {
                      //             comments[index].isLiked = false;
                      //             comments[index].likes -= 1;
                      //           });
                      //         }
                      //       } else {
                      //         if (like(int.parse(comments[index].commentId)) == true) {
                      //           setState(() {
                      //             comments[index].isLiked = false;
                      //             comments[index].likes -= 1;
                      //           });
                      //         } else {
                      //           setState(() {
                      //             comments[index].isLiked = true;
                      //             comments[index].likes += 1;
                      //           });
                      //         }
                      //       }
                      //     },
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.end,
                      //       children: [
                      //         Text(
                      //           '',
                      //           //'${comments[index].likes}',
                      //           style: TextStyle(fontSize: 12, color: Colors.grey),
                      //         ),
                      //         ImageIcon(
                      //           AssetImage('images/Light/Heart.png'),
                      //           color: comments[index].isLiked == true ? Colors.red : Colors.grey,
                      //           size: 16,
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // )
                      //     ],
                      //   ),
                      // ),
                      // comments[index].replies.isNotEmpty
                      //     ? Column(
                      //         children: [
                      //           Container(
                      //               margin: EdgeInsets.only(left: 70, right: 10),
                      //               decoration: BoxDecoration(
                      //                 //color: Color.fromARGB(223, 48, 45, 45),
                      //                 borderRadius: BorderRadius.circular(12),
                      //               ),
                      //               child: allReplies == false
                      //                   ? GestureDetector(
                      //                       onTap: () {
                      //                         if (comments[index].replies.last.fullText == true) {
                      //                           setState(() {
                      //                             comments[index].replies.last.fullText = false;
                      //                           });
                      //                         } else {
                      //                           setState(() {
                      //                             comments[index].replies.last.fullText = true;
                      //                           });
                      //                         }
                      //                       },
                      //                       child: Column(
                      //                         children: [
                      //                           Column(
                      //                             children: [
                      //                               Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                      //                                 Container(
                      //                                     alignment: Alignment.topLeft,
                      //                                     width: 35,
                      //                                     height: 35,
                      //                                     decoration: BoxDecoration(
                      //                                       image: DecorationImage(
                      //                                           fit: BoxFit.cover,
                      //                                           image: NetworkImage(
                      //                                             image + comments[index].replies.last.avatar,
                      //                                           )),
                      //                                       color: const Color.fromARGB(223, 119, 106, 106),
                      //                                       borderRadius: BorderRadius.circular(12),
                      //                                     )),
                      //                                 Expanded(
                      //                                   flex: 7,
                      //                                   child: Container(
                      //                                     margin: EdgeInsets.only(left: 5, right: 0),
                      //                                     child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                      //                                       Container(
                      //                                           decoration: BoxDecoration(
                      //                                             color: Color.fromARGB(223, 24, 23, 23),
                      //                                             borderRadius: BorderRadius.circular(12),
                      //                                           ),
                      //                                           child: Container(
                      //                                             margin: EdgeInsets.only(left: 5, right: 0),
                      //                                             child: Column(
                      //                                               mainAxisAlignment: MainAxisAlignment.start,
                      //                                               crossAxisAlignment: CrossAxisAlignment.start,
                      //                                               children: [
                      //                                                 Row(
                      //                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                                                   children: [
                      //                                                     Expanded(flex: 3, child: Text('@${comments[index].replies.last.username}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color.fromARGB(216, 158, 158, 158)))),
                      //                                                     Expanded(
                      //                                                       flex: 1,
                      //                                                       child: Container(
                      //                                                         margin: EdgeInsets.only(right: 0),
                      //                                                         child: comments[index].replies.last.isAdmin == true
                      //                                                             ? ImageIcon(
                      //                                                                 AssetImage('images/Light/Star.png'),
                      //                                                                 color: Colors.amber,
                      //                                                                 size: 14,
                      //                                                               )
                      //                                                             : Container(),
                      //                                                       ),
                      //                                                     ),
                      //                                                     Expanded(
                      //                                                       flex: 1,
                      //                                                       child: Container(
                      //                                                         margin: const EdgeInsets.only(right: 0),
                      //                                                         child: comments[index].replies.last.isEdited == true
                      //                                                             ? ImageIcon(
                      //                                                                 AssetImage('images/Light/Edit Square.png'),
                      //                                                                 color: Colors.grey,
                      //                                                                 size: 14,
                      //                                                               )
                      //                                                             : Container(),
                      //                                                       ),
                      //                                                     ),
                      //                                                     myId.toString() == comments[index].replies.last.commentUser || isAdmin == true
                      //                                                         ? Expanded(
                      //                                                             flex: 2,
                      //                                                             child: GestureDetector(
                      //                                                               onTap: () {
                      //                                                                 setState(() {
                      //                                                                   FocusScope.of(context).requestFocus(FocusNode());
                      //                                                                 });
                      //                                                                 showModalBottomSheet(
                      //                                                                   context: context,
                      //                                                                   builder: (context) {
                      //                                                                     return Container(
                      //                                                                       color: Color.fromARGB(255, 19, 18, 18),
                      //                                                                       height: size.height / 6,
                      //                                                                       child: Padding(
                      //                                                                         padding: const EdgeInsets.all(8.0),
                      //                                                                         child: Column(
                      //                                                                           children: [
                      //                                                                             GestureDetector(
                      //                                                                               onTap: () {
                      //                                                                                 setState(() async {
                      //                                                                                   Navigator.pop(context);
                      //                                                                                   if (await deleteComment(int.parse(comments[index].commentId))) {
                      //                                                                                     setState(() {
                      //                                                                                       comments3[index].replies.removeAt(comments3[index].replies.length - 1);
                      //                                                                                     });
                      //                                                                                   } else {
                      //                                                                                     true;
                      //                                                                                   }
                      //                                                                                 });
                      //                                                                                 setState(() {
                      //                                                 //                                   deleteComment(int.parse(comments[index].replies.last.commentId));
                      //                                   isEdit = false;
                      //                                   _isComment = true;
                      //                                   isRepling = false;
                      //                                   _myController.clear();
                      //                                 });
                      //                               },
                      //                               child: Padding(
                      //                                 padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                      //                                 child: Container(
                      //                                   color: Color.fromARGB(255, 19, 18, 18),
                      //                                   width: double.infinity,
                      //                                   child: Row(
                      //                                     children: const [
                      //                                       Text(
                      //                                         'Delete  ',
                      //                                         style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
                      //                                       ),
                      //                                       Icon(Icons.delete, color: Colors.grey, size: 20)
                      //                                     ],
                      //                                   ),
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                             myId.toString() == comments[index].replies.last.commentUser
                      //                                 ? GestureDetector(
                      //                                     onTap: () {
                      //                                       commentTime = comments[index].replies.last.commentTime;
                      //                                       _replyToId = int.parse(comments[index].replies.last.commentId);
                      //                                       setState(() {
                      //                                         setState(() {
                      //                                           isEdit = true;
                      //                                           _isComment = false;
                      //                                           if (_isComment == false) {
                      //                                             _replyTo = "";
                      //                                           }
                      //                                         });
                      //                                         _editReply = true;
                      //                                         _myCommentIndex = index;
                      //                                         _myReplyIndex = comments[index].replies.length - 1;
                      //                                       });

                      //                                       _myController.clear();
                      //                                       Navigator.pop(context);
                      //                                     },
                      //                                     child: Padding(
                      //                                       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                      //                                       child: Container(
                      //                                         color: Color.fromARGB(255, 19, 18, 18),
                      //                                         width: double.infinity,
                      //                                         child: Row(
                      //                                           children: const [
                      //                                             Text(
                      //                                               'Edit  ',
                      //                                               style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
                      //                                             ),
                      //                                             Icon(
                      //                                               Icons.edit,
                      //                                               color: Colors.grey,
                      //                                               size: 20,
                      //                                             )
                      //                                           ],
                      //                                         ),
                      //                                       ),
                      //                                     ),
                      //                                   )
                      //                                 : Container()
                      //                           ],
                      //                         ),
                      //                       ),
                      //                     );
                      //                   },
                      //                 );
                      //               },
                      //               child: Container(
                      //                 alignment: Alignment.centerRight,
                      //                 margin: EdgeInsets.only(right: 8),
                      //                 child: Icon(
                      //                   Icons.more_horiz,
                      //                   color: Colors.grey,
                      //                   size: 20,
                      //                 ),
                      //               ),
                      //             ),
                      //           )
                      //         : Container(),
                      //   ],
                      // ),
                      // comments[index].replies.last.fair == false
                      //     ? Text(
                      //         comments[index].replies.last.commentCont,
                      //         textAlign: TextAlign.left,
                      //         style: const TextStyle(fontSize: 15, color: Colors.grey),
                      //         // overflow: e.fullText == true ? TextOverflow.ellipsis : TextOverflow.visible,
                      //       )
                      //           : GestureDetector(
                      //               onDoubleTap: () {
                      //                 setState(() {
                      //                   comments[index].replies.last.fair = false;
                      //                 });
                      //               },
                      //               child: Padding(
                      //                 padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: 8),
                      //                 child: Container(
                      //                   decoration: BoxDecoration(
                      //                     borderRadius: BorderRadius.circular(14),
                      //                   ),
                      //                   child: Center(
                      //                     child: Row(
                      //                       mainAxisAlignment: MainAxisAlignment.center,
                      //                       children: [
                      //                         Text(
                      //                           'Double tap to view the reply ',
                      //                           style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.red),
                      //                         ),
                      //                         ImageIcon(
                      //                           AssetImage(
                      //                             'images/Light/Show.png',
                      //                           ),
                      //                           color: Colors.red,
                      //                           size: 15,
                      //                         )
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ))
                      //     ],
                      //   ),
                      // )),
                      //                   ]),
                      //                 ),
                      //               )
                      //             ]),
                      //             Padding(
                      //               padding: const EdgeInsets.only(left: 44, top: 5),
                      //               child: Container(
                      //                 //color: Colors.red,
                      //                 child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      //                   Expanded(
                      //                     flex: 2,
                      //                     child: Text(
                      //                       Jiffy(comments[index].replies.last.commentTime).fromNow(),
                      //                       style: const TextStyle(fontSize: 12, color: Colors.grey),
                      //                     ),
                      //                   ),
                      //                   Expanded(
                      //                     flex: 1,
                      //                     child: Text(
                      //                       comments[index].replies.last.likes > 1 ? '${comments[index].replies.last.likes} Likes' : '${comments[index].replies.last.likes} like',
                      //                       style: const TextStyle(fontSize: 12, color: Colors.grey),
                      //                     ),
                      //                   ),
                      //                   Expanded(
                      //                     flex: 1,
                      //                     child: Text(
                      //                       'Reply',
                      //                       style: const TextStyle(fontSize: 12, color: Colors.grey),
                      //                     ),
                      //                   ),
                      //                   Expanded(
                      //                     flex: 1,
                      //                     child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      //                       Text(
                      //                         '',
                      //                         //'${comments[index].replies.last.likes}',
                      //                         style: TextStyle(fontSize: 12, color: Colors.grey),
                      //                       ),
                      //                       GestureDetector(
                      //                         onTap: () {
                      //                           if (comments[index].replies.last.isLiked == true) {
                      //                             if (unLike(int.parse(comments[index].replies.last.commentId)) == true) {
                      //                               setState(() {
                      //                                 comments[index].replies.last.isLiked = true;
                      //                                 comments[index].replies.last.likes += 1;
                      //                               });
                      //                             } else {
                      //                               setState(() {
                      //                                 comments[index].replies.last.isLiked = false;
                      //                                 comments[index].replies.last.likes -= 1;
                      //                               });
                      //                             }
                      //                           } else {
                      //                             if (like(int.parse(comments[index].replies.last.commentId)) == true) {
                      //                               setState(() {
                      //                                 comments[index].replies.last.isLiked = false;
                      //                                 comments[index].replies.last.likes -= 1;
                      //                               });
                      //                             } else {
                      //                               setState(() {
                      //                                 comments[index].replies.last.isLiked = true;
                      //                                 comments[index].replies.last.likes += 1;
                      //                               });
                      //                             }
                      //                           }
                      //                         },
                      //                         child: ImageIcon(
                      //                           AssetImage('images/Light/Heart.png'),
                      //                           color: comments[index].replies.last.isLiked == true ? Colors.red : Colors.grey,
                      //                           size: 16,
                      //                         ),
                      //                       )
                      //                     ]),
                      //                   ),
                      //                 ]),
                      //               ),
                      //             )
                      //           ],
                      //         )
                      //       ],
                      //     ),
                      //   )
                      // : Column(
                      //     children: comments[index].replies.map((e) {
                      //       return Builder(
                      //         builder: (context) {
                      //           return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                      //             Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                      //               Container(
                      //                   alignment: Alignment.topLeft,
                      //                   width: 35,
                      //                   height: 35,
                      //                   decoration: BoxDecoration(
                      //                     image: DecorationImage(
                      //                         fit: BoxFit.cover,
                      //                         image: NetworkImage(
                      //                           image + comments[index].replies.last.avatar,
                      //                         )),
                      //                     color: const Color.fromARGB(223, 119, 106, 106),
                      //                     borderRadius: BorderRadius.circular(10),
                      //                   )),
                      //               Expanded(
                      //                 flex: 7,
                      //                 child: Container(
                      //                   margin: EdgeInsets.only(left: 5, right: 0),
                      //                   child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                      //                     Container(
                      //                         decoration: BoxDecoration(
                      //                           color: Color.fromARGB(223, 24, 23, 23),
                      //                           borderRadius: BorderRadius.circular(10),
                      //                         ),
                      //                         child: Container(
                      //                           margin: EdgeInsets.only(left: 5, right: 0),
                      //                           child: Column(
                      //                             mainAxisAlignment: MainAxisAlignment.start,
                      //                             crossAxisAlignment: CrossAxisAlignment.start,
                      //                             children: [
                      //                               Row(
                      //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                                 children: [
                      //                                   Expanded(flex: 3, child: Text('@${e.username}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color.fromARGB(216, 158, 158, 158)))),
                      //                                   Expanded(
                      //                                     flex: 1,
                      //                                     child: Container(
                      //                                       margin: EdgeInsets.only(right: 0),
                      //                                       child: e.isAdmin == true
                      //                                           ? ImageIcon(
                      //                                               AssetImage('images/Light/Star.png'),
                      //                                               color: Colors.amber,
                      //                                               size: 14,
                      //                                             )
                      //                                           : Container(),
                      //                                     ),
                      //                                   ),
                      //                                   Expanded(
                      //                                     flex: 1,
                      //                                     child: Container(
                      //                                       margin: const EdgeInsets.only(right: 0),
                      //                                       child: e.isEdited == true
                      //                                           ? ImageIcon(
                      //                                               AssetImage('images/Light/Edit Square.png'),
                      //                                               color: Colors.grey,
                      //                                               size: 14,
                      //                                             )
                      //                                           : Container(),
                      //                                     ),
                      //                                   ),
                      //                                   myId.toString() == e.commentUser || isAdmin == true
                      //                                       ? Expanded(
                      //                                           flex: 2,
                      //                                           child: GestureDetector(
                      //                                             onTap: () {
                      //                                               setState(() {
                      //                                                 FocusScope.of(context).requestFocus(FocusNode());
                      //                                               });
                      //                                               showModalBottomSheet(
                      //                                                 context: context,
                      //                                                 builder: (context) {
                      //                                                   return Container(
                      //                                                     color: Color.fromARGB(255, 19, 18, 18),
                      //                                                     height: size.height / 6,
                      //                                                     child: Padding(
                      //                                                       padding: const EdgeInsets.all(8.0),
                      //                                                       child: Column(
                      //                                                         children: [
                      //                                                           GestureDetector(
                      //                                                             onTap: () {
                      //                                                               setState(() async {
                      //                                                                 Navigator.pop(context);
                      //                                                                 if (await deleteComment(int.parse(e.commentId))) {
                      //                                                                   setState(() {
                      //                                                                     comments3[index].replies.removeAt(comments3[index].replies.indexOf(e));
                      //                                                                   });
                      //                                                                 } else {
                      //                                                                   true;
                      //                                                                 }
                      //                                                               });
                      //                                                               setState(() {
                      //                                                                 isEdit = false;
                      //                                                                 _isComment = true;
                      //                                                                 isRepling = false;
                      //                                                                 _myController.clear();
                      //                                                                 Navigator.pop(context);
                      //                                                               });
                      //                                                             },
                      //                                                             child: Padding(
                      //                                                               padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                      //                                                               child: Container(
                      //                                                                 color: Color.fromARGB(255, 19, 18, 18),
                      //                                                                 width: double.infinity,
                      //                                                                 child: Row(
                      //                                                                   children: const [
                      //                                                                     Text(
                      //                                                                       'Delete  ',
                      //                                                                       style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
                      //                                                                     ),
                      //                                                                     Icon(Icons.delete, color: Colors.grey, size: 20)
                      //                                                                   ],
                      //                                                                 ),
                      //                                                               ),
                      //                                                             ),
                      //                                                           ),
                      //                                                           myId.toString() == e.commentUser
                      //                                                               ? GestureDetector(
                      //                                                                   onTap: () {
                      //                                                                     commentTime = e.commentTime;
                      //                                                                     _replyToId = int.parse(e.commentId);

                      //                                                                     setState(() {
                      //                                                                       setState(() {
                      //                                                                         isEdit = true;
                      //                                                                         _isComment = false;
                      //                                                                         if (_isComment == false) {
                      //                                                                           _replyTo = "";
                      //                                                                         }
                      //                                                                       });
                      //                                                                       _editReply = true;
                      //                                                                       _myCommentIndex = index;
                      //                                                                       _myReplyIndex = comments[index].replies.indexOf(e);
                      //                                                                     });

                      //                                                                     _myController.clear();
                      //                                                                     Navigator.pop(context);
                      //                                                                   },
                      //                                                                   child: Padding(
                      //                                                                     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                      //                                                                     child: Container(
                      //                                                                       color: Color.fromARGB(255, 19, 18, 18),
                      //                                                                       width: double.infinity,
                      //                                                                       child: Row(
                      //                                                                         children: const [
                      //                                                                           Text(
                      //                                                                             'Edit  ',
                      //                                                                             style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
                      //                                                                           ),
                      //                                                                           Icon(
                      //                                                                             Icons.edit,
                      //                                                                             color: Colors.grey,
                      //                                                                             size: 20,
                      //                                                                           )
                      //                                                                         ],
                      //                                                                       ),
                      //                                                                     ),
                      //                                                                   ),
                      //                                                                                                                                     )
                      //                                                                                                                                   : Container()
                      //                                                                                                                             ],
                      //                                                                                                                           ),
                      //                                                                                                                         ),
                      //                                                                                                                       );
                      //                                                                                                                     },
                      //                                                                                                                   );
                      //                                                                                                                 },
                      //                                                                                                                 child: Container(
                      //                                                                                                                   alignment: Alignment.centerRight,
                      //                                                                                                                   margin: EdgeInsets.only(right: 8),
                      //                                                                                                                   child: Icon(
                      //                                                                                                                     Icons.more_horiz,
                      //                                                                                                                     color: Colors.grey,
                      //                                                                                                                     size: 20,
                      //                                                                                                                   ),
                      //                                                                                                                 ),
                      //                                                                                                               ),
                      //                                                                                                             )
                      //                                                                                                           : Container(),
                      //                                                                                                     ],
                      //                                                                                                   ),
                      //                                                                                                   e.fair == false
                      //                                                                                                       ? Text(
                      //                                                                                                           e.commentCont,
                      //                                                                                                           textAlign: TextAlign.left,
                      //                                                                                                           style: const TextStyle(fontSize: 15, color: Colors.grey),
                      //                                                                                                           // overflow: e.fullText == true ? TextOverflow.ellipsis : TextOverflow.visible,
                      //                                                                                                         )
                      //                                                                                                       : GestureDetector(
                      //                                                                                                           onDoubleTap: () {
                      //                                                                                                             setState(() {
                      //                                                                                                               e.fair = false;
                      //                                                                                                             });
                      //                                                                                                           },
                      //                                                                                                           child: Padding(
                      //                                                                                                             padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: 8),
                      //                                                                                                             child: Container(
                      //                                                                                                               decoration: BoxDecoration(
                      //                                                                                                                 borderRadius: BorderRadius.circular(14),
                      //                                                                                                               ),
                      //                                                                                                               child: Center(
                      //                                                                                                                 child: Row(
                      //                                                                                                                   mainAxisAlignment: MainAxisAlignment.center,
                      //                                                                                                                   children: [
                      //                                                                                                                     Text(
                      //                                                                                                                       'Double tap to view the reply ',
                      //                                                                                                                       style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.red),
                      //                                                                                                                     ),
                      //                                                                                                                     ImageIcon(
                      //                                                                                                                       AssetImage(
                      //                                                                                                                         'images/Light/Show.png',
                      //                                                                                                                       ),
                      //                                                                                                                       color: Colors.red,
                      //                                                                                                                       size: 15,
                      //                                                                                                                     )
                      //                                                                                                                   ],
                      //                                                                                                                 ),
                      //                                                                                                               ),
                      //                                                                                                             ),
                      //                                                                                                           ))
                      //                                                                                                 ],
                      //                                                                                               ),
                      //                                                                                             )),
                      //                                                                                       ]),
                      //                                                                                     ),
                      //                                                                                   )
                      //                                                                                 ]),
                      //                                                                                 Padding(
                      //                                                                                     padding: const EdgeInsets.only(left: 44, top: 5),
                      //                                                                                     child: Container(
                      //                                                                                         //color: Colors.red,
                      //                                                                                         child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      //                                                                                       Expanded(
                      //                                                                                         flex: 2,
                      //                                                                                         child: Text(
                      //                                                                                           Jiffy(e.commentTime).fromNow(),
                      //                                                                                           style: const TextStyle(fontSize: 12, color: Colors.grey),
                      //                                                                                         ),
                      //                                                                                       ),
                      //                                                                                       Expanded(
                      //                                                                                         flex: 1,
                      //                                                                                         child: Text(
                      //                                                                                           e.likes > 1 ? '${e.likes} Likes' : '${e.likes} like',
                      //                                                                                           style: const TextStyle(fontSize: 12, color: Colors.grey),
                      //                                                                                         ),
                      //                                                                                       ),
                      //                                                                                       Expanded(
                      //                                                                                         flex: 1,
                      //                                                                                         child: Text(
                      //                                                                                           'Reply',
                      //                                                                                           style: const TextStyle(fontSize: 12, color: Colors.grey),
                      //                                                                                         ),
                      //                                                                                       ),
                      //                                                                                       Expanded(
                      //                                                                                           flex: 1,
                      //                                                                                           child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      //                                                                                             Text(
                      //                                                                                               '',
                      //                                                                                               //'${comments[index].replies.last.likes}',
                      //                                                                                               style: TextStyle(fontSize: 12, color: Colors.grey),
                      //                                                                                             ),
                      //                                                                                             GestureDetector(
                      //                                                                                               onTap: () {
                      //                                                                                                 if (e.isLiked == true) {
                      //                                                                                                   if (unLike(int.parse(e.commentId)) == true) {
                      //                                                                                                     setState(() {
                      //                                                                                                       e.isLiked = true;
                      //                                                                                                       e.likes += 1;
                      //                                                                                                     });
                      //                                                                                                   } else {
                      //                                                                                                     setState(() {
                      //                                                                                                       e.isLiked = false;
                      //                                                                                                       e.likes -= 1;
                      //                                                                                                     });
                      //                                                                                                   }
                      //                                                                                                 } else {
                      //                                                                                                   if (like(int.parse(e.commentId)) == true) {
                      //                                                                                                     setState(() {
                      //                                                                                                       e.isLiked = false;
                      //                                                                                                       e.likes -= 1;
                      //                                                                                                     });
                      //                                                                                                   } else {
                      //                                                                                                     setState(() {
                      //                                                                                                       e.isLiked = true;
                      //                                                                                                       e.likes += 1;
                      //                                                                                                     });
                      //                                                                                                   }
                      //                                                                                                 }
                      //                                                                                               },
                      //                                                                                               child: ImageIcon(
                      //                                                                                                 AssetImage('images/Light/Heart.png'),
                      //                                                                                                 color: e.isLiked == true ? Colors.red : Colors.grey,
                      //                                                                                                 size: 16,
                      //                                                                                               ),
                      //                                                                                             )
                      //                                                                                           ]))
                      //                                                                                     ])))
                      //                                                                               ]);
                      //                                                                             },
                      //                                                                           );
                      //                                                                         }).toList(),
                      //                                                                       )),
                      //                                                             GestureDetector(
                      //                                                                 onTap: () {
                      //                                                                   setState(() {
                      //                                                                     if (allReplies == true) {
                      //                                                                       allReplies = false;
                      //                                                                     } else {
                      //                                                                       allReplies = true;
                      //                                                                     }
                      //                                                                   });
                      //                                                                 },
                      //                                                                 child: Padding(
                      //                                                                   padding: const EdgeInsets.only(bottom: 10, top: 10, left: 10),
                      //                                                                   child: Row(
                      //                                                                     children: [
                      //                                                                       Expanded(flex: 4, child: SizedBox()),
                      //                                                                       Expanded(
                      //                                                                         flex: 4,
                      //                                                                         child: Container(
                      //                                                                           margin: EdgeInsets.symmetric(horizontal: 5),
                      //                                                                           height: 1,
                      //                                                                           width: 50,
                      //                                                                           color: comments[index].replies.length >= 2 ? Colors.grey : Colors.transparent,
                      //                                                                         ),
                      //                                                                       ),
                      //                                                                       comments[index].replies.length > 1
                      //                                                                           ? Text(
                      //                                                                               textAlign: TextAlign.start,
                      //                                                                               allReplies == false ? 'View ${comments[index].replies.length - 1} ${comments[index].replies.length != 2 ? 'more relpies' : 'more relpy'}' : 'Hide replies',
                      //                                                                               style: const TextStyle(fontSize: 12, color: Color.fromARGB(206, 199, 192, 192)),
                      //                                                                             )
                      //                                                                           : Container(),
                      //                                                                       Expanded(flex: 8, child: SizedBox()),
                      //                                                                     ],
                      //                                                                   ),
                      //                                                                 ))
                      //                                                           ],
                      //                                                         )
                      //                                                       : Container(),
                      //                                                 ],
                      //                                               ),
                      //                                             ),
                      //                                           ]),
                      //                                     );
                      //                                   } else {
                      //                                     return const Text('');
                      //                                     //  Padding(
                      //                                     //   padding: const EdgeInsets.symmetric(
                      //                                     //       vertical: 15),
                      //                                     //   child: Center(
                      //                                     //       child:
                      //                                     //           const CircularProgressIndicator()),
                      //                                     // );
                      //                                   }
                      //                                 }),
                      //                           ),
                      //                         );
                      //                 } else {
                      //                   return const Center(
                      //                     child: CircularProgressIndicator(),
                      //                   );
                      //                 }
                      //               })),
                      //     ),
                      //   )
                      : Container()
                ])
              : const Center(child: CircularProgressIndicator())),
    );
  }
}

// comments from json
class Comments {
  final String commentAnime;
  final String commentId;
  final String commentUser;
  bool fair;
  bool fullText;
  bool isEdited;
  bool isAdmin;
  bool isLiked;
  final String replyOf;
  int likes;
  String commentCont;
  final String username;
  final String name;
  final String avatar;
  final String commentTime;
  final List<Comments> replies;

  Comments(
    this.commentAnime,
    this.commentId,
    this.commentUser,
    this.fair,
    this.fullText,
    this.isEdited,
    this.isAdmin,
    this.isLiked,
    this.replyOf,
    this.likes,
    this.commentCont,
    this.username,
    this.name,
    this.avatar,
    this.commentTime,
    this.replies,
  );

  static Comments fromJson(json) => Comments(
        json['comment_anime'].toString(),
        json['comment_id'].toString(),
        json['comment_user'].toString(),
        json['fair'] == '0' ? false : true,
        json['fair'] == '0' ? false : true,
        json['is_edited'] == '0' ? false : true,
        json['is_admin'] == '0' ? false : true,
        json['is_liked'] == 0 ? false : true,
        json['reply_of2'].toString(),
        json['likes'],
        json['comment_cont'],
        json['username'],
        json['name'],
        json['avatar'],
        json['comment_time'],
        json['replies'] == null
            ? 0
            : json['replies'].map<Comments>(Comments.fromJson).toList(),
      );
}

class Download {
  final String url;
  final String server;
  final String quality;
  final String image;

  Download(this.url, this.server, this.quality, this.image);
}
