import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35, left: 24, right: 24),
      child: SizedBox(
        height: size.height / 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'W a t c h  Y o u r  B e s t\nA n i m e',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            CircleAvatar(
              radius: size.height / 24,
              backgroundImage:
                  const AssetImage('images/flutter_native_splash.png'),
            )
          ],
        ),
      ),
    );
  }
}
