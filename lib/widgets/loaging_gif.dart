import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingGif extends StatelessWidget {
  const LoadingGif({
    Key? key,
    required this.logo,
  }) : super(key: key);
  final bool logo;
  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    return logo
        ? Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Shimmer.fromColors(
                  direction: ShimmerDirection.ttb,
                  highlightColor: customColors.bottomDown,
                  baseColor: customColors.primaryColor,
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                            width: 2, color: customColors.primaryColor)),
                    child: Image.asset(
                      'images/AnimonDark.png',
                      height: 80,
                      width: 80,
                    ),
                  ),
                ),
                Shimmer.fromColors(
                  direction: ShimmerDirection.ttb,
                  highlightColor: customColors.primaryColor,
                  baseColor: customColors.backgroundColor.withOpacity(.5),
                  child: Container(
                    height: 78,
                    width: 78,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          width: 2,
                          color: customColors.backgroundColor,
                        )),
                    child: Image.asset(
                      'images/AnimonDark.png',
                    ),
                  ),
                ),
              ],
            ),
          )
        : Center(
            child: SizedBox(
                height: 70,
                width: 70,
                child: Image.asset(
                  'images/circle_white.gif',
                  color: customColors.primaryColor.withOpacity(.8),
                )),
          );
  }
}
