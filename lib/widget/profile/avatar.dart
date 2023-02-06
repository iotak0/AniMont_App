import 'package:anime_mont_test/server/urls_php.dart';
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
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             ChatPage(avatar: profail.avatar)));
              },
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                    // color: Color.fromARGB(0, 209, 14, 0),
                    image: DecorationImage(
                        image: AssetImage(
                          'images/circle_fire.gif',
                        ),
                        onError: (exception, stackTrace) => print('hhhh'),
                        //invertColors: true,
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(100),
                    // border: Border.all(
                    //   width: 2,
                    // color: widget.color[0],
                  )),
                  // ),
                  Positioned(
                    width: 80,
                    height: 80,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          // color: Color.fromARGB(0, 209, 14, 0),
                          image: DecorationImage(
                              image: NetworkImage(
                                avatar,
                              ),
                              onError: (exception, stackTrace) => print('hhhh'),
                              //invertColors: true,
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(100
                              // border: Border.all(
                              //   width: 2,
                              // color: widget.color[0],
                              )),
                    ),
                  ),
                ],
              ),
            ))
        :  Positioned(
            top: 140,
            right: 15,
            width: 100,
            height: 100,
            child: GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             ChatPage(avatar: profail.avatar)));
              },
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                    // color: Color.fromARGB(0, 209, 14, 0),
                    image: DecorationImage(
                        image: AssetImage(
                          'images/circle_fire.gif',
                        ),
                        onError: (exception, stackTrace) => print('hhhh'),
                        //invertColors: true,
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(100),
                    // border: Border.all(
                    //   width: 2,
                    // color: widget.color[0],
                  )),
                  // ),
                  Positioned(
                    width: 80,
                    height: 80,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          // color: Color.fromARGB(0, 209, 14, 0),
                          image: DecorationImage(
                              image: NetworkImage(
                                avatar,
                              ),
                              onError: (exception, stackTrace) => print('hhhh'),
                              //invertColors: true,
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(100
                              // border: Border.all(
                              //   width: 2,
                              // color: widget.color[0],
                              )),
                    ),
                  ),
                ],
              ),
            ));
  }
}
