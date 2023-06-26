import 'package:anime_mont_test/server/urls_php.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../provider/user_model.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key? key,
    required this.profail,
    required this.isEn,
  }) : super(key: key);
  final bool isEn;
  final UserProfial profail;

  @override
  Widget build(BuildContext context) {
    String avatar = '';
    if (profail.avatar.startsWith("http")) {
      avatar = profail.avatar;
    } else {
      avatar = image2 + profail.avatar.toString();
    }

    return isEn
        ? Positioned(
            top: 140,
            left: 15,
            width: 100,
            height: 100,
            child: GestureDetector(
              onTap: () {},
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  profail.admin
                      ? Container(
                          decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'images/circle_fire.gif',
                              ),
                              onError: (exception, stackTrace) => print('hhhh'),
                              //invertColors: true,
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(100),
                        ))
                      : SizedBox(),
                  Positioned(
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          key: UniqueKey(),
                          imageUrl: avatar,
                          fit: BoxFit.cover,
                        )),
                  ),
                ],
              ),
            ))
        : Positioned(
            top: 140,
            right: 15,
            width: 100,
            height: 100,
            child: GestureDetector(
              onTap: () {},
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  profail.admin
                      ? Container(
                          decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'images/circle_fire.gif',
                              ),
                              onError: (exception, stackTrace) => print('hhhh'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(100),
                        ))
                      : SizedBox(),
                  // ),
                  Positioned(
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          // height: 205,
                          // width: double.infinity,
                          key: UniqueKey(),
                          imageUrl: avatar,
                          fit: BoxFit.cover,
                        )),
                  ),
                ],
              ),
            ));
  }
}
