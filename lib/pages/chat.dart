// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'package:anime_mont_test/pages/chat_list.dart';
// import 'package:anime_mont_test/pages/profial_screen.dart';
// import 'package:anime_mont_test/provider/user_model.dart';
// import 'package:anime_mont_test/utils/image_helper.dart';
// import 'package:anime_mont_test/widget/keep_page.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:jiffy/jiffy.dart';
// import 'package:palette_generator/palette_generator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:socket_io_client/socket_io_client.dart' as iso;
// import 'package:swipe_to/swipe_to.dart';
// import 'dart:async';
// import '../server/server_php.dart';
// import '../server/urls_php.dart';

// class ChatPage extends StatefulWidget {
//   const ChatPage({
//     super.key,
//     required this.info,
//     required this.name,
//     required this.reseverID,
//     required this.isGroub,
//   });
//   final String name;
//   final bool isGroub;
//   final String info;
//   final int reseverID;
//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   List<Message> messagesList = [];
//   late Message replyMessage;
//   bool is_reply = false;
//   bool maxScrollExtent = false;
//   bool floatingButton = false;
//   bool empty = true;
//   int messageCount = 0;
//   late int myId;

//   File? _image;

//   String uImage = '';

//   final Server _server = Server();
//   //List<Message> messages = [];
//   TextEditingController myController = TextEditingController();
//   int page = 1;
//   late ScrollController _scrollController;
//   final int _maxLength = 20;
//   bool isLoading = false;
//   bool hasMore = true;
//   late iso.Socket socket;

//   //?page=1&user_id=154
//   getMessages() async {
//     setState(() {
//       isLoading = true;
//     });
//     final response = await http.get(Uri.parse("$messages_link?page=$page"));

//     //print(response.body);
//     List data = jsonDecode(response.body);
//     //print(response.body);
//     if (kDebugMode) {
//       print(data);
//     }
//     for (var e in data) {
//       messagesList.add(Message(
//         e['message_sender'],
//         e['message_resiver'],
//         e['message_time'],
//         e['message_avatar'],
//         e['messsage_cont'],
//         e['messsage_reply'] ?? '',
//         e['messsage_image'] == 1
//             ? true
//             : false || e['messsage_is_reply'] == "1"
//                 ? true
//                 : false,
//         e['messsage_is_reply'] == 1
//             ? true
//             : false || e['messsage_is_reply'] == "1"
//                 ? true
//                 : false,
//       ));
//     }
//     try {
//       messagesList.sort((a, b) {
//         int aDate = DateTime.parse(a.mesageTime).microsecondsSinceEpoch;
//         int bDate = DateTime.parse(b.mesageTime).microsecondsSinceEpoch;
//         return aDate.compareTo(bDate);
//       });
//     } catch (e) {}
//     setState(() {
//       isLoading = false;
//       page += 1;
//       hasMore = (data.length < _maxLength) ? false : true;
//     });
//     //print(data[0]);
//   }
//   // static Future<List<Message>> getMessages() async {
//   //   final response = await http.post(Uri.parse(messages_link), body: {
//   //     'page': page.toString(),
//   //   });
//   //   final body = json.decode(response.body);

//   //   return body.map<Message>(Message.fromJson).toList();
//   // }

//   uploadImage() async {
//     // var response = await _server.postRequestWithFiles(
//     //     uploadImageUrl,
//     //     {"sender": '$myId', "resiver": '${widget.reseverID}', "avatar": '555'},
//     //     _image!);
//     // //if (response['status'] != "fail") {
//     //   if (response['status'] == "fail") {
//     //print('imagggggge     ${response['name']}');
//     setState(() {
//       //uImage = response['name'];
//       uImage = 'name';
//     });
//     return true;
//     // } else {
//     //   return false;
//     // }
//   }

//   @override
//   void dispose() {
//     myController.dispose();
//     _scrollController.dispose();
//     socket.dispose();
//     super.dispose();
//   }

//   refresh() {
//     setState(() {});
//   }

//   loadMessages() {
//     page += 1;
//     getMessages();
//   }

