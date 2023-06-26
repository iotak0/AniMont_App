import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomLListTile extends StatelessWidget {
  const CustomLListTile({
    Key? key,
    required this.body,
    required this.trailing,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final Widget body;
  final GestureTapCallback onTap;
  final Widget trailing;
  final String icon;

  @override
  Widget build(BuildContext context) {
    CustomColors customColor = CustomColors(context);
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    height: 50,
                    width: 50,
                    errorWidget: (context, url, error) => SizedBox(),
                    key: UniqueKey(),
                    imageUrl: icon,
                    fit: BoxFit.cover,
                  )),
            ),
            Expanded(child: body),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: trailing,
            )
          ],
        ),
      ),
    );
  }
}
