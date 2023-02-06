import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:anime_mont_test/pages/anime_player.dart';
import 'package:anime_mont_test/server/server_php.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:flutter/material.dart';

import '../pages/profial_screen.dart';
import 'anime_list.dart';
import 'anime_test2.dart';

class AnimeScrollView2 extends StatefulWidget {
  const AnimeScrollView2({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  State<AnimeScrollView2> createState() => _AnimeScrollView2State();
}

class _AnimeScrollView2State extends State<AnimeScrollView2> {
  Future<List<Anime2>> animeFuture = getAnime(139);
  List<Anime2> anime2 = [];

  @override
  void initState() {
    getAnime(139);
    super.initState();
    setState(() {
      getAnime(139);
    });
  }

  static Future<List<Anime2>> getAnime(int animeId) async {
    final response = await http
        .post(Uri.parse('${my_anime_link}'), body: {"user_id": "${animeId}"});
    final body = json.decode(response.body);

    return body.map<Anime2>(Anime2.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.size.height / 4,
        child: FutureBuilder<List<Anime2>>(
            future: animeFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: const CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else if (snapshot.hasData) {
                final anime = snapshot.data!;
                anime2 = anime;
                return anime.isEmpty
                    ? Center(child: const CircularProgressIndicator())
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: anime2.length,
                        itemBuilder: (context, index) {
                          return AnimeList2(
                            size: widget.size,
                            anime: anime2[index],
                          );
                        });
              } else
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }));
  }
}

class Anime {
  final String poster;
  final String name;
  final String url;
  final String type;

  Anime(this.poster, this.name, this.url, this.type);
}