//   getMyId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     //print("wwwwww    widget.id    wwwwwww${widget.id}");
//     String? userPref = prefs.getString('userData');
//     final user = json.decode(userPref!);
//     myId = int.parse(user['id']);
//   }

//   @override
//   void initState() {
//     _scrollController = ScrollController();
//     getMessages();
//     getMyId();
//     getColor();
//     connect();

//     myController.addListener(() {
//       if (myController.text.isNotEmpty) {
//         setState(() {
//           empty = false;
//         });
//         refresh();
//       } else if (myController.text.isEmpty) {
//         setState(() {
//           empty = true;
//         });
//         null;
//       } else {
//         refresh();
//       }
//     });
//     _scrollController.addListener(() {
//       //  if (messagesList.isNotEmpty) {
//       //       listController.jumpTo(listController.position.maxScrollExtent);
//       //     }
//       if (_scrollController.position.minScrollExtent ==
//           _scrollController.offset) {
//         loadMessages();
//         setState(() {
//           maxScrollExtent = true;
//           messageCount = 0;
//           floatingButton = false;
//         });
//       } else {
//         setState(() {
//           maxScrollExtent = false;
//         });
//       }
//     });
//     myController.addListener(() {
//       if (myController.text.isNotEmpty) {
//         socket.emit("typing", {
//           "senderId": myId,
//           "reseverId": widget.reseverID,
//           "type": true,
//         });
//       } else {
//         socket.emit("typing", {
//           "senderId": myId,
//           "reseverId": widget.reseverID,
//           "type": false,
//         });
//       }
//     });

//     super.initState();
//   }

//   Typing typing = Typing(false);
//   void connect() async {
//     Map<String, dynamic> user = await UserModel.getAcount();
//     int myId = int.parse(user['id']);
//     socket = iso.io(
//         "http://192.168.43.202:4000",
//         iso.OptionBuilder()
//             .setTransports(['websocket'])
//             .disableAutoConnect()
//             .build());
//     socket.connect();
//     if (widget.isGroub) {
//       socket.emit("signin", widget.reseverID);
//     } else {
//       socket.emit("signin", myId);
//     }

//     socket.on("message-r", (message) {
//       print(message);
//       setState(() {
//         messagesList.add(Message.fromJson(message));
//         if (message["message_sender"] != myId) {
//           messageCount += 1;
//         }
//         if (maxScrollExtent) {
//           _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//         } else {
//           if (message["message_sender"] != myId) {
//             floatingButton = true;
//           }
//         }
//       });
//     });
//     socket.on('typing-r', (type) {
//       print(type);
//       setState(() {
//         /// if (type["type"])
//         typing = Typing.fromJson(type);
//         messagesList.sort((a, b) {
//           int aDate = DateTime.parse(a.mesageTime).microsecondsSinceEpoch;
//           int bDate = DateTime.parse(b.mesageTime).microsecondsSinceEpoch;
//           return aDate.compareTo(bDate);
//         });
//         setState(() {});
//         if (maxScrollExtent) {
//           if (typing.isTyping != true) {
//             _scrollController
//                 .jumpTo(_scrollController.position.maxScrollExtent);
//           }
//         }

//         print("//////////isTyping///////////////" + typing.isTyping.toString());
//         print(
//             "/////////messageCount////////////////" + messageCount.toString());
//       });
//     });
//     // });

//     //print( widget.socket.connected);
//   }

//   void sendMessage(String message, String avatar, var reply, int myId,
//       int reseverId, int image, int isReply) {
//     socket.emit("message", {
//       "message": message,
//       "avatar": avatar,
//       "reply": reply,
//       "senderId": myId,
//       "reseverId": reseverId,
//       "image": image,
//       "isReply": isReply
//     });
//     /////////////////////////////////////
//     ///
//     is_reply = false;
//     myController.clear();
//     setState(() {});
//   }

