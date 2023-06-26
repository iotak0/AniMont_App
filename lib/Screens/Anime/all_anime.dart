import 'package:anime_mont_test/Screens/Anime/anime_card.dart';
import 'package:anime_mont_test/Screens/Home/Search/search_page.dart';
import 'package:anime_mont_test/Screens/Anime/anime_details_screen.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/widgets/alart_internet.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class AllAnime extends StatefulWidget {
  final String genre;
  final String headLine;
  final int myId;
  const AllAnime(
      {Key? key,
      required this.genre,
      required this.headLine,
      required this.myId})
      : super(key: key);

  @override
  State<AllAnime> createState() => AllAnimeState();
}

class AllAnimeState extends State<AllAnime> {
  late List<Result> anime;
  List<Result> results = [];
  static bool isLoading = false;
  bool error = false;
  bool more = true;
  int page = 1;
  final listController = ScrollController();

  @override
  getWebsiteData(searchKey) async {
    print('hhhhhhhhhhhhhh$searchKey');
    final url = Uri.parse(searchKey);

    final response = await http.get(url).catchError((e) {
      setState(() {
        isLoading = false;
        error = true;
      });
    }).then((value) {
      try {
        dom.Document html = dom.Document.html(value.body);

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
                    poster[index].replaceAll("(", '').replaceAll(")", ''),false
                  ));
          results.addAll(anime);
          if (name.length < 30) more = false;

          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    isLoading = true;
    getWebsiteData(
        'https://animetitans.com/anime/?${widget.genre.replaceAll(' ', '+').replaceAll('_', '+')}');

    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset &&
          more &&
          isLoading == false) {
        setState(() {
          isLoading = true;
          error = false;
        });
        page++;
        print('page$page');
        getWebsiteData(
            'https://animetitans.com/anime/?page=$page&${widget.genre.replaceAll(' ', '+').replaceAll('-', '+').replaceAll('_', '+')}');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColor = CustomColors(context);
    return Scaffold(
      appBar: AppBar(
    leading: GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Icon(
        Icons.arrow_back_ios_new,
        color: customColor.primaryColor,
      ),
    ),
    backgroundColor: customColor.backgroundColor,
    elevation: 1,
    title: LocaleText(
      widget.headLine,
      style: TextStyle(
          fontFamily: 'SFPro',
          fontWeight: FontWeight.bold,
          color: customColor.primaryColor),
    ),
      ),
      body: (isLoading && results.isEmpty && !error)
      ? (results.isEmpty && 1 == 0)
          ? Center(
              child: SvgPicture.string(
                '<svg id="Слой_1" data-name="Слой 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 868.5 778.07"><defs></defs><path class="cls-1" d="M878.5,887H541.61c-42.94,0-69.77-46.48-48.31-83.67L661.75,511.58,830.2,219.82c21.46-37.18,75.14-37.18,96.6,0l168.45,291.76L1263.7,803.33c21.46,37.19-5.37,83.67-48.31,83.67Z" transform="translate(-444.25 -150.43)"/><ellipse class="cls-2" cx="434.28" cy="590.89" rx="36.5" ry="28.31"/><path class="cls-2" d="M894.63,696.36H864.57L835.79,375.91a6.16,6.16,0,0,1,1.45-4.46c20.52-25.48,61.21-26.67,81.64.07a6.26,6.26,0,0,1,1.35,4.27Z" transform="translate(-444.25 -150.43)"/></svg>',
                height: 50,
                width: 50,
                color: customColor.bottomDown,
              ),
            )
          : LoadingGif(logo: true,)
      : (error)
          ? Center(
              child: AlartInternet(onTap: () {
                if (!isLoading) {
                  error = false;
                  more = true;
                  page = 1;
                  getWebsiteData(
                      'https://animetitans.com/anime/?page=$page&genre%5B0%5D=${widget.genre.replaceAll(' ', '+').replaceAll('-', '+')}');
                }
              }),
            )
          : AllGenresList(
              myId: widget.myId,
              anime: results,
              controller: listController,
            ),
    );
  }
}

/**i == anime.length - 1
                          ? LoadingGif()
                          : */
///////////////  conestens  ////////////////
class AllGenresList extends StatelessWidget {
  const AllGenresList({
    Key? key,
    required this.controller,
    required this.anime,
    required this.myId,
  }) : super(key: key);

  final ScrollController controller;
  final int myId;
  final List<Result> anime;

  @override
  Widget build(BuildContext context) {
    CustomColors customColor = CustomColors(context);
    final Size size = MediaQuery.of(context).size;
    return ListView(
        padding: const EdgeInsets.symmetric(vertical: 15),
        controller: controller,
        children: [
          SizedBox(
              width: double.infinity,
              child: Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.center,
                  children: List.generate(
                      AllAnimeState.isLoading
                          ? (anime.length + 1)
                          : anime.length, (index) {
                    return (index == anime.length)
                        ? LoadingGif(logo: true,)
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AnimeDetailsScreen(
                                            myId: myId,
                                            url: anime[index].link,
                                          )));
                            },
                            child: AnimeCard(
                                rusult: anime[index],
                                customColor: customColor));
                  })))
        ]);
  }
}
