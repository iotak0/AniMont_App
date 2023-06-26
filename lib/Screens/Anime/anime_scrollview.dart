import 'dart:convert';
import 'package:anime_mont_test/Screens/Anime/anime_details_screen.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/widgets/alart_internet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AnimeScrollView extends StatefulWidget {
  const AnimeScrollView({
    Key? key,
    required this.size,
    required this.url,
    required this.myId,
  }) : super(key: key);
  final int myId;
  final Size size;
  final String url;

  @override
  State<AnimeScrollView> createState() => _AnimeScrollViewState();
}

class _AnimeScrollViewState extends State<AnimeScrollView> {
  bool error = false;
  List<Anime> anime = [];
  Future getWebsiteData2(String link) async {
    setState(() {
      error = false;
    });
    final url = Uri.parse(link);
    final response = await http.get(url).catchError((e) {
      error = true;
      setState(() {});
    });
    dom.Document html = dom.Document.html(response.body);
    var tybes = [];
    try {
      tybes = html
          .querySelectorAll(
              '> div > div.listupd.normal > div.excstf > article > div > a > div.limit > div.bt > span')
          .map((e) => e.innerHtml.trim())
          .toList();
    } catch (e) {
      print('Tybes Error $e');
    }

    var titles = [];
    try {
      titles = html
          .querySelectorAll(
              'div > div.listupd.normal > div.excstf > article > div > a > div.tt > h2')
          .map((e) => e.innerHtml.trim())
          .toList();
    } catch (e) {
      print('titles Error $e');
    }
    var urls = [];
    try {
      urls = html
          .querySelectorAll(
              ' div > div.listupd.normal > div.excstf > article > div > a')
          .map((e) => e.attributes['href']!)
          .toList();
    } catch (e) {
      print('urls Error $e');
    }
    var images = [];

    try {
      images = html
          .querySelectorAll(
              'div > div.listupd.normal > div.excstf > article > div > a > div.limit > img')
          .map((e) => e.attributes['src']!)
          .toList();
    } catch (e) {
      print('images Error $e');
      images = html
          .querySelectorAll(' article > div > a > div.limit > img')
          .map((e) => e.attributes['src']!)
          .toList();
    }

    setState(() {
      anime = List.generate(
          titles.length,
          (index) => Anime(
                images[index]
                    .replaceAll("(", '')
                    .replaceAll(")", '')
                    .replaceAll("(", '')
                    .replaceAll(")", '')
                    .replaceAll('i0.wp.com/', '')
                    .replaceAll('i1.wp.com/', '')
                    .replaceAll('i2.wp.com/', '')
                    .replaceAll('i3.wp.com/', '')
                    .replaceAll('i4.wp.com/', '')
                    .replaceAll('i5.wp.com/', '')
                    .replaceAll('i6.wp.com/', '')
                    .replaceAll(
                        "/wp-content/", "https://animetitans.net/wp-content/")
                    .replaceAll(
                        'https://animetitans.nethttps://animetitans.net/wp-content/',
                        'https://animetitans.net/wp-content/'),
                // .replaceAll("https://animetitans.com",
                //     "https://animetitans.com/wp-content/"),
                titles[index],
                urls[index],
                tybes[index].isNotEmpty ? tybes[index] : '',
              ));
      print(anime[0].poster);
    });
  }

