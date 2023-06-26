import 'package:anime_mont_test/Screens/Posts/post_card.dart';
import 'package:anime_mont_test/Screens/Posts/post_class.dart';
import 'package:anime_mont_test/helper/constans.dart';
import 'package:anime_mont_test/Screens/Posts/posts.dart';
import 'package:anime_mont_test/models/get_x_controller.dart';

import 'package:anime_mont_test/widgets/alart.dart';
import 'package:anime_mont_test/widgets/alart_internet.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:http/http.dart';

class AllPostsPage extends StatefulWidget {
  const AllPostsPage({super.key, required this.myId, required this.explore});
  final int myId;
  final bool explore;
  @override
  State<AllPostsPage> createState() => AllPostsPageState();
}

class AllPostsPageState extends State<AllPostsPage> {
  //?page=1&user_id=154
  @override
  void dispose() {
    //PostsPageState.scrollController.dispose();
    PostsPageState.isLoading = false;
    PostsPageState.page = 1;
    PostsPageState.hasMore = true;
    PostsPageState.erorr = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height - 136,
      child: ListView.separated(
        controller: PostsPageState.scrollController,
        itemCount: PostsPageState.isLoading &&
                PostsPageState.hasMore &&
                ChatGetX.posts.isNotEmpty
            ? ChatGetX.posts.length + 1
            : ChatGetX.posts.length,
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
        itemBuilder: (context, index) {
          if (index == ChatGetX.posts.length &&
              PostsPageState.isLoading &&
              ChatGetX.posts.isNotEmpty) {
            return LoadingGif(
              logo: true,
            );
          }
          return Obx(() => PostCard(
                profile: false,
                index: index,
                myId: widget.myId,
                size: size,
                post: ChatGetX.posts[index],
              ));
        },
      ),
    );
  }
}
