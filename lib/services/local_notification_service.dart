import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalNotificationService {
  static Future<void> initialize() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
    );
    FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    InitializationSettings initializationSettings =
        InitializationSettings(android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.instance.getNotificationSettings();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      List notificationJsonList = [];
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      if (sharedPreferences.getString('notificationList') != null) {
        List notificationSharedPreferencesList = jsonDecode(sharedPreferences.getString('notificationList'));
        notificationJsonList = notificationSharedPreferencesList;
      }
      notificationJsonList
          .add({'readed': false, 'title': message.notification.title, 'subTitle': message.notification.body});
      var notificationEncodeList = jsonEncode(notificationJsonList);
      sharedPreferences.setString('notificationList', notificationEncodeList);
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification.title,
          message.notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name, icon: '@mipmap/ic_launcher'),
          ));
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
}
