import 'dart:convert';
import 'package:anime_mont_test/Screens/Anime/anime_scrollview.dart';
import 'package:anime_mont_test/Screens/Player/video_page.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/server/ads.dart';
import 'package:anime_mont_test/widgets/alart_internet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';

class SliderBar extends StatefulWidget {
  const SliderBar({
    Key? key,
    required this.size,
    required this.myId,
  }) : super(key: key);
  final Size size;
  final int myId;
  @override
  State<SliderBar> createState() => _SliderBarState();
}

class _SliderBarState extends State<SliderBar> {
  bool error = false;
  List<Anime> anime = [];
  //RewardedAd? rewardedAd;

  // TODO: Add _interstitialAd
  InterstitialAd? _interstitialAd;

  // TODO: Implement _loadInterstitialAd()
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.intersAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
             // Navigator.pop(context);
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //AllAds.createRewardedAd().then((value) => rewardedAd = value);
    _loadInterstitialAd();

    getWebsiteData2();
  }

  Future getWebsiteData2() async {
    // _interstitialAd?.show();
    error = false;
    setState(() {});
    final url = Uri.parse('https://animetitans.com');
    final response = await http.get(url).catchError((e) {
      error = true;
      setState(() {});
    });
    dom.Document html = dom.Document.html(utf8.decode(response.bodyBytes));

    final tybes = html
        .querySelectorAll(
            '> div > div.listupd.normal > div.excstf > article > div > a > div.limit > div.bt > span')
        .map((e) => e.innerHtml.trim())
        .toList();

    final titles = html
        .querySelectorAll(
            'div > div.listupd.normal > div.excstf > article > div > a > div.tt > h2')
        .map((e) => e.innerHtml.trim())
        .toList();
    final urls = html
        .querySelectorAll(
            ' div > div.listupd.normal > div.excstf > article > div > a')
        .map((e) => e.attributes['href']!)
        .toList();
    final images = html
        .querySelectorAll(
            'div > div.listupd.normal > div.excstf > article > div > a > div.limit > img')
        .map((e) => e.attributes['src']!)
        .toList();

    setState(() {
      anime = List.generate(
          titles.length,
          (index) => Anime(
                images[index].replaceAll("(", '').replaceAll(")", ''),
                titles[index],
                urls[index],
                tybes[index],
              ));
      print(anime);
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomColors colors = CustomColors(context);
    return (error && anime.isEmpty)
        ? AlartInternet(onTap: getWebsiteData2)
        : (anime.isNotEmpty && !error)
            ? CarouselSlider(
                items: anime
                    .map((e) => Builder(builder: (context) {
                          String name = e.name;
                          String type = e.type;
                          try {
                            name =
                                e.name.substring(0, e.name.indexOf('الحلقة'));
                          } catch (e) {}
                          try {
                            name = e.name.substring(0, e.name.indexOf('الفلم'));
                          } catch (e) {}

                          try {
                            type = type.replaceAll(
                                'الحلقة',
                                context.currentLocale!.languageCode == 'en'
                                    ? 'Ep'
                                    : 'الحلقة');
                          } catch (e) {}
                          try {
                            type = type.replaceAll(
                                'الفلم',
                                context.currentLocale!.languageCode == 'en'
                                    ? 'Movie'
                                    : 'الفلم');
                          } catch (e) {}

                          return GestureDetector(
                            onTap: () {
                              // await RewardedAd.load(
                              //     adUnitId: AdHelper.rewardedAdUnitId,
                              //     rewardedAdLoadCallback:
                              //         RewardedAdLoadCallback(
                              //       onAdLoaded: (RewardedAd ad) async {
                              //         print(
                              //           'RewardedAd loaded',
                              //         );
                              //         this.rewardedAd = ad;
                              //         await rewardedAd!.show(
                              //             onUserEarnedReward: (ad, reward) {});
                              //       },
                              //       onAdFailedToLoad: (LoadAdError error) {
                              //         //createBannerAd();
                              //       },
                              //     ),
                              //     request: const AdRequest());
                              _interstitialAd?.show();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SizedBox(
                                              child: new NewPlayerPage(
                                            myId: widget.myId,
                                            url: e.url,
                                          ))));

                              // showModalBottomSheet<dynamic>(
                              //     backgroundColor: Colors.transparent,
                              //     isScrollControlled: true,
                              //     context: context,
                              //     builder: (context) {
                              //       return DraggableScrollableSheet(
                              //           // controller:
                              //           //     draggableController,
                              //           initialChildSize: 1,
                              //           minChildSize: 0.3,
                              //           builder: (context, scrollController) =>
                              //               new NewPlayerPage(
                              //                 myId: widget.myId,
                              //                 url: e.url,
                              //               ));
                              //     });
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      height: 205,
                                      width: double.infinity,
                                      key: UniqueKey(),
                                      imageUrl: e.poster,
                                      fit: BoxFit.cover,
                                    )),
                                Container(
                                  height: 230,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color.fromARGB(166, 0, 0, 0),
                                            Colors.transparent,
                                            Colors.transparent,
                                            Colors.transparent,
                                            Colors.transparent,
                                            Colors.transparent,
                                            Color.fromARGB(166, 0, 0, 0),
                                          ])),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 8, top: 5, right: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              !e.type.contains('الفلم')
                                                  ? Icons.tv
                                                  : Icons.movie,
                                              color: Colors.grey.shade300,
                                            ),
                                            Text(
                                              type,
                                              style: TextStyle(
                                                  color: Colors.grey.shade300,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(child: Text('')),
                                      Container(
                                        width: widget.size.width,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        child: Text(
                                          name,
                                          // .replaceAll(
                                          //     'الحلقة',
                                          //     context.currentLocale!
                                          //                 .languageCode ==
                                          //             'en'
                                          //         ? 'Ep'
                                          //         : 'الحلقة')
                                          // .replaceAll(
                                          //     'الفلم',
                                          //     context.currentLocale!
                                          //                 .languageCode ==
                                          //             'en'
                                          //         ? 'Movie'
                                          //         : 'الفلم'),
                                          //textAlign: TextAlign.justify,
                                          style: const TextStyle(
                                              fontFamily: "SFPro",
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // .replaceAll('i0.wp.com/', '')
                                // .replaceAll('i1.wp.com/', '')
                                // .replaceAll('i2.wp.com/', '')
                                // .replaceAll('i3.wp.com/', '')
                                // .replaceAll('i4.wp.com/', '')
                                // .replaceAll('i5.wp.com/', '')
                                // .replaceAll('i6.wp.com/', '')

                                //https://i2.wp.com/animetitans.comhttps://animetitans.com/wp-content/
                                // https://animetitans.com/wp-content//Blue-Lock-
                                // .replaceAll("/wp-content/",
                                //     "https://animetitans.com/wp-content/")
                                // .replaceAll(
                                //     'https://animetitans.comhttps://animetitans.com/wp-content/',
                                //     'https://animetitans.com/wp-content/'))),
                              ],
                            ),
                          );
                        }))
                    .toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
              )
            : CarouselSlider(
                items: List.generate(
                  3,
                  (index) => SliderLoading(
                      widget: widget,
                      iconTheme: colors.iconTheme,
                      bottomDown: colors.bottomDown),
                ),
                options:
                    CarouselOptions(autoPlay: true, enlargeCenterPage: true));
  }
}

class SliderLoading extends StatelessWidget {
  const SliderLoading({
    Key? key,
    required this.widget,
    required this.iconTheme,
    required this.bottomDown,
  }) : super(key: key);

  final SliderBar widget;
  final Color iconTheme;
  final Color bottomDown;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 185,
          width: widget.size.width,
          //  padding: const EdgeInsets.only(left: 10, bottom: 0),
          decoration: BoxDecoration(
            color: iconTheme,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Container(
          height: 210,
          decoration: BoxDecoration(
              //  color: bottomDown,
              //  borderRadius: BorderRadius.circular(14),
              ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Shimmer.fromColors(
                      baseColor: bottomDown,
                      highlightColor: iconTheme,
                      child: Container(
                        height: 15,
                        width: 50,
                        decoration: BoxDecoration(
                          color: bottomDown,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: bottomDown,
                      highlightColor: iconTheme,
                      child: Container(
                        height: 15,
                        width: 50,
                        decoration: BoxDecoration(
                          color: bottomDown,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Spacer(),
              Container(
                  padding: const EdgeInsets.only(bottom: 2, left: 8, top: 2),
                  height: 15,
                  width: widget.size.width / 3.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    color: iconTheme,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
