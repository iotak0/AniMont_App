import 'dart:convert';
import 'package:anime_mont_test/Screens/Anime/anime_card.dart';
import 'package:anime_mont_test/Screens/Anime/anime_details_screen.dart';
import 'package:anime_mont_test/helper/constans.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:anime_mont_test/widgets/alart.dart';
import 'package:anime_mont_test/widgets/alart_internet.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home/Search/search_page.dart';

class AllMyAnime extends StatefulWidget {
  final String headLine;
  const AllMyAnime({Key? key, required this.headLine}) : super(key: key);

  @override
  State<AllMyAnime> createState() => AllMyAnimeState();
}

class AllMyAnimeState extends State<AllMyAnime> {
  int? myId;
  getMyId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString('userData');
    final user = json.decode(userPref!);
    myId = int.parse(user['id'].toString());
  }

  late List<Result> anime;
  List<Result> results = [];
  static bool isLoading = false;
  bool error = false;
  bool more = true;
  int page = 1;
  bool done = false;
  final listController = ScrollController();

  getMyAnime() async {
    setState(() {
      isLoading = true;
      error = false;
    });
    await getMyId();
    Response response = await http
        .get(Uri.parse(
            "$get_all_my_anime?user_id=${myId.toString()}&page=$page"))
        .catchError((error) {
      setState(() {
        isLoading = false;
        error = true;
      });
      return Response('error', 400);
    });

    if (response.statusCode == 200) {
      print(response.body);
      var data;
      try {
        data = jsonDecode(response.body);
      } catch (e) {
        setState(() {
          isLoading = false;
          done = true;
        });
      }
      setState(() {
        anime = List.generate(
            data.length,
            (index) => Result(
                data[index]['anime_name'],
                data[index]['anime_id'],
                data[index]['anime_url'],
                data[index]['anime_poster'],
                false));
        results.addAll(anime);
        if (data.length < 15) more = false;

        isLoading = false;
        done = true;
      });
    } else {
      setState(() {
        error = true;
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    isLoading = true;
    getMyId();
    getMyAnime();

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
        getMyAnime();
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
      body: isLoading && results.isEmpty
          ? LoadingGif(
              logo: true,
            )
          : error && results.isEmpty
              ? AlartInternet(onTap: () {
                  if (!isLoading) {
                    error = false;
                    more = true;
                    page = 1;
                    getMyAnime();
                  }
                })
              : (done && !isLoading && !error && results.isEmpty)
                  ? Alart(body: 'no_thing_to_see_here_yet', icon: favorite)
                  : AllGenresList(
                      myId: myId!,
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
                      AllMyAnimeState.isLoading
                          ? (anime.length + 1)
                          : anime.length, (index) {
                    return (index == anime.length)
                        ? LoadingGif(
                            logo: true,
                          )
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
