import 'package:flutter/material.dart';

import '../../constes.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({
    Key? key,
    required this.size,
    required this.anime,
  }) : super(key: key);

  final Size size;
  final Anime anime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: size.height / 3.5,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(anime.backgroundImage), fit: BoxFit.cover),
          ),
        ),
        Container(
          height: 200,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              darkPurple2,
              lightPurple2,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        )
      ],
    );
  }
}
