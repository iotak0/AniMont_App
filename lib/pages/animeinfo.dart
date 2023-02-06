import 'package:anime_mont_test/pages/anime_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

import '../utils/AnimeDetalis/components/back.dart';
import '../utils/buttons/arrow_back_button.dart';
import '../utils/constes.dart';
import '../utils/loading.dart';
import 'all_anime.dart';
import 'all_genres.dart';
import 'genres_page.dart';

class AnimeInfo extends StatefulWidget {
  final String url;
  const AnimeInfo({Key? key, required this.url}) : super(key: key);

  @override
  State<AnimeInfo> createState() => _AnimeInfoState();
}

class _AnimeInfoState extends State<AnimeInfo> {
  @override
  void initState() {
    super.initState();
    getAnimeData(widget.url);
  }

  List<DataInfo2> dataInfo = [];
  Future getAnimeData(link) async {
    final url = Uri.parse(link);
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    final backgroundImage = html
        .querySelectorAll('div.bixbox.animefull > div.bigcover > div > img')
        .map((e) => e.attributes['src']!)
        .toString();
    final poster = html
        .querySelectorAll(' div.thumbook > div.thumb > img')
        .map((e) => e.attributes['src']!)
        .toString();
    final name = html
        .querySelectorAll(' div.infox > h1')
        .map((e) => e.innerHtml.trim())
        .toString();
    final info = html
        .querySelectorAll('div.infox > div > div.info-content > div.spe > span')
        .map((e) => e.innerHtml.trim())
        .toList();
    final category = html
        .querySelectorAll(
            ' div.infox > div > div.info-content > div.genxed > a')
        .map((e) => e.innerHtml.trim())
        .toList();
    final description = html
        .querySelectorAll(' div.entry-content > p')
        .map((e) => e.innerHtml.trim())
        .toString();

    final epLink = html
        .querySelectorAll(' div.eplister > ul > li > a')
        .map((e) => e.attributes['href']!)
        .toList();
    final epNum = html
        .querySelectorAll('div.eplister > ul > li > a > div.epl-num')
        .map((e) => e.innerHtml.trim())
        .toList();
    setState(() {
      DataInfo2 dataInfo1 = DataInfo2(backgroundImage, poster, name,
          description, info, category, epLink, epNum);
      dataInfo.add(dataInfo1);
      print('pppppppppppppppppppppppppppppppppp$poster');
    });
  }

  final List<Color> dark = [darkPurple, lightPurple];
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (dataInfo.isEmpty) {
      return Loading(size: size);
    } else {
      return Scaffold(
        backgroundColor: darkPurple,
        body: Align(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: size.height),
              child: IntrinsicHeight(
                child: Stack(children: [
                  Column(
                    children: dataInfo
                        .map((e) => Builder(builder: (context) {
                              String poster2 = e.poster
                                  .replaceAll('(', '')
                                  .replaceAll(')', '');
                              const start = '"';
                              final stIndex = poster2.indexOf(start);
                              final String posterUrl;
                              final endIndex = poster2.indexOf(
                                  start, stIndex + start.length);
                              if (poster2.indexOf('"') == start) {
                                posterUrl = poster2.substring(
                                    stIndex + start.length, endIndex);
                              } else {
                                posterUrl = poster2;
                              }
                              print("poster $poster2");
                              return Column(
                                children: [
                                  Stack(children: [
                                    BackgroundWidget2(
                                      size: size,
                                      poster2: posterUrl,
                                    ),
                                    Container(
                                      height: size.height / 3.5,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [lightPurple2, darkPurple2],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter),
                                      ),
                                    ),
                                    ArrowBackButton(size: size),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 24.0,
                                              top: size.height / 4.5),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: size.width / 2.5,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  child: Image.network(
                                                    posterUrl,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8,
                                                              bottom: 8),
                                                      width: size.width,
                                                      child: Text(
                                                        e.name
                                                            .replaceAll('(', '')
                                                            .replaceAll(
                                                                ')', ''),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 3.0,
                                                          vertical: 3),
                                                      child: Container(
                                                        width: double.infinity,
                                                        child: Wrap(
                                                          spacing: 1,
                                                          runSpacing: 1,
                                                          alignment:
                                                              WrapAlignment
                                                                  .start,
                                                          children: e.category
                                                              .asMap()
                                                              .entries
                                                              .map((e) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(20),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => AllGenres(
                                                                                  genre: e.value,
                                                                                )));
                                                                  });
                                                                },
                                                                child:
                                                                    GestureDetector(
                                                                  child:
                                                                      Container(
                                                                    height: 25,
                                                                    width: 50,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    decoration: BoxDecoration(
                                                                        gradient:
                                                                            const LinearGradient(colors: [
                                                                          darkPurple,
                                                                          darkPink
                                                                        ]),
                                                                        borderRadius:
                                                                            BorderRadius.circular(25)),
                                                                    child: Text(
                                                                      '${e.value.trim()}',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                                  buildTitle('summarize'.toUpperCase()),
                                  Container(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        e.description
                                            .replaceAll("(", "")
                                            .replaceAll(")", ""),
                                        textDirection: TextDirection.rtl,
                                        style: const TextStyle(
                                            color: textColor3,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  buildTitle('Episodes'.toUpperCase()),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8.0, left: 8, right: 8),
                                    child: Container(
                                      width: double.infinity,
                                      child: Wrap(
                                        children:
                                            e.epLink.asMap().entries.map((e0) {
                                          var epIndex = e.epNum[e0.key];
                                          return Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AnimePlayer(
                                                                      quality:
                                                                          '240',
                                                                      url: e0
                                                                          .value)));
                                                    });
                                                  },
                                                  child: SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            height: 50,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: BoxDecoration(
                                                                gradient:
                                                                    const LinearGradient(
                                                                        colors: [
                                                                      darkPurple,
                                                                      darkPink
                                                                    ]),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            14)),
                                                            child: Text(
                                                                '${epIndex}'),
                                                          ),
                                                        ],
                                                      ))));
                                        }).toList(),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }))
                        .toList(),
                  ),
                ]),
              ),
            ),
          ),
        ),
      );
    }
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
