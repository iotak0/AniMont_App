import 'dart:convert';
import 'package:anime_mont_test/Screens/Posts/post_card.dart';
import 'package:anime_mont_test/Screens/Posts/post_class.dart';
import 'package:anime_mont_test/helper/constans.dart';
import 'package:anime_mont_test/widgets/alart.dart';
import 'package:anime_mont_test/widgets/alart_internet.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:http/http.dart';

class PostsUserPage extends StatefulWidget {
  const PostsUserPage({super.key, required this.myId, required this.userId});
  final int myId;
  final int userId;
  @override
  State<PostsUserPage> createState() => PostsPageState();
}

class PostsPageState extends State<PostsUserPage> {
  int page = 1;
  late ScrollController _scrollController;
  final int _maxLength = 15;
  bool erorr = false;
  bool isLoading = false;
  bool hasMore = true;
  bool complet = false;
  List<Post> posts = [];
  //?page=1&user_id=154
  getPosts() async {
    setState(() {
      isLoading = true;
      erorr = false;
    });
    final response = await http
        .get(Uri.parse(
            "$user_posts?page=$page&user_id=${widget.myId}&follower_id=${widget.userId}"))
        .catchError((erorr0) {
      isLoading = false;
      erorr = true;
      setState(() {});
      return Response('error', 400);
    });
    print(response.body);
    if (response.statusCode == 200) {
      page++;
      var data;
      try {
        data = jsonDecode(response.body);
      } catch (e) {
        isLoading = false;
        complet = true;
        setState(() {});
        return;
      }

      List<Map<String, dynamic>> users = []; //user
      //List string = ["name", "username", "admin", "avata"];
      for (var e in data) {
        Map<String, dynamic> userPost = {};
        List list = e["user"];
        for (var user in list) {
          userPost.addAll(user);
        }
        users.add(userPost);
      }
      List<List<Map<String, dynamic>>> postsCont = []; //user
      //List string = ["name", "username", "admin", "avata"];
      for (var e in data) {
        List<Map<String, dynamic>> cont = [];

        List list = e["posts_cont"];
        for (var contItem in list) {
          cont.add(contItem);
        }

        postsCont.add(cont);
      }

      for (var e in data) {
        posts.add(Post(
            e['id'] ?? '',
            e['post_user'] ?? '',
            users[data.indexOf(e)],
            e['caption'] ?? '',
            e['post_date'] ?? '',
            postsCont[data.indexOf(e)],
            e['is_like'],
            e['comments'] ?? 0,
            e['likes'] ?? 0,
            e['post_cont'] ?? 0,
            e["time"],
            e['is_followed'],
            e['admin'] ?? false));
      }
      setState(() {
        isLoading = false;
        hasMore = (data.length >= _maxLength) ? true : false;
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

  @override
  void initState() {
    super.initState();
    try {
      posts.clear();
    } catch (e) {
      
    }
    getPosts();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.95 &&
          !isLoading &&
          hasMore) {
        getPosts();
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
    setState(() {});
    posts.clear();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
        onRefresh: () => refresh(),
        child: (isLoading && !erorr && posts.isEmpty)
            ? LoadingGif(
                logo: true,
              )
            : (erorr && posts.isEmpty)
                ? AlartInternet(onTap: () => isLoading ? null : getPosts())
                : (complet && posts.isEmpty)
                    ? Alart(body: 'no_posts_yet', icon: noPosts)
                    : SizedBox(
                        child: SingleChildScrollView(
                            // height: size.height - 136,
                            controller: _scrollController,
                            child: Column(
                                children: List.generate(
                              posts.length +
                                  (hasMore && posts.isNotEmpty ? 1 : 0),
                              (index) {
                                if (index == posts.length) {
                                  return LoadingGif(
                                    logo: true,
                                  );
                                }
                                return posts.isEmpty
                                    ? LoadingGif(
                                        logo: true,
                                      )
                                    : PostCard(
                                        profile: true,
                                        index: index,
                                        myId: widget.myId,
                                        size: size,
                                        post: posts[index],
                                      );
                              },
                            )))));
  }
}
