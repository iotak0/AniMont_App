import 'package:anime_mont_test/pages/chat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

requestPermissionNotification() async {
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}

fcmconfig() {
  FirebaseMessaging.onMessage.listen((message) {
    print('////    title    //////${message.notification!.title}');
    print('////   body     //////${message.notification!.body}');
    LocalNotificationsService.showNotification(message);
    // NotificationService().showNotification(
    //     1, message.notification!.title!, message.notification!.body!, 10);
    // Get.showSnackbar(GetSnackBar(
    //   title: message.notification!.title!,
    //   message: message.notification!.body!,
    //   icon: const Icon(Icons.refresh),
    //   duration: const Duration(seconds: 3),
    // ));
    // Get.snackbar(
    //   ' message.notification!.title!',
    //   ' message.notification!.body!',
    //   // colorText: Colors.white,
    //   // backgroundColor: Colors.lightBlue,
    //   icon: const Icon(Icons.add_alert),
    // );
    // Get.snackbar(
    //   message.notification!.title!,
    //   message.notification!.body!,
    //   // colorText: Colors.white,
    //   // backgroundColor: Colors.lightBlue,
    //   icon: const Icon(Icons.add_alert),
    // );
    //   Get.snackbar(message.notification!.title!, message.notification!.body!);
    //(snackbar());
  });
}

class LocalNotificationsService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

//  NotificationService._internal();

  void initNotification() async {
    // final AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('@drawable/ic_notification');

    // final IOSInitializationSettings initializationSettingsIOS =
    // IOSInitializationSettings(
    //   requestAlertPermission: false,
    //   requestBadgePermission: false,
    //   requestSoundPermission: false,
    // );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_notification'),
      //iOS: initializationSettingsIOS
    );
    //await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    //,onDidReceiveNotificationResponse: (details) { },);
  }

  static void showNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
              'pushnotificationl', 'pushnotificationchannel',
              importance: Importance.max,
              priority: Priority.max,
              icon: '@drawable/ic_notification'));

      await flutterLocalNotificationsPlugin.show(
          id,
          message.notification!.title,
          message.notification!.body,
          notificationDetails);
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //   id,
    //   title,
    //   body,
    //   tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
    //   const NotificationDetails(
    //     android: AndroidNotificationDetails(
    //         'Main Channel', 'Main channel notifications',
    //         importance: Importance.max,
    //         priority: Priority.max,
    //         icon: '@drawable/ic_notification'),
    //     //android\app\src\main\res\drawable-xhdpi\ic_notification.png
    //     // iOS: IOSNotificationDetails(
    //     //   sound: 'default.wav',
    //     //   presentAlert: true,
    //     //   presentBadge: true,
    //     //   presentSound: true,
    //     // ),
    //   ),
    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.absoluteTime,
    //   androidAllowWhileIdle: true,
    // );
  }

  // Future<void> cancelAllNotifications() async {
  //   await flutterLocalNotificationsPlugin.cancelAll();
  // }
}
