import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustSnackBar extends StatelessWidget {
  const CustSnackBar({
    Key? key,
    required this.erorr,
    required this.headLine,
    required this.color,
    required this.image,
  }) : super(key: key);
  final String headLine, image, erorr;
  final Color color;
  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            height: 80,
            width: double.infinity,
            //Color(0xFFC72C41)
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              children: [
                SizedBox(
                  width: 48,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Text(
                        headLine,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: 'SFPro'),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Text(
                        erorr,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis,
                            color: Colors.white,
                            fontFamily: 'SFPro'),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            )),
        // Positioned(
        //     top: -15,
        //     left: -3,
        //     child: CircleAvatar(
        //       backgroundColor: Color(0xFFC72C41),
        //       radius: 15,
        //       backgroundImage: AssetImage(
        //         'images/Light/Close Square.png',
        //       ),
        //     )),
        Positioned(
            bottom: 20,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SvgPicture.string(
                image,
                height: 40,
                width: 48,
                color: Colors.white,
              ),
            ))
      ],
    );
  }
}