//   Color _colors = Colors.purple;
//   getColor() async {
//     var paletteGenerator = await PaletteGenerator.fromImageProvider(
//       AssetImage('images/mal.png'),
//     );
//     _colors = paletteGenerator.dominantColor!.color;
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//           leadingWidth: 80,
//           leading: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 5),
//             child: GestureDetector(
//               onTap: () {
//                 socket.disconnect();
//                 page = 1;
//                 Navigator.pop(context);
//               },
//               child: Row(children: [
//                 Icon(
//                   Icons.arrow_back_ios_new_rounded,
//                   color: Color.fromARGB(255, 179, 177, 177),
//                 ),
//                 Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
//                     child: Container(
//                       height: 30,
//                       width: 30,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(100),
//                         image: DecorationImage(
//                             image: AssetImage('images/mal.png')),
//                       ),
//                     )),
//               ]),
//             ),
//           ),
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Text(
//                 widget.name,
//                 style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Color.fromARGB(255, 184, 183, 183)),
//               ),
//               Text(
//                 widget.info,
//                 style: TextStyle(fontSize: 12, color: Colors.grey),
//               )
//             ],
//           )),
//       floatingActionButton: floatingButton == true
//           ? Container(
//               height: 50,
//               width: 50,
//               margin: EdgeInsets.only(bottom: 65, right: size.width / 2.52),
//               child: Stack(
//                 //mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   FloatingActionButton.small(
//                     elevation: 0,
//                     backgroundColor: Colors.blueAccent,
//                     onPressed: () {
//                       _scrollController
//                           .jumpTo(_scrollController.position.maxScrollExtent);
//                       floatingButton = false;
//                     },
//                     child: CircleAvatar(
//                       radius: 18,
//                       backgroundImage: AssetImage('images/mal.png'),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : null,
//       backgroundColor: Colors.transparent,
//       body: Stack(children: [
//         Column(children: [
//           /**if (index <
//                                                     messagesList.length) {
//                                                   bool? sendByMe;
//                                                   if (messagesList[index]
//                                                           .senderId ==
//                                                       myId) {
//                                                     sendByMe = true;
//                                                   } else {
//                                                     sendByMe = false;
//                                                   } 
                                                  
                                                  
//                                                   Shimmer.fromColors(
//                                           //     baseColor: Color.fromARGB(
//                                           //         48, 158, 158, 158),
//                                           //     highlightColor:
//                                           //         Colors.transparent,
//                                           //     child: Container(
//                                           //       height: 100,
//                                           //       width: 500,
//                                           //       color: Colors.white,
//                                           //     ))*/
//           Container(
//             child: Expanded(
//               child: ListView.separated(
//                   controller: _scrollController,
//                   // reverse: true,
//                   shrinkWrap: true,
//                   itemCount: messagesList.length,
//                   separatorBuilder: (context, index) => const SizedBox(
//                         height: 10,
//                       ),
//                   itemBuilder: (context, index) {
//                     bool? sendByMe;
//                     if (index == 0) {
//                       return Column(
//                         children: [
//                           hasMore
//                               ? SizedBox(
//                                   width: 40,
//                                   height: 40,
//                                   child: GestureDetector(
//                                       onTap: () => getMessages(),
//                                       child: const FittedBox(
//                                           child: CircularProgressIndicator())),
//                                 )
//                               : SizedBox(),
//                           SwipeTo(
//                             offsetDx: .3,
//                             //animationDuration: Duration(seconds: 1),
//                             iconColor: Colors.white10,
//                             rightSwipeWidget: ImageIcon(
//                               AssetImage('images/Light/Swap.png'),
//                               color: sendByMe == false
//                                   ? Colors.white
//                                   : Colors.transparent,
//                             ),
//                             leftSwipeWidget: ImageIcon(
//                               AssetImage('images/Light/Swap.png'),
//                               color: sendByMe != false
//                                   ? Colors.white
//                                   : Colors.transparent,
//                             ),
//                             onRightSwipe: () {
//                               sendByMe != true
//                                   ? setState(() {
//                                       is_reply = true;
//                                       replyMessage = messagesList[index];
//                                     })
//                                   : null;
//                               print("Swipe To Right");
//                             },
//                             onLeftSwipe: () {
//                               sendByMe == true
//                                   ? setState(() {
//                                       is_reply = true;
//                                       replyMessage = messagesList[index];
//                                     })
//                                   : null;
//                               print("Swipe To Left");
//                             },
//                             child: MessageItem(
//                               nextMessageTime: messagesList[
//                                       index != messagesList.length - 1
//                                           ? index + 1
//                                           : index]
//                                   .mesageTime,
//                               lastMessageTime:
//                                   messagesList[index != 0 ? index - 1 : index]
//                                       .mesageTime,
//                               lenght: messagesList.length - 1,
//                               message: messagesList[index],
//                               index: index,
//                               sendByMe: messagesList[index].senderId == myId
//                                   ? true
//                                   : false,
//                               lastMessage:
//                                   messagesList[index != 0 ? index - 1 : index],
//                               nextMessage: messagesList[
//                                   index != messagesList.length - 1
//                                       ? index + 1
//                                       : index],
//                             ),
//                           )
//                         ],
//                       );
//                     } else {
//                       return SwipeTo(
//                         offsetDx: .3,
//                         //animationDuration: Duration(seconds: 1),
//                         iconColor: Colors.white10,
//                         rightSwipeWidget: ImageIcon(
//                           AssetImage('images/Light/Swap.png'),
//                           color: sendByMe == false
//                               ? Colors.white
//                               : Colors.transparent,
//                         ),
//                         leftSwipeWidget: ImageIcon(
//                           AssetImage('images/Light/Swap.png'),
//                           color: sendByMe != false
//                               ? Colors.white
//                               : Colors.transparent,
//                         ),
//                         onRightSwipe: () {
//                           sendByMe != true
//                               ? setState(() {
//                                   is_reply = true;
//                                   replyMessage = messagesList[index];
//                                 })
//                               : null;
//                           print("Swipe To Right");
//                         },
//                         onLeftSwipe: () {
//                           sendByMe == true
//                               ? setState(() {
//                                   is_reply = true;
//                                   replyMessage = messagesList[index];
//                                 })
//                               : null;
//                           print("Swipe To Left");
//                         },
//                         child: MessageItem(
//                           nextMessageTime: messagesList[
//                                   index != messagesList.length - 1
//                                       ? index + 1
//                                       : index]
//                               .mesageTime,
//                           lastMessageTime:
//                               messagesList[index != 0 ? index - 1 : index]
//                                   .mesageTime,
//                           lenght: messagesList.length - 1,
//                           message: messagesList[index],
//                           index: index,
//                           sendByMe: messagesList[index].senderId == myId
//                               ? true
//                               : false,
//                           lastMessage:
//                               messagesList[index != 0 ? index - 1 : index],
//                           nextMessage: messagesList[
//                               index != messagesList.length - 1
//                                   ? index + 1
//                                   : index],
//                         ),
//                       );
//                     }
//                     if (index < messagesList.length) {
//                       if (messagesList[index].senderId == myId) {
//                         sendByMe = true;
//                       } else {
//                         sendByMe = false;
//                       }
//                     }
//                   }),
//             ),
//           ),
//           typing.isTyping
//               ? Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   child: Container(
//                       color: Colors.transparent,
//                       alignment: Alignment.centerLeft,
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Stack(
//                               children: [
//                                 Positioned(
//                                   child: CircleAvatar(
//                                     radius: 15,
//                                     backgroundColor: Colors.transparent,
//                                     child: CircleAvatar(
//                                         radius: 12,
//                                         backgroundImage:
//                                             AssetImage("images/reigen.gif")),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   left: 15,
//                                   child: CircleAvatar(
//                                     radius: 15,
//                                     backgroundColor: Colors.transparent,
//                                     child: CircleAvatar(
//                                         radius: 12,
//                                         backgroundImage:
//                                             AssetImage("images/reigen.gif")),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Text(
//                             '   Typing...',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.grey),
//                           ),
//                         ],
//                       )),
//                 )
//               : Container(),
//           Container(
//             color: is_reply == true ? Color.fromARGB(255, 6, 0, 24) : null,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 7),
//               child: Column(
//                 children: [
//                   is_reply == true
//                       ? Container(
//                           height: 50,
//                           // color: Color.fromARGB(255, 6, 0, 24),
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 5),
//                             height: 40,
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         replyMessage.senderId == myId
//                                             ? 'Replying to yourself'
//                                             : 'Replying to ${replyMessage.senderId}',
//                                         style: TextStyle(
//                                             color: Colors.white70,
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       SizedBox(
//                                         height: 5,
//                                       ),
//                                       Text(
//                                         '${replyMessage.message}',
//                                         overflow: TextOverflow.ellipsis,
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 12,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       is_reply = false;
//                                     });
//                                   },
//                                   child: Container(
//                                     height: 45,
//                                     width: 45,
//                                     child: Icon(
//                                       Icons.cancel,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         )
//                       : Container(),
//                   Container(
//                     constraints: BoxConstraints(minHeight: 48),
//                     height: 48,
//                     decoration: BoxDecoration(
//                         color: Color.fromARGB(255, 42, 79, 110),
//                         borderRadius: BorderRadius.circular(50)),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 9),
//                       child: Row(
//                         children: [
//                           GestureDetector(
//                             onTap: () async {
//                               final ImageHelper imageHelper = ImageHelper(
//                                 source: ImageSource.camera,context:context,
//                               );
//                               final files = await imageHelper.pickImage();
//                               if (files.isNotEmpty) {
//                                 // setState(() {
//                                 //   _image = File(files.first!.path);
//                                 // });
//                                 final croppedFile = await imageHelper.crop(
//                                   file: files.first!,
//                                   cropStyle: CropStyle.circle,
//                                 );
//                                 if (croppedFile != null) {
//                                   setState(() async {
//                                     _image = File(croppedFile.path);
//                                     await uploadImage() == true
//                                         ? sendMessage(
//                                             uImage,
//                                             "reigen2.gif",
//                                             is_reply == true
//                                                 ? replyMessage.message
//                                                 : null,
//                                             myId,
//                                             widget.reseverID,
//                                             1,
//                                             is_reply == true ? 1 : 0)
//                                         : null;
//                                   });
//                                 }
//                               }
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   color: Colors.blue,
//                                   borderRadius: BorderRadius.circular(50)),
//                               height: 34,
//                               width: 34,
//                               child: ImageIcon(
//                                   AssetImage('images/Light/Camera.png'),
//                                   color: Colors.white),
//                             ),
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(left: 8.0),
//                               child: Column(
//                                 children: [
//                                   TextField(
//                                     //maxLines: 5,
//                                     style: TextStyle(color: Colors.white),
//                                     cursorColor: Colors.blueAccent,
//                                     controller: myController,
//                                     decoration: InputDecoration(
//                                       hintText: 'Message...',
//                                       hintStyle: TextStyle(color: Colors.grey),
//                                       border: InputBorder.none,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           empty == true
//                               ? GestureDetector(
//                                   onTap: () async {
//                                     final ImageHelper imageHelper = ImageHelper(
//                                       source: ImageSource.gallery,context:context,
//                                     );
//                                     final files = await imageHelper.pickImage();
//                                     if (files.isNotEmpty) {
//                                       // setState(() {
//                                       //   _image = File(files.first!.path);
//                                       // });
//                                       final croppedFile =
//                                           await imageHelper.crop(
//                                         file: files.first!,
//                                         // cropStyle: CropStyle.circle,
//                                       );
//                                       if (croppedFile != null) {
//                                         setState(() async {
//                                           _image = File(croppedFile.path);
//                                           await uploadImage() == true
//                                               ? sendMessage(
//                                                   uImage,
//                                                   "reigen2.gif",
//                                                   is_reply == true
//                                                       ? replyMessage.message
//                                                       : null,
//                                                   myId,
//                                                   widget.reseverID,
//                                                   1,
//                                                   is_reply == true ? 1 : 0)
//                                               : null;
//                                         });
//                                       }
//                                     }
//                                   },
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         //color: Colors.blue,
//                                         borderRadius:
//                                             BorderRadius.circular(50)),
//                                     height: 34,
//                                     width: 34,
//                                     child: ImageIcon(
//                                         AssetImage('images/Light/Image 2.png'),
//                                         color: Colors.white),
//                                   ),
//                                 )
//                               : Container(),
//                           empty != true
//                               ? Container(
//                                   margin: EdgeInsets.symmetric(
//                                       horizontal: 5, vertical: 5),
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       if (myController.text.isNotEmpty) {
//                                         sendMessage(
//                                             myController.text,
//                                             "reigen2.gif",
//                                             is_reply == true
//                                                 ? replyMessage.message
//                                                 : null,
//                                             myId,
//                                             widget.reseverID,
//                                             0,
//                                             is_reply == true ? 1 : 0);
//                                       }
//                                     },
//                                     child: Text("Send",
//                                         style: TextStyle(
//                                             color: Colors.blueAccent,
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold)),
//                                   ),
//                                 )
//                               : Container()
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ])
//       ]),
//     );
//   }
// }

