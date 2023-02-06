import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final Size size;
  const Loading({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(size.width / 8),
      child: Center(
          child: Padding(
        padding: EdgeInsets.only(right: size.width / 15),
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/demon-slayer.gif'))),
        ),
      )),
    );
  }
}
