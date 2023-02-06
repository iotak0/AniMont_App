import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../pages/all_anime.dart';
import '../../anime_scrollview.dart';
import '../../constes.dart';
import '../../search_bar.dart';
import '../../slider_bar.dart';
import 'all_anime_slider.dart';
import 'category_bar.dart';
import 'header.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        },
        child: Scaffold(
            backgroundColor: darkPurple,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // header
                  HomeHeader(size: size),
                  // search bar
                  SearchBar(size: size),
                  // category bar
                  CategoryBar(size: size),
                  // title
                  // buildTitle(
                  //     'NEW EP ADDED',
                  // AllAnime(
                  //   link:
                  //       'https://animetitans.com/anime/?status=ongoing&type=tv&sub=&order=latest',
                  //   headLine: 'NEW EP ADDED',
                  //  ),
                  // size),
                  // slider
                  SliderBar(size: size),
                  // buildTitle(
                  //     'RECENTLY UPDATED',size),
                  // AllAnime(
                  //   link: 'https://animetitans.com/anime/?order=update',
                  //   headLine: 'RECENTLY UPDATED',
                  // ),
                  //size),
                  // RECENTLY UPDATED
                  // AnimeScrollView(url: ,
                  //   size: size,
                  // ),
                  // buildTitle(
                  //     'Movies',
                  //     AllAnime(
                  //         link:
                  //             'https://animetitans.com/anime/?status=&type=Movie&order=update',
                  //         headLine: 'Movies'),
                  //     size),
                  AllAnimeSlider(
                      size: size,
                      link:
                          'https://animetitans.com/anime/?status=&type=Movie&order=update'),
                  SizedBox(
                    height: 20,
                  ),
                  Text(" ")
                ],
              ),
            )));
  }

  Padding buildTitle(String context1, var page, Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(context1,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => page)),
            child: SeeAll(
              size: size,
            ),
          ),
        ],
      ),
    );
  }
}

class SeeAll extends StatelessWidget {
  const SeeAll({
    Key? key,
    required this.size,
  }) : super(key: key);
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      width: size.height / 30,
      height: size.height / 30,
      decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            darkPurple2,
            lightPink,
          ]),
          borderRadius: BorderRadius.circular(10)),
      child: const ImageIcon(
        AssetImage("images/Arrow-Right-Square.png"),
        color: Colors.white,
        size: 12,
      ),
    );
  }
}
