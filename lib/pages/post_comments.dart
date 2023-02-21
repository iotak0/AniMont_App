import 'package:anime_mont_test/pages/profial_screen.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:chewie/chewie.dart';
import 'package:html/dom.dart' as dom;
import 'package:linkfy_text/linkfy_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:convert';
import 'package:anime_mont_test/server/server_php.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'dart:isolate';
import 'package:flutter_locales/flutter_locales.dart';

import 'dart:ui';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class PostComments extends StatefulWidget {
  const PostComments({super.key, required this.animeId, required this.myId});
  @override
  State<PostComments> createState() => PostCommentsState();
  final int animeId;
  final int myId;
}

class PostCommentsState extends State<PostComments> {
  List<Comments> comments3 = [];
  Future<List<Comments>>? commentsFuture;
  //DateTime time = DateTime.utc(year)

  DateTime t = DateTime.now().toUtc();
  int? _replyToId;

  int fullScrean = 10;
  late bool _editReply;
  bool right = true;
  bool allReplies = false;
  bool isEdit = false;
  bool isRepling = false;
  bool _isComment = true;
  bool _myCommentFire = false;
  String _replyTo = '';
  bool isAdmin = true;

  String? commentTime;
  bool isFullScrean = false;
  bool allowBack = true;

  bool isMyComment = false;
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  final TextEditingController _myController = TextEditingController();
  final Server _server = Server();
  addAnime() async {
    print("AnimeId :   " +
        widget.animeId.toString() +
        "     MyId :   " +
        widget.myId.toString());
    //print('${animeId} 000000000000000000000000000');
    var response = await _server.postRequest(addAnime_link, {
      "anime_id": '${widget.animeId}',
    });
  }

  addComment() async {
    try {
      addAnime();
    } catch (e) {}
    refresh();
    var response = await _server.postRequest(addComment_link, {
      "comment_anime": '${widget.animeId}',
      "comment_cont": _myController.text,
      "comment_user": '${widget.myId}',
      "comment_fair": _myCommentFire == false ? "0" : "1",
      "reply_of": "0"
    });
    print('//////////////////    ' + response.toString());
    if (response['status'] == "success") {
      print("add comment success");
    } else {
      print("add comment fail");
    }
    setState(() {
      refresh();
    });
  }

  like(int id) async {
    var response = await _server.postRequest(like_link, {
      "user_id": '${widget.myId}',
      "comment_id": '$id',
      "comment_anime": '${widget.animeId}',
    });

    if (response['status'] == "success") {
      print("add like success");
      return true;
    } else {
      print("add Like fail");
      return false;
    }
  }

  unLike(int id) async {
    var response = await _server.postRequest(unLike_link, {
      "user_id": '${widget.myId}',
      "comment_id": '$id',
    });

    if (response['status'] == "success") {
      return true;
      print("add unlike success");
    } else {
      return false;
      print("add unLike fail");
    }
  }

  Future refresh() async {
    setState(() {
      comments3.clear();
      getComments(widget.animeId, widget.myId);
      commentsFuture = getComments(widget.animeId, widget.myId);
    });
  }

  refresh2() {
    setState(() {
      test = 200 - _myController.text.length;
    });
  }

  fetch() async {}

  static Future<List<Comments>> getComments(int animeId, int myId) async {
    final response = await http.post(Uri.parse('${post_comments_link}'),
        body: {"comment_anime": '${animeId}', "my_id": '${myId}'});

    final body = json.decode(response.body);
    //print("//////////Body $body");

    return body.map<Comments>(Comments.fromJson).toList();
  }

  int test = 200;
  final listController = ScrollController();
  final listController2 = ScrollController();
  final listController3 = ScrollController();

  addReplay(int id) async {
    var response = await _server.postRequest(addComment_link, {
      "comment_anime": '${widget.animeId}',
      "comment_cont": '${_myController.text}',
      "comment_user": "${widget.myId}",
      "comment_fair": _myCommentFire == true ? "1" : "0",
      "reply_of": '$id'
    });

    if (response['status'] == "success") {
      print("add Replay success");
    } else {
      print("add Replay fail");
    }
    setState(() {
      refresh();
    });
  }

  Future deleteComment(int id) async {
    var response = await _server.postRequest(deleteComment_link, {
      "comment_anime": '${widget.animeId}',
      "comment_id": '$id',
    });

    if (response['status'] == "success") {
      print("delete Comment success");
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
      print("delete comment fail");
      return false;
    }
  }

  late int _myCommentIndex;
  late int _myReplyIndex;
  Future editComment(int id, String time) async {
    var response = await _server.postRequest(editComment_link, {
      "comment_anime": '${widget.animeId}',
      "comment_cont": '${_myController.text}',
      "comment_fair": _myCommentFire == true ? "1" : "0",
      "comment_id": '$id',
      "comment_time": '$time',
      "is_edited": '1'
    });

    if (response['status'] == "success") {
      print("edit Comment success");

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
      print("edit Comment fail");
      return false;
    }
  }

