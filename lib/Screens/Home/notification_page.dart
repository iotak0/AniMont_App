import 'dart:convert';
import 'package:anime_mont_test/Screens/Home/home_page.dart';
import 'package:anime_mont_test/Screens/Profile/profial_screen.dart';
import 'package:anime_mont_test/helper/constans.dart';
import 'package:anime_mont_test/models/get_x_controller.dart';
import 'package:anime_mont_test/widgets/alart.dart';
import 'package:anime_mont_test/widgets/alart_internet.dart';
import 'package:anime_mont_test/widgets/custom_listTile.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';

class NotifiPage extends StatefulWidget {
  const NotifiPage({super.key, required this.myId});
  final int myId;
  @override
  State<NotifiPage> createState() => _NotifiPageState();
}

class _NotifiPageState extends State<NotifiPage> {
  late ScrollController _scrollController;
  final int _maxLength = 15;
  bool isLoading = false;
  bool hasErorr = false;
  bool hasMore = true;
  bool done = false;
  int page = 1;
  List<Notification> notificationList = [];
  getNotification() async {
    setState(() {
      isLoading = true;
      hasErorr = false;
    });
    await http
        .get(Uri.parse(
            '$my_notifications?page=${page.toString()}&user_id=${widget.myId.toString()}'))
        .catchError((error) {
      isLoading = false;
      hasErorr = true;
      setState(() {});
    }).then((value) async {
      if (value.statusCode == 200) {
        var data;
        try {
          data = jsonDecode(value.body);
        } catch (e) {
          setState(() {
            isLoading = false;
            done = true;
          });
        }

        data.isNotEmpty ? page++ : page;

        for (var e in data) {
          notificationList.add(Notification(
            e['id'].toString(),
            e['notifi_sender'].toString(),
            e['notifi_user'].toString(),
            e['notifi_sender'].toString(),
            e['notifi_body'].toString(),
            e['notifi_data'].toString(),
            e['notifi_senderName'].toString(),
            e['notifi_state'].toString(),
            e['notifiDate'].toString(),
            e['with_image'].toString(),
            e['time_now'].toString(),
            e['notifi_more'].toString(),
          ));
        }
        await http.get(Uri.parse(
            '$my_notifications_read_it?user_id=${widget.myId.toString()}'));
        ChatGetX.noitificationCount.value = 0;
        setState(() {
          isLoading = false;

          hasMore = (data.length >= _maxLength) ? true : false;
        });
      } else {
        setState(() {
          hasErorr = true;
          isLoading = false;
        });
      }
      done = true;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    page = 1;

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getNotification();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.95 &&
          !isLoading &&
          hasMore) {
        getNotification();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColor = CustomColors(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: LocaleText(
            'notifications',
            style: TextStyle(
                fontFamily: 'SFPro',
                fontWeight: FontWeight.bold,
                color: customColor.primaryColor),
          ),
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: customColor.primaryColor,
            ),
          ),
          backgroundColor: customColor.backgroundColor,
          elevation: 1,
        ),
        body: RefreshIndicator(
          onRefresh: () => getNotification(),
          child: (isLoading && !hasErorr && notificationList.isEmpty)
              ? LoadingGif(
                  logo: true,
                )
              : (hasErorr && notificationList.isEmpty)
                  ? AlartInternet(
                      onTap: () => isLoading ? null : getNotification())
                  : (done && notificationList.isEmpty)
                      ? Alart(
                          body: 'no_thing_to_see_here_yet',
                          icon: noNotifications)
                      : ListView.separated(
                          controller: _scrollController,
                          itemCount: (isLoading &&
                                  hasMore &&
                                  notificationList.isNotEmpty)
                              ? notificationList.length + 1
                              : notificationList.length,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemBuilder: (context, index) {
                            if (index == notificationList.length &&
                                isLoading &&
                                notificationList.isNotEmpty) {
                              return LoadingGif(
                                logo: true,
                              );
                            }
                            return CustomLListTile(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfialPage(
                                          myId: widget.myId,
                                          id: int.parse(notificationList[index]
                                              .notifiSender),
                                          isMyProfile: false),
                                    )),
                                body: Wrap(
                                  children: [
                                    Text(
                                      notificationList[index].notifiSenderName,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: customColor.primaryColor),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    LocaleText(
                                      notificationList[index].notifiBody,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: customColor.primaryColor),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      notificationList[index].notifiMore,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: customColor.primaryColor),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Text(
                                        Jiffy(DateTime.parse(
                                                notificationList[index]
                                                    .notifiDate))
                                            .from(DateTime.parse(
                                                notificationList[index]
                                                    .time_now)),
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: customColor.primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: notificationList[index].with_image ==
                                        '0'
                                    ? SizedBox()
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: CachedNetworkImage(
                                          imageUrl: notificationList[index]
                                              .notifiData
                                              .substring(
                                                  notificationList[index]
                                                      .notifiData
                                                      .indexOf('\\'),
                                                  notificationList[index]
                                                      .notifiData
                                                      .length)
                                              .replaceAll("\\", ""),
                                          height: 50,
                                          width: 50,
                                          errorWidget: (context, url, error) =>
                                              SizedBox(),
                                        )),
                                icon: notificationList[index]
                                    .notifiData
                                    .substring(
                                        0,
                                        notificationList[index]
                                            .notifiData
                                            .indexOf('\\'))
                                    .replaceAll("\\", ""));
                          },
                        ),
        ));

    /* ListView.separated(
            controller: _scrollController,
            itemCount: notificationList.length +
                ((isLoading && hasMore && notificationList.isNotEmpty) ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
            itemBuilder: (context, index) {
              if (index == notificationList.length &&
                  isLoading &&
                  hasMore &&
                  notificationList.isNotEmpty) {
                return LoadingGif();
              }

              return (isLoading && notificationList.isEmpty)
                  ? LoadingGif()
                  : CustomLListTile(
                    onTap: () => null,
                      body: Wrap(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            notificationList[index].notifiTitle.toString(),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 16.5,
                                color: customColor.primaryColor),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            notificationList[index].notifiBody.toString() + '.',
                            style: TextStyle(
                                fontSize: 15, color: customColor.primaryColor),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '5d',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: customColor.primaryColor),
                            ),
                          ),
                        ],
                      ),
                      trailing: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: customColor.bottomDown,
                          ),
                          height: 50,
                          width: 50,
                          child: Image.asset(
                            'images/mal.png',
                          )),
                      icon: 'images/mal.png',
                    );
            }));*/
  }
}

class Notification {
  final String id;
  final String notifiSender;
  final String notifiUser;
  final String notifiTitle;
  final String notifiBody;
  final String notifiData;
  final String notifiSenderName;
  final String notifiState;
  final String notifiDate;
  final String with_image;
  final String time_now;
  final String notifiMore;

  Notification(
    this.id,
    this.notifiSender,
    this.notifiUser,
    this.notifiTitle,
    this.notifiBody,
    this.notifiData,
    this.notifiSenderName,
    this.notifiState,
    this.notifiDate,
    this.with_image,
    this.time_now,
    this.notifiMore,
  );

  static Notification fromJson(json) => Notification(
        json['id'].toString(),
        json['notifi_sender'].toString(),
        json['notifi_user'].toString(),
        json['notifi_title'].toString(),
        json['notifi_body'].toString(),
        json['notifi_data'].toString(),
        json['notifi_senderName'].toString(),
        json['notifi_state'].toString(),
        json['notifi_date'].toString(),
        json['with_image'].toString(),
        json['time_now'].toString(),
        json['notifi_more'].toString(),
      );
}
