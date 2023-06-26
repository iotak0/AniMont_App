import 'dart:io';
import 'package:anime_mont_test/Screens/Profile/profial_screen.dart';
import 'package:anime_mont_test/Screens/settings/circleBotton.dart';
import 'package:anime_mont_test/Screens/settings/more_items.dart';
import 'package:anime_mont_test/Screens/settings/show_more_widget.dart';
import 'package:anime_mont_test/helper/constans.dart';
import 'package:anime_mont_test/models/comments.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/provider/user_model.dart';
import 'package:anime_mont_test/server/banner_ad.dart';
import 'package:anime_mont_test/widgets/add_comment_post.dart';
import 'package:anime_mont_test/widgets/alart.dart';
import 'package:anime_mont_test/widgets/alart_internet.dart';
import 'package:anime_mont_test/widgets/cust_snak_bar.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:http/http.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostCommentsPage extends StatefulWidget {
  const PostCommentsPage(
      {super.key,
      required this.myId,
      required this.pageId,
      required this.isPost});
  final int myId;
  final pageId;
  final bool isPost;

  @override
  State<PostCommentsPage> createState() => PostCommentsPageState();
}

class PostCommentsPageState extends State<PostCommentsPage> {
  int page = 1;
  static late ScrollController _scrollController;
  TextEditingController myController = TextEditingController();
  final int _maxLength = 15;
  bool erorr = false;
  bool isLoading = false;
  bool hasMore = true;
  bool complet = false;

