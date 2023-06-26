// import 'dart:math';

// import 'package:anime_mont_test/pages/chat.dart';
// import 'package:anime_mont_test/provider/user_model.dart';
// import 'package:anime_mont_test/widget/keep_page.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socket_io_client/socket_io_client.dart' as iso;

// class ChatList extends StatefulWidget {
//   const ChatList({super.key});

//   @override
//   State<ChatList> createState() => _ChatListState();
// }

// class _ChatListState extends State<ChatList> {
//   List<Chat> chat = [];

//   List<String> list = [
//     "One Piece 3mak",
//     "Attack on Titan",
//     "Naruto",
//     "We Bier Fans",
//     "Public Chat"
//   ];

//   @override
//   void initState() {
//     //connect();
//     super.initState();
//     for (var i = 0; i < 5; i++) {
//       chat.add(Chat(list[i], list[i], 'images/reigen.gif', 'hi',
//           '${Random().nextInt(100)} online', i));
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     return KeepPage(
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: ListView(
//           children: [
//             Container(
//               height: size.height,
//               child: ListView.builder(
//                 itemCount: list.length,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => KeepPage(
//                                   child: ChatPage(
//                                     isGroub: true,
//                                     name: list[index],
//                                     info: "EnJoy (:",
//                                     reseverID: index,
//                                   ),
//                                 ))),
//                     child: ListTile(
//                       minVerticalPadding: 25,
//                       leading: Padding(
//                         padding: const EdgeInsets.only(right: 5.0),
//                         child: CircleAvatar(
//                             radius: 25,
//                             backgroundImage: AssetImage(chat[index].avatar)),
//                       ),
//                       trailing: ImageIcon(
//                         AssetImage('images/Light/Camera.png'),
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                       title: Text(
//                         chat[index].name,
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       subtitle: Text(
//                         chat[index].online,
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Chat {
//   final String name;
//   final String username;
//   final String avatar;
//   final String lastmessage;
//   final String online;
//   final int reserverId;

//   Chat(this.name, this.username, this.avatar, this.lastmessage, this.online,
//       this.reserverId);
// }
