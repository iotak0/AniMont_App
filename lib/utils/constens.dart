import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:anime_mont_test/server/server_php.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:flutter/material.dart';

class Comment extends StatefulWidget {
  const Comment({super.key});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  final Server _server = Server();
  bool isLoading = false;

  Future<List<Comments>> commentsFuture = getComments();
  static Future<List<Comments>> getComments() async {
    final response = await http.post(Uri.parse(comments_link), body: {
      "comment_anime": "2",
    });
    final body = json.decode(response.body);
    return body.map<Comments>(Comments.fromJson).toList();
  }

  TextEditingController comment_anime = TextEditingController();
  signUp() async {
    isLoading = true;
    setState(() {});
    var response = await _server.postRequest(comments_link, {
      "comment_anime": comment_anime.text,
    });
    isLoading = false;
    setState(() {});
    // if (response['status'] == "success") {
    //   Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
    // } else {
    //   print("Sign up fail");
    // }

    print(response);

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: FutureBuilder<List<Comments>>(
                future: commentsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final comments = snapshot.data!;
                    return buildComments(comments);
                  } else {
                    return const Text("No Comments data.");
                  }
                })));
  }

  Widget buildComments(List<Comments> comments) => ListView.builder(
      itemCount: comments.length,
      itemBuilder: ((context, index) {
        final comment = comments[index];
        return Card(
            child: ListTile(
          leading: CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage(comment.avatar),
          ),
          title: Text(
            comment.name,
          ),
          subtitle: (Text(comment.username)),
        ));
      }));
}

class Comments {
  final int comment_anime;
  final int comment_id;
  final int comment_user;
  final bool fair;
  final int reply_of;
  final String comment_cont;
  final String username;
  final String name;
  final String avatar;
  final String comment_time;
  //bool liked;

  Comments(
      this.comment_anime,
      this.comment_id,
      this.comment_user,
      this.fair,
      this.reply_of,
      this.comment_cont,
      this.username,
      this.name,
      this.avatar,
      this.comment_time);
  static Comments fromJson(json) => Comments(
        json['comment_anime'],
        json['comment_id'],
        json['comment_user'],
        json['fair'] == 0 ? false : true,
        json['reply_of'],
        json['comment_cont'],
        json['username'],
        json['name'],
        json['avatar'],
        json['comment_time'],
      );
}


/*
 Future<List<Comments2>> comments2 = getComments('');

  static Future<List<Comments2>> getComments(String id) async {
    final Server _server = Server();
    final response = await _server.postRequest(
      comments_link,
      {'comment_anime': id},
    );
    final body = json.decode(response.body);

    //return response;

    return body.map<Comments2>(Comments2.fromJson).toList();
  } 
 */