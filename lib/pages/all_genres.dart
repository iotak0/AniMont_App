import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

import 'anime_details_screen.dart';
import 'search_page.dart';

class AllGenres extends StatefulWidget {
  final String genre;

  const AllGenres({
    super.key,
    required this.genre,
  });

  @override
  State<AllGenres> createState() => _AllGenresState();
}

class _AllGenresState extends State<AllGenres> {
  late List<Result> anime;
  List<Result> results = [];

  int page = 1;
  final listController = ScrollController();

  @override
  getWebsiteData(searchKey) async {
    print('hhhhhhhhhhhhhh$searchKey');
    final url = Uri.parse(searchKey);

    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final type = html
        .querySelectorAll('article > div > a > div.limit > div.bt > span')
        .map((e) => e.innerHtml.trim())
        .toList();

    final name = html
        .querySelectorAll(' article> div > a > div.tt > h2')
        .map((e) => e.innerHtml.trim())
        .toList();
    final urls = html
        .querySelectorAll(' article > div > a')
        .map((e) => e.attributes['href']!)
        .toList();
    final poster = html
        .querySelectorAll(' article > div > a > div.limit > img')
        .map((e) => e.attributes['src']!)
        .toList();
    print('///////////////////////////$name');
    setState(() {
      // https://i2.wp.com/animetitans.com/wp-content/https://i2.wp.com/animetitans.com/wp-content/

      anime = List.generate(
          name.length,
          (index) => Result(
                name[index],
                type[index],
                urls[index],
                poster[index].replaceAll("(", '').replaceAll(")", ''),
              ));
      results.addAll(anime);
    });
  }

  @override
  void initState() {
    getWebsiteData(
        'https://animetitans.com/anime/?genre%5B0%5D=${widget.genre.replaceAll(' ', '+').replaceAll('-', '+')}');

    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        page++;
        print('page$page');

        getWebsiteData(
            'https://animetitans.com/anime/?page=$page&genre%5B0%5D=${widget.genre.replaceAll(' ', '+').replaceAll('-', '+')}');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconTheme = Theme.of(context).iconTheme.color!;
    final Color textColor = Color.fromARGB(255, 160, 146, 167);
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color bottomUp = Theme.of(context).primaryColorDark;
    final Color bottomDown = Theme.of(context).primaryColorLight;
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: AllGenresList(
      anime: results,
      controller: listController,
    ));
  }
}

///////////////  conestens  ////////////////
class AllGenresList extends StatelessWidget {
  const AllGenresList({
    Key? key,
    required this.controller,
    required this.anime,
  }) : super(key: key);

  final ScrollController controller;
  final List<Result> anime;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconTheme = Theme.of(context).iconTheme.color!;
    final Color textColor = Color.fromARGB(255, 160, 146, 167);
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color bottomUp = Theme.of(context).primaryColorDark;
    final Color bottomDown = Theme.of(context).primaryColorLight;
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Container(child: Text("Gen....")),
        ),
        SizedBox(
          height: size.height - 50,
          child: ListView(
            controller: controller,
            children: [
              SizedBox(
                width: double.infinity,
                child: Wrap(
                    spacing: 8,
                    alignment: WrapAlignment.center,
                    children: anime.map((e) {
                      int idx = anime.indexOf(e);
                      return Builder(builder: (context) {
                        return idx != anime.length - 1
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AnimeDetailsScreen(
                                                url: e.link,
                                              )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Stack(
                                    children: [
                                      Container(
                                          width: 110,
                                          height: 210,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    primaryColor,
                                                    iconTheme,
                                                  ])),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    bottom: 1.5, left: 8),
                                                child: Text(
                                                  e.name,
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          )),
                                      Container(
                                        width: 110,
                                        height: 190,
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 24),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(e.image
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
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              );
                      });
                    }).toList()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
