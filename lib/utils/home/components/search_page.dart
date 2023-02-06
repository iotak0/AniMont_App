import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../../pages/animeinfo.dart';
import '../../buttons/arrow_back_button.dart';
import '../../constes.dart';
import '../../loading.dart';

class SearchPage extends StatefulWidget {
  final String search;
  const SearchPage({super.key, required this.search});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Article> articles = [];
  List dataInfo = [];
  @override
  void initState() {
    super.initState();
    getWebsiteData(widget.search.replaceAll(' ', '+').replaceAll('-', '+'));
  }

  Future getWebsiteData(searchKey) async {
    final url = Uri.parse('https://animetitans.com/?s=$searchKey');
    print('urllllllllllllllllllllllllllllll $url');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final tybes = html
        .querySelectorAll(
            '#content > div > div.postbody > div > div.listupd > article > div > a > div.limit > div.bt > span')
        .map((e) => e.innerHtml.trim())
        .toList();

    final titles = html
        .querySelectorAll(
            '#content > div > div.postbody > div > div.listupd > article > div > a > div.tt > h2')
        .map((e) => e.innerHtml.trim())
        .toList();
    final urls = html
        .querySelectorAll(
            '#content > div > div.postbody > div > div.listupd > article > div > a')
        .map((e) => e.attributes['href']!)
        .toList();
    final images = html
        .querySelectorAll(
            '#content > div > div.postbody > div > div.listupd > article > div > a > div.limit > img')
        .map((e) => e.attributes['src']!)
        .toList();

    setState(() {
      articles = List.generate(
          titles.length,
          (index) =>
              Article(titles[index], tybes[index], urls[index], images[index]));
      print("aaaaaaaaaaaaaaaaaaaaaaaaa$articles");
      print("jjjjjjjjjjjjjjjjjjj$titles");
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (articles.isEmpty) {
      return  Loading(size: size);
    } else {
      return Scaffold(
        backgroundColor: darkPurple,
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 3),
          clipBehavior: Clip.hardEdge,
          physics: const ScrollPhysics(),
          //scrollDirection: Axis.horizontal,
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: ArrowBackButton(size: size),
                ),
                buildTitle('Search'),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Wrap(
                  runSpacing: size.height / 35,
                  alignment: WrapAlignment.spaceEvenly,
                  children: articles
                      .map((e) => Builder(builder: (context) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AnimeInfo(
                                              url: e.url,
                                            )));
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: size.width / 3,
                                    height: size.height / 4,
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 24),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(e.poster),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: size.width / 3,
                                    height: size.height / 4,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        gradient: const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              lightPurple2,
                                              darkPurple2
                                            ])),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          e.score,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(
                                              bottom: 8, left: 8),
                                          child: Text(
                                            e.name,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
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
                ),
              ),
            ),
          ]),
        ),
      );
    }
  }
}

Padding buildTitle(String context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(context,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
