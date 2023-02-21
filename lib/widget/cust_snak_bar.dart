import 'package:flutter/material.dart';

class CustSnackBar extends StatelessWidget {
  const CustSnackBar({
    Key? key,
    required this.erorr,
    required this.headLine,
  }) : super(key: key);
  final String headLine;
  final String erorr;
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconTheme = Theme.of(context).iconTheme.color!;
    final Color textColor = Color.fromARGB(255, 160, 146, 167);
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color bottomUp = Theme.of(context).primaryColorDark;
    final Color bottomDown = Theme.of(context).primaryColorLight;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color(0xFFC72C41),
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
                      Text(
                        headLine,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      const Spacer(),
                      Text(
                        erorr,
                        style: TextStyle(fontSize: 12, color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
            child: Image.asset(
              'images/Light/Info Square.png',
              height: 40,
              width: 48,
            ))
      ],
    );
  }
}