  getWebsiteData(link) async {
    error = false;
    setState(() {});
    final url = Uri.parse(link);
    final response = await http.get(url).catchError((e) {
      error = true;
      setState(() {});
    });
    dom.Document html = dom.Document.html(utf8.decode(response.bodyBytes));

    var tybes = [];
    try {
      tybes = html
          .querySelectorAll(
              '#content > div > div.postbody > div.bixbox.bixboxarc.bbnofrm > div.mrgn > div.listupd > article > div > a > div.limit > div.bt > span')
          .map((e) => e.innerHtml.trim())
          .toList();
    } catch (e) {
      print('tybes Error $e');
    }

    var titles = [];
    try {
      titles = html
          .querySelectorAll(
              '#content > div > div.postbody > div.bixbox.bixboxarc.bbnofrm > div.mrgn > div.listupd > article > div > a')
          .map((e) => e.attributes['title']!)
          .toList();
    } catch (e) {
      print('titles Error $e');
    }
    var urls = [];
    try {
      urls = html
          .querySelectorAll(
              ' #content > div > div.postbody > div.bixbox.bixboxarc.bbnofrm > div.mrgn > div.listupd > article > div > a')
          .map((e) => e.attributes['href']!)
          .toList();
    } catch (e) {
      print('urls Error $e');
    }
    var images = [];
    try {
      images = html
          .querySelectorAll(
              '#content > div > div.postbody > div.bixbox.bixboxarc.bbnofrm > div.mrgn > div.listupd > article > div > a > div.limit > img')
          .map((e) => e.attributes['src']!)
          .toList();
    } catch (e) {
      print('images Error $e');
      images = html
          .querySelectorAll(' article > div > a > div.limit > img')
          .map((e) => e.attributes['src']!)
          .toList();
    }

    setState(() {
      // https://i2.wp.com/animetitans.com/wp-content/https://i2.wp.com/animetitans.com/wp-content/
      anime = List.generate(
          titles.length,
          (index) => Anime(
                images[index]
                    //fP4hcGqcQxKvrcVE-6fqLF:APA91bEw_ZRxnnJoMYAFAqa6jN5K7lY5wsA-RPqyUC-ix-rQJ1dWRdL82hfokLIv7vdABGx2fyKaJI9V1LaPekQEoRmjDfGQ8HyI8Ro_ej99SD1Zjb_50x_u2f4n3cXFicsLyZnC5q4H
                    .replaceAll("(", '')
                    .replaceAll(")", '')
                    .replaceAll('i0.wp.com/', '')
                    .replaceAll('i1.wp.com/', '')
                    .replaceAll('i2.wp.com/', '')
                    .replaceAll('i3.wp.com/', '')
                    .replaceAll('i4.wp.com/', '')
                    .replaceAll('i5.wp.com/', '')
                    .replaceAll('i6.wp.com/', '')
                    .replaceAll(
                        "/wp-content/", "https://animetitans.net/wp-content/")
                    .replaceAll(
                        'https://animetitans.nethttps://animetitans.net/wp-content/',
                        'https://animetitans.net/wp-content/'),
                titles[index],
                urls[index],
                tybes[index],
              ));

      print("////////////////////////////////////////////${anime[0].poster}");
      //eiUfxB2SQrSPX-kBaR2x7G:APA91bE1UpXzYpn-s9MyUs8YaH7UjbHwc5en1BW-B4GX72HmqzPeGkUIXiw2T5HjbBGjOCb3ZCs1QvtJnUgKZczwngG1jC_qEgw9AngB7O73Yjn3FcxFDbdM_KsFIH0J_z5_Uz0jsevl
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      //getWebsiteData2();
      getWebsiteData(widget.url);
    });
  }

//static final customCachManager= CacheManager(Config('customCachKey',stalePeriod:const Duration(days:15)));
  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    return Container(
        height: 220,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          scrollDirection: Axis.horizontal,
          child: (anime.isNotEmpty && !error)
              ? Row(
                  children: anime
                      .map((e) => Builder(builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AnimeDetailsScreen(
                                              myId: widget.myId,
                                              url: e.url,
                                            )));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          // filterQuality: FilterQuality.low,
                                          //cacheManager: customCachManager(),
                                          width: 150,
                                          height: 220,
                                          key: UniqueKey(),
                                          imageUrl: e.poster.toString(),
                                          fit: BoxFit.cover,
                                        )),
                                    Positioned(
                                      bottom: 0,
                                      height: 30,
                                      width: 150,
                                      child: Container(
                                        alignment: Alignment.bottomLeft,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black.withOpacity(.3),
                                                  Colors.black.withOpacity(.6),
                                                  Colors.black.withOpacity(.7),
                                                ]),
                                            borderRadius: BorderRadius.vertical(
                                                bottom: Radius.circular(10))),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 8),
                                        child: Text(
                                          e.name,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              shadows: [
                                                Shadow(
                                                    color:
                                                        customColors.bottomUp,
                                                    blurRadius: 1)
                                              ],
                                              fontFamily: 'SFPro',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }))
                      .toList(),
                )
              : (error && anime.isEmpty)
                  ? AlartInternet(onTap: (() => getWebsiteData(widget.url)))
                  : Row(
                      children: List.generate(
                      5,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Stack(
                          children: [
                            Shimmer.fromColors(
                                baseColor: customColors.iconTheme,
                                highlightColor: customColors.backgroundColor,
                                child: Container(
                                    width: 150,
                                    height: 220,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: customColors.iconTheme,
                                    ))),
                            Positioned(
                              bottom: 0,
                              child: Shimmer.fromColors(
                                baseColor: customColors.bottomDown,
                                highlightColor: customColors.iconTheme,
                                child: Container(
                                    height: 23,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(10)),
                                      color: customColors.iconTheme,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
        ));
  }
}

class Anime {
  final String poster;
  final String name;
  final String url;
  final String type;

  Anime(this.poster, this.name, this.url, this.type);
}

class Comments {
  final String avatar;
  final String userName;
  final String name;
  final String commnet;
  final String time;
  int likes;
  List<String> relpies;
  bool liked = false;
  bool fire = false;
  bool allReplies = false;

  Comments(this.avatar, this.userName, this.name, this.commnet, this.time,
      this.likes, this.relpies, this.liked, this.fire, this.allReplies);
}
