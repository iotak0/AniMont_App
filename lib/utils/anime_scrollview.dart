import 'dart:convert';
import 'package:anime_mont_test/utils/scro2.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:anime_mont_test/pages/anime_player.dart';
import 'package:anime_mont_test/server/server_php.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../pages/anime_details_screen.dart';
import '../pages/animeinfo.dart';

class AnimeScrollView extends StatefulWidget {
  const AnimeScrollView({
    Key? key,
    required this.size,
    required this.url,
  }) : super(key: key);

  final Size size;
  final String url;

  @override
  State<AnimeScrollView> createState() => _AnimeScrollViewState();
}

class _AnimeScrollViewState extends State<AnimeScrollView> {
  List<Anime> anime = [];
  Future getWebsiteData2(String link) async {
    final url = Uri.parse(link);
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    var tybes = [];
    try {
      tybes = html
          .querySelectorAll(
              '> div > div.listupd.normal > div.excstf > article > div > a > div.limit > div.bt > span')
          .map((e) => e.innerHtml.trim())
          .toList();
    } catch (e) {
      print('Tybes Error $e');
    }

    var titles = [];
    try {
      titles = html
          .querySelectorAll(
              'div > div.listupd.normal > div.excstf > article > div > a > div.tt > h2')
          .map((e) => e.innerHtml.trim())
          .toList();
    } catch (e) {
      print('titles Error $e');
    }
    var urls = [];
    try {
      urls = html
          .querySelectorAll(
              ' div > div.listupd.normal > div.excstf > article > div > a')
          .map((e) => e.attributes['href']!)
          .toList();
    } catch (e) {
      print('urls Error $e');
    }
    var images = [];

    try {
      images = html
          .querySelectorAll(
              'div > div.listupd.normal > div.excstf > article > div > a > div.limit > img')
          .map((e) => e.attributes['src']!)
          .toList();
    } catch (e) {
      print('images Error $e');
    }

    setState(() {
      anime = List.generate(
          titles.length,
          (index) => Anime(
                images[index]
                    .replaceAll("(", '')
                    .replaceAll(")", '')
                    .replaceAll("https://animetitans.com",
                        "https://animetitans.com/wp-content/"),
                titles[index],
                urls[index],
                tybes[index].isNotEmpty ? tybes[index] : '',
              ));
      print(anime);
    });
  }

  Future getWebsiteData(link) async {
    final url = Uri.parse(link);
    final response = await http.get(url);
    dom.Document html = dom.Document.html(utf8.decode(response.bodyBytes));

    var tybes = [];
    try {
      tybes = html
          .querySelectorAll(
              '#content > div > div.postbody > div.bixbox.bixboxarc.bbnofrm > div.mrgn > div.listupd > article > div > a > div.limit > div.bt > span')
          .map((e) => e.innerHtml.trim())
          .toList();
    } catch (e) {
      print('tybes Error $e');
    }

    var titles = [];
    try {
      titles = html
          .querySelectorAll(
              '#content > div > div.postbody > div.bixbox.bixboxarc.bbnofrm > div.mrgn > div.listupd > article > div > a')
          .map((e) => e.attributes['title']!)
          .toList();
    } catch (e) {
      print('titles Error $e');
    }
    var urls = [];
    try {
      urls = html
          .querySelectorAll(
              ' #content > div > div.postbody > div.bixbox.bixboxarc.bbnofrm > div.mrgn > div.listupd > article > div > a')
          .map((e) => e.attributes['href']!)
          .toList();
    } catch (e) {
      print('urls Error $e');
    }
    var images = [];
    try {
      images = html
          .querySelectorAll(
              '#content > div > div.postbody > div.bixbox.bixboxarc.bbnofrm > div.mrgn > div.listupd > article > div > a > div.limit > img')
          .map((e) => e.attributes['src']!)
          .toList();
    } catch (e) {
      print('images Error $e');
    }

    setState(() {
      // https://i2.wp.com/animetitans.com/wp-content/https://i2.wp.com/animetitans.com/wp-content/
      anime = List.generate(
          titles.length,
          (index) => Anime(
                images[index].replaceAll("(", '').replaceAll(")", ''),
                // .replaceAll(
                //     "https://i2.wp.com/animetitans.com/wp-content/https://i3.wp.com/animetitans.com/wp-content/",
                //     "https://i0.wp.com/animetitans.com/wp-content/"),
                titles[index],
                urls[index],
                tybes[index],
              ));
      print("////////////////////////////////////////////$images");
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      //getWebsiteData2();
      getWebsiteData(widget.url);
    });
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Color iconTheme = Theme.of(context).iconTheme.color!;
    Color textColor = Color.fromARGB(255, 160, 146, 167);
    Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Size size = MediaQuery.of(context).size;
    Color bottomUp = Theme.of(context).primaryColorDark;
    Color bottomDown = Theme.of(context).primaryColorLight;
    return Container(
        height: 220,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          scrollDirection: Axis.horizontal,
          child: anime.isNotEmpty
              ? Row(
                  children: anime
                      .map((e) => Builder(builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AnimeDetailsScreen(
                                              url: e.url,
                                            )));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 150,
                                      height: 220,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: iconTheme),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 8, left: 8),
                                            child: Text(
                                              e.name,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: primaryColor),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 150,
                                      height: 190,
                                      padding: const EdgeInsets.only(
                                          left: 10, bottom: 24),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(e.poster
                                              .replaceAll('i0.wp.com/', '')
                                              .replaceAll('i1.wp.com/', '')
                                              .replaceAll('i2.wp.com/', '')
                                              .replaceAll('i3.wp.com/', '')
                                              .replaceAll('i4.wp.com/', '')
                                              .replaceAll('i5.wp.com/', '')
                                              .replaceAll('i6.wp.com/', '')

                                              //https://i2.wp.com/animetitans.comhttps://animetitans.com/wp-content/
                                              // https://animetitans.com/wp-content//Blue-Lock-
                                              .replaceAll("/wp-content/",
                                                  "https://animetitans.com/wp-content/")
                                              .replaceAll(
                                                  'https://animetitans.comhttps://animetitans.com/wp-content/',
                                                  'https://animetitans.com/wp-content/')),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }))
                      .toList(),
                )
              : Row(
                  children: List.generate(
                  5,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Stack(
                      children: [
                        Shimmer.fromColors(
                            baseColor: iconTheme,
                            highlightColor: backgroundColor,
                            child: Container(
                                width: 150,
                                height: 220,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: iconTheme,
                                ))),
                        Positioned(
                          bottom: 0,
                          child: Shimmer.fromColors(
                            baseColor: bottomDown,
                            highlightColor: iconTheme,
                            child: Container(
                                height: 23,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(25),
                                      bottomRight: Radius.circular(25)),
                                  color: iconTheme,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
        ));
  }
}

class Anime {
  final String poster;
  final String name;
  final String url;
  final String type;

  Anime(this.poster, this.name, this.url, this.type);
}

class Comments {
  final String avatar;
  final String userName;
  final String name;
  final String commnet;
  final String time;
  int likes;
  List<String> relpies;
  bool liked = false;
  bool fire = false;
  bool allReplies = false;

  Comments(this.avatar, this.userName, this.name, this.commnet, this.time,
      this.likes, this.relpies, this.liked, this.fire, this.allReplies);
}
