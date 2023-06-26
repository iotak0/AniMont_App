import 'dart:async';

import 'package:anime_mont_test/Screens/Profile/profial_screen.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/server/Chat-Server-master/lib/Model/MessageModel.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ntp/ntp.dart';
import 'package:readmore/readmore.dart';

class ReplyCard extends StatefulWidget {
  const ReplyCard({
    Key? key,
    required this.message,
    required this.myId,
    required this.pref,
  }) : super(key: key);
  final MessageModel message;
  final int myId;
  final bool pref;

  @override
  State<ReplyCard> createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
  var timeNow;
  @override
  void initState() {
    _loadNTP();

    super.initState();
  }

  _loadNTP() async {
    final time = await NTP.now().toString();
    timeNow = DateTime.parse(time);

    //ntp = await NTP.now().toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    bool myMessage = widget.message.userId.toString == widget.myId.toString;
    return Align(
      alignment: context.currentLocale!.languageCode != 'en'
          ? myMessage
              ? Alignment.centerLeft
              : Alignment.centerRight
          : !myMessage
              ? Alignment.centerLeft
              : Alignment.centerRight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          myMessage
              ? SizedBox()
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                  child: widget.pref
                      ? Container(
                          height: 36,
                          width: 36,
                        )
                      : GestureDetector(
                          onTap: (() => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfialPage(
                                    id: widget.message.userId,
                                    isMyProfile: false,
                                    myId: widget.myId),
                              ))),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              errorWidget: (context, url, error) => Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: customColors.iconTheme),
                              ),
                              imageUrl:
                                  widget.message.avatar.startsWith('https://')
                                      ? widget.message.avatar
                                      : image + widget.message.avatar,
                              //  color: Colors.white,
                              height: 36,
                              width: 36,
                            ),
                          ),
                        ),
                ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth:
                  MediaQuery.of(context).size.width - (myMessage ? 45 : 90),
            ),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: myMessage ? customColors.iconTheme : customColors.bottomUp,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.message.reply == null
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Container(
                              // height: 60,
                              // width: MediaQuery.of(context).size.width - 68,
                              decoration: BoxDecoration(
                                  color: customColors.bottomUp,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12),
                                      bottom: Radius.circular(12))),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  //constraints: BoxConstraints(maxWidth: 50),
                                  //width: 50,
                                  decoration: BoxDecoration(
                                      color: customColors.backgroundColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 60,
                                              width: 8,
                                              decoration: BoxDecoration(
                                                  color: customColors.bottomDown
                                                      .withOpacity(.6),
                                                  borderRadius: BorderRadius.horizontal(
                                                      right: context
                                                                  .currentLocale!
                                                                  .languageCode !=
                                                              'en'
                                                          ? Radius.circular(30)
                                                          : Radius.circular(0),
                                                      left: context
                                                                  .currentLocale!
                                                                  .languageCode ==
                                                              'en'
                                                          ? Radius.circular(30)
                                                          : Radius.circular(
                                                              0))),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          (myMessage ? 40 : 85),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints(
                                                        maxWidth: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            (myMessage
                                                                ? 110
                                                                : 155),
                                                      ),
                                                      child: Text(
                                                        '${widget.message.reply.userId.toString() == widget.myId.toString() ? context.localeString("you") : widget.message.reply.userName}',
                                                        style: TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontFamily: 'SFPro',
                                                            color: customColors
                                                                .primaryColor,
                                                            fontSize: 13),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints(
                                                        maxWidth: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            (myMessage
                                                                ? 110
                                                                : 155),
                                                      ),
                                                      child: Text(
                                                        widget.message.reply
                                                            .message,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontFamily: 'SFPro',
                                                            color: customColors
                                                                .primaryColor,
                                                            fontSize: 13),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]),
                                    ],
                                  ),
                                ),
                              )),
                        ),
                  widget.pref
                      ? SizedBox()
                      : myMessage
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 5,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.message.userName,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: widget.message.admin
                                            ? Color.fromARGB(255, 218, 197, 12)
                                            : Colors.white,
                                        fontFamily: 'SFPro',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  !widget.message.admin
                                      ? SizedBox()
                                      : SvgPicture.string(
                                          height: 15,
                                          color:
                                              Color.fromARGB(255, 218, 197, 12),
                                          '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Light/Star</title>
    <g id="Iconly/Light/Star" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round">
        <g id="Star" transform="translate(3.000000, 3.500000)" stroke="#000000" stroke-width="1.5">
            <path d="M10.1042564,0.67700614 L11.9316681,4.32775597 C12.1107648,4.68615589 12.4564632,4.93467388 12.8573484,4.99218218 L16.9453359,5.58061527 C17.9553583,5.72643988 18.3572847,6.95054503 17.6263201,7.65194084 L14.6701824,10.4924399 C14.3796708,10.7717659 14.2474307,11.173297 14.3161539,11.5676396 L15.0137982,15.5778163 C15.1856062,16.5698344 14.1297683,17.3266846 13.2269958,16.8573759 L9.57321374,14.9626829 C9.21502023,14.7768079 8.78602103,14.7768079 8.42678626,14.9626829 L4.77300425,16.8573759 C3.87023166,17.3266846 2.81439382,16.5698344 2.98724301,15.5778163 L3.68384608,11.5676396 C3.75256926,11.173297 3.62032921,10.7717659 3.32981762,10.4924399 L0.373679928,7.65194084 C-0.357284727,6.95054503 0.0446417073,5.72643988 1.05466409,5.58061527 L5.14265161,4.99218218 C5.54353679,4.93467388 5.89027643,4.68615589 6.06937319,4.32775597 L7.89574356,0.67700614 C8.34765049,-0.225668713 9.65234951,-0.225668713 10.1042564,0.67700614 Z" id="Stroke-1"></path>
        </g>
    </g>
</svg>'''),
                                ],
                              ),
                            ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: ReadMoreText(
                      lessStyle: TextStyle(
                          color: Colors.white.withOpacity(.5), fontSize: 14),
                      ' ${widget.message.message}',
                      moreStyle: TextStyle(
                          color: Colors.white.withOpacity(.5), fontSize: 14),
                      trimLines: 5,
                      trimCollapsedText: context.localeString('read_more'),
                      trimExpandedText: context.localeString('show_less'),
                      postDataText: '',
                      preDataText: '',
                      trimMode: TrimMode.Line,
                      style: TextStyle(
                        fontSize: 16,
                        color: myMessage
                            ? customColors.primaryColor
                            : Colors.white,
                        fontFamily: 'SFPro',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 4.0, right: 4, bottom: 4),
                    child: Text(
                      Jiffy(DateTime.parse(widget.message.time)).from(timeNow),
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'SFPro',
                        color: myMessage
                            ? customColors.primaryColor
                            : Colors.white.withOpacity(.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
