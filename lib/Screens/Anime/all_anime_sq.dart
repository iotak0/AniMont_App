import 'package:anime_mont_test/Screens/Home/Search/search_page.dart';
import 'package:anime_mont_test/Screens/Anime/anime_details_screen.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/widgets/cust_appbar.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class AllAnimeSq extends StatefulWidget {
  final String genre;
  final int myId;

  const AllAnimeSq({
    super.key,
    required this.genre,
    required this.myId,
  });

  @override
  State<AllAnimeSq> createState() => _AllAnimeSqState();
}

class _AllAnimeSqState extends State<AllAnimeSq> {
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
                false
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
    return Scaffold(
        body: AllAnimeSqList(
      myId: widget.myId,
      title: widget.genre,
      anime: results,
      controller: listController,
    ));
  }
}

///////////////  conestens  ////////////////
class AllAnimeSqList extends StatelessWidget {
  const AllAnimeSqList({
    Key? key,
    required this.controller,
    required this.anime,
    required this.title,
    required this.myId,
  }) : super(key: key);

  final ScrollController controller;
  final String title;
  final int myId;
  final List<Result> anime;

  @override
  Widget build(BuildContext context) {
    CustomColors customColor = CustomColors(context);
    return ListView(
      controller: controller,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: CustAppBar(title: title, isLocalText: false),
        ),
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
                                    builder: (context) => AnimeDetailsScreen(
                                          myId: myId,
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
                                        color: customColor.iconTheme,
                                        borderRadius: BorderRadius.circular(14),
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              customColor.primaryColor,
                                              customColor.iconTheme,
                                            ])),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              bottom: 1.5, left: 8),
                                          child: Text(
                                            e.name,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    customColor.primaryColor),
                                            overflow: TextOverflow.ellipsis,
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
                                    borderRadius: BorderRadius.circular(14),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(e.image
                                          /*
                                                .replaceAll('i0.wp.com/', '')
                                                .replaceAll('i1.wp.com/', '')
                                                .replaceAll('i2.wp.com/', '')
                                                .replaceAll('i3.wp.com/', '')
                                                .replaceAll('i4.wp.com/', '')
                                                .replaceAll('i5.wp.com/', '')
                                                .replaceAll('i6.wp.com/', '')*/

                                          /* .replaceAll("/wp-content/",
                                                    "https://animetitans.com/wp-content/")
                                                .replaceAll(
                                                    'https://animetitans.comhttps://animetitans.com/wp-content/',
                                                    'https://animetitans.com/wp-content/')*/
                                          ),
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
    );
  }
}