// class MessageItem extends StatefulWidget {
//   const MessageItem({
//     super.key,
//     required this.sendByMe,
//     required this.index,
//     required this.message,
//     required this.lenght,
//     required this.lastMessageTime,
//     required this.nextMessageTime,
//     required this.lastMessage,
//     required this.nextMessage,
//   });
//   final String lastMessageTime;

//   final String nextMessageTime;
//   final int lenght;
//   final bool sendByMe;
//   final int index;
//   final Message lastMessage;
//   final Message nextMessage;
//   final Message message;

//   @override
//   State<MessageItem> createState() => _MessageItemState();
// }

// class _MessageItemState extends State<MessageItem> {
//   void showBottom(image, size) {
//     showModalBottomSheet<dynamic>(
//       isScrollControlled: true,
//       context: context,
//       builder: (context) {
//         return Container(
//           color: Color.fromARGB(255, 6, 0, 24),
//           child: Center(
//             child: Column(
//               ///runSpacing: 0,
//               children: <Widget>[
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         height: size.height,
//                         child: Image.network(
//                           image,
//                           fit: BoxFit.scaleDown,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     return Align(
//       alignment: widget.sendByMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         mainAxisAlignment:
//             widget.sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//         children: [
//           widget.sendByMe
//               ? Container()
//               : widget.index == widget.lenght ||
//                       Jiffy(widget.message.mesageTime).minute !=
//                           Jiffy(widget.nextMessageTime).minute ||
//                       widget.message.senderId != widget.nextMessage.senderId
//                   ? GestureDetector(
//                       // onTap: () => Navigator.push(
//                       //     context,
//                       // MaterialPageRoute(
//                       //     builder: (context) => ProfialPage())),
//                       child: Container(
//                         margin: EdgeInsets.only(left: 10, bottom: 5),
//                         height: 30,
//                         width: 30,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(25),
//                             image: DecorationImage(
//                               image: NetworkImage(
//                                 "http://192.168.43.4:8080/Flutter_PHP_Tutorial/upload/" +
//                                     widget.message.avatar,
//                               ),
//                               fit: BoxFit.cover,
//                             )),
//                       ),
//                     )
//                   : Container(
//                       margin: EdgeInsets.only(left: 10),
//                       height: 30,
//                       width: 30,
//                     ),
//           Column(
//             crossAxisAlignment: widget.sendByMe == true
//                 ? CrossAxisAlignment.end
//                 : CrossAxisAlignment.start,
//             children: [
//               widget.message.isRelpy == true
//                   ? Column(
//                       children: [
//                         Container(
//                           constraints:
//                               BoxConstraints(maxWidth: size.width / 1.4),
//                           width: size.width / 1.4,
//                           alignment: widget.sendByMe == true
//                               ? Alignment.centerRight
//                               : Alignment.centerLeft,
//                           child: Text(
//                             widget.sendByMe != true
//                                 ? '   Replied to'
//                                 : 'You replied   ',
//                             textAlign: widget.sendByMe != true
//                                 ? TextAlign.left
//                                 : TextAlign.right,
//                             style: TextStyle(fontSize: 13, color: Colors.white),
//                           ),
//                         ),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           textBaseline: TextBaseline.alphabetic,
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             widget.sendByMe != true
//                                 ? Container(
//                                     height: 30,
//                                     width: 2,
//                                     decoration: BoxDecoration(
//                                         color: Colors.grey,
//                                         borderRadius:
//                                             BorderRadius.circular(25)))
//                                 : Container(),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 5, vertical: 3),
//                               child: Container(
//                                 alignment: widget.sendByMe == true
//                                     ? Alignment.centerRight
//                                     : Alignment.centerLeft,
//                                 padding: EdgeInsets.only(
//                                     top: 5, left: 10, right: 10, bottom: 5),
//                                 constraints:
//                                     BoxConstraints(maxWidth: size.width / 1.6),
//                                 decoration: BoxDecoration(
//                                     color: Colors.black,
//                                     borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(25),
//                                         topRight: Radius.circular(25),
//                                         bottomLeft: Radius.circular(25),
//                                         bottomRight: Radius.circular(25))),
//                                 child: Text(
//                                   widget.message.reply,
//                                   overflow: TextOverflow.ellipsis,
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       fontSize: 18,
//                                       color: widget.sendByMe == false
//                                           ? Colors.white
//                                           : Colors.white),
//                                 ),
//                               ),
//                             ),
//                             widget.sendByMe == true
//                                 ? Container(
//                                     height: 30,
//                                     width: 2,
//                                     decoration: BoxDecoration(
//                                         color: Colors.grey,
//                                         borderRadius:
//                                             BorderRadius.circular(25)))
//                                 : Container()
//                           ],
//                         ),
//                       ],
//                     )
//                   : Container(),
//               widget.message.image == true
//                   ? GestureDetector(
//                       onTap: () {
//                         showBottom(
//                             "http://192.168.43.4:8080/Flutter_PHP_Tutorial/upload/" +
//                                 widget.message.message,
//                             size);
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(vertical: 10),
//                         child: Container(
//                             margin: EdgeInsets.symmetric(horizontal: 10),
//                             height: 250,
//                             width: 250,
//                             decoration: BoxDecoration(
//                                 color: Colors.blue,
//                                 borderRadius: BorderRadius.circular(25),
//                                 image: DecorationImage(
//                                   image: NetworkImage(
//                                     image2 + widget.message.message,
//                                   ),
//                                   fit: BoxFit.cover,
//                                 ))),
//                       ),
//                     )
//                   : Container(
//                       constraints: BoxConstraints(maxWidth: size.width / 1.4),
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       margin: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
//                       decoration: BoxDecoration(
//                           color: widget.sendByMe
//                               ? Color.fromARGB(255, 48, 107, 209)
//                               : Color.fromARGB(255, 7, 55, 136),
//                           borderRadius: Jiffy(widget.message.mesageTime).minute != Jiffy(widget.lastMessageTime).minute &&
//                                       Jiffy(widget.message.mesageTime).minute ==
//                                           Jiffy(widget.nextMessageTime)
//                                               .minute &&
//                                       widget.index != widget.lenght &&
//                                       widget.nextMessage.senderId ==
//                                           widget.message.senderId ||
//                                   /* &&
//                                       widget.nextMessage.image != true &&
//                                       widget.lastMessage.image == true  */
//                                   widget.lastMessage.senderId != widget.message.senderId &&
//                                       widget.nextMessage.senderId ==
//                                           widget.message.senderId &&
//                                       Jiffy(widget.message.mesageTime).minute ==
//                                           Jiffy(widget.nextMessageTime)
//                                               .minute &&
//                                       widget.index != widget.lenght ||
//                                   widget.index == 0
//                               ? widget.sendByMe
//                                   ?
//                                   // send by me
//                                   BorderRadius.only(
//                                       topLeft: Radius.circular(25),
//                                       topRight: Radius.circular(25),
//                                       bottomLeft: Radius.circular(25),
//                                       bottomRight: Radius.circular(5))
//                                   :
//                                   //send by anthoer one
//                                   BorderRadius.only(
//                                       topLeft: Radius.circular(25),
//                                       topRight: Radius.circular(25),
//                                       bottomLeft: Radius.circular(5),
//                                       bottomRight: Radius.circular(25),
//                                     )
//                               : Jiffy(widget.lastMessageTime).minute != Jiffy(widget.message.mesageTime).minute ||
//                                       widget.lastMessage.senderId !=
//                                           widget.message.senderId
//                                   //||
//                                   // widget.nextMessage.senderId != widget.message.senderId &&
//                                   //     widget.lastMessage.senderId !=
//                                   //         widget.message.senderId ||
//                                   // widget.lastMessage.senderId != widget.message.senderId &&
//                                   //     widget.nextMessage.senderId !=
//                                   //         widget.message.senderId ||
//                                   // widget.lastMessage.senderId != widget.message.senderId &&
//                                   //     widget.nextMessage.senderId !=
//                                   //         widget.message.senderId &&
//                                   //     widget.index == 0 &&
//                                   //     widget.lenght < 1 ||
//                                   // Jiffy(widget.lastMessageTime).minute != Jiffy(widget.message.mesageTime).minute &&
//                                   //     widget.index == widget.lenght ||
//                                   // Jiffy(widget.nextMessageTime).minute != Jiffy(widget.message.mesageTime).minute &&
//                                   //     widget.index == widget.lenght
//                                   ? BorderRadius.only(
//                                       topLeft: Radius.circular(25),
//                                       topRight: Radius.circular(25),
//                                       bottomLeft: Radius.circular(25),
//                                       bottomRight: Radius.circular(25))
//                                   : widget.nextMessage.senderId != widget.message.senderId ||
//                                           widget.index == widget.lenght ||
//                                           Jiffy(widget.message.mesageTime).minute !=
//                                               Jiffy(widget.nextMessageTime)
//                                                   .minute
//                                       ? widget.sendByMe
//                                           ?
//                                           // send by me
//                                           BorderRadius.only(
//                                               topLeft: Radius.circular(25),
//                                               bottomLeft: Radius.circular(25),
//                                               bottomRight: Radius.circular(25),
//                                               topRight: Radius.circular(5))
//                                           :
//                                           //send by anthoer one
//                                           BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25), topRight: Radius.circular(25))
//                                       : widget.sendByMe
//                                           ?
//                                           // send by me
//                                           BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25), bottomRight: Radius.circular(5), topRight: Radius.circular(5))
//                                           :
//                                           //send by anthoer one
//                                           BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5), bottomRight: Radius.circular(25), topRight: Radius.circular(25))),
//                       child: Column(
//                         children: [
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.baseline,
//                             textBaseline: TextBaseline.alphabetic,
//                             mainAxisSize: MainAxisSize.min,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 constraints:
//                                     BoxConstraints(maxWidth: size.width / 1.4),
//                                 //padding: EdgeInsets.only(right: 100),
//                                 child: Column(
//                                   children: [
//                                     Container(
//                                       constraints: BoxConstraints(
//                                           maxWidth: size.width / 1.6),
//                                       child: Text(
//                                         widget.message.message,
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                             fontSize: 18,
//                                             color: widget.sendByMe == false
//                                                 ? Colors.white
//                                                 : Colors.white),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Message {
//   final int senderId;
//   final int resiverId;
//   final String mesageTime;
//   final String avatar;
//   final String message;
//   final String reply;
//   final bool image;
//   final bool isRelpy;

//   Message(this.senderId, this.resiverId, this.mesageTime, this.avatar,
//       this.message, this.reply, this.image, this.isRelpy);

//   static Message fromJson(json) => Message(
//         json['message_sender'],
//         json['message_resiver'],
//         json['message_time'],
//         json['message_avatar'],
//         json['messsage_cont'],
//         json['messsage_reply'] == null ? '' : json['messsage_reply'],
//         json['messsage_image'] == 1
//             ? true
//             : false || json['messsage_is_reply'] == "1"
//                 ? true
//                 : false,
//         json['messsage_is_reply'] == 1
//             ? true
//             : false || json['messsage_is_reply'] == "1"
//                 ? true
//                 : false,
//       );
// }

// class Typing {
//   bool isTyping;
//   Typing(this.isTyping);
//   static Typing fromJson(json) => Typing(json['type'] as bool);
// }
