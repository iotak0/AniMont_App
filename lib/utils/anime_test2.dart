import 'package:anime_mont_test/pages/profial_screen.dart';
import 'package:anime_mont_test/utils/anime_scrollview.dart';
import 'package:flutter/material.dart';

import '../pages/anime_player.dart';

class AnimeList2 extends StatelessWidget {
  final Anime2 anime;
  final Size size;
  const AnimeList2({
    Key? key,
    required this.anime,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AnimePlayer(
                      quality: '240',
                      url: '',
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Stack(
          children: [
            Container(
              width: size.width / 3,
              height: size.height / 4.6,
              padding: const EdgeInsets.only(left: 10, bottom: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      'http://192.168.43.4:8080/Flutter_PHP_Tutorial/upload/${anime.animePoster}'),
                ),
              ),
            ),
            Container(
              width: size.width / 3,
              height: size.height / 3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(41, 117, 117, 117),
                        Color.fromARGB(41, 66, 66, 66)
                      ])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 8, left: 8),
                    child: Text(
                      anime.animeName,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
