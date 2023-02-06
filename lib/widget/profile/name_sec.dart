import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import '../../provider/user_model.dart';

class NameSec extends StatelessWidget {
  const NameSec({
    Key? key,
    required this.profail,
    required this.isEn,
  }) : super(key: key);
  final bool isEn;
  final UserProfial profail;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconTheme = Theme.of(context).iconTheme.color!;
    final Color textColor = Color.fromARGB(255, 160, 146, 167);
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color bottomUp = Theme.of(context).primaryColorDark;
    final Color bottomDown = Theme.of(context).primaryColorLight;
    return isEn
        ? Positioned(
            height: 52,
            top: 250,
            left: 20,
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  //alignment: Alignment.centerLeft,

                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    profail.name.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: context.localeString('en') == 'en'
                            ? 'Angie'
                            : 'SFPro'),
                  ),
                ),
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  // child: Text(
                  //   '@${profail.userName.toLowerCase()}',
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.w400,
                  //       fontSize: 15,
                  //       fontFamily: context.localeString('en') == 'en'
                  //           ? 'Angie'
                  //           : 'SFPro'),
                  // ),
                )
              ],
            ))
        : Positioned(
            height: 52,
            top: 250,
            right: 20,
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  //alignment: Alignment.centerLeft,

                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    profail.name.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: context.localeString('en') == 'en'
                            ? 'Angie'
                            : 'SFPro'),
                  ),
                ),
                // Container(
                //   width: 200,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(25),
                //   ),
                //   child: Text(
                //     '@${profail.userName.toLowerCase()}',
                //     style: TextStyle(
                //         fontWeight: FontWeight.w400,
                //         fontSize: 15,
                //         fontFamily: context.localeString('en') == 'en'
                //             ? 'Angie'
                //             : 'SFPro'),
                //   ),
                // )
              ],
            ));
  }
}
