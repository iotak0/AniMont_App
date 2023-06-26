import 'dart:ui';

import 'package:flutter/material.dart';

class GlassBox extends StatelessWidget {
  const GlassBox({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 100,
      color: Colors.transparent,
      child: Stack(children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: Container(),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white.withOpacity(.13),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(.15),
                    Colors.white.withOpacity(.05)
                  ])),
        ),
        Center(
          child: child,
        )
      ]),
    );
  }
}
