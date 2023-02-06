import 'dart:convert';

import 'package:anime_mont_test/pages/anime_details_screen.dart';
import 'package:anime_mont_test/pages/profial_screen.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:http/http.dart' as http;

import '../pages/search_page.dart';
import '../pages/search_users.dart';
import '../server/banner_ad.dart';
import '../utils/anime_scrollview.dart';

class SearchResults extends StatefulWidget {
  final List<Result> list;
  final bool isAnime;
  final ScrollController listController;
  const SearchResults({
    Key? key,
    required this.list,
    required this.isAnime,
    required this.listController,
  }) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  final List<Users> list = [];
  @override
  Widget build(BuildContext context) {
    return widget.isAnime
        ? AnimeResults(
            list: widget.list,
            listController: widget.listController,
          )
        : UsersResults(users: list);
  }
}

class AnimeResults extends StatelessWidget {
  const AnimeResults({
    Key? key,
    required this.list,
    required this.listController,
  }) : super(key: key);
  final List<Result> list;
  final ScrollController listController;
  @override
  Widget build(BuildContext context) {
    int length = list.length;

    return ListView(
        controller: listController,
        children: List.generate(length, (idx) {
          var image = list[idx].image.contains('animetitans')
              ? list[idx].image
              : list[idx].image.contains('http')
                  ? list[idx].image
                  : image2 + list[idx].image;
          //  users[index].username
          if (idx == 4 || idx == 9 || idx == 14) {
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: const MyBannerAd(),
                ),
                GoTo(list: list, idx: idx, image: image),
              ],
            );
          } else {
            return GoTo(list: list, idx: idx, image: image);
          }
        }));
  }
}

class GoTo extends StatelessWidget {
  const GoTo({
    Key? key,
    required this.list,
    required this.idx,
    required this.image,
  }) : super(key: key);

  final List<Result> list;
  final int idx;
  final String image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            if (list[idx].image.contains('animetitans')) {
              return AnimeDetailsScreen(url: list[idx].link);
            } else {
              return ProfialPage(id: int.parse(list[idx].link));
            }
          },
        ));
      },
      child: Container(
          child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            image,
          ),
          radius: 40,
        ),
        title: Text(
          list[idx].name,
          style: TextStyle(fontSize: 17),
        ),
        subtitle: Text(
          list[idx].sub,
          style: TextStyle(fontSize: 15),
        ),
      )
          // trailing: Container(
          //     height: 25,
          //     width: 70,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(5),
          //       color: Color.fromARGB(255, 57, 56, 56),
          //     ),
          //     child: Center(child: const LocaleText('follow')))),
          ),
    );
  }
}

class UsersResults extends StatelessWidget {
  const UsersResults({
    Key? key,
    required this.users,
  }) : super(key: key);

  final List<Users> users;

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: List.generate(
            users.length,
            (index) => GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfialPage(id: users[index].id),
                      )),
                  child: Container(
                    child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            image2 + users[index].avatar,
                          ),
                          radius: 40,
                        ),
                        title: Text(
                          users[index].username,
                          style: TextStyle(fontSize: 17),
                        ),
                        subtitle: Text(
                          users[index].name,
                          style: TextStyle(fontSize: 15),
                        ),
                        trailing: Container(
                            height: 25,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromARGB(255, 57, 56, 56),
                            ),
                            child: Center(child: const LocaleText('follow')))),
                  ),
                )));
  }
}
