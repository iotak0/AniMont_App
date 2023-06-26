import 'dart:convert';
import 'package:anime_mont_test/Screens/Anime/anime_scrollview.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:anime_mont_test/widgets/search_results.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.myId});
  final int myId;
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
    results.clear();
    setState(() {});
    final response =
        await http.post(Uri.parse(search_Users), body: {'key': search.text});

    var body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      // isLoading = false;
      // complet = true;
      setState(() {});
      return;
    }
    setState(() {
      results.addAll(body.map<Result>(fromJson).toSet().toList());
    });
  }

  static Result fromJson(json) => Result(
      json['name'].toString(),
      json['username'],
      json['id'].toString(),
      json['avatar'],
      json['admin'].toString() == '0' ? false : true);
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
        return Result(name[index], type[index], urls[index],
            poster[index].replaceAll("(", '').replaceAll(")", ''), false);
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
  bool loading = false;

  searchAll() async {
    loading = true;
    setState(() {});
    if (loading && search.text.isNotEmpty) {
      await getUsers();
      await getWebsiteData(
          'https://animetitans.com/?s=${search.text.replaceAll(' ', '+').replaceAll('-', '+')}');
    }
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: customColors.backgroundColor,
        centerTitle: true,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: customColors.iconTheme,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => loading ? null : searchAll(),
                            child: Center(
                                child: SvgPicture.string(
                              '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Light-Outline/Search</title>
    <g id="Iconly/Light-Outline/Search" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
        <g id="Search" transform="translate(2.000000, 2.000000)" fill="#000000">
            <path d="M9.7388,8.8817842e-14 C15.1088,8.8817842e-14 19.4768,4.368 19.4768,9.738 C19.4768,12.2715459 18.5045194,14.5822774 16.9134487,16.3164943 L20.0442,19.4407 C20.3372,19.7337 20.3382,20.2077 20.0452,20.5007 C19.8992,20.6487 19.7062,20.7217 19.5142,20.7217 C19.3232,20.7217 19.1312,20.6487 18.9842,20.5027 L15.8156604,17.3430042 C14.1488713,18.6778412 12.0354764,19.477 9.7388,19.477 C4.3688,19.477 -0.0002,15.108 -0.0002,9.738 C-0.0002,4.368 4.3688,8.8817842e-14 9.7388,8.8817842e-14 Z M9.7388,1.5 C5.1958,1.5 1.4998,5.195 1.4998,9.738 C1.4998,14.281 5.1958,17.977 9.7388,17.977 C14.2808,17.977 17.9768,14.281 17.9768,9.738 C17.9768,5.195 14.2808,1.5 9.7388,1.5 Z" id="Combined-Shape"></path>
        </g>
    </g>
</svg>''',
                              height: 30,
                              color: customColors.primaryColor,
                            )),
                          ),
                          Expanded(
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: TextField(
                                    controller: search,
                                    autocorrect: true,
                                    textInputAction: TextInputAction.search,
                                    onEditingComplete: () {
                                      searchAll();
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    },
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                        color: customColors.primaryColor,
                                        fontSize: 13,
                                        fontFamily: 'SFPro',
                                      ),
                                      hintStyle: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'SFPro',
                                      ),
                                      border: InputBorder.none,
                                      hintText: context.localeString('search'),
                                    ),
                                    style: TextStyle(
                                      color: customColors.primaryColor,
                                      fontSize: 13,
                                      fontFamily:
                                          context.currentLocale.toString() ==
                                                  'ar'
                                              ? 'SFPro'
                                              : 'Angie',
                                    ))),
                          ),
                          search.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () => search.clear(),
                                  child: SizedBox(
                                      child: SvgPicture.string(
                                    '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Light-Outline/Close Square</title>
    <g id="Iconly/Light-Outline/Close-Square" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
        <g id="Close-Square" transform="translate(2.000000, 2.000000)" fill="#000000">
            <path d="M14.334,0 C17.723,0 20,2.378 20,5.916 L20,14.084 C20,17.622 17.723,20 14.333,20 L5.665,20 C2.276,20 0,17.622 0,14.084 L0,5.916 C0,2.378 2.276,0 5.665,0 L14.334,0 Z M14.334,1.5 L5.665,1.5 C3.135,1.5 1.5,3.233 1.5,5.916 L1.5,14.084 C1.5,16.767 3.135,18.5 5.665,18.5 L14.333,18.5 C16.864,18.5 18.5,16.767 18.5,14.084 L18.5,5.916 C18.5,3.233 16.864,1.5 14.334,1.5 Z M8.1305,7.0626 L9.998,8.93 L11.8645,7.0647 C12.1575,6.7717 12.6315,6.7717 12.9245,7.0647 C13.2175,7.3577 13.2175,7.8317 12.9245,8.1247 L11.058,9.99 L12.9265,11.8596 C13.2195,12.1526 13.2195,12.6266 12.9265,12.9196 C12.7805,13.0666 12.5875,13.1396 12.3965,13.1396 C12.2045,13.1396 12.0125,13.0666 11.8665,12.9196 L9.998,11.05 L8.1325,12.9167 C7.9865,13.0637 7.7945,13.1367 7.6025,13.1367 C7.4105,13.1367 7.2185,13.0637 7.0725,12.9167 C6.7795,12.6237 6.7795,12.1497 7.0725,11.8567 L8.938,9.99 L7.0705,8.1226 C6.7775,7.8296 6.7775,7.3556 7.0705,7.0626 C7.3645,6.7696 7.8385,6.7696 8.1305,7.0626 Z" id="Combined-Shape"></path>
        </g>
    </g>
</svg>''',
                                    height: 18,
                                    color: customColors.primaryColor,
                                  )),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
      body: results.isNotEmpty
          ? AllAnimes(
              myId: widget.myId,
              anime: results,
              controller: listController,
            )
          : (loading && results.isEmpty)
              ? LoadingGif(
                  logo: true,
                )
              : SizedBox(),
    );
  }
}

///////////////  conestens  ////////////////
class AllAnimes extends StatelessWidget {
  const AllAnimes({
    Key? key,
    required this.controller,
    required this.anime,
    required this.myId,
  }) : super(key: key);
  final int myId;
  final ScrollController controller;
  final List<Result> anime;

  @override
  Widget build(BuildContext context) {
    return SearchResults(
      myId: myId,
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
  bool admin = false;

  Result(this.name, this.sub, this.link, this.image, this.admin);
}
