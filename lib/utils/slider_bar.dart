import 'dart:convert';

import 'package:anime_mont_test/pages/anime_player.dart';
import 'package:anime_mont_test/utils/anime_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';

class SliderBar extends StatefulWidget {
  const SliderBar({
    Key? key,
    required this.size,
  }) : super(key: key);
  final Size size;

  @override
  State<SliderBar> createState() => _SliderBarState();
}

class _SliderBarState extends State<SliderBar> {
  List<Anime> anime = [];
  @override
  void initState() {
    super.initState();
    getWebsiteData2();
  }

  Future getWebsiteData2() async {
    final url = Uri.parse('https://animetitans.com');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(utf8.decode(response.bodyBytes));

    final tybes = html
        .querySelectorAll(
            '> div > div.listupd.normal > div.excstf > article > div > a > div.limit > div.bt > span')
        .map((e) => e.innerHtml.trim())
        .toList();

    final titles = html
        .querySelectorAll(
            'div > div.listupd.normal > div.excstf > article > div > a > div.tt > h2')
        .map((e) => e.innerHtml.trim())
        .toList();
    final urls = html
        .querySelectorAll(
            ' div > div.listupd.normal > div.excstf > article > div > a')
        .map((e) => e.attributes['href']!)
        .toList();
    final images = html
        .querySelectorAll(
            'div > div.listupd.normal > div.excstf > article > div > a > div.limit > img')
        .map((e) => e.attributes['src']!)
        .toList();

    setState(() {
      anime = List.generate(
          titles.length,
          (index) => Anime(
                images[index].replaceAll("(", '').replaceAll(")", ''),
                titles[index],
                urls[index],
                tybes[index],
              ));
      print(anime);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconTheme = Theme.of(context).iconTheme.color!;
    final Color textColor = Color.fromARGB(255, 160, 146, 167);
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color bottomUp = Theme.of(context).primaryColorDark;
    final Color bottomDown = Theme.of(context).primaryColorLight;
    return anime.isNotEmpty
        ? CarouselSlider(
            items: anime
                .map((e) => Builder(builder: (context) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AnimePlayer(
                                      quality: '240',
                                      url: e.url,
                                    ))),
                        child: Stack(
                          children: [
                            Container(
                              height: 205,
                              width: widget.size.width,
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 0),
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
                                            'https://animetitans.com/wp-content/'))),
                              ),
                            ),
                            Container(
                              height: 230,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color.fromARGB(166, 0, 0, 0),
                                        Colors.transparent,
                                        Colors.transparent,
                                        Colors.transparent,
                                        Colors.transparent,
                                        Colors.transparent,
                                        Color.fromARGB(83, 161, 157, 157),
                                      ])),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 8, top: 5, right: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.tv,
                                          color: Colors.grey.shade300,
                                        ),
                                        Text(
                                          e.type,
                                          style: TextStyle(
                                              color: Colors.grey.shade300,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(child: Text('')),
                                  Container(
                                    width: widget.size.width,
                                    padding: const EdgeInsets.only(
                                        bottom: 2, left: 8),
                                    child: Text(
                                      e.name,
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }))
                .toList(),
            options: CarouselOptions(autoPlay: true, enlargeCenterPage: true),
          )
        : CarouselSlider(
            items: List.generate(
              3,
              (index) => Stack(
                children: [
                  Container(
                    height: 205,
                    width: widget.size.width,
                    padding: const EdgeInsets.only(left: 10, bottom: 0),
                    decoration: BoxDecoration(
                      color: iconTheme,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  Container(
                    height: 230,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 10, top: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Shimmer.fromColors(
                                baseColor: bottomDown,
                                highlightColor: iconTheme,
                                child: Container(
                                  height: 15,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: bottomDown,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor: bottomDown,
                                highlightColor: iconTheme,
                                child: Container(
                                  height: 15,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: bottomDown,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(child: Text('')),
                        Container(
                            padding: const EdgeInsets.only(
                                bottom: 2, left: 8, top: 2),
                            height: 23,
                            width: widget.size.width / 3.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25)),
                              color: iconTheme,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            options: CarouselOptions(autoPlay: true, enlargeCenterPage: true));
  }
}
