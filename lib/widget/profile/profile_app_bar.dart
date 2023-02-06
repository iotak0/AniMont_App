import 'package:anime_mont_test/server/urls_php.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import '../../provider/user_model.dart';
import 'avatar.dart';
import 'follow_sec.dart';
import 'name_sec.dart';

class ProfileAppBar extends StatefulWidget {
  const ProfileAppBar({
    Key? key,
    required this.profail,
    required this.myId,
  }) : super(key: key);

  final UserProfial profail;
  final String myId;

  @override
  State<ProfileAppBar> createState() => _ProfileAppBarState();
}

class _ProfileAppBarState extends State<ProfileAppBar> {
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconTheme = Theme.of(context).iconTheme.color!;
    final Color textColor = Color.fromARGB(255, 160, 146, 167);
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color bottomUp = Theme.of(context).primaryColorDark;
    final Color bottomDown = Theme.of(context).primaryColorLight;
    String bgImage = '';
    if (widget.profail.backGroung.startsWith("http")) {
      bgImage = widget.profail.backGroung;
    } else {
      bgImage = image2 + widget.profail.backGroung.toString();
    }
    return Container(
      height: 350,
      child: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(bgImage), fit: BoxFit.cover),
              // color: Color.fromARGB(255, 0, 83, 79),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              border: Border.all(
                width: 2,
                color: backgroundColor,
              ),
            ),
          ),

          NameSec(
              profail: widget.profail,
              isEn: context.currentLocale.toString() == 'en' ? true : false),
          FollowSec(
              myId: widget.myId,
              profile: widget.profail,
              isEn: context.currentLocale.toString() == 'en' ? true : false),
          Avatar(
              profail: widget.profail,
              isEn: context.currentLocale.toString() == 'en' ? true : false),
          // Padding(
          //   padding: const EdgeInsets.only(top: 5.0),
          //   child: ArrowBackButton(
          //     size: MediaQuery.of(context).size,
          //   ),
          // )
        ],
      ),
    );
  }
}
