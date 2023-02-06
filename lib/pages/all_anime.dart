import 'package:anime_mont_test/pages/anime_player.dart';
import 'package:anime_mont_test/pages/search_page.dart';
import 'package:anime_mont_test/utils/anime_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

import '../utils/buttons/arrow_back_button.dart';

class AllAnime extends StatefulWidget {
  final String genre;
  final String headLine;
  const AllAnime({Key? key, required this.genre, required this.headLine})
      : super(key: key);

  @override
  State<AllAnime> createState() => _AllAnimeState();
}

class _AllAnimeState extends State<AllAnime> {
  late List<Result> anime;
  List<Result> animes = [];
  int page = 1;
  final listController = ScrollController();

  Future getWebsiteData(link) async {
    final url = Uri.parse(link);
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final type = html
        .querySelectorAll(
            ' #content > div > div.postbody > div.bixbox.bixboxarc.bbnofrm > div.mrgn > div.listupd > article > div > a > div.limit > div.bt > span')
        .map((e) => e.innerHtml.trim())
        .toList();

    final name = html
        .querySelectorAll(
            '  div.postbody > div.bixbox.bixboxarc.bbnofrm > div.mrgn > div.listupd > article> div > a > div.tt > h2')
        .map((e) => e.innerHtml.trim())
        .toList();
    final urls = html
        .querySelectorAll(
            '#content > div > div.postbody > div.bixbox.bixboxarc.bbnofrm > div.mrgn > div.listupd > article > div > a')
        .map((e) => e.attributes['href']!)
        .toList();
    final poster = html
        .querySelectorAll(
            ' div.postbody > div.bixbox.bixboxarc.bbnofrm > div.mrgn > div.listupd > article > div > a > div.limit > img')
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
      animes.addAll(anime);
      page += 1;
      //loadAnime();
      for (var element in animes) {
        print(element.name);
      }
    });
  }

  // int end = 20;
  // late List<Anime> animeList;
  // Future loadAnime() async {
  //   for (int i = page; i < end; i++) {
  //     int index = i;
  //     animeList.add(Anime(anime[index].poster, anime[index].name,
  //         anime[index].url, anime[index].type));
  //     if (i == end) {
  //       page += i;
  //       end += i;
  //     }
  //   }
  //   // https://i2.wp.com/animetitans.com/wp-content
  // }

  @override
  void initState() {
    super.initState();
    setState(() {
      getWebsiteData(
          'https://animetitans.com/anime/?genre%5B%5D=${widget.genre}');
    });
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        getWebsiteData(
            'https://animetitans.com/anime/?page=$page&genre%5B%5D=${widget.genre}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return animes.isNotEmpty
        ? Scaffold(
            backgroundColor: Color.fromARGB(255, 46, 45, 45),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ArrowBackButton(size: size),
                        buildTitle(widget.headLine.toUpperCase()),
                      ],
                    ),
                  ),
                  Expanded(
                      child: AllAnimes(
                    anime: anime,
                    controller: listController,
                  ))
                ]),
          )
        : Center(child: CircularProgressIndicator());
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
