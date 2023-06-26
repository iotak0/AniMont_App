// import 'package:camera/camera.dart';
// import 'package:chatapp/CustomUI/CameraUI.dart';
import 'package:anime_mont_test/Screens/settings/circleBotton.dart';
import 'package:anime_mont_test/Screens/settings/more_items.dart';
import 'package:anime_mont_test/Screens/settings/show_more_widget.dart';
import 'package:anime_mont_test/helper/constans.dart';
import 'package:anime_mont_test/models/get_x_controller.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/provider/user_model.dart';
import 'package:anime_mont_test/server/Chat-Server-master/lib/CustomUI/ReplyCard.dart';
import 'package:anime_mont_test/server/Chat-Server-master/lib/Model/MessageModel.dart';
import 'package:anime_mont_test/server/Chat-Server-master/lib/Model/replyModel.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:anime_mont_test/widgets/cust_snak_bar.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:swipe_to/swipe_to.dart';

class IndividualPage extends StatefulWidget {
  IndividualPage({
    Key? key,
  }) : super(key: key);

  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;
  List<MessageModel> messages = [];
  TextEditingController _controller = TextEditingController();
  late ScrollController _scrollController;
  IO.Socket? socket;
  final int _maxLength = 15;
  bool isLoading = true;
  bool hasErorr = false;
  bool hasMore = true;
  bool done = false;
  int page = 1;
  UserProfial? account;
  SharedPreferences? prefs;
  ChatGetX chatGetX = ChatGetX();
  bool maxScroll = false;
  bool typing = false;
  bool isReply = false;
  String? theme;
  var reply;
  getMessages() async {
    // setState(() {
    //   isLoading = true;
    //   hasErorr = false;
    // });
    prefs = await SharedPreferences.getInstance();
    String? userPref = prefs!.getString('userData');
    final body = json.decode(userPref!);
    account = UserProfial.fromJson(body);
    theme = prefs!.getString('theme');
    setState(() {});
    await http
        .get(Uri.parse('${messages_link}chat?page=${page.toString()}}'))
        .catchError((error) {
      isLoading = false;
      hasErorr = true;
      setState(() {});
    }).then((value) async {
      if (value.statusCode == 200) {
        var data;
        print(value.body);
        try {
          data = jsonDecode(value.body);
        } catch (e) {
          setState(() {
            isLoading = false;
            done = true;
          });
        }

        data.isNotEmpty ? page++ : page;

        for (var e in data) {
          chatGetX.messageList.add(MessageModel(
              e['id'],
              e['userId'],
              e['userName'].toString(),
              e['name'].toString(),
              e['message'].toString(),
              e['avatar'].toString(),
              e['admin'],
              e['reply'] == null ? null : Reply.fromJson(e['reply']),
              e['time']));
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
      isLoading = false;
      setState(() {});

      done = true;
      isLoading = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    setState(() {
      isLoading = true;
    });

    _scrollController.addListener(() {
      if (_scrollController.position.minScrollExtent ==
          _scrollController.offset) {
        setState(() {
          maxScroll = true;
        });
      } else
        setState(() {
          maxScroll = false;
        });
    });
    super.initState();
    getMessages();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });

    connect();
  }

  void connect() async {
    // MessageModel messageModel = MessageModel(sourceId: widget.sourceChat.id.toString(),targetId: );
    socket = IO.io(
        messages_link,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    setState(() {});
    socket!.connect();
    print(socket!.connected);

    socket!.on("message-r", (message) async {
      chatGetX.messageList.add(MessageModel(
          message['id'],
          message['userId'],
          message['userName'].toString(),
          message['name'].toString(),
          message['message'].toString(),
          message['avatar'].toString(),
          message['admin'],
          message['reply'] == null ? null : Reply.fromJson(message['reply']),
          message['time']));
      try {
        //await Duration(seconds: 1);
        //_scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        _scrollController.animateTo(_scrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      } catch (e) {}
    });
    socket!.on("connected-user", (msg) {
      chatGetX.connectedUser.value = msg;
    });

    socket!.on("delete-message-r", (id) {
      chatGetX.messageList.removeWhere((element) => element.id == id);
    });
    socket!.on('clear-chat-r', (deleted) async {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustSnackBar(
            color: Colors.green,
            image: danger,
            headLine: context.localeString("chat_has_been_cleaned_up"),
            erorr: context.localeString("a_moderator_has_cleaned_the_chat")),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
      reply = null;
      isReply = false;
      setState(() {});
      chatGetX.messageList.clear();
    });

    _controller.addListener(() {
      if (_controller.text.isNotEmpty) {
        if (!typing) {
          socket!.emit("typing", {'type': true, "id": socket!.id});
        }
        typing = true;
      } else {
        if (typing) {
          socket!.emit("typing", {'type': false, "id": socket!.id});
          chatGetX.typingUsers.value++;
        }
        typing = false;
      }
    });
    socket!.on("typing-r", (msg) {
      chatGetX.typingUsers.value = msg['type'];
      if (typing) {
        chatGetX.typingUsers.value--;
      }
    });

    socket!.on("block-user-r", (id) {
      if (id['userId'].toString().contains(account!.id.toString())) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: CustSnackBar(
              color: Color(0xFFC72C41),
              image: danger,
              headLine: context.localeString("you_have_been_banned"),
              erorr: context.localeString("your_account_is_banned")),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ));
      }
    });
  }

  void blockUser(int id, String userName, String avatar) {
    socket!.emit(
        "block-user", {"userId": id, "userName": userName, "avatar": avatar});
  }

  deleteMessage(messageId) {
    socket!.emit(
      "delete-message",
      messageId,
      // "userId": message.userId,
      // "name": message.name,
      // "userName": message.userName,
      // "message": message.message,
      // "avatar": message.avatar,
      // 'admin': message.admin,
      // 'reply': message.reply
    );
  }

  clearChat() {
    socket!.emit(
      "clear-chat",
    );
  }

  void unBlockUser(int id, String userName, String avatar) {
    socket!.emit(
        "block-user", {"userId": id, "userName": userName, "avatar": avatar});
  }

  void unBlockAllUser() {
    socket!.emit("block-all-user");
  }

  void sendMessage(message) {
    // setMessage({
    //   "id": 1,
    //   "userId": int.parse(account!.id),
    //   "name": account!.name,
    //   "userName": account!.userName,
    //   "message": message,
    //   "avatar": account!.avatar,
    //   'admin': account!.admin,
    // });
    socket!.emit("message", {
      "id": 1,
      "userId": int.parse(account!.id),
      "name": account!.name,
      "userName": account!.userName,
      "message": message,
      "avatar": account!.avatar,
      'admin': account!.admin,
      'reply': reply
    });
  }

  void setMessage(message) {
    print(message);
  }

  @override
  void dispose() {
    socket!.disconnect();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          height: size.height,
          width: size.height,
          color: customColors.backgroundColor,
        ),
        Center(
          child: Image.asset(
            "images/AnimonDark.png",
            height: 250,
            width: 250,
            color: customColors.primaryColor.withOpacity(.5),
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              elevation: 1,
              backgroundColor: customColors.backgroundColor,
              leadingWidth: 70,
              titleSpacing: 0,
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back_ios_new,
                      color: customColors.primaryColor,
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          'images/animont.png',
                          height: 36,
                          width: 36,
                          fit: BoxFit.cover,
                        )
                        //  CachedNetworkImage(
                        //   imageUrl: image + account!.avatar,
                        //   //  color: Colors.white,
                        //   errorWidget: (context, url, error) => Container(
                        //     height: 36,
                        //     width: 36,
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(100),
                        //         color: customColors.iconTheme),
                        //   ),
                        //   height: 36,
                        //   width: 36,
                        // ),
                        ),
                  ],
                ),
              ),
              title: InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LocaleText(
                        "global_chat",
                        style: TextStyle(
                          color: customColors.primaryColor,
                          fontSize: 18.5,
                          fontFamily: 'SFPro',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      (chatGetX.connectedUser == 0 && chatGetX.typingUsers == 0)
                          ? SizedBox()
                          : Row(
                              children: [
                                chatGetX.connectedUser == 0
                                    ? SizedBox()
                                    : Obx(() => Text(
                                          "${chatGetX.connectedUser} ${context.localeString('online')}  • ",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'SFPro',
                                            color: customColors.primaryColor
                                                .withOpacity(.7),
                                          ),
                                        )),
                                SizedBox(
                                  width: 5,
                                ),
                                chatGetX.typingUsers == 0
                                    ? SizedBox()
                                    : Obx(() => Text(
                                          "${chatGetX.typingUsers} ${context.localeString('typing')}",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'SFPro',
                                            color: customColors.primaryColor
                                                .withOpacity(.7),
                                          ),
                                        )),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
              actions: account == null
                  ? []
                  : !account!.admin
                      ? []
                      : [
                          PopupMenuButton<String>(
                            icon: Icon(
                                color: customColors.primaryColor,
                                Icons.more_vert_sharp),
                            padding: EdgeInsets.all(0),
                            onSelected: (value) {
                              if (value == 'clear-chat') {
                                clearChat();
                                focusNode.unfocus();
                              } else
                                unBlockAllUser();
                              FocusNode().unfocus();
                            },
                            itemBuilder: (BuildContext contesxt) {
                              return [
                                PopupMenuItem(
                                  child: LocaleText(
                                    "clear",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'SFPro',
                                      color: customColors.primaryColor
                                          .withOpacity(.9),
                                    ),
                                  ),
                                  value: "clear-chat",
                                ),
                                PopupMenuItem(
                                  child: LocaleText(
                                    "un_block_all_users",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'SFPro',
                                      color: customColors.primaryColor
                                          .withOpacity(.9),
                                    ),
                                  ),
                                  value: "unBlock_all_users",
                                ),
                              ];
                            },
                          ),
                        ],
            ),
          ),
          body: SafeArea(
            child: isLoading
                ? LoadingGif(
                    logo: true,
                  )
                : SizedBox(
                    height: size.height,
                    child: Column(
                      children: [
                        Expanded(
                          child: WillPopScope(
                            child: SingleChildScrollView(
                                //  padding: EdgeInsets.only(bottom: 70),
                                controller: _scrollController,
                                reverse: true,
                                child: Obx(
                                  () => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Column(
                                      children: List.generate(
                                          chatGetX.messageList.length, (index) {
                                        var message =
                                            chatGetX.messageList[index];

                                        return SwipeTo(
                                          onLeftSwipe: () => setState(() {
                                            isReply = !isReply;
                                            reply = reply != null
                                                ? null
                                                : {
                                                    "userId": message.userId,
                                                    "messageId": message.id,
                                                    "avatar": message.avatar,
                                                    "userName":
                                                        message.userName,
                                                    "name": message.name,
                                                    "message": message.message
                                                  };
                                          }),
                                          child: InkWell(
                                            onLongPress: () {
                                              focusNode.unfocus();
                                              (message.admin &&
                                                      message.userId
                                                              .toString() !=
                                                          account!.id
                                                              .toString())
                                                  ? null
                                                  : (message.userId
                                                                  .toString() !=
                                                              account!.id
                                                                  .toString() &&
                                                          !account!.admin)
                                                      ? null
                                                      : showMore(
                                                          customColors,
                                                          context,
                                                          MoreItems(children: [
                                                            GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  deleteMessage(
                                                                    message.id,
                                                                  );
                                                                },
                                                                child: Center(
                                                                  child:
                                                                      CircBotton(
                                                                    title:
                                                                        'delete',
                                                                    child:
                                                                        Center(
                                                                      child: SvgPicture
                                                                          .string(
                                                                        delete,
                                                                        color: customColors
                                                                            .primaryColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )),
                                                            !account!.admin
                                                                ? SizedBox()
                                                                : message.userId
                                                                            .toString() ==
                                                                        account!
                                                                            .id
                                                                            .toString()
                                                                    ? SizedBox()
                                                                    : GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          blockUser(
                                                                              message.userId,
                                                                              message.userName,
                                                                              message.avatar);
                                                                        },
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              CircBotton(
                                                                            title:
                                                                                'ban',
                                                                            child:
                                                                                Center(
                                                                              child: SvgPicture.string(
                                                                                ban,
                                                                                color: customColors.primaryColor,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ))
                                                          ]),
                                                        );
                                            },
                                            child: ReplyCard(
                                              pref: chatGetX.messageList
                                                              .length -
                                                          1 ==
                                                      index
                                                  ? false
                                                  : (chatGetX
                                                          .messageList[
                                                              index + 1]
                                                          .userId
                                                          .toString() ==
                                                      chatGetX
                                                          .messageList[index]
                                                          .userId
                                                          .toString()),
                                              myId: int.parse(account!.id),
                                              message: message,
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                )),
                            onWillPop: () {
                              if (show) {
                                setState(() {
                                  show = false;
                                });
                              } else {
                                Navigator.pop(context);
                              }
                              return Future.value(false);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              //height: 70,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  !isReply
                                      ? SizedBox()
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2),
                                          child: Container(
                                              //height: 65,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  68,
                                              decoration: BoxDecoration(
                                                  color: customColors.iconTheme,
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              12))),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5,
                                                    right: 5,
                                                    left: 5,
                                                    bottom: 0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: customColors
                                                          .backgroundColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              height: 50,
                                                              width: 8,
                                                              decoration: BoxDecoration(
                                                                  color: customColors
                                                                      .bottomDown,
                                                                  borderRadius: BorderRadius.horizontal(
                                                                      right: context.currentLocale!.languageCode !=
                                                                              'en'
                                                                          ? Radius.circular(
                                                                              30)
                                                                          : Radius.circular(
                                                                              0),
                                                                      left: context.currentLocale!.languageCode ==
                                                                              'en'
                                                                          ? Radius.circular(
                                                                              30)
                                                                          : Radius.circular(
                                                                              0))),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  ConstrainedBox(
                                                                    constraints:
                                                                        BoxConstraints(
                                                                            maxWidth:
                                                                                size.width - 128),
                                                                    child: Text(
                                                                      '${reply['userId'].toString() == account!.id.toString() ? context.localeString("you") : reply['userName']}',
                                                                      style: TextStyle(
                                                                          color: customColors
                                                                              .primaryColor,
                                                                          fontFamily:
                                                                              'SFPro',
                                                                          fontSize:
                                                                              13),
                                                                    ),
                                                                  ),
                                                                  ConstrainedBox(
                                                                    constraints:
                                                                        BoxConstraints(
                                                                            maxWidth:
                                                                                size.width - 128),
                                                                    child: Text(
                                                                      '${reply['message']}',
                                                                      style: TextStyle(
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          color: customColors
                                                                              .primaryColor,
                                                                          fontFamily:
                                                                              'SFPro',
                                                                          fontSize:
                                                                              13),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            GestureDetector(
                                                              onTap: () =>
                                                                  setState(() {
                                                                isReply =
                                                                    !isReply;
                                                                reply = null;
                                                              }),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Icon(
                                                                  Icons.cancel,
                                                                  size: 15,
                                                                  color: customColors
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                            )
                                                          ]),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                        ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                64,
                                        child: Card(
                                          color: customColors.iconTheme,
                                          margin: EdgeInsets.only(
                                              left: 2, right: 2, bottom: 8),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: !isReply
                                                          ? Radius.circular(25)
                                                          : Radius.circular(0),
                                                      bottom:
                                                          Radius.circular(25))),
                                          child: TextFormField(
                                            controller: _controller,
                                            style: TextStyle(
                                              fontFamily: 'SFPro',
                                              color: customColors.primaryColor
                                                  .withOpacity(.9),
                                            ),
                                            maxLength: _controller.text.isEmpty
                                                ? null
                                                : 150,
                                            focusNode: focusNode,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            // keyboardType:
                                            //     TextInputType.multiline,
                                            maxLines: 5,
                                            minLines: 1,
                                            onChanged: (value) {
                                              setState(() {});
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,

                                              hintText: context
                                                  .localeString("message"),
                                              hintStyle: TextStyle(
                                                  color: customColors
                                                      .primaryColor
                                                      .withOpacity(.8),
                                                  fontFamily: 'SFPro'),
                                              prefixIcon: IconButton(
                                                icon: Icon(
                                                  show
                                                      ? Icons.keyboard
                                                      : Icons
                                                          .emoji_emotions_outlined,
                                                  color: customColors.bottomUp,
                                                ),
                                                onPressed: () {
                                                  if (!show) {
                                                    focusNode.unfocus();
                                                    focusNode.canRequestFocus =
                                                        false;
                                                  }
                                                  setState(() {
                                                    show = !show;
                                                    focusNode.nextFocus();
                                                  });
                                                },
                                              ),
                                              // suffixIcon: Row(
                                              //   mainAxisSize: MainAxisSize.min,
                                              //   children: [
                                              // IconButton(
                                              //   icon: Icon(Icons.attach_file),
                                              //   onPressed: () {
                                              //     showModalBottomSheet(
                                              //         backgroundColor:
                                              //             Colors.transparent,
                                              //         context: context,
                                              //         builder: (builder) =>
                                              //             bottomSheet());
                                              //   },
                                              // ),
                                              // IconButton(
                                              //   icon: Icon(Icons.camera_alt),
                                              //   onPressed: () {
                                              //     // Navigator.push(
                                              //     //     context,
                                              //     //     MaterialPageRoute(
                                              //     //         builder: (builder) =>
                                              //     //             CameraApp()));
                                              //   },
                                              // ),
                                              //   ],
                                              // ),
                                              contentPadding: EdgeInsets.all(5),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                          right: 2,
                                          left: 2,
                                        ),
                                        child: CircleAvatar(
                                          radius: 23,
                                          backgroundColor:
                                              customColors.bottomDown,
                                          child: Center(
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.send,
                                                color: Colors.white,
                                                size: 25,
                                              ),
                                              onPressed: () {
                                                if (_controller
                                                        .text.isNotEmpty &&
                                                    _controller.text.length
                                                        .isLowerThan(302)) {
                                                  sendMessage(
                                                    _controller.text,
                                                  );

                                                  _controller.clear();
                                                  setState(() {
                                                    reply = null;
                                                    isReply = false;
                                                    sendButton = false;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        show
                            ? SizedBox(
                                height: 300,
                                child: Column(
                                  children: [
                                    Expanded(child: emojiSelect()),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }

  Widget emojiSelect() {
    CustomColors customColors = CustomColors(context);
    return SizedBox(
      child: EmojiPicker(
          config: Config(bgColor: customColors.backgroundColor),
          onEmojiSelected: (category, emoji) {
            print(emoji);
            setState(() {
              _controller.text = _controller.text + emoji.emoji;
            });
          }),
    );
  }
}