  static bool isFire = false;
  static bool sending = false;
  late int commentsCount;
  static List<PostsComments> comments = [];
  static bool reply = false;
  static bool edit = false;
  static bool showEmoji = false;
  static int select = 0;
  static late UserProfial account;
  addComment() async {
    setState(() {
      PostCommentsPageState.sending = true;
    });

    FocusScope.of(context).requestFocus(FocusNode());

    final response = await http.post(Uri.parse(add_post_comment), body: {
      "post_id": '${widget.pageId}',
      "comment_cont": myController.text,
      "comment_user": '${widget.myId}',
      "comment_fair": isFire == false ? "0" : "1",
      "reply_of": "${!reply ? 0 : comments[select].commentId}"
    }).catchError((e) {
      PostCommentsPageState.sending = false;

      setState(() {});
    });
    final body = json.decode(response.body);
    if (body['status'] == "success") {
      myController.clear();
      edit = false;
      isFire = false;
      PostCommentsPageState.reply = false;
      select = 0;
      refresh();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustSnackBar(
          headLine: body['message'] == "error"
              ? context.localeString('erorr')
              : context.localeString('you_have_been_banned'),
          erorr: body['message'] == "error"
              ? context.localeString("try_again")
              : context.localeString("your_account_is_banned"),
          color: Color(0xFFC72C41),
          image: danger,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    }
    setState(() {
      sending = false;
    });
  }

  getComments() async {
    //addComment();
    setState(() {
      isLoading = true;
      erorr = false;
    });
    final response = await http
        .get(Uri.parse(
            '${all_comments_posts}?page=$page&post_id=${widget.pageId}&user_id=${widget.myId}'))
        //
        .catchError((erorr0) {
      isLoading = false;
      erorr = true;
      setState(() {});
      return Response('error', 400);
    });

    if (response.statusCode == 200) {
      page++;
      print(response.body);
      var data;
      try {
        data = jsonDecode(response.body);
      } catch (e) {
        complet = true;
        isLoading = false;
        setState(() {});
        return;
      }

      for (var e in data) {
        comments.add(PostsComments(
          e['post_id'].toString(),
          int.parse(e['comment_id']),
          e['fair'] == '0' ? false : true,
          e['fair'] == '0' ? false : true,
          e['is_edited'] == '0' ? false : true,
          e['is_like'],
          e['reply_of'] == '0' ? 0 : int.parse(e['reply_of']),
          e['likes'],
          e['comment_cont'],
          UserModel.fromJson(e['account']),
          e['comment_time'],
          e['replies'],
          e['replies'],
          e['time_now'],
        ));
      }
      // comments.addAll(data.map<Comments>(Comments.fromJson).toList());
      setState(() {
        isLoading = false;
        hasMore = (data.length >= _maxLength) ? true : false;
        commentsCount = data.length;
      });
    } else {
      setState(() {
        erorr = true;
        isLoading = false;
      });
    }
    complet = true;
    setState(() {});
  }

  getAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString('userData');
    final body = json.decode(userPref!);
    account = UserProfial.fromJson(body);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    comments.clear();
    getAccount();
    getComments();
    isFire = false;
    sending = false;
    edit = false;
    reply = false;
    select = 0;
    setState(() {});
    myController.addListener(() {
      if (myController.text.isEmpty) {
        setState(() {});
      }
      if (myController.text.length == 1) {
        setState(() {});
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * .95 &&
          !isLoading &&
          hasMore) {
        getComments();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    isLoading = false;
    page = 1;
    hasMore = true;
    erorr = false;
    super.dispose();
  }

  Future refresh() async {
    hasMore = true;
    page = 1;
    erorr = false;
    isLoading = false;
    sending = false;
    setState(() {});
    comments.clear();
    getComments();
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        color: customColors.backgroundColor,
        child: RefreshIndicator(
          onRefresh: () => refresh(),
          child: Column(
            //controller: _scrollController,
            children: [
              AddCommentPost(
                  showEmoji: () => setState(() {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: SizedBox(
                              height: 300,
                              child: EmojiPicker(
                                textEditingController: myController,
                                config: Config(
                                    columns: 7,
                                    bgColor: customColors.backgroundColor,
                                    emojiSizeMax:
                                        32 * (Platform.isIOS ? 1.30 : 1)),
                              ),
                            ),
                          ),
                        );
                      }),
                  sendCallBack: () => addComment(),
                  myController: myController,
                  customColors: customColors),
              const MyBannerAd(),
              Expanded(
                child: (isLoading && !erorr && comments.isEmpty)
                    ? LoadingGif(
                        logo: true,
                      )
                    : (erorr && comments.isEmpty)
                        ? AlartInternet(
                            onTap: () => isLoading ? null : getComments())
                        : (complet && comments.isEmpty)
                            ? Alart(body: 'no_comments_yet', icon: onComments)
                            : SizedBox(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.only(bottom: 15),
                                  controller: _scrollController,
                                  child: Column(
                                    children: List.generate(
                                      comments.length +
                                          (hasMore && comments.isNotEmpty
                                              ? 1
                                              : 0),
                                      (index) {
                                        if (index == comments.length) {
                                          return LoadingGif(
                                            logo: true,
                                          );
                                        }
                                        getReplies() async {
                                          //addComment();
                                          setState(() {
                                            comments[index].replyLoading = true;
                                            comments[index].replyErorr = false;
                                          });

                                          final response = await http
                                              .get(Uri.parse(
                                                  '${all_comments_posts_replies}?page=${comments[index].replyPage}&comment_id=${comments[index].commentId}&user_id=${widget.myId}'))
                                              .catchError((erorr0) {
                                            comments[index].replyLoading =
                                                false;
                                            comments[index].replyErorr = true;
                                            setState(() {});
                                            return Response('error', 400);
                                          });

                                          if (response.statusCode == 200) {
                                            comments[index].replyPage++;
                                            print(response.body);
                                            final data =
                                                jsonDecode(response.body);
                                            for (var e in data) {
                                              comments[index]
                                                  .replies
                                                  .add(PostsComments(
                                                    e['post_id'].toString(),
                                                    int.parse(e['comment_id']),
                                                    e['fair'] == '0'
                                                        ? false
                                                        : true,
                                                    e['fair'] == '0'
                                                        ? false
                                                        : true,
                                                    e['is_edited'] == '0'
                                                        ? false
                                                        : true,
                                                    e['is_like'],
                                                    e['reply_of'] == '0'
                                                        ? 0
                                                        : int.parse(
                                                            e['reply_of']),
                                                    e['likes'],
                                                    e['comment_cont'],
                                                    UserModel.fromJson(
                                                        e['account']),
                                                    e['comment_time'],
                                                    e['replies'],
                                                    e['replies'],
                                                    e['time_now'],
                                                  ));
                                              setState(() {
                                                comments[index].repliesCount--;
                                              });
                                            }
                                            // comments.addAll(data.map<Comments>(Comments.fromJson).toList());
                                            setState(() {
                                              comments[index].replyLoading =
                                                  false;
                                              comments[index].replyHasMore =
                                                  (data.length >= _maxLength)
                                                      ? true
                                                      : false;
                                              if (comments[index]
                                                      .repliesCountFinal ==
                                                  comments[index]
                                                      .replies
                                                      .length) {
                                                comments[index].done = true;
                                              }
                                            });
                                          } else {
                                            setState(() {
                                              comments[index].replyErorr = true;
                                              comments[index].replyLoading =
                                                  false;
                                            });
                                          }
                                          comments[index].replyComplet = true;
                                          setState(() {});
                                        }

                                        onTap() {
                                          PostCommentsPageState.reply = true;
                                          PostCommentsPageState.select = index;
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          setState(() {});
                                        }
                                        // if (index == 0 && !isLoading) {
                                        //   return Column(
                                        //     children: [

                                        //       CommentCard(
                                        //         pageId: widget.pageId,
                                        //         onTap: () => onTap(),
                                        //         profile: true,
                                        //         index: index,
                                        //         myId: widget.myId,
                                        //       ),
                                        //     ],
                                        //   );
                                        // }
                                        return comments[index].hasDeleted
                                            ? SizedBox()
                                            : CommentCard(
                                                account: account,
                                                controller: myController,
                                                scrollController:
                                                    _scrollController,
                                                addReply: () => getReplies(),
                                                pageId: widget.pageId,
                                                onTap: () => onTap(),
                                                profile: true,
                                                index: index,
                                                myId: widget.myId,
                                              );
                                      },
                                    ),
                                  ),
                                ),
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentCard extends StatefulWidget {
  const CommentCard({
    super.key,
    required this.profile,
    required this.index,
    required this.myId,
    required this.onTap,
    required this.pageId,
    required this.addReply,
    required this.scrollController,
    required this.controller,
    required this.account,
  });
  final bool profile;
  final int index;
  final int pageId;
  final int myId;
  final GestureTapCallback onTap;
  final GestureTapCallback addReply;
  final ScrollController scrollController;
  final TextEditingController controller;
  final UserProfial account;
  @override
  State<CommentCard> createState() => CommentCardState();
}

class CommentCardState extends State<CommentCard> {
  late PostsComments comment;
  late ScrollController scrollController;
  like() async {
    setState(() {
      comment.isLiked = true;
      comment.likes++;
    });
    final response = await http.post(
        Uri.parse(
          like_comments_posts,
        ),
        body: {
          "user_id": '${widget.myId}',
          "comment_user": '${comment.account.id}',
          "comment_id": '${comment.commentId}',
          "post_id": '${widget.pageId}',
        }).catchError((e) {
      setState(() {
        comment.isLiked = false;
        comment.likes--;
      });
    });
    final data = jsonDecode(response.body);
    print(data);
    if (data['status'] == "success") {
      setState(() {});

      return true;
    } else {
      setState(() {
        comment.isLiked = false;
        comment.likes--;
      });
      return false;
    }
  }

  unLike() async {
    setState(() {
      comment.isLiked = false;
      comment.likes--;
    });

    final response = await http.post(
        Uri.parse(
          un_like_comments_posts,
        ),
        body: {
          "user_id": '${widget.myId}',
          "comment_id": '${comment.commentId}',
        }).catchError((e) {
      setState(() {
        comment.isLiked = true;
        comment.likes++;
      });
    });
    final data = jsonDecode(response.body);
    print(data);
    if (data['status'] == "success") {
      setState(() {});
      return true;
    } else {
      setState(() {
        comment.isLiked = true;
        comment.likes++;
      });
      return false;
    }
  }

  delete() async {
    setState(() {
      comment.editing = true;
    });

    final response = await http.post(
        Uri.parse(
          delete_comments_post,
        ),
        body: {
          "post_id": '${widget.pageId}',
          "comment_id": '${comment.commentId}',
        }).catchError((e) {
      setState(() {
        comment.editing = false;
      });
    });
    final data = jsonDecode(response.body);
    print(data);
    if (data['status'] == "success") {
      setState(() {
        comment.editing = false;
        comment.hasDeleted = true;
      });
      return true;
    } else {
      setState(() {
        comment.editing = false;
      });
      return false;
    }
  }

  edit() async {
    PostCommentsPageState.edit = true;
    await showDialog(
        context: context,
        builder: (context) {
          CustomColors customColors = CustomColors(context);

          return Dialog(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        // enabled: !PostCommentsPageState.edit,
                        // autofocus: true,
                        controller: widget.controller,
                        maxLines: 5,
                        onChanged: (value) => setState(() {}),
                        onEditingComplete: (widget.controller.text.isEmpty)
                            ? () {
                                Navigator.pop(context);
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              }
                            : () async {
                                setState(() {
                                  comment.editing = true;
                                  PostCommentsPageState.edit = true;
                                });
                                final response = await http.post(
                                    Uri.parse(
                                      edit_comment,
                                    ),
                                    body: {
                                      "comment_cont":
                                          '${widget.controller.text}',
                                      "comment_id": '${comment.commentId}',
                                      "fire":
                                          PostCommentsPageState.isFire == false
                                              ? "0"
                                              : "1",
                                    }).catchError((e) {
                                  setState(() {
                                    PostCommentsPageState.edit = false;
                                    comment.editing = false;
                                  });
                                });
                                final data = jsonDecode(response.body);
                                print(data);
                                if (data['status'] == "success") {
                                  setState(() {
                                    PostCommentsPageState.edit = false;
                                    comment.editing = false;
                                    Navigator.pop(context);
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  });
                                } else {
                                  setState(() {
                                    widget.controller.clear();
                                    PostCommentsPageState.edit = false;
                                    comment.editing = false;
                                  });
                                }
                                setState(() {
                                  PostCommentsPageState.edit = false;
                                  comment.editing = false;
                                });
                              },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: context.localeString('edit'),
                          hintStyle: TextStyle(
                            fontFamily: 'SFPro',
                            color: customColors.primaryColor.withOpacity(0.6),
                          ),
                        ),
                        minLines: 1,

                        // expands: true,
                        textAlignVertical: TextAlignVertical.center,

                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.send,

                        maxLength: widget.controller.text.isEmpty ? null : 150,

                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
    setState(() {
      comment.editing = false;
    });
  }

  report() async {
    setState(() {
      comment.editing = true;
    });

    final response = await http.post(
        Uri.parse(
          report_comments_posts,
        ),
        body: {
          "user_id": '${widget.myId}',
          "comment_id": '${comment.commentId}',
        }).catchError((e) {
      setState(() {
        comment.editing = false;
      });
    });
    var data;
    try {
      data = jsonDecode(response.body);
    } catch (e) {
      data = {"status": "hi"};
    }
    if (data['status'] == "success") {
      setState(() {
        comment.editing = false;
      });
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                backgroundColor: Colors.transparent,
                content: Container(
                  //height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: CustomColors(context).backgroundColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            child: SvgPicture.string(
                              '<?xml version="1.0" encoding="UTF-8"?> <svg xmlns="http://www.w3.org/2000/svg" id="Слой_1" data-name="Слой 1" viewBox="0 0 783 783"><path d="M911,170.5a362.21,362.21,0,1,1-141.48,28.55A361.31,361.31,0,0,1,911,170.5m0-28c-216.22,0-391.5,175.28-391.5,391.5S694.78,925.5,911,925.5,1302.5,750.22,1302.5,534,1127.22,142.5,911,142.5Z" transform="translate(-519.5 -142.5)"></path><path d="M651.5,487.5a363.14,363.14,0,0,1,34.75,16.12c11.35,5.91,22.43,12.3,33.34,19s21.61,13.63,32.17,20.8c5.29,3.57,10.49,7.25,15.71,10.92l7.75,5.6c2.59,1.86,5.18,3.73,7.72,5.64,20.48,15.16,40.38,31.05,59.83,47.44l14.48,12.42c4.8,4.18,9.55,8.4,14.31,12.63s9.44,8.54,14.14,12.86l7,6.52c2.35,2.22,4.6,4.35,7.06,6.74l-50.45,6.8,3.27-7.16c1-2.28,2.13-4.51,3.22-6.73,2.19-4.44,4.36-8.86,6.66-13.2s4.6-8.66,7-13,4.82-8.52,7.28-12.75Q891.62,592.86,908.8,569c11.5-15.87,23.72-31.27,36.77-46a528.87,528.87,0,0,1,41.74-42.18,429.2,429.2,0,0,1,47.08-36.94,342.92,342.92,0,0,1,52.66-29.4,259.29,259.29,0,0,1,57.55-18.23c4.94-.93,9.91-1.68,14.88-2.23s10-1,14.94-1.1c2.48-.1,5-.12,7.44-.13s5,.12,7.43.23A136.28,136.28,0,0,1,1204,394.5c-4.46,2.1-8.83,4.19-13.12,6.31l-3.2,1.6-3.16,1.65c-2.1,1.08-4.19,2.16-6.24,3.31q-12.36,6.76-23.84,14.2a437.23,437.23,0,0,0-43.34,32.19c-27.31,22.92-52.11,48.31-75.82,75q-17.76,20-34.66,41T967.35,612.2Q951,633.79,935.22,655.94q-4,5.52-7.86,11.09c-2.62,3.7-5.23,7.4-7.79,11.12s-5.16,7.42-7.66,11.14l-7.26,10.77-24.78,36.77-25.67-30L842.3,693l-12.16-14-12.25-14-12.29-14q-24.66-27.9-49.71-55.54c-16.74-18.4-33.61-36.73-50.9-54.75-8.64-9-17.33-18-26.25-26.88S660.77,496.28,651.5,487.5Z" transform="translate(-519.5 -142.5)"></path></svg>',
                              height: 50,
                              width: 50,
                              color: CustomColors(context).bottomDown,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          LocaleText(
                            'thax_report',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: CustomColors(context).primaryColor,
                              //   fontFamily: 'SFPro',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Divider(
                            height: 1,
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: SizedBox(
                              width: double.infinity,
                              child: LocaleText(
                                'close',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: CustomColors(context)
                                      .primaryColor
                                      .withOpacity(.6),
                                  //   fontFamily: 'SFPro',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                        ]),
                  ),
                ));
          });
      return true;
    } else {
      setState(() {
        comment.editing = false;
      });
      return false;
    }
  }

  @override
  void initState() {
    scrollController = widget.scrollController;
    super.initState();
    comment = PostCommentsPageState.comments[widget.index];
    setState(() {});
  }

  bool sended = false;
  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    final avatar = comment.account.avatar.toString().startsWith('http')
        ? comment.account.avatar
        : image + comment.account.avatar;
    if (widget.account.userName != comment.account.userName) {
      CachedNetworkImage.evictFromCache(comment.account.avatar);
    }
    return comment.hasDeleted
        ? SizedBox()
        : comment.editing
            ? LoadingGif(
                logo: true,
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: GestureDetector(
                  onTap: () => null,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfialPage(
                                          id: int.parse(comment.account.id),
                                          isMyProfile: false,
                                          myId: widget.myId)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                    height: 35,
                                    width: 35,
                                    errorWidget: (context, url, error) =>
                                        SizedBox(),
                                    key: UniqueKey(),
                                    imageUrl: avatar,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                          Expanded(
                              child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    comment.account.userName.toLowerCase(),
                                    softWrap: true,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "SFPro",
                                        color: customColors.primaryColor
                                            .withOpacity(.9)),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  !comment.account.admin
                                      ? SizedBox()
                                      : SvgPicture.string(
                                          '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Light/Star</title>
    <g id="Iconly/Light/Star" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round">
        <g id="Star" transform="translate(3.000000, 3.500000)" stroke="#000000" stroke-width="1.5">
            <path d="M10.1042564,0.67700614 L11.9316681,4.32775597 C12.1107648,4.68615589 12.4564632,4.93467388 12.8573484,4.99218218 L16.9453359,5.58061527 C17.9553583,5.72643988 18.3572847,6.95054503 17.6263201,7.65194084 L14.6701824,10.4924399 C14.3796708,10.7717659 14.2474307,11.173297 14.3161539,11.5676396 L15.0137982,15.5778163 C15.1856062,16.5698344 14.1297683,17.3266846 13.2269958,16.8573759 L9.57321374,14.9626829 C9.21502023,14.7768079 8.78602103,14.7768079 8.42678626,14.9626829 L4.77300425,16.8573759 C3.87023166,17.3266846 2.81439382,16.5698344 2.98724301,15.5778163 L3.68384608,11.5676396 C3.75256926,11.173297 3.62032921,10.7717659 3.32981762,10.4924399 L0.373679928,7.65194084 C-0.357284727,6.95054503 0.0446417073,5.72643988 1.05466409,5.58061527 L5.14265161,4.99218218 C5.54353679,4.93467388 5.89027643,4.68615589 6.06937319,4.32775597 L7.89574356,0.67700614 C8.34765049,-0.225668713 9.65234951,-0.225668713 10.1042564,0.67700614 Z" id="Stroke-1"></path>
        </g>
    </g>
</svg>''',
                                          height: 12,
                                          width: 12,
                                          color: Color.fromARGB(
                                              255, 218, 197, 12)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  !comment.isEdited
                                      ? SizedBox()
                                      : SvgPicture.string(
                                          '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Bold/Edit</title>
    <g id="Iconly/Bold/Edit" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
            <g id="Edit" transform="translate(3.000000, 3.000000)" fill="#000000" fill-rule="nonzero">
                <path d="M16.989778,15.9532516 C17.5468857,15.9532516 18,16.412265 18,16.9766258 C18,17.5420615 17.5468857,18 16.989778,18 L16.989778,18 L11.2796888,18 C10.7225811,18 10.2694668,17.5420615 10.2694668,16.9766258 C10.2694668,16.412265 10.7225811,15.9532516 11.2796888,15.9532516 L11.2796888,15.9532516 Z M13.0298561,0.699063657 L14.5048652,1.87078412 C15.109725,2.34377219 15.5129649,2.96725648 15.6509154,3.62298994 C15.810089,4.34429676 15.6403038,5.0527039 15.1627829,5.66543845 L6.37639783,17.027902 C5.97315794,17.543889 5.37890967,17.8341317 4.74221511,17.8448814 L1.24039498,17.8878803 C1.04938661,17.8878803 0.890212963,17.7588836 0.847766658,17.5761382 L0.051898447,14.1254752 C-0.086052043,13.4912412 0.051898447,12.8355077 0.455138341,12.3302704 L6.68413354,4.26797368 C6.7902493,4.13897694 6.98125767,4.11855245 7.10859659,4.21422504 L9.7296559,6.29967247 C9.89944111,6.43941894 10.1328958,6.51466705 10.376962,6.48241786 C10.8969293,6.41791948 11.2471113,5.94493141 11.1940534,5.43969415 C11.1622187,5.18170065 11.0348798,4.96670607 10.8650945,4.80546013 C10.8120367,4.76246122 8.31831627,2.76301162 8.31831627,2.76301162 C8.15914263,2.63401488 8.1273079,2.39752084 8.25464681,2.23734988 L9.24152339,0.957057153 C10.1541189,-0.214663308 11.7458554,-0.322160598 13.0298561,0.699063657 Z"></path>
            </g>
    </g>
    </svg>''',
                                          height: 12,
                                          width: 12,
                                          color: customColors.primaryColor
                                              .withOpacity(.7)),
                                  Expanded(child: SizedBox()),
                                  GestureDetector(
                                    onTap: () => comment.editing
                                        ? null
                                        : showMore(
                                            customColors,
                                            context,
                                            MoreItems(children: [
                                              // (comment.commentUser !=
                                              //         widget.myId)
                                              1 == 1
                                                  ? SizedBox()
                                                  : Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                          edit();
                                                        },
                                                        child: CircBotton(
                                                          title: 'edit',
                                                          child: Center(
                                                            child: SvgPicture
                                                                .string(
                                                              '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                                                      <title>Iconly/Bold/Edit</title>
                                                      <g id="Iconly/Bold/Edit" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                                          <g id="Edit" transform="translate(3.000000, 3.000000)" fill="#000000" fill-rule="nonzero">
                                                              <path d="M16.989778,15.9532516 C17.5468857,15.9532516 18,16.412265 18,16.9766258 C18,17.5420615 17.5468857,18 16.989778,18 L16.989778,18 L11.2796888,18 C10.7225811,18 10.2694668,17.5420615 10.2694668,16.9766258 C10.2694668,16.412265 10.7225811,15.9532516 11.2796888,15.9532516 L11.2796888,15.9532516 Z M13.0298561,0.699063657 L14.5048652,1.87078412 C15.109725,2.34377219 15.5129649,2.96725648 15.6509154,3.62298994 C15.810089,4.34429676 15.6403038,5.0527039 15.1627829,5.66543845 L6.37639783,17.027902 C5.97315794,17.543889 5.37890967,17.8341317 4.74221511,17.8448814 L1.24039498,17.8878803 C1.04938661,17.8878803 0.890212963,17.7588836 0.847766658,17.5761382 L0.051898447,14.1254752 C-0.086052043,13.4912412 0.051898447,12.8355077 0.455138341,12.3302704 L6.68413354,4.26797368 C6.7902493,4.13897694 6.98125767,4.11855245 7.10859659,4.21422504 L9.7296559,6.29967247 C9.89944111,6.43941894 10.1328958,6.51466705 10.376962,6.48241786 C10.8969293,6.41791948 11.2471113,5.94493141 11.1940534,5.43969415 C11.1622187,5.18170065 11.0348798,4.96670607 10.8650945,4.80546013 C10.8120367,4.76246122 8.31831627,2.76301162 8.31831627,2.76301162 C8.15914263,2.63401488 8.1273079,2.39752084 8.25464681,2.23734988 L9.24152339,0.957057153 C10.1541189,-0.214663308 11.7458554,-0.322160598 13.0298561,0.699063657 Z"></path>
                                                          </g>
                                                      </g>
                                                  </svg>''',
                                                              color: customColors
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                              (comment.account.id.toString() !=
                                                      widget.myId.toString())
                                                  ? !widget.account.admin
                                                      ? SizedBox()
                                                      : Expanded(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                              delete();
                                                            },
                                                            child: CircBotton(
                                                              title: 'delete',
                                                              child: Center(
                                                                child:
                                                                    SvgPicture
                                                                        .string(
                                                                  '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                                                      <title>Iconly/Bold/Delete</title>
                                                      <g id="Iconly/Bold/Delete" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                                          <g id="Delete" transform="translate(3.000000, 2.000000)" fill="#000000" fill-rule="nonzero">
                                                              <path d="M15.9390642,6.69713303 C16.1384374,6.69713303 16.3193322,6.78413216 16.4622974,6.93113069 C16.5955371,7.08812912 16.6626432,7.28312717 16.6431921,7.48912511 C16.6431921,7.55712443 16.1102334,14.297057 15.8058245,17.1340287 C15.6152042,18.8750112 14.4928788,19.9320007 12.8093905,19.9610004 C11.5149233,19.9900001 10.2496326,20 9.00379295,20 C7.68112168,20 6.38762697,19.9900001 5.13206181,19.9610004 C3.50498163,19.9220008 2.3816836,18.8460115 2.20078885,17.1340287 C1.88762697,14.2870571 1.36439378,7.55712443 1.35466825,7.48912511 C1.34494273,7.28312717 1.41107629,7.08812912 1.54528852,6.93113069 C1.67755565,6.78413216 1.86817592,6.69713303 2.06852172,6.69713303 L15.9390642,6.69713303 Z M11.0647288,-2.48689958e-14 C11.9487789,-2.48689958e-14 12.7384915,0.61699383 12.9670413,1.49698503 L12.9670413,1.49698503 L13.1304301,2.22697773 C13.2626972,2.82197178 13.77815,3.24296757 14.371407,3.24296757 L14.371407,3.24296757 L17.2871191,3.24296757 C17.67614,3.24296757 18,3.56596434 18,3.97696023 L18,3.97696023 L18,4.35695643 C18,4.75795242 17.67614,5.09094909 17.2871191,5.09094909 L17.2871191,5.09094909 L0.713853469,5.09094909 C0.323859952,5.09094909 1.95399252e-14,4.75795242 1.95399252e-14,4.35695643 L1.95399252e-14,4.35695643 L1.95399252e-14,3.97696023 C1.95399252e-14,3.56596434 0.323859952,3.24296757 0.713853469,3.24296757 L0.713853469,3.24296757 L3.62956559,3.24296757 C4.22185001,3.24296757 4.73730279,2.82197178 4.87054247,2.22797772 L4.87054247,2.22797772 L5.0232332,1.54598454 C5.26053598,0.61699383 6.04149557,-2.48689958e-14 6.93527123,-2.48689958e-14 L6.93527123,-2.48689958e-14 Z"></path>
                                                          </g>
                                                      </g>
                                                  </svg>''',
                                                                  color: customColors
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                  : Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                          delete();
                                                        },
                                                        child: CircBotton(
                                                          title: 'delete',
                                                          child: Center(
                                                            child: SvgPicture
                                                                .string(
                                                              '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                                                      <title>Iconly/Bold/Delete</title>
                                                      <g id="Iconly/Bold/Delete" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                                          <g id="Delete" transform="translate(3.000000, 2.000000)" fill="#000000" fill-rule="nonzero">
                                                              <path d="M15.9390642,6.69713303 C16.1384374,6.69713303 16.3193322,6.78413216 16.4622974,6.93113069 C16.5955371,7.08812912 16.6626432,7.28312717 16.6431921,7.48912511 C16.6431921,7.55712443 16.1102334,14.297057 15.8058245,17.1340287 C15.6152042,18.8750112 14.4928788,19.9320007 12.8093905,19.9610004 C11.5149233,19.9900001 10.2496326,20 9.00379295,20 C7.68112168,20 6.38762697,19.9900001 5.13206181,19.9610004 C3.50498163,19.9220008 2.3816836,18.8460115 2.20078885,17.1340287 C1.88762697,14.2870571 1.36439378,7.55712443 1.35466825,7.48912511 C1.34494273,7.28312717 1.41107629,7.08812912 1.54528852,6.93113069 C1.67755565,6.78413216 1.86817592,6.69713303 2.06852172,6.69713303 L15.9390642,6.69713303 Z M11.0647288,-2.48689958e-14 C11.9487789,-2.48689958e-14 12.7384915,0.61699383 12.9670413,1.49698503 L12.9670413,1.49698503 L13.1304301,2.22697773 C13.2626972,2.82197178 13.77815,3.24296757 14.371407,3.24296757 L14.371407,3.24296757 L17.2871191,3.24296757 C17.67614,3.24296757 18,3.56596434 18,3.97696023 L18,3.97696023 L18,4.35695643 C18,4.75795242 17.67614,5.09094909 17.2871191,5.09094909 L17.2871191,5.09094909 L0.713853469,5.09094909 C0.323859952,5.09094909 1.95399252e-14,4.75795242 1.95399252e-14,4.35695643 L1.95399252e-14,4.35695643 L1.95399252e-14,3.97696023 C1.95399252e-14,3.56596434 0.323859952,3.24296757 0.713853469,3.24296757 L0.713853469,3.24296757 L3.62956559,3.24296757 C4.22185001,3.24296757 4.73730279,2.82197178 4.87054247,2.22797772 L4.87054247,2.22797772 L5.0232332,1.54598454 C5.26053598,0.61699383 6.04149557,-2.48689958e-14 6.93527123,-2.48689958e-14 L6.93527123,-2.48689958e-14 Z"></path>
                                                          </g>
                                                      </g>
                                                  </svg>''',
                                                              color: customColors
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                              (comment.account.id.toString() ==
                                                      widget.myId.toString())
                                                  ? SizedBox()
                                                  : Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                          report();
                                                        },
                                                        child: CircBotton(
                                                          title: 'report',
                                                          child: Center(
                                                            child: SvgPicture
                                                                .string(
                                                              '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                                                      <title>Iconly/Bold/Danger</title>
                                                      <g id="Iconly/Bold/Danger" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                                          <g id="Danger" transform="translate(2.000000, 3.000000)" fill="#000000" fill-rule="nonzero">
                                                              <path d="M8.6279014,0.353093862 C9.98767226,-0.400979673 11.7173808,0.0944694301 12.4772527,1.44209099 L12.4772527,1.44209099 L19.7460279,14.057216 C19.9060009,14.4337574 19.9759891,14.7399449 19.9959857,15.0580232 C20.035979,15.8011969 19.7760228,16.5235617 19.2661087,17.0794556 C18.7561947,17.6333677 18.0663109,17.9603641 17.3164373,18 L17.3164373,18 L2.67890388,18 C2.36895611,17.9811729 2.05900834,17.9108192 1.7690572,17.8018204 C0.319301497,17.2171904 -0.380580564,15.5722994 0.20932003,14.1463969 L0.20932003,14.1463969 L7.52808673,1.43317291 C7.77804461,0.986277815 8.15798058,0.600818413 8.6279014,0.353093862 Z M9.99767057,12.2726084 C9.51775145,12.2726084 9.11781884,12.6689677 9.11781884,13.1455897 C9.11781884,13.6202299 9.51775145,14.0175801 9.99767057,14.0175801 C10.4775897,14.0175801 10.867524,13.6202299 10.867524,13.1346898 C10.867524,12.6600496 10.4775897,12.2726084 9.99767057,12.2726084 Z M9.99767057,6.09039447 C9.51775145,6.09039447 9.11781884,6.47585387 9.11781884,6.95247591 L9.11781884,6.95247591 L9.11781884,9.75572693 C9.11781884,10.2313581 9.51775145,10.6287083 9.99767057,10.6287083 C10.4775897,10.6287083 10.867524,10.2313581 10.867524,9.75572693 L10.867524,9.75572693 L10.867524,6.95247591 C10.867524,6.47585387 10.4775897,6.09039447 9.99767057,6.09039447 Z"></path>
                                                          </g>
                                                      </g>
                                                  </svg>''',
                                                              color: customColors
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                            ])),
                                    child: Icon(
                                      Icons.more_horiz_outlined,
                                      color: customColors.primaryColor,
                                    ),
                                  )
                                ],
                              ),
                              !comment.fair
                                  ? GestureDetector(
                                      onDoubleTap: () => setState(() {
                                        comment.isLiked ? unLike() : like();
                                      }),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4.0,
                                        ),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            comment.commentCont,
                                            softWrap: true,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w200,
                                                fontFamily: "SFPro",
                                                color: customColors.primaryColor
                                                    .withOpacity(.99)),
                                          ),
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onDoubleTap: () => setState(() {
                                        comment.fair = false;
                                      }),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5.0,
                                          ),
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: customColors.iconTheme,
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: LocaleText(
                                                  "double_tap",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontFamily: "SFPro",
                                                      color: customColors
                                                          .primaryColor),
                                                ),
                                              ),
                                            ),
                                          )),
                                    ),
                              Row(
                                children: [
                                  Text(
                                    Jiffy(DateTime.parse(comment.commentTime))
                                        .from(DateTime.parse(comment.timeNow)),
                                    softWrap: true,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "SFPro",
                                        color: customColors.primaryColor
                                            .withOpacity(.7)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: widget.onTap,
                                    child: LocaleText(
                                      'reply',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "SFPro",
                                          color: customColors.primaryColor
                                              .withOpacity(.7)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      comment.isLiked ? unLike() : like(),
                                  child: SvgPicture.string(
                                      comment.isLiked
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
                                      height: 20,
                                      width: 20,
                                      color: comment.isLiked
                                          ? Colors.red
                                          : customColors.primaryColor
                                              .withOpacity(.5)),
                                ),
                                comment.likes == 0
                                    ? SizedBox()
                                    : SizedBox(
                                        height: 2,
                                      ),
                                comment.likes == 0
                                    ? SizedBox()
                                    : Text(
                                        '${comment.likes}',
                                        softWrap: true,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "SFPro",
                                            color: customColors.primaryColor
                                                .withOpacity(.5)),
                                      )
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: context.currentLocale!.languageCode == "ar"
                                ? 65
                                : 15,
                            left: context.currentLocale!.languageCode == "ar"
                                ? 15
                                : 65),
                        child: Column(
                          children: [
                            (comment.repliesCountFinal == 0 &&
                                    comment.replies.isEmpty)
                                ? SizedBox()
                                : !comment.showReplies
                                    ? SizedBox()
                                    : ReplyCard(
                                        account: widget.account,
                                        controller: widget.controller,
                                        myId: widget.myId,
                                        pageId: widget.pageId,
                                        comment: comment.replies,
                                        onTap: widget.onTap,
                                      ),
                            (comment.repliesCountFinal == 0 &&
                                    comment.replies.isEmpty)
                                ? SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        Center(
                                          child: SizedBox(
                                            width: 30,
                                            child: Divider(
                                              height: 3,
                                              color: customColors.primaryColor
                                                  .withOpacity(.7),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        GestureDetector(
                                          onTap: comment.done
                                              ? () => setState(() {
                                                    comment.showReplies =
                                                        comment.showReplies
                                                            ? false
                                                            : true;
                                                    if (!comment.showReplies) {
                                                      scrollController.jumpTo(
                                                          widget.index
                                                              .toDouble());
                                                    }
                                                  })
                                              : widget.addReply,
                                          child: Text(
                                            (comment.replies.length ==
                                                        comment
                                                            .repliesCountFinal &&
                                                    comment.showReplies &&
                                                    comment.done)
                                                ? context.localeString(
                                                    "hide_replies")
                                                : comment.replies.length ==
                                                            comment
                                                                .repliesCountFinal &&
                                                        !comment.showReplies &&
                                                        comment.done
                                                    ? context.localeString(
                                                        "see_more")
                                                    : comment.replyLoading
                                                        ? context.localeString(
                                                            "loaging")
                                                        : comment.repliesCountFinal ==
                                                                1
                                                            ? "${context.localeString('view')} ${context.localeString('reply')}"
                                                            : "${context.localeString('viewall')} ${comment.repliesCountFinal - comment.replies.length} ${context.localeString('replies')}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 10,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              fontFamily: 'SFPro',
                                              fontWeight: FontWeight.w500,
                                              color: customColors.primaryColor
                                                  .withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
  }
}

class ReplyCard extends StatefulWidget {
  const ReplyCard({
    Key? key,
    required this.comment,
    required this.onTap,
    required this.pageId,
    required this.myId,
    required this.controller,
    required this.account,
  }) : super(key: key);
  final UserProfial account;
  final List<PostsComments> comment;
  final GestureTapCallback onTap;
  final int pageId;
  final int myId;
  final TextEditingController controller;
  @override
  State<ReplyCard> createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    return Column(
        children: List.generate(
      widget.comment.length,
      (index) {
        like() async {
          setState(() {
            widget.comment[index].isLiked = true;
            widget.comment[index].likes++;
          });
          final response = await http.post(
              Uri.parse(
                like_comments_posts,
              ),
              body: {
                "user_id": '${widget.myId}',
                "comment_user": '${widget.comment[index].account.id}',
                "comment_id": '${widget.comment[index].commentId}',
                "post_id": '${widget.pageId}',
              }).catchError((e) {
            setState(() {
              widget.comment[index].isLiked = false;
              widget.comment[index].likes--;
            });
          });
          final data = jsonDecode(response.body);
          print(data);
          if (data['status'] == "success") {
            setState(() {});

            return true;
          } else {
            setState(() {
              widget.comment[index].isLiked = false;
              widget.comment[index].likes--;
            });
            return false;
          }
        }

        unLike() async {
          setState(() {
            widget.comment[index].isLiked = false;
            widget.comment[index].likes--;
          });

          final response = await http.post(
              Uri.parse(
                un_like_comments_posts,
              ),
              body: {
                "user_id": '${widget.myId}',
                "comment_id": '${widget.comment[index].commentId}',
              }).catchError((e) {
            setState(() {
              widget.comment[index].isLiked = true;
              widget.comment[index].likes++;
            });
          });
          final data = jsonDecode(response.body);
          print(data);
          if (data['status'] == "success") {
            setState(() {});
            return true;
          } else {
            setState(() {
              widget.comment[index].isLiked = true;
              widget.comment[index].likes++;
            });
            return false;
          }
        }

        delete() async {
          setState(() {
            widget.comment[index].editing = true;
          });

          final response = await http.post(
              Uri.parse(
                delete_comments_post,
              ),
              body: {
                "post_id": '${widget.pageId}',
                "comment_id": '${widget.comment[index].commentId}',
              }).catchError((e) {
            setState(() {
              widget.comment[index].editing = false;
            });
          });
          print(response.body);
          final data = jsonDecode(response.body);

          if (data['status'] == "success") {
            setState(() {
              widget.comment[index].editing = false;
              widget.comment[index].hasDeleted = true;
            });
            return true;
          } else {
            setState(() {
              widget.comment[index].editing = false;
            });
            return false;
          }
        }

        edit() async {
          PostCommentsPageState.edit = true;
          await showDialog(
              context: context,
              builder: (context) {
                CustomColors customColors = CustomColors(context);

                return Dialog(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextField(
                              // enabled: !PostCommentsPageState.edit,
                              // autofocus: true,
                              controller: widget.controller,
                              maxLines: 5,
                              onChanged: (value) => setState(() {}),
                              onEditingComplete: (widget
                                      .controller.text.isEmpty)
                                  ? () {
                                      Navigator.pop(context);
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    }
                                  : () async {
                                      setState(() {
                                        widget.comment[index].editing = true;
                                        PostCommentsPageState.edit = true;
                                      });
                                      final response = await http.post(
                                          Uri.parse(
                                            edit_comment,
                                          ),
                                          body: {
                                            "comment_cont":
                                                '${widget.controller.text}',
                                            "comment_id":
                                                '${widget.comment[index].commentId}',
                                            "fire":
                                                PostCommentsPageState.isFire ==
                                                        false
                                                    ? "0"
                                                    : "1",
                                          }).catchError((e) {
                                        setState(() {
                                          PostCommentsPageState.edit = false;
                                          widget.comment[index].editing = false;
                                        });
                                      });
                                      final data = jsonDecode(response.body);
                                      print(data);
                                      if (data['status'] == "success") {
                                        setState(() {
                                          PostCommentsPageState.edit = false;
                                          widget.comment[index].editing = false;
                                          Navigator.pop(context);
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                        });
                                      } else {
                                        setState(() {
                                          widget.controller.clear();
                                          PostCommentsPageState.edit = false;
                                          widget.comment[index].editing = false;
                                        });
                                      }
                                      setState(() {
                                        PostCommentsPageState.edit = false;
                                        widget.comment[index].editing = false;
                                      });
                                    },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: context.localeString('edit'),
                                hintStyle: TextStyle(
                                  fontFamily: 'SFPro',
                                  color: customColors.primaryColor
                                      .withOpacity(0.6),
                                ),
                              ),
                              minLines: 1,

                              // expands: true,
                              textAlignVertical: TextAlignVertical.center,

                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.send,

                              maxLength:
                                  widget.controller.text.isEmpty ? null : 150,

                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
          setState(() {
            widget.comment[index].editing = false;
          });
        }

        report() async {
          setState(() {
            widget.comment[index].editing = true;
          });

          final response = await http.post(
              Uri.parse(
                report_comments_posts,
              ),
              body: {
                "user_id": '${widget.myId}',
                "comment_id": '${widget.comment[index].commentId}',
              }).catchError((e) {
            setState(() {
              widget.comment[index].editing = false;
            });
          });
          var data;
          try {
            data = jsonDecode(response.body);
          } catch (e) {
            data = {"status": "hi"};
          }
          if (data['status'] == "success") {
            setState(() {
              widget.comment[index].editing = false;
            });
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      backgroundColor: Colors.transparent,
                      content: Container(
                        //height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: customColors.backgroundColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  child: SvgPicture.string(
                                    '<?xml version="1.0" encoding="UTF-8"?> <svg xmlns="http://www.w3.org/2000/svg" id="Слой_1" data-name="Слой 1" viewBox="0 0 783 783"><path d="M911,170.5a362.21,362.21,0,1,1-141.48,28.55A361.31,361.31,0,0,1,911,170.5m0-28c-216.22,0-391.5,175.28-391.5,391.5S694.78,925.5,911,925.5,1302.5,750.22,1302.5,534,1127.22,142.5,911,142.5Z" transform="translate(-519.5 -142.5)"></path><path d="M651.5,487.5a363.14,363.14,0,0,1,34.75,16.12c11.35,5.91,22.43,12.3,33.34,19s21.61,13.63,32.17,20.8c5.29,3.57,10.49,7.25,15.71,10.92l7.75,5.6c2.59,1.86,5.18,3.73,7.72,5.64,20.48,15.16,40.38,31.05,59.83,47.44l14.48,12.42c4.8,4.18,9.55,8.4,14.31,12.63s9.44,8.54,14.14,12.86l7,6.52c2.35,2.22,4.6,4.35,7.06,6.74l-50.45,6.8,3.27-7.16c1-2.28,2.13-4.51,3.22-6.73,2.19-4.44,4.36-8.86,6.66-13.2s4.6-8.66,7-13,4.82-8.52,7.28-12.75Q891.62,592.86,908.8,569c11.5-15.87,23.72-31.27,36.77-46a528.87,528.87,0,0,1,41.74-42.18,429.2,429.2,0,0,1,47.08-36.94,342.92,342.92,0,0,1,52.66-29.4,259.29,259.29,0,0,1,57.55-18.23c4.94-.93,9.91-1.68,14.88-2.23s10-1,14.94-1.1c2.48-.1,5-.12,7.44-.13s5,.12,7.43.23A136.28,136.28,0,0,1,1204,394.5c-4.46,2.1-8.83,4.19-13.12,6.31l-3.2,1.6-3.16,1.65c-2.1,1.08-4.19,2.16-6.24,3.31q-12.36,6.76-23.84,14.2a437.23,437.23,0,0,0-43.34,32.19c-27.31,22.92-52.11,48.31-75.82,75q-17.76,20-34.66,41T967.35,612.2Q951,633.79,935.22,655.94q-4,5.52-7.86,11.09c-2.62,3.7-5.23,7.4-7.79,11.12s-5.16,7.42-7.66,11.14l-7.26,10.77-24.78,36.77-25.67-30L842.3,693l-12.16-14-12.25-14-12.29-14q-24.66-27.9-49.71-55.54c-16.74-18.4-33.61-36.73-50.9-54.75-8.64-9-17.33-18-26.25-26.88S660.77,496.28,651.5,487.5Z" transform="translate(-519.5 -142.5)"></path></svg>',
                                    height: 50,
                                    width: 50,
                                    color: customColors.bottomDown,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                LocaleText(
                                  'thax_report',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: customColors.primaryColor,
                                    //   fontFamily: 'SFPro',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Divider(
                                  height: 1,
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: LocaleText(
                                      'close',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: customColors.primaryColor
                                            .withOpacity(.6),
                                        //   fontFamily: 'SFPro',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                        ),
                      ));
                });
            return true;
          } else {
            setState(() {
              widget.comment[index].editing = false;
            });
            return false;
          }
        }

        final avatar =
            widget.comment[index].account.avatar.toString().startsWith('http')
                ? widget.comment[index].account.avatar
                : image + widget.comment[index].account.avatar;
        if (widget.account.userName != widget.comment[index].account.userName) {
          CachedNetworkImage.evictFromCache(
              widget.comment[index].account.avatar);
        }

        return (widget.comment[index].hasDeleted)
            ? SizedBox()
            : widget.comment[index].editing
                ? LoadingGif(
                    logo: true,
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfialPage(
                                              id: int.parse(widget
                                                  .comment[index].account.id),
                                              isMyProfile: false,
                                              myId: widget.myId)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 5),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        height: 30,
                                        width: 30,
                                        errorWidget: (context, url, error) =>
                                            SizedBox(),
                                        key: UniqueKey(),
                                        imageUrl: avatar,
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              ),
                              Expanded(
                                  child: Column(children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    right:
                                        context.currentLocale!.languageCode ==
                                                "ar"
                                            ? 10
                                            : 0,
                                    left: context.currentLocale!.languageCode ==
                                            "ar"
                                        ? 0
                                        : 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.comment[index].account.userName
                                            .toLowerCase(),
                                        softWrap: true,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "SFPro",
                                            color: customColors.primaryColor
                                                .withOpacity(.9)),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      !widget.comment[index].account.admin
                                          ? SizedBox()
                                          : SvgPicture.string(
                                              '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Light/Star</title>
    <g id="Iconly/Light/Star" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round">
        <g id="Star" transform="translate(3.000000, 3.500000)" stroke="#000000" stroke-width="1.5">
            <path d="M10.1042564,0.67700614 L11.9316681,4.32775597 C12.1107648,4.68615589 12.4564632,4.93467388 12.8573484,4.99218218 L16.9453359,5.58061527 C17.9553583,5.72643988 18.3572847,6.95054503 17.6263201,7.65194084 L14.6701824,10.4924399 C14.3796708,10.7717659 14.2474307,11.173297 14.3161539,11.5676396 L15.0137982,15.5778163 C15.1856062,16.5698344 14.1297683,17.3266846 13.2269958,16.8573759 L9.57321374,14.9626829 C9.21502023,14.7768079 8.78602103,14.7768079 8.42678626,14.9626829 L4.77300425,16.8573759 C3.87023166,17.3266846 2.81439382,16.5698344 2.98724301,15.5778163 L3.68384608,11.5676396 C3.75256926,11.173297 3.62032921,10.7717659 3.32981762,10.4924399 L0.373679928,7.65194084 C-0.357284727,6.95054503 0.0446417073,5.72643988 1.05466409,5.58061527 L5.14265161,4.99218218 C5.54353679,4.93467388 5.89027643,4.68615589 6.06937319,4.32775597 L7.89574356,0.67700614 C8.34765049,-0.225668713 9.65234951,-0.225668713 10.1042564,0.67700614 Z" id="Stroke-1"></path>
        </g>
    </g>
</svg>''',
                                              height: 12,
                                              width: 12,
                                              color: Color.fromARGB(
                                                  255, 218, 197, 12)),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      !widget.comment[index].isEdited
                                          ? SizedBox()
                                          : SvgPicture.string(
                                              '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
        <title>Iconly/Bold/Edit</title>
        <g id="Iconly/Bold/Edit" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                <g id="Edit" transform="translate(3.000000, 3.000000)" fill="#000000" fill-rule="nonzero">
                    <path d="M16.989778,15.9532516 C17.5468857,15.9532516 18,16.412265 18,16.9766258 C18,17.5420615 17.5468857,18 16.989778,18 L16.989778,18 L11.2796888,18 C10.7225811,18 10.2694668,17.5420615 10.2694668,16.9766258 C10.2694668,16.412265 10.7225811,15.9532516 11.2796888,15.9532516 L11.2796888,15.9532516 Z M13.0298561,0.699063657 L14.5048652,1.87078412 C15.109725,2.34377219 15.5129649,2.96725648 15.6509154,3.62298994 C15.810089,4.34429676 15.6403038,5.0527039 15.1627829,5.66543845 L6.37639783,17.027902 C5.97315794,17.543889 5.37890967,17.8341317 4.74221511,17.8448814 L1.24039498,17.8878803 C1.04938661,17.8878803 0.890212963,17.7588836 0.847766658,17.5761382 L0.051898447,14.1254752 C-0.086052043,13.4912412 0.051898447,12.8355077 0.455138341,12.3302704 L6.68413354,4.26797368 C6.7902493,4.13897694 6.98125767,4.11855245 7.10859659,4.21422504 L9.7296559,6.29967247 C9.89944111,6.43941894 10.1328958,6.51466705 10.376962,6.48241786 C10.8969293,6.41791948 11.2471113,5.94493141 11.1940534,5.43969415 C11.1622187,5.18170065 11.0348798,4.96670607 10.8650945,4.80546013 C10.8120367,4.76246122 8.31831627,2.76301162 8.31831627,2.76301162 C8.15914263,2.63401488 8.1273079,2.39752084 8.25464681,2.23734988 L9.24152339,0.957057153 C10.1541189,-0.214663308 11.7458554,-0.322160598 13.0298561,0.699063657 Z"></path>
                </g>
        </g>
      </svg>''',
                                              height: 12,
                                              width: 12,
                                              color: customColors.primaryColor
                                                  .withOpacity(.7)),
                                      Expanded(child: SizedBox()),
                                      SizedBox(
                                        width: 40,
                                        child: GestureDetector(
                                          onTap: () => widget
                                                  .comment[index].editing
                                              ? null
                                              : showMore(
                                                  customColors,
                                                  context,
                                                  MoreItems(children: [
                                                    // (widget.comment[index]
                                                    //             .commentUser !=
                                                    //         widget.myId)&&
                                                    1 == 1
                                                        ? SizedBox()
                                                        : GestureDetector(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                              edit();
                                                            },
                                                            child: CircBotton(
                                                              title: 'edit',
                                                              child: Center(
                                                                child:
                                                                    SvgPicture
                                                                        .string(
                                                                  '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Bold/Edit</title>
    <g id="Iconly/Bold/Edit" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
        <g id="Edit" transform="translate(3.000000, 3.000000)" fill="#000000" fill-rule="nonzero">
            <path d="M16.989778,15.9532516 C17.5468857,15.9532516 18,16.412265 18,16.9766258 C18,17.5420615 17.5468857,18 16.989778,18 L16.989778,18 L11.2796888,18 C10.7225811,18 10.2694668,17.5420615 10.2694668,16.9766258 C10.2694668,16.412265 10.7225811,15.9532516 11.2796888,15.9532516 L11.2796888,15.9532516 Z M13.0298561,0.699063657 L14.5048652,1.87078412 C15.109725,2.34377219 15.5129649,2.96725648 15.6509154,3.62298994 C15.810089,4.34429676 15.6403038,5.0527039 15.1627829,5.66543845 L6.37639783,17.027902 C5.97315794,17.543889 5.37890967,17.8341317 4.74221511,17.8448814 L1.24039498,17.8878803 C1.04938661,17.8878803 0.890212963,17.7588836 0.847766658,17.5761382 L0.051898447,14.1254752 C-0.086052043,13.4912412 0.051898447,12.8355077 0.455138341,12.3302704 L6.68413354,4.26797368 C6.7902493,4.13897694 6.98125767,4.11855245 7.10859659,4.21422504 L9.7296559,6.29967247 C9.89944111,6.43941894 10.1328958,6.51466705 10.376962,6.48241786 C10.8969293,6.41791948 11.2471113,5.94493141 11.1940534,5.43969415 C11.1622187,5.18170065 11.0348798,4.96670607 10.8650945,4.80546013 C10.8120367,4.76246122 8.31831627,2.76301162 8.31831627,2.76301162 C8.15914263,2.63401488 8.1273079,2.39752084 8.25464681,2.23734988 L9.24152339,0.957057153 C10.1541189,-0.214663308 11.7458554,-0.322160598 13.0298561,0.699063657 Z"></path>
        </g>
    </g>
</svg>''',
                                                                  color: customColors
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                    (widget.comment[index]
                                                                .account.id
                                                                .toString() !=
                                                            widget.myId
                                                                .toString())
                                                        ? !widget.account.admin
                                                            ? SizedBox()
                                                            : Expanded(
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    delete();
                                                                  },
                                                                  child:
                                                                      CircBotton(
                                                                    title:
                                                                        'delete',
                                                                    child:
                                                                        Center(
                                                                      child: SvgPicture
                                                                          .string(
                                                                        '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                                                            <title>Iconly/Bold/Delete</title>
                                                            <g id="Iconly/Bold/Delete" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                                                <g id="Delete" transform="translate(3.000000, 2.000000)" fill="#000000" fill-rule="nonzero">
                                                                    <path d="M15.9390642,6.69713303 C16.1384374,6.69713303 16.3193322,6.78413216 16.4622974,6.93113069 C16.5955371,7.08812912 16.6626432,7.28312717 16.6431921,7.48912511 C16.6431921,7.55712443 16.1102334,14.297057 15.8058245,17.1340287 C15.6152042,18.8750112 14.4928788,19.9320007 12.8093905,19.9610004 C11.5149233,19.9900001 10.2496326,20 9.00379295,20 C7.68112168,20 6.38762697,19.9900001 5.13206181,19.9610004 C3.50498163,19.9220008 2.3816836,18.8460115 2.20078885,17.1340287 C1.88762697,14.2870571 1.36439378,7.55712443 1.35466825,7.48912511 C1.34494273,7.28312717 1.41107629,7.08812912 1.54528852,6.93113069 C1.67755565,6.78413216 1.86817592,6.69713303 2.06852172,6.69713303 L15.9390642,6.69713303 Z M11.0647288,-2.48689958e-14 C11.9487789,-2.48689958e-14 12.7384915,0.61699383 12.9670413,1.49698503 L12.9670413,1.49698503 L13.1304301,2.22697773 C13.2626972,2.82197178 13.77815,3.24296757 14.371407,3.24296757 L14.371407,3.24296757 L17.2871191,3.24296757 C17.67614,3.24296757 18,3.56596434 18,3.97696023 L18,3.97696023 L18,4.35695643 C18,4.75795242 17.67614,5.09094909 17.2871191,5.09094909 L17.2871191,5.09094909 L0.713853469,5.09094909 C0.323859952,5.09094909 1.95399252e-14,4.75795242 1.95399252e-14,4.35695643 L1.95399252e-14,4.35695643 L1.95399252e-14,3.97696023 C1.95399252e-14,3.56596434 0.323859952,3.24296757 0.713853469,3.24296757 L0.713853469,3.24296757 L3.62956559,3.24296757 C4.22185001,3.24296757 4.73730279,2.82197178 4.87054247,2.22797772 L4.87054247,2.22797772 L5.0232332,1.54598454 C5.26053598,0.61699383 6.04149557,-2.48689958e-14 6.93527123,-2.48689958e-14 L6.93527123,-2.48689958e-14 Z"></path>
                                                                </g>
                                                            </g>
                                                        </svg>''',
                                                                        color: customColors
                                                                            .primaryColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                        : Expanded(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                                delete();
                                                              },
                                                              child: CircBotton(
                                                                title: 'delete',
                                                                child: Center(
                                                                  child:
                                                                      SvgPicture
                                                                          .string(
                                                                    '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                                                            <title>Iconly/Bold/Delete</title>
                                                            <g id="Iconly/Bold/Delete" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                                                <g id="Delete" transform="translate(3.000000, 2.000000)" fill="#000000" fill-rule="nonzero">
                                                                    <path d="M15.9390642,6.69713303 C16.1384374,6.69713303 16.3193322,6.78413216 16.4622974,6.93113069 C16.5955371,7.08812912 16.6626432,7.28312717 16.6431921,7.48912511 C16.6431921,7.55712443 16.1102334,14.297057 15.8058245,17.1340287 C15.6152042,18.8750112 14.4928788,19.9320007 12.8093905,19.9610004 C11.5149233,19.9900001 10.2496326,20 9.00379295,20 C7.68112168,20 6.38762697,19.9900001 5.13206181,19.9610004 C3.50498163,19.9220008 2.3816836,18.8460115 2.20078885,17.1340287 C1.88762697,14.2870571 1.36439378,7.55712443 1.35466825,7.48912511 C1.34494273,7.28312717 1.41107629,7.08812912 1.54528852,6.93113069 C1.67755565,6.78413216 1.86817592,6.69713303 2.06852172,6.69713303 L15.9390642,6.69713303 Z M11.0647288,-2.48689958e-14 C11.9487789,-2.48689958e-14 12.7384915,0.61699383 12.9670413,1.49698503 L12.9670413,1.49698503 L13.1304301,2.22697773 C13.2626972,2.82197178 13.77815,3.24296757 14.371407,3.24296757 L14.371407,3.24296757 L17.2871191,3.24296757 C17.67614,3.24296757 18,3.56596434 18,3.97696023 L18,3.97696023 L18,4.35695643 C18,4.75795242 17.67614,5.09094909 17.2871191,5.09094909 L17.2871191,5.09094909 L0.713853469,5.09094909 C0.323859952,5.09094909 1.95399252e-14,4.75795242 1.95399252e-14,4.35695643 L1.95399252e-14,4.35695643 L1.95399252e-14,3.97696023 C1.95399252e-14,3.56596434 0.323859952,3.24296757 0.713853469,3.24296757 L0.713853469,3.24296757 L3.62956559,3.24296757 C4.22185001,3.24296757 4.73730279,2.82197178 4.87054247,2.22797772 L4.87054247,2.22797772 L5.0232332,1.54598454 C5.26053598,0.61699383 6.04149557,-2.48689958e-14 6.93527123,-2.48689958e-14 L6.93527123,-2.48689958e-14 Z"></path>
                                                                </g>
                                                            </g>
                                                        </svg>''',
                                                                    color: customColors
                                                                        .primaryColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                    (widget.comment[index]
                                                                .account.id
                                                                .toString() ==
                                                            widget.myId
                                                                .toString())
                                                        ? SizedBox()
                                                        : Expanded(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                                report();
                                                              },
                                                              child: CircBotton(
                                                                title: 'report',
                                                                child: Center(
                                                                  child:
                                                                      SvgPicture
                                                                          .string(
                                                                    '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                                                        <title>Iconly/Bold/Danger</title>
                                                        <g id="Iconly/Bold/Danger" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                                            <g id="Danger" transform="translate(2.000000, 3.000000)" fill="#000000" fill-rule="nonzero">
                                                                <path d="M8.6279014,0.353093862 C9.98767226,-0.400979673 11.7173808,0.0944694301 12.4772527,1.44209099 L12.4772527,1.44209099 L19.7460279,14.057216 C19.9060009,14.4337574 19.9759891,14.7399449 19.9959857,15.0580232 C20.035979,15.8011969 19.7760228,16.5235617 19.2661087,17.0794556 C18.7561947,17.6333677 18.0663109,17.9603641 17.3164373,18 L17.3164373,18 L2.67890388,18 C2.36895611,17.9811729 2.05900834,17.9108192 1.7690572,17.8018204 C0.319301497,17.2171904 -0.380580564,15.5722994 0.20932003,14.1463969 L0.20932003,14.1463969 L7.52808673,1.43317291 C7.77804461,0.986277815 8.15798058,0.600818413 8.6279014,0.353093862 Z M9.99767057,12.2726084 C9.51775145,12.2726084 9.11781884,12.6689677 9.11781884,13.1455897 C9.11781884,13.6202299 9.51775145,14.0175801 9.99767057,14.0175801 C10.4775897,14.0175801 10.867524,13.6202299 10.867524,13.1346898 C10.867524,12.6600496 10.4775897,12.2726084 9.99767057,12.2726084 Z M9.99767057,6.09039447 C9.51775145,6.09039447 9.11781884,6.47585387 9.11781884,6.95247591 L9.11781884,6.95247591 L9.11781884,9.75572693 C9.11781884,10.2313581 9.51775145,10.6287083 9.99767057,10.6287083 C10.4775897,10.6287083 10.867524,10.2313581 10.867524,9.75572693 L10.867524,9.75572693 L10.867524,6.95247591 C10.867524,6.47585387 10.4775897,6.09039447 9.99767057,6.09039447 Z"></path>
                                                            </g>
                                                        </g>
                                                    </svg>''',
                                                                    color: customColors
                                                                        .primaryColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                  ])),
                                          child: Icon(
                                            Icons.more_horiz_outlined,
                                            color: customColors.primaryColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                !widget.comment[index].fair
                                    ? GestureDetector(
                                        onDoubleTap: () => setState(() {
                                          widget.comment[index].isLiked
                                              ? unLike()
                                              : like();
                                        }),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 4.0,
                                          ),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              widget.comment[index].commentCont,
                                              softWrap: true,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w200,
                                                  fontFamily: "SFPro",
                                                  color: customColors
                                                      .primaryColor
                                                      .withOpacity(.99)),
                                            ),
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onDoubleTap: () => setState(() {
                                          widget.comment[index].fair = false;
                                        }),
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5.0,
                                            ),
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: customColors.iconTheme,
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: LocaleText(
                                                    "double_tap",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        fontFamily: "SFPro",
                                                        color: customColors
                                                            .primaryColor),
                                                  ),
                                                ),
                                              ),
                                            )),
                                      ),
                                Row(
                                  children: [
                                    Text(
                                      Jiffy(DateTime.parse(widget
                                              .comment[index].commentTime))
                                          .from(DateTime.parse(
                                              widget.comment[index].timeNow)),
                                      softWrap: true,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "SFPro",
                                          color: customColors.primaryColor
                                              .withOpacity(.7)),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: widget.onTap,
                                      child: LocaleText(
                                        'reply',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "SFPro",
                                            color: customColors.primaryColor
                                                .withOpacity(.7)),
                                      ),
                                    ),
                                  ],
                                )
                              ])),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 15,
                                  right: context.currentLocale!.languageCode ==
                                          "ar"
                                      ? 8
                                      : 0,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () => widget.comment[index].isLiked
                                          ? unLike()
                                          : like(),
                                      child: SvgPicture.string(
                                          widget.comment[index].isLiked
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
                                          height: 20,
                                          width: 20,
                                          color: widget.comment[index].isLiked
                                              ? Colors.red
                                              : customColors.primaryColor
                                                  .withOpacity(.5)),
                                    ),
                                    widget.comment[index].likes == 0
                                        ? SizedBox()
                                        : SizedBox(
                                            height: 2,
                                          ),
                                    widget.comment[index].likes == 0
                                        ? SizedBox()
                                        : Text(
                                            '${widget.comment[index].likes}',
                                            softWrap: true,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "SFPro",
                                                color: customColors.primaryColor
                                                    .withOpacity(.5)),
                                          )
                                  ],
                                ),
                              )
                            ]),
                      ],
                    ),
                  );
      },
    ));
  }
}
