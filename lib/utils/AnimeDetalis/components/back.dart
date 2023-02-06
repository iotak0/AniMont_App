import 'package:anime_mont_test/utils/constes.dart';
import 'package:flutter/material.dart';
class BackgroundWidget2 extends StatefulWidget {
  const BackgroundWidget2({
    Key? key,
    required this.size,
    required this.poster2,
  }) : super(key: key);

  final Size size;
  final String poster2;

  @override
  State<BackgroundWidget2> createState() => _BackgroundWidget2State();
}

class _BackgroundWidget2State extends State<BackgroundWidget2> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: widget.size.height / 3.5,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(widget.poster2), fit: BoxFit.cover),
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
