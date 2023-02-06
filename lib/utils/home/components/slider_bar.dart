import 'package:anime_mont_test/pages/anime_player.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

import '../../constes.dart';

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
  List<Article> articles = [];
  @override
  void initState() {
    super.initState();
    getWebsiteData2();
  }

  Future getWebsiteData2() async {
    final url = Uri.parse('https://animetitans.com');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

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
      articles = List.generate(
          titles.length,
          (index) => Article(titles[index], tybes[index], urls[index],
              images[index].replaceAll("(", '').replaceAll(")", '')));
      print("aaaaaaaaaaaaaaaaaaaaaaaaa$articles");
      print("jjjjjjjjjjjjjjjjjjj$titles");
    });
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: articles
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
                        width: widget.size.width,
                        padding: const EdgeInsets.only(left: 10, bottom: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(e.poster),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [lightPurple2, darkPurple2])),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: widget.size.width,
                              padding:
                                  const EdgeInsets.only(bottom: 8, left: 8),
                              child: Text(
                                e.name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 8, bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    Icons.tv,
                                    color: textColor,
                                  ),
                                  Text(
                                    e.score,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }))
          .toList(),
      options: CarouselOptions(autoPlay: true, enlargeCenterPage: true),
    );
  }
}