  @override
  void initState() {
    commentsFuture = getComments(widget.animeId, widget.myId);
    //print("///comments $comments3");
    super.initState();
    _myController.addListener(() {
      if (_myController.text.length < 3) {
        refresh2();
      } else {
        refresh2();
      }
    });

    listController2.addListener(() {
      if (listController2.position.keepScrollOffset == true) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
    listController3.addListener(() {
      if (listController3.position.maxScrollExtent == listController3.offset) {
        fetch();
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
    listController.dispose();
    listController2.dispose();
    listController3.dispose();
    _myController.dispose();
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
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 10),
              child: Container(
                  color: Colors.transparent,
                  //height: _isComment == true ? 6 : 70,
                  child: Stack(children: [
                    Container(
                      margin: EdgeInsets.only(right: 75),
                      padding: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        // gradient: LinearGradient(
                        //     colors: [Colors.black, Colors.grey])
                      ),
                    ),
                    Column(
                      mainAxisAlignment: _isComment == false
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        _isComment == false
                            ? Container(
                                decoration: BoxDecoration(
                                  // gradient: LinearGradient(colors: [
                                  //   Colors.black,
                                  //   Colors.grey
                                  // ]),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                ),
                                margin: EdgeInsets.only(right: 75),
                                padding: EdgeInsets.only(left: 8),
                                height: size.height / 45,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 5,
                                      ),
                                      child: Text(
                                        isEdit == true
                                            ? "Edit comment"
                                            : _isComment != true
                                                ? 'Reply to ${_replyTo}'
                                                : '',
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isComment = true;
                                          isEdit = false;
                                          _myController.clear();
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 16, right: 12),
                                        child: Icon(
                                          Icons.cancel,
                                          size: 17,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                  // gradient: LinearGradient(colors: [
                                  //   Colors.black,
                                  //   Colors.grey
                                  // ]),
                                  borderRadius: _isComment == true
                                      ? BorderRadius.circular(15)
                                      : BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15))),
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 16, right: 12),
                                    child: Icon(
                                      Icons.emoji_emotions,
                                      color: primaryColor,
                                    ),
                                  ),
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () {
                                      setState(() {});
                                    },
                                    child: TextField(
                                      style: TextStyle(color: primaryColor),
                                      cursorColor: primaryColor,
                                      textInputAction: TextInputAction.send,
                                      controller: _myController,
                                      decoration: InputDecoration(
                                        hintText: _isComment != true
                                            ? 'Edit the comment...'
                                            : 'Add a comment ...',
                                        hintStyle:
                                            TextStyle(color: primaryColor),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  )),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(left: 1, right: 1),
                                      child: Text(
                                        '${test}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: test < 0
                                              ? Colors.red
                                              : primaryColor,
                                        ),
                                      )),
                                  //_myController.text.isNotEmpty
                                  1 == 1
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (_myCommentFire == true) {
                                                _myCommentFire = false;
                                              } else {
                                                _myCommentFire = true;
                                              }
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 5, right: 12),
                                            child: CircleAvatar(
                                              maxRadius: 16,
                                              backgroundColor:
                                                  _myCommentFire == true
                                                      ? Colors.red
                                                      : iconTheme,
                                              child: Text(
                                                '🔥',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            )),
                            Container(
                                margin: const EdgeInsets.only(left: 16),
                                decoration: BoxDecoration(
                                    // gradient: LinearGradient(colors: [
                                    //   Colors.grey,
                                    //   Colors.grey.shade800
                                    // ]),
                                    borderRadius: BorderRadius.circular(14)),
                                child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      });
                                      if (_isComment == true) {
                                        setState(() {
                                          addComment();
                                          _myController.clear();
                                          _myCommentFire = false;
                                        });
                                      } else if (isEdit == true) {
                                        if (_myController.text.isNotEmpty) {
                                          setState(() async {
                                            setState(() {
                                              isEdit = true;
                                              _isComment = false;
                                              if (_isComment == false) {
                                                _replyTo = "";
                                              }
                                            });
                                            if (await editComment(
                                                _replyToId!, commentTime!)) {
                                              _editReply == false
                                                  ? setState(() {
                                                      comments3[_myCommentIndex]
                                                              .commentCont =
                                                          _myController.text;
                                                      isEdit = false;
                                                      _isComment = true;
                                                      _myController.clear();
                                                    })
                                                  : setState(() {
                                                      comments3[_myCommentIndex]
                                                              .replies[
                                                                  _myReplyIndex]
                                                              .commentCont =
                                                          _myController.text;
                                                      isEdit = false;
                                                      _isComment = true;
                                                      _editReply = false;
                                                      _myController.clear();
                                                    });
                                            }
                                          });
                                          setState(() {
                                            isEdit = false;
                                            _editReply = false;
                                            _isComment = true;
                                            _myController.clear();
                                            _myCommentFire = false;
                                          });
                                        }
                                      } else if (isRepling == true) {
                                        if (_myController.text.isNotEmpty) {
                                          setState(() {
                                            addReplay(_replyToId!);
                                            _isComment = true;
                                            _myController.clear();
                                            _myCommentFire = false;
                                          });
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      child: Center(
                                        child: ImageIcon(
                                          AssetImage('images/Light/Send.png'),
                                          size: 30,
                                          color: primaryColor,
                                        ),
                                      ),
                                    )))
                          ],
                        ),
                      ],
                    ),
                  ]))),
          //////// C O M M E N T S   S I C
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: SizedBox(
                child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: FutureBuilder<List<Comments>>(
                        future: commentsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            //${snapshot.error}
                            return RefreshIndicator(
                              onRefresh: refresh,
                              child: Center(
                                  child: Text('No Connection',
                                      style: TextStyle(color: Colors.red))),
                            );
                          } else if (snapshot.hasData) {
                            final comments = snapshot.data!;
                            //print('snapshot /////// $comments');
                            comments3 = comments;
                            return comments.isEmpty
                                ? RefreshIndicator(
                                    onRefresh: refresh,
                                    child: Center(
                                        child: Text('No Comments yet',
                                            style: TextStyle(color: Colors.red))
                                        // CircularProgressIndicator()
                                        ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: refresh,
                                    child: GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        SystemChrome.setEnabledSystemUIMode(
                                            SystemUiMode.immersiveSticky);
                                      },
                                      child: RefreshIndicator(
                                        onRefresh: refresh,
                                        child: ListView.builder(
                                            controller: listController,
                                            itemCount: comments.length + 1,
                                            itemBuilder: (context, index) {
                                              if (index < comments.length) {
                                                DateTime? m = DateTime.tryParse(
                                                    comments[index]
                                                        .commentTime);
                                                print(DateTime.now().toUtc());
                                                print(m!);
                                                print(comments[index]
                                                    .commentTime);
                                                print(Jiffy(m).from(
                                                    DateTime.now().toUtc()));
                                                return GestureDetector(
                                                  onTap: () {
                                                    print(
                                                        DateTime.now().toUtc());
                                                    print(m);
                                                    print(comments[index]
                                                        .commentTime);
                                                    debugPrint(m.toString());
                                                    print(Jiffy(m).from(
                                                        DateTime.now()
                                                            .toUtc()));
                                                    // FocusScope.of(context)
                                                    //     .requestFocus(
                                                    //         FocusNode());
                                                  },
                                                  child: Stack(children: [
                                                    Container(
                                                      // height: comments[index]
                                                      //             .replies
                                                      //             .length ==
                                                      //         0
                                                      //     ? size.height / 8
                                                      //     : size.height / 5.5,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 8,
                                                                        right:
                                                                            8),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    // Navigator.push(
                                                                    //     context,
                                                                    //     MaterialPageRoute(
                                                                    // builder: (context) => ProfialPage()));
                                                                  },
                                                                  child: Container(
                                                                      width: 55,
                                                                      height: 55,
                                                                      decoration: BoxDecoration(
                                                                        image: DecorationImage(
                                                                            fit: BoxFit.cover,
                                                                            image: NetworkImage(
                                                                              image2 + comments[index].avatar,
                                                                            )),
                                                                        borderRadius:
                                                                            BorderRadius.circular(12),
                                                                        //color: const Color.fromARGB(223, 119, 106, 106),
                                                                      )),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 4,
                                                                child: Padding(
                                                                  padding: context.currentLocale
                                                                              .toString() ==
                                                                          'en'
                                                                      ? EdgeInsets.only(
                                                                          right:
                                                                              8.0)
                                                                      : EdgeInsets.only(
                                                                          left:
                                                                              8.0),
                                                                  child:
                                                                      Container(
                                                                    padding: context.currentLocale.toString() ==
                                                                            'en'
                                                                        ? EdgeInsets.only(
                                                                            left:
                                                                                10)
                                                                        : EdgeInsets.only(
                                                                            right:
                                                                                10),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color:
                                                                          iconTheme,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12),
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                comments[index].name,
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: primaryColor,
                                                                                  fontSize: 15,
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Text(
                                                                                '@${comments[index].username}',
                                                                                style: TextStyle(
                                                                                  color: Colors.grey,
                                                                                  fontSize: 12,
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Container(
                                                                                margin: context.currentLocale.toString() == 'en' ? EdgeInsets.only(right: 10) : EdgeInsets.only(left: 15),
                                                                                child: comments[index].isAdmin == true
                                                                                    ? ImageIcon(
                                                                                        AssetImage('images/Light/Star.png'),
                                                                                        color: Colors.amber,
                                                                                        size: 14,
                                                                                      )
                                                                                    : Container(),
                                                                              ),
                                                                              Container(
                                                                                margin: context.currentLocale.toString() == 'en' ? EdgeInsets.only(right: 15) : EdgeInsets.only(left: 15),
                                                                                child: comments[index].isEdited == true
                                                                                    ? ImageIcon(
                                                                                        AssetImage('images/Light/Edit Square.png'),
                                                                                        color: Colors.grey,
                                                                                        size: 14,
                                                                                      )
                                                                                    : Container(),
                                                                              ),
                                                                              const Expanded(
                                                                                  child: SizedBox(
                                                                                child: Text(''),
                                                                              )),
                                                                              widget.myId.toString() == comments[index].commentUser.toString() || isAdmin == true
                                                                                  ? GestureDetector(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          FocusScope.of(context).requestFocus(FocusNode());
                                                                                        });
                                                                                        showModalBottomSheet(
                                                                                          context: context,
                                                                                          builder: (context) {
                                                                                            return Container(
                                                                                              color: backgroundColor,
                                                                                              height: size.height / 6,
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.all(8.0),
                                                                                                child: Column(
                                                                                                  children: [
                                                                                                    GestureDetector(
                                                                                                      onTap: () async {
                                                                                                        Navigator.pop(context);
                                                                                                        if (await deleteComment(comments[index].commentId)) {
                                                                                                          setState(() async {
                                                                                                            comments3.removeAt(index);
                                                                                                          });
                                                                                                        } else {
                                                                                                          true;
                                                                                                        }
                                                                                                        setState(() {
                                                                                                          isEdit = false;
                                                                                                          _isComment = true;
                                                                                                          isRepling = false;
                                                                                                          _myController.clear();
                                                                                                        });
                                                                                                      },
                                                                                                      child: Padding(
                                                                                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                                                                                                        child: Container(
                                                                                                          color: backgroundColor,
                                                                                                          width: double.infinity,
                                                                                                          child: Row(
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                'Delete  ',
                                                                                                                style: TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
                                                                                                              ),
                                                                                                              ImageIcon(AssetImage('images/Light/Delete.png'), color: primaryColor, size: 20)
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    widget.myId.toString() == comments[index].commentUser.toString()
                                                                                                        ? GestureDetector(
                                                                                                            onTap: () {
                                                                                                              commentTime = comments[index].commentTime.toString();
                                                                                                              _replyToId = comments[index].commentId;
                                                                                                              setState(() {
                                                                                                                setState(() {
                                                                                                                  isEdit = true;
                                                                                                                  _isComment = false;
                                                                                                                  if (_isComment == false) {
                                                                                                                    _replyTo = "";
                                                                                                                  }
                                                                                                                });
                                                                                                                _myCommentIndex = index;
                                                                                                                print('iiiiiiiiiiiiiiiiiiiiindex $index');
                                                                                                              });

                                                                                                              _myController.clear();
                                                                                                              Navigator.pop(context);
                                                                                                            },
                                                                                                            child: Padding(
                                                                                                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                                                                                                              child: Container(
                                                                                                                color: backgroundColor,
                                                                                                                width: double.infinity,
                                                                                                                child: Row(
                                                                                                                  children: [
                                                                                                                    Text(
                                                                                                                      'Edit  ',
                                                                                                                      style: TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
                                                                                                                    ),
                                                                                                                    ImageIcon(
                                                                                                                      AssetImage('images/Light/Edit.png'),
                                                                                                                      color: primaryColor,
                                                                                                                      size: 20,
                                                                                                                    )
                                                                                                                  ],
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          )
                                                                                                        : Container()
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                        );
                                                                                      },
                                                                                      child: Container(
                                                                                        margin: context.currentLocale.toString() == 'en' ? EdgeInsets.only(top: 3, right: 8) : EdgeInsets.only(top: 3, left: 8),
                                                                                        width: 20,
                                                                                        child: Icon(
                                                                                          Icons.more_horiz,
                                                                                          color: Colors.grey,
                                                                                          size: 20,
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  : const Text(''),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Column(
                                                                          children: [
                                                                            Container(
                                                                              margin: context.currentLocale.toString() == 'en' ? EdgeInsets.only(right: 8, bottom: 8) : EdgeInsets.only(left: 8, bottom: 8),
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                                                                              child: Container(
                                                                                margin: EdgeInsets.all(5),
                                                                                child: comments[index].fair == true
                                                                                    ? GestureDetector(
                                                                                        onDoubleTap: () {
                                                                                          setState(() {
                                                                                            comments[index].fair = false;
                                                                                          });
                                                                                        },
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(8),
                                                                                          child: Container(
                                                                                            decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(14),
                                                                                            ),
                                                                                            child: Center(
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    'Double tap to view the comment ',
                                                                                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.red),
                                                                                                  ),
                                                                                                  ImageIcon(
                                                                                                    AssetImage(
                                                                                                      'images/Light/Show.png',
                                                                                                    ),
                                                                                                    color: Colors.red,
                                                                                                    size: 15,
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ))
                                                                                    : LinkifyText(
                                                                                        comments[index].commentCont,
                                                                                        textStyle: TextStyle(
                                                                                          color: primaryColor,
                                                                                          fontSize: 15,
                                                                                        ),
                                                                                        linkStyle: TextStyle(
                                                                                          color: bottomDown,
                                                                                          fontSize: 15,
                                                                                        ),
                                                                                        linkTypes: [
                                                                                          LinkType.userTag,
                                                                                          LinkType.hashTag
                                                                                        ],
                                                                                      ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding: context
                                                                        .currentLocale
                                                                        .toString() ==
                                                                    'en'
                                                                ? EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            5.0,
                                                                        right:
                                                                            10,
                                                                        bottom:
                                                                            5,
                                                                        left:
                                                                            15)
                                                                : EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            5.0,
                                                                        left:
                                                                            10,
                                                                        bottom:
                                                                            5,
                                                                        right:
                                                                            15),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Expanded(
                                                                  flex: 2,
                                                                  child: Text(
                                                                      '   '),
                                                                ),
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Text(
                                                                    Jiffy(comments[index]
                                                                            .commentTime)
                                                                        .fromNow()
                                                                        //.toUtc()
                                                                        .toString(),
                                                                    // Jiffy(m.toUtc())
                                                                    //     .from(
                                                                    //         DateTime.now().toUtc()),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 2,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap:
                                                                        () {},
                                                                    child: Text(
                                                                      comments[index].likes >
                                                                              1
                                                                          ? '${comments[index].likes} Likes'
                                                                          : '${comments[index].likes} like',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 2,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        print(comments[index]
                                                                            .commentId);
                                                                        reply(
                                                                            comments[index].commentId,
                                                                            '@${comments[index].username}');
                                                                      });
                                                                    },
                                                                    child: Text(
                                                                      comments[index].replies.length >
                                                                              1
                                                                          ? '${comments[index].replies.length} Replies'
                                                                          : '${comments[index].replies.length} reply',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 2,
                                                                  child:
                                                                      SizedBox(),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      if (comments[index]
                                                                              .isLiked ==
                                                                          true) {
                                                                        if (unLike(comments[index].commentId) ==
                                                                            true) {
                                                                          setState(
                                                                              () {
                                                                            comments[index].isLiked =
                                                                                true;
                                                                            comments[index].likes +=
                                                                                1;
                                                                          });
                                                                        } else {
                                                                          setState(
                                                                              () {
                                                                            comments[index].isLiked =
                                                                                false;
                                                                            comments[index].likes -=
                                                                                1;
                                                                          });
                                                                        }
                                                                      } else {
                                                                        if (like(comments[index].commentId) ==
                                                                            true) {
                                                                          setState(
                                                                              () {
                                                                            comments[index].isLiked =
                                                                                false;
                                                                            comments[index].likes -=
                                                                                1;
                                                                          });
                                                                        } else {
                                                                          setState(
                                                                              () {
                                                                            comments[index].isLiked =
                                                                                true;
                                                                            comments[index].likes +=
                                                                                1;
                                                                          });
                                                                        }
                                                                      }
                                                                    },
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                          '',
                                                                          //'${comments[index].likes}',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              color: Colors.grey),
                                                                        ),
                                                                        ImageIcon(
                                                                          AssetImage(
                                                                              'images/Light/Heart.png'),
                                                                          color: comments[index].isLiked == true
                                                                              ? Colors.red
                                                                              : Colors.grey,
                                                                          size:
                                                                              16,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          comments[index]
                                                                  .replies
                                                                  .isNotEmpty
                                                              ? Column(
                                                                  children: [
                                                                    Container(
                                                                        margin: EdgeInsets.only(
                                                                            left: Locales.currentLocale(context).toString() == 'en'
                                                                                ? 70
                                                                                : 10,
                                                                            right: Locales.currentLocale(context).toString() == 'en'
                                                                                ? 10
                                                                                : 70),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          //color: Color.fromARGB(223, 48, 45, 45),
                                                                          borderRadius:
                                                                              BorderRadius.circular(12),
                                                                        ),
                                                                        child: allReplies ==
                                                                                false
                                                                            ? GestureDetector(
                                                                                onTap: () {
                                                                                  if (comments[index].replies.last.fullText == true) {
                                                                                    setState(() {
                                                                                      comments[index].replies.last.fullText = false;
                                                                                    });
                                                                                  } else {
                                                                                    setState(() {
                                                                                      comments[index].replies.last.fullText = true;
                                                                                    });
                                                                                  }
                                                                                },
                                                                                child: Column(
                                                                                  children: [
                                                                                    Column(
                                                                                      children: [
                                                                                        Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                                                                          Container(
                                                                                              alignment: Locales.currentLocale(context).toString() == 'en' ? Alignment.topLeft : Alignment.topRight,
                                                                                              width: 35,
                                                                                              height: 35,
                                                                                              decoration: BoxDecoration(
                                                                                                image: DecorationImage(
                                                                                                    fit: BoxFit.cover,
                                                                                                    image: NetworkImage(
                                                                                                      image + comments[index].replies.last.avatar,
                                                                                                    )),
                                                                                                color: iconTheme,
                                                                                                borderRadius: BorderRadius.circular(12),
                                                                                              )),
                                                                                          Expanded(
                                                                                            flex: 7,
                                                                                            child: Container(
                                                                                              margin: Locales.currentLocale(context).toString() == 'en' ? EdgeInsets.only(left: 5, right: 0) : EdgeInsets.only(left: 0, right: 5),
                                                                                              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                                                                                                Container(
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: iconTheme,
                                                                                                      borderRadius: BorderRadius.circular(12),
                                                                                                    ),
                                                                                                    child: Container(
                                                                                                      margin: Locales.currentLocale(context).toString() == 'en' ? EdgeInsets.only(left: 5, right: 0) : EdgeInsets.only(left: 0, right: 5),
                                                                                                      child: Column(
                                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                          Row(
                                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                            children: [
                                                                                                              Expanded(flex: 3, child: Text('@${comments[index].replies.last.username}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color.fromARGB(216, 158, 158, 158)))),
                                                                                                              Expanded(
                                                                                                                flex: 1,
                                                                                                                child: Container(
                                                                                                                  margin: EdgeInsets.only(right: 0),
                                                                                                                  child: comments[index].replies.last.isAdmin == true
                                                                                                                      ? ImageIcon(
                                                                                                                          AssetImage('images/Light/Star.png'),
                                                                                                                          color: Colors.amber,
                                                                                                                          size: 14,
                                                                                                                        )
                                                                                                                      : Container(),
                                                                                                                ),
                                                                                                              ),
                                                                                                              Expanded(
                                                                                                                flex: 1,
                                                                                                                child: Container(
                                                                                                                  margin: const EdgeInsets.only(right: 0),
                                                                                                                  child: comments[index].replies.last.isEdited == true
                                                                                                                      ? ImageIcon(
                                                                                                                          AssetImage('images/Light/Edit Square.png'),
                                                                                                                          color: Colors.grey,
                                                                                                                          size: 14,
                                                                                                                        )
                                                                                                                      : Container(),
                                                                                                                ),
                                                                                                              ),
                                                                                                              widget.myId.toString() == comments[index].replies.last.commentUser.toString() || isAdmin == true
                                                                                                                  ? Expanded(
                                                                                                                      flex: 2,
                                                                                                                      child: GestureDetector(
                                                                                                                        onTap: () {
                                                                                                                          setState(() {
                                                                                                                            FocusScope.of(context).requestFocus(FocusNode());
                                                                                                                          });
                                                                                                                          showModalBottomSheet(
                                                                                                                            context: context,
                                                                                                                            builder: (context) {
                                                                                                                              return Container(
                                                                                                                                color: backgroundColor,
                                                                                                                                height: size.height / 6,
                                                                                                                                child: Padding(
                                                                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                                                                  child: Column(
                                                                                                                                    children: [
                                                                                                                                      GestureDetector(
                                                                                                                                        onTap: () {
                                                                                                                                          setState(() async {
                                                                                                                                            Navigator.pop(context);
                                                                                                                                            if (await deleteComment(comments[index].commentId)) {
                                                                                                                                              setState(() {
                                                                                                                                                comments3[index].replies.removeAt(comments3[index].replies.length - 1);
                                                                                                                                              });
                                                                                                                                            } else {
                                                                                                                                              true;
                                                                                                                                            }
                                                                                                                                          });
                                                                                                                                          setState(() {
                                                                                                                                            deleteComment(comments[index].replies.last.commentId);
                                                                                                                                            isEdit = false;
                                                                                                                                            _isComment = true;
                                                                                                                                            isRepling = false;
                                                                                                                                            _myController.clear();
                                                                                                                                          });
                                                                                                                                        },
                                                                                                                                        child: Padding(
                                                                                                                                          padding: Locales.currentLocale(context).toString() == 'en' ? EdgeInsets.symmetric(horizontal: 5, vertical: 12) : EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                                                                                                                          child: Container(
                                                                                                                                            color: backgroundColor,
                                                                                                                                            width: double.infinity,
                                                                                                                                            child: Row(
                                                                                                                                              children: [
                                                                                                                                                Text(
                                                                                                                                                  'Delete  ',
                                                                                                                                                  style: TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
                                                                                                                                                ),
                                                                                                                                                Icon(Icons.delete, color: primaryColor, size: 20)
                                                                                                                                              ],
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                        ),
                                                                                                                                      ),
                                                                                                                                      widget.myId.toString() == comments[index].replies.last.commentUser.toString()
                                                                                                                                          ? GestureDetector(
                                                                                                                                              onTap: () {
                                                                                                                                                commentTime = comments[index].replies.last.commentTime.toString();
                                                                                                                                                _replyToId = comments[index].replies.last.commentId;
                                                                                                                                                setState(() {
                                                                                                                                                  setState(() {
                                                                                                                                                    isEdit = true;
                                                                                                                                                    _isComment = false;
                                                                                                                                                    if (_isComment == false) {
                                                                                                                                                      _replyTo = "";
                                                                                                                                                    }
                                                                                                                                                  });
                                                                                                                                                  _editReply = true;
                                                                                                                                                  _myCommentIndex = index;
                                                                                                                                                  _myReplyIndex = comments[index].replies.length - 1;
                                                                                                                                                });

                                                                                                                                                _myController.clear();
                                                                                                                                                Navigator.pop(context);
                                                                                                                                              },
                                                                                                                                              child: Padding(
                                                                                                                                                padding: Locales.currentLocale(context).toString() == 'en' ? EdgeInsets.symmetric(horizontal: 5, vertical: 12) : EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                                                                                                                                child: Container(
                                                                                                                                                  color: backgroundColor,
                                                                                                                                                  width: double.infinity,
                                                                                                                                                  child: Row(
                                                                                                                                                    children: [
                                                                                                                                                      Text(
                                                                                                                                                        'Edit  ',
                                                                                                                                                        style: TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
                                                                                                                                                      ),
                                                                                                                                                      Icon(
                                                                                                                                                        Icons.edit,
                                                                                                                                                        color: primaryColor,
                                                                                                                                                        size: 20,
                                                                                                                                                      )
                                                                                                                                                    ],
                                                                                                                                                  ),
                                                                                                                                                ),
                                                                                                                                              ),
                                                                                                                                            )
                                                                                                                                          : Container()
                                                                                                                                    ],
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                              );
                                                                                                                            },
                                                                                                                          );
                                                                                                                        },
                                                                                                                        child: Container(
                                                                                                                          alignment: Locales.currentLocale(context).toString() == 'en' ? Alignment.centerRight : Alignment.centerLeft,
                                                                                                                          margin: Locales.currentLocale(context).toString() == 'en' ? EdgeInsets.only(right: 8) : EdgeInsets.only(left: 8),
                                                                                                                          child: Icon(
                                                                                                                            Icons.more_horiz,
                                                                                                                            color: Colors.grey,
                                                                                                                            size: 20,
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    )
                                                                                                                  : Container(),
                                                                                                            ],
                                                                                                          ),
                                                                                                          comments[index].replies.last.fair == false
                                                                                                              ? LinkifyText(
                                                                                                                  comments[index].replies.last.commentCont,
                                                                                                                  textStyle: TextStyle(
                                                                                                                    color: primaryColor,
                                                                                                                    fontSize: 15,
                                                                                                                  ),
                                                                                                                  linkStyle: TextStyle(
                                                                                                                    color: bottomDown,
                                                                                                                    fontSize: 15,
                                                                                                                  ),
                                                                                                                  linkTypes: [LinkType.userTag, LinkType.hashTag],
                                                                                                                )
                                                                                                              : GestureDetector(
                                                                                                                  onDoubleTap: () {
                                                                                                                    setState(() {
                                                                                                                      comments[index].replies.last.fair = false;
                                                                                                                    });
                                                                                                                  },
                                                                                                                  child: Padding(
                                                                                                                    padding: const EdgeInsets.all(8),
                                                                                                                    child: Container(
                                                                                                                      decoration: BoxDecoration(
                                                                                                                        borderRadius: BorderRadius.circular(14),
                                                                                                                      ),
                                                                                                                      child: Center(
                                                                                                                        child: Row(
                                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                          children: [
                                                                                                                            Text(
                                                                                                                              'Double tap to view the reply ',
                                                                                                                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.red),
                                                                                                                            ),
                                                                                                                            ImageIcon(
                                                                                                                              AssetImage(
                                                                                                                                'images/Light/Show.png',
                                                                                                                              ),
                                                                                                                              color: Colors.red,
                                                                                                                              size: 15,
                                                                                                                            )
                                                                                                                          ],
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ))
                                                                                                        ],
                                                                                                      ),
                                                                                                    )),
                                                                                              ]),
                                                                                            ),
                                                                                          )
                                                                                        ]),
                                                                                        Padding(
                                                                                          padding: Locales.currentLocale(context).toString() == 'en' ? EdgeInsets.only(left: 44, top: 5) : EdgeInsets.only(right: 44, top: 5),
                                                                                          child: Container(
                                                                                            //color: Colors.red,
                                                                                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                                              Expanded(
                                                                                                flex: 2,
                                                                                                child: Text(
                                                                                                  Jiffy(comments[index].replies.last.commentTime).fromNow(),
                                                                                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                flex: 1,
                                                                                                child: Text(
                                                                                                  comments[index].replies.last.likes > 1 ? '${comments[index].replies.last.likes} Likes' : '${comments[index].replies.last.likes} like',
                                                                                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                flex: 1,
                                                                                                child: Text(
                                                                                                  'Reply',
                                                                                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                flex: 1,
                                                                                                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                                                                                  Text(
                                                                                                    '',
                                                                                                    //'${comments[index].replies.last.likes}',
                                                                                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                                                                                  ),
                                                                                                  GestureDetector(
                                                                                                    onTap: () {
                                                                                                      if (comments[index].replies.last.isLiked == true) {
                                                                                                        if (unLike(comments[index].replies.last.commentId) == true) {
                                                                                                          setState(() {
                                                                                                            comments[index].replies.last.isLiked = true;
                                                                                                            comments[index].replies.last.likes += 1;
                                                                                                          });
                                                                                                        } else {
                                                                                                          setState(() {
                                                                                                            comments[index].replies.last.isLiked = false;
                                                                                                            comments[index].replies.last.likes -= 1;
                                                                                                          });
                                                                                                        }
                                                                                                      } else {
                                                                                                        if (like(comments[index].replies.last.commentId) == true) {
                                                                                                          setState(() {
                                                                                                            comments[index].replies.last.isLiked = false;
                                                                                                            comments[index].replies.last.likes -= 1;
                                                                                                          });
                                                                                                        } else {
                                                                                                          setState(() {
                                                                                                            comments[index].replies.last.isLiked = true;
                                                                                                            comments[index].replies.last.likes += 1;
                                                                                                          });
                                                                                                        }
                                                                                                      }
                                                                                                    },
                                                                                                    child: ImageIcon(
                                                                                                      AssetImage('images/Light/Heart.png'),
                                                                                                      color: comments[index].replies.last.isLiked == true ? Colors.red : Colors.grey,
                                                                                                      size: 16,
                                                                                                    ),
                                                                                                  )
                                                                                                ]),
                                                                                              ),
                                                                                            ]),
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            : Column(
                                                                                children: comments[index].replies.map((e) {
                                                                                  return Builder(
                                                                                    builder: (context) {
                                                                                      return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                                                                                        Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                                                                          Container(
                                                                                              alignment: Locales.currentLocale(context).toString() == 'en' ? Alignment.topLeft : Alignment.topRight,
                                                                                              width: 35,
                                                                                              height: 35,
                                                                                              decoration: BoxDecoration(
                                                                                                image: DecorationImage(
                                                                                                    fit: BoxFit.cover,
                                                                                                    image: NetworkImage(
                                                                                                      image + comments[index].replies.last.avatar,
                                                                                                    )),
                                                                                                color: iconTheme,
                                                                                                borderRadius: BorderRadius.circular(10),
                                                                                              )),
                                                                                          Expanded(
                                                                                            flex: 7,
                                                                                            child: Container(
                                                                                              margin: Locales.currentLocale(context).toString() == 'en' ? EdgeInsets.only(left: 5, right: 0) : EdgeInsets.only(left: 0, right: 5),
                                                                                              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                                                                                                Container(
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: iconTheme,
                                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                                    ),
                                                                                                    child: Container(
                                                                                                      margin: Locales.currentLocale(context).toString() == 'en' ? EdgeInsets.only(left: 5, right: 0) : EdgeInsets.only(left: 0, right: 5),
                                                                                                      child: Column(
                                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                          Row(
                                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                            children: [
                                                                                                              Expanded(flex: 3, child: Text('@${e.username}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color.fromARGB(216, 158, 158, 158)))),
                                                                                                              Expanded(
                                                                                                                flex: 1,
                                                                                                                child: Container(
                                                                                                                  child: e.isAdmin == true
                                                                                                                      ? ImageIcon(
                                                                                                                          AssetImage('images/Light/Star.png'),
                                                                                                                          color: Colors.amber,
                                                                                                                          size: 14,
                                                                                                                        )
                                                                                                                      : Container(),
                                                                                                                ),
                                                                                                              ),
                                                                                                              Expanded(
                                                                                                                flex: 1,
                                                                                                                child: Container(
                                                                                                                  child: e.isEdited == true
                                                                                                                      ? ImageIcon(
                                                                                                                          AssetImage('images/Light/Edit Square.png'),
                                                                                                                          color: Colors.grey,
                                                                                                                          size: 14,
                                                                                                                        )
                                                                                                                      : Container(),
                                                                                                                ),
                                                                                                              ),
                                                                                                              widget.myId.toString() == e.commentUser.toString() || isAdmin == true
                                                                                                                  ? Expanded(
                                                                                                                      flex: 2,
                                                                                                                      child: GestureDetector(
                                                                                                                        onTap: () {
                                                                                                                          setState(() {
                                                                                                                            FocusScope.of(context).requestFocus(FocusNode());
                                                                                                                          });
                                                                                                                          showModalBottomSheet(
                                                                                                                            context: context,
                                                                                                                            builder: (context) {
                                                                                                                              return Container(
                                                                                                                                color: Color.fromARGB(255, 19, 18, 18),
                                                                                                                                height: size.height / 6,
                                                                                                                                child: Padding(
                                                                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                                                                  child: Column(
                                                                                                                                    children: [
                                                                                                                                      GestureDetector(
                                                                                                                                        onTap: () {
                                                                                                                                          setState(() async {
                                                                                                                                            Navigator.pop(context);
                                                                                                                                            if (await deleteComment(e.commentId)) {
                                                                                                                                              setState(() {
                                                                                                                                                comments3[index].replies.removeAt(comments3[index].replies.indexOf(e));
                                                                                                                                              });
                                                                                                                                            } else {
                                                                                                                                              true;
                                                                                                                                            }
                                                                                                                                          });
                                                                                                                                          setState(() {
                                                                                                                                            isEdit = false;
                                                                                                                                            _isComment = true;
                                                                                                                                            isRepling = false;
                                                                                                                                            _myController.clear();
                                                                                                                                            Navigator.pop(context);
                                                                                                                                          });
                                                                                                                                        },
                                                                                                                                        child: Padding(
                                                                                                                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                                                                                                                                          child: Container(
                                                                                                                                            color: Color.fromARGB(255, 19, 18, 18),
                                                                                                                                            width: double.infinity,
                                                                                                                                            child: Row(
                                                                                                                                              children: const [
                                                                                                                                                Text(
                                                                                                                                                  'Delete  ',
                                                                                                                                                  style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
                                                                                                                                                ),
                                                                                                                                                Icon(Icons.delete, color: Colors.grey, size: 20)
                                                                                                                                              ],
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                        ),
                                                                                                                                      ),
                                                                                                                                      widget.myId.toString() == e.commentUser.toString()
                                                                                                                                          ? GestureDetector(
                                                                                                                                              onTap: () {
                                                                                                                                                commentTime = e.commentTime.toString();
                                                                                                                                                _replyToId = e.commentId;

                                                                                                                                                setState(() {
                                                                                                                                                  setState(() {
                                                                                                                                                    isEdit = true;
                                                                                                                                                    _isComment = false;
                                                                                                                                                    if (_isComment == false) {
                                                                                                                                                      _replyTo = "";
                                                                                                                                                    }
                                                                                                                                                  });
                                                                                                                                                  _editReply = true;
                                                                                                                                                  _myCommentIndex = index;
                                                                                                                                                  _myReplyIndex = comments[index].replies.indexOf(e);
                                                                                                                                                });

                                                                                                                                                _myController.clear();
                                                                                                                                                Navigator.pop(context);
                                                                                                                                              },
                                                                                                                                              child: Padding(
                                                                                                                                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                                                                                                                                                child: Container(
                                                                                                                                                  color: Color.fromARGB(255, 19, 18, 18),
                                                                                                                                                  width: double.infinity,
                                                                                                                                                  child: Row(
                                                                                                                                                    children: const [
                                                                                                                                                      Text(
                                                                                                                                                        'Edit  ',
                                                                                                                                                        style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
                                                                                                                                                      ),
                                                                                                                                                      Icon(
                                                                                                                                                        Icons.edit,
                                                                                                                                                        color: Colors.grey,
                                                                                                                                                        size: 20,
                                                                                                                                                      )
                                                                                                                                                    ],
                                                                                                                                                  ),
                                                                                                                                                ),
                                                                                                                                              ),
                                                                                                                                            )
                                                                                                                                          : Container()
                                                                                                                                    ],
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                              );
                                                                                                                            },
                                                                                                                          );
                                                                                                                        },
                                                                                                                        child: Container(
                                                                                                                          alignment: Alignment.centerRight,
                                                                                                                          margin: EdgeInsets.only(right: 8),
                                                                                                                          child: Icon(
                                                                                                                            Icons.more_horiz,
                                                                                                                            color: Colors.grey,
                                                                                                                            size: 20,
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    )
                                                                                                                  : Container(),
                                                                                                            ],
                                                                                                          ),
                                                                                                          e.fair == false
                                                                                                              ? LinkifyText(
                                                                                                                  e.commentCont,
                                                                                                                  textStyle: TextStyle(
                                                                                                                    color: primaryColor,
                                                                                                                    fontSize: 15,
                                                                                                                  ),
                                                                                                                  linkStyle: TextStyle(
                                                                                                                    color: bottomDown,
                                                                                                                    fontSize: 15,
                                                                                                                  ),
                                                                                                                  linkTypes: [LinkType.userTag, LinkType.hashTag],
                                                                                                                )
                                                                                                              : GestureDetector(
                                                                                                                  onDoubleTap: () {
                                                                                                                    setState(() {
                                                                                                                      e.fair = false;
                                                                                                                    });
                                                                                                                  },
                                                                                                                  child: Padding(
                                                                                                                    padding: const EdgeInsets.all(8),
                                                                                                                    child: Container(
                                                                                                                      decoration: BoxDecoration(
                                                                                                                        borderRadius: BorderRadius.circular(14),
                                                                                                                      ),
                                                                                                                      child: Center(
                                                                                                                        child: Row(
                                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                          children: [
                                                                                                                            Text(
                                                                                                                              'Double tap to view the reply ',
                                                                                                                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.red),
                                                                                                                            ),
                                                                                                                            ImageIcon(
                                                                                                                              AssetImage(
                                                                                                                                'images/Light/Show.png',
                                                                                                                              ),
                                                                                                                              color: Colors.red,
                                                                                                                              size: 15,
                                                                                                                            )
                                                                                                                          ],
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ))
                                                                                                        ],
                                                                                                      ),
                                                                                                    )),
                                                                                              ]),
                                                                                            ),
                                                                                          )
                                                                                        ]),
                                                                                        Padding(
                                                                                            padding: Locales.currentLocale(context).toString() == 'en' ? EdgeInsets.only(left: 44, top: 5) : EdgeInsets.only(right: 44, top: 5),
                                                                                            child: Container(
                                                                                                //color: Colors.red,
                                                                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                                              Expanded(
                                                                                                flex: 2,
                                                                                                child: Text(
                                                                                                  Jiffy(e.commentTime).fromNow(),
                                                                                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                flex: 1,
                                                                                                child: Text(
                                                                                                  e.likes > 1 ? '${e.likes} Likes' : '${e.likes} like',
                                                                                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                flex: 1,
                                                                                                child: Text(
                                                                                                  'Reply',
                                                                                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                  flex: 1,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                                                                                    Text(
                                                                                                      '',
                                                                                                      //'${comments[index].replies.last.likes}',
                                                                                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                                                                                    ),
                                                                                                    GestureDetector(
                                                                                                      onTap: () {
                                                                                                        if (e.isLiked == true) {
                                                                                                          if (unLike(e.commentId) == true) {
                                                                                                            setState(() {
                                                                                                              e.isLiked = true;
                                                                                                              e.likes += 1;
                                                                                                            });
                                                                                                          } else {
                                                                                                            setState(() {
                                                                                                              e.isLiked = false;
                                                                                                              e.likes -= 1;
                                                                                                            });
                                                                                                          }
                                                                                                        } else {
                                                                                                          if (like(e.commentId) == true) {
                                                                                                            setState(() {
                                                                                                              e.isLiked = false;
                                                                                                              e.likes -= 1;
                                                                                                            });
                                                                                                          } else {
                                                                                                            setState(() {
                                                                                                              e.isLiked = true;
                                                                                                              e.likes += 1;
                                                                                                            });
                                                                                                          }
                                                                                                        }
                                                                                                      },
                                                                                                      child: ImageIcon(
                                                                                                        AssetImage('images/Light/Heart.png'),
                                                                                                        color: e.isLiked == true ? Colors.red : Colors.grey,
                                                                                                        size: 16,
                                                                                                      ),
                                                                                                    )
                                                                                                  ]))
                                                                                            ])))
                                                                                      ]);
                                                                                    },
                                                                                  );
                                                                                }).toList(),
                                                                              )),
                                                                    GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            if (allReplies ==
                                                                                true) {
                                                                              allReplies = false;
                                                                            } else {
                                                                              allReplies = true;
                                                                            }
                                                                          });
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              bottom: 10,
                                                                              top: 10,
                                                                              left: 10),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Expanded(flex: 4, child: SizedBox()),
                                                                              Expanded(
                                                                                flex: 4,
                                                                                child: Container(
                                                                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                                                                  height: 1,
                                                                                  width: 50,
                                                                                  color: comments[index].replies.length >= 2 ? Colors.grey : Colors.transparent,
                                                                                ),
                                                                              ),
                                                                              comments[index].replies.length > 1
                                                                                  ? Text(
                                                                                      textAlign: TextAlign.start,
                                                                                      allReplies == false ? '${context.localeString('View')} ${comments[index].replies.length - 1} ${comments[index].replies.length != 2 ? 'more relpies' : 'more relpy'}' : 'Hide replies',
                                                                                      style: const TextStyle(fontSize: 12, color: Color.fromARGB(206, 199, 192, 192)),
                                                                                    )
                                                                                  : Container(),
                                                                              Expanded(flex: 8, child: SizedBox()),
                                                                            ],
                                                                          ),
                                                                        ))
                                                                  ],
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                    ),
                                                  ]),
                                                );
                                              } else {
                                                return const Text('');
                                                //  Padding(
                                                //   padding: const EdgeInsets.symmetric(
                                                //       vertical: 15),
                                                //   child: Center(
                                                //       child:
                                                //           const CircularProgressIndicator()),
                                                // );
                                              }
                                            }),
                                      ),
                                    ),
                                  );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        })),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

// comments from json
class Comments {
  var commentAnime;
  var commentId;
  var commentUser;
  bool fair;
  bool fullText;
  bool isEdited;
  bool isAdmin;
  bool isLiked;
  var replyOf;
  var likes;
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
        int.parse(json['comment_anime']),
        int.parse(json['comment_id']),
        int.parse(json['comment_user']),
        json['fair'] == '0' ? false : true,
        json['fair'] == '0' ? false : true,
        json['is_edited'] == '0' ? false : true,
        json['is_admin'] == '0' ? false : true,
        json['is_liked'] == 0 ? false : true,
        json['reply_of'] == '0' ? 0 : int.parse(json['reply_of']),
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
