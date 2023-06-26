import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/server/Chat-Server-master/lib/Model/MessageModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:jiffy/jiffy.dart';

class OwnMessageCard extends StatelessWidget {
  const OwnMessageCard({
    Key? key,
    required this.message,
  }) : super(key: key);
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    return Align(
     alignment: context.currentLocale!.languageCode != 'en'
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: customColors.iconTheme.withOpacity(.7),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                  top: 5,
                  bottom: 5,
                ),
                child: Text(
                  message.message,
                  style:
                      TextStyle(fontSize: 16, color: customColors.primaryColor),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Jiffy(DateTime.parse(message.time)).fromNow(),
                    style: TextStyle(
                      fontSize: 13,
                      color: customColors.primaryColor.withOpacity(.5),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.done_all,
                    size: 20,
                    color: customColors.primaryColor.withOpacity(.5),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
