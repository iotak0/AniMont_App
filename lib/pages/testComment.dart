import 'package:anime_mont_test/pages/post_comments.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

import '../utils/anime_video_player.dart';

class TestComment extends StatefulWidget {
  const TestComment({super.key, required this.url});
  final String url;
  @override
  State<TestComment> createState() => _TestCommentState();
}

class _TestCommentState extends State<TestComment> {
  String id = '';
  bool ok = false;
  String play = '';
  Future getAnimeData(link) async {
    final url = Uri.parse(link);
    final response = await http.get(url);

    dom.Document html = dom.Document.html(response.body);

    final ifram = html
        .querySelectorAll('#pembed > iframe')
        .map((e) => e.attributes['src']!)
        .toString();
    print("Screeebt/////////////////" + ifram);
    final url2 = Uri.parse(ifram.replaceAll("(", '').replaceAll(")", ''));
    final response2 = await http.get(url2);
    dom.Document html2 = dom.Document.html(response2.body);
    var play1 = html2
        .querySelectorAll('body > script')
        .map((e) => e.innerHtml.trim())
        .toString();
    play = play1
        .substring(0, play1.indexOf('",'))
        .replaceAll('var player = new Clappr.Player(', '')
        .replaceAll('{', '')
        .replaceAll('source: "', '')
        .replaceAll(' ', '')
        .replaceAll('0p', '240p_1')
        .replaceAll("(", '')
        .replaceAll(")", '');
    print("play/////////////////" + play);
    ok = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //https://animetitans.com/boku-no-hero-academia-6th-season-%d8%a7%d9%84%d8%ad%d9%84%d9%82%d8%a9-18/#'
    getAnimeData(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: 500,
      child: Center(
        child: Column(
          children: [
            ok
                ? AnimeVideoPlayer(
                    url: play,
                    context: context,
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                  onTap: () => getAnimeData(widget.url),
                  child: Text("ReLoad web")),
            )
          ],
        ),
      ),
    ));
    // child: PostComments()));
  }
}
