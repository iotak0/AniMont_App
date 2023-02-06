import 'dart:convert';

import 'package:anime_mont_test/pages/profial_screen.dart';
import 'package:anime_mont_test/pages/search_users.dart';
import 'package:anime_mont_test/widget/search_results.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:anime_mont_test/utils/anime_scrollview.dart';
import '../server/urls_php.dart';
import '../utils/buttons/arrow_back_button.dart';
import '../utils/home/components/search_bar.dart';
import 'anime_details_screen.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static TextEditingController search = TextEditingController();
  late List<Result> anime;
  late List<Anime> users;
  List<Result> results = [];

  int page = 1;
  final listController = ScrollController();

  //final listController = ScrollController();

  // Future getWebsiteData(searchKey) async {
  Future getUsers() async {
    try {
      results.clear();
      setState(() {});
    } catch (e) {}
    print("jjjjjjjjjjjjjjjjj");
    //users.clear();
    final response =
        await http.post(Uri.parse(search_Users), body: {'key': search.text});
    final body = json.decode(response.body);
    // user = List.generate(
    //     10,
    //     (i) => Users(body[i]['name'].toString(), body[i]['username'],
    //         body[i]['avatar']));

    setState(() {
      results.addAll(body.map<Result>(fromJson).toSet().toList());
    });
    //loadAnime();
  }

  static Result fromJson(json) => Result(json['name'].toString(),
      json['username'], json['id'].toString(), json['avatar']);
  @override
  Future getWebsiteData(searchKey) async {
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
    print('///////////////////////////$poster');
    setState(() {
      // https://i2.wp.com/animetitans.com/wp-content/https://i2.wp.com/animetitans.com/wp-content/

      anime = List.generate(name.length, (index) {
        print("Image ${image}");
        return Result(
          name[index],
          type[index],
          urls[index],
          poster[index].replaceAll("(", '').replaceAll(")", ''),
        );
      });
      results.addAll(anime.toSet());

      //loadAnime();
      for (var element in results) {
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
    /* For User Search 
    getUsers().then((value) => setState(() {}));
  getUsers(key) async {
    final response =
        await http.post(Uri.parse(search_Users), body: {'key': key});
    final body = json.decode(response.body);

    try {} catch (e) {}
   */
    search.addListener(() {
      if (search.text.isNotEmpty) {
        setState(() {
          try {
            results.clear();
          } catch (e) {
            print('AnimeList Error $e');
          }
          print('kkkk${search.text} page page+= 1;');
          getUsers();
          getWebsiteData(
              'https://animetitans.com/?s=${search.text.replaceAll(' ', '+').replaceAll('-', '+')}');
        });
      } else {
        setState(() {
          page += 1;

          print('page$page');

          results.clear();
        });
      }
    });

    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        setState(() {
          page++;
        });
        print('page$page');

        print('page$page');
        getWebsiteData(
            'https://animetitans.com/page/$page/?s=${search.text.replaceAll(' ', '+').replaceAll('-', '+')}');
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
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 0, top: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                    onTap: () =>
                        FocusScope.of(context).requestFocus(FocusNode()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 7),
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          color: iconTheme,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              SizedBox(
                                  child: Image.asset(
                                'images/Light/Search.png',
                                height: 30,
                                color: primaryColor,
                              )),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: TextField(
                                        controller: search,
                                        autocorrect: true,
                                        decoration: InputDecoration(
                                          labelStyle: TextStyle(
                                            color: primaryColor,
                                            fontSize: 13,
                                            fontFamily: context.currentLocale
                                                        .toString() ==
                                                    'ar'
                                                ? 'SFPro'
                                                : 'Angie',
                                          ),
                                          hintStyle: TextStyle(
                                            fontSize: 13,
                                            fontFamily: context.currentLocale
                                                        .toString() ==
                                                    'ar'
                                                ? 'SFPro'
                                                : 'Angie',
                                          ),
                                          border: InputBorder.none,
                                          hintText:
                                              context.localeString('search'),
                                        ),
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 13,
                                          fontFamily: context.currentLocale
                                                      .toString() ==
                                                  'ar'
                                              ? 'SFPro'
                                              : 'Angie',
                                        ))),
                              ),
                              search.text.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () => search.clear(),
                                      child: SizedBox(
                                          child: Image.asset(
                                        'images/Light/Delete.png',
                                        height: 18,
                                        color: primaryColor,
                                      )),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
        results.isNotEmpty
            ? Expanded(
                child: AllAnimes(
                anime: results,
                controller: listController,
              ))
            : search.text.isNotEmpty
                ? Center(child: CircularProgressIndicator())
                : Container()
      ]),
    );
  }
}

///////////////  conestens  ////////////////
class AllAnimes extends StatelessWidget {
  const AllAnimes({
    Key? key,
    required this.controller,
    required this.anime,
  }) : super(key: key);

  final ScrollController controller;
  final List<Result> anime;

  @override
  Widget build(BuildContext context) {
    return SearchResults(
      isAnime: true,
      list: anime,
      listController: controller,
    );
  }
}

class Result {
  final String name;
  final String sub;
  final String link;
  final String image;

  Result(this.name, this.sub, this.link, this.image);
}
