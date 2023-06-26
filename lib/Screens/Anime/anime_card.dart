import 'package:anime_mont_test/Screens/Home/Search/search_page.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AnimeCard extends StatelessWidget {
  const AnimeCard({
    Key? key,
    required this.customColor,
    required this.rusult,
  }) : super(key: key);
  final Result rusult;
  final CustomColors customColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: 200,
        width: 110,
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  width: 110,
                  height: 200,
                  key: UniqueKey(),
                  imageUrl: rusult.image,
                  fit: BoxFit.cover,
                )),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 1.5, horizontal: 8),
              child: Text(
                '',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: customColor.primaryColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Positioned(
              bottom: 0,
              height: 30,
              width: 110,
              child: Container(
                alignment: Alignment.bottomLeft,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(.3),
                          Colors.black.withOpacity(.6),
                          Colors.black.withOpacity(.7),
                        ]),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(10))),
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                child: Text(
                  rusult.name,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      shadows: [
                        Shadow(color: customColor.bottomUp, blurRadius: 1)
                      ],
                      fontFamily: 'SFPro',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            /*Container(
                    width: 110,
                    height: 210,
                    decoration: BoxDecoration(
                        color: customColor.iconTheme,
                        borderRadius:
                            BorderRadius.circular(12),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              customColor.primaryColor,
                              customColor.iconTheme,
                            ])),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.end,
                      children: [],
                    )), */
          ],
        ),
      ),
    );
  }
}
