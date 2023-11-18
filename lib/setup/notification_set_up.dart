import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:newtest/services/local_notification_service.dart';

abstract class SetUpNotification {
  static Future<void> notificationSetup() async {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    await LocalNotificationService.initialize();
  }
}
