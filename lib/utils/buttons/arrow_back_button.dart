import 'package:anime_mont_test/utils/constes.dart';
import 'package:flutter/material.dart';

class ArrowBackButton extends StatelessWidget {
  const ArrowBackButton({
    Key? key,
    required this.size,
  }) : super(key: key);
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 16),
          width: size.height / 20,
          height: size.height / 20,
          decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [
                Colors.black,
                Color.fromARGB(131, 66, 65, 65),
              ]),
              borderRadius: BorderRadius.circular(14)),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
