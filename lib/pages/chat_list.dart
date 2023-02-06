import 'package:anime_mont_test/pages/chat.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<Chat> chat = [];
  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 11; i++) {
      chat.add(Chat(
          'mont${i}', 'iotak0${i}', 'images/reigen.gif', 'hi', 'online', 2));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Container(
            height: size.height,
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(avatar: ''))),
                  child: ListTile(
                    minVerticalPadding: 25,
                    leading: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(chat[index].avatar)),
                    ),
                    trailing: ImageIcon(
                      AssetImage('images/Light/Camera.png'),
                      color: Colors.white,
                      size: 30,
                    ),
                    title: Text(
                      chat[index].name,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      chat[index].online,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class Chat {
  final String name;
  final String username;
  final String avatar;
  final String lastmessage;
  final String online;
  final int reserverId;

  Chat(this.name, this.username, this.avatar, this.lastmessage, this.online,
      this.reserverId);
}
