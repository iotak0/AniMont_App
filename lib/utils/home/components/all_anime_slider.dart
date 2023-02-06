import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

import '../../../pages/animeinfo.dart';
import '../../constes.dart';

class AllAnimeSlider extends StatefulWidget {
  final String link;
  const AllAnimeSlider({
    Key? key,
    required this.size, required this.link,
  }) : super(key: key);

  final Size size;

  @override
  State<AllAnimeSlider> createState() => _AllAnimeSliderState();
}

class _AllAnimeSliderState extends State<AllAnimeSlider> {
  List<Article> articles = [];
  @override
  void initState() {
    super.initState();
    getWebsiteData(widget.link);
  }

  Future getWebsiteData(link) async {
    final url = Uri.parse(link);
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final tybes = html
        .querySelectorAll(
            '#content > div > div.postbody > div.bixbox.bixboxarc.bbnofrm > div.mrgn > div.listupd > article > div > a > div.limit > div.bt > span')
        .map((e) => e.innerHtml.trim())
        .toList();

    final titles = html
        .querySelectorAll(
            '#content > div > div.postbody > div.bixbox.bixboxarc.bbnofrm > div.mrgn > div.listupd > article > div > a')
        .map((e) => e.attributes['title']!)
        .toList();
    final urls = html
        .querySelectorAll(
            ' #content > div > div.postbody > div.bixbox.bixboxarc.bbnofrm > div.mrgn > div.listupd > article > div > a')
        .map((e) => e.attributes['href']!)
        .toList();
    final images = html
        .querySelectorAll(
            '#content > div > div.postbody > div.bixbox.bixboxarc.bbnofrm > div.mrgn > div.listupd > article > div > a > div.limit > img')
        .map((e) => e.attributes['src']!)
        .toList();

    setState(() {
      articles = List.generate(
          titles.length,
          (index) => Article(
              titles[index], 'tybes[index]', urls[index], images[index]));
      print("aaaaaaaaaaaaaaaaaaaaaaaaa$articles");
      print("jjjjjjjjjjjjjjjjjjj$titles");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.hardEdge,
      physics: const ScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: articles
            .map((e) => Builder(builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AnimeInfo(
                                    url: e.url,
                                  )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Stack(
                        children: [
                          Container(
                            width: widget.size.width / 3,
                            height: widget.size.height / 4,
                            padding:
                                const EdgeInsets.only(left: 10, bottom: 24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(e.poster),
                              ),
                            ),
                          ),
                          Container(
                            width: widget.size.width / 3,
                            height: widget.size.height / 4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [lightPurple2, darkPurple2])),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.only(bottom: 8, left: 8),
                                  child: Text(
                                    e.name,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }))
            .toList(),

        // recentlyUpdata
        //     .map((e) => Builder(builder: (context) {
        //           return InkWell(
        //             onTap: () => Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: (context) => DetailsPage(e = e))),
        //             child: Padding(
        //               padding: const EdgeInsets.only(left: 24),
        //               child: Stack(
        //                 children: [
        //                   Container(
        //                     margin: const EdgeInsets.only(
        //                         left: 10, bottom: 10, right: 5),
        //                     width: size.width / 3,
        //                     padding:
        //                         const EdgeInsets.only(left: 10, bottom: 200),
        //                     decoration: BoxDecoration(
        //                       color: Colors.transparent,
        //                       borderRadius: BorderRadius.circular(14),
        //                       image: DecorationImage(
        //                         fit: BoxFit.cover,
        //                         image: NetworkImage(e.poster),
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           );
        //         }))
        //     .toList(),
      ),
    );
  }
}
