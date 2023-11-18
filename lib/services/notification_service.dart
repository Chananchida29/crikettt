import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class NotificationService {
  static String notificationKey =
      'key=AAAAcRTap6o:APA91bGL5UrkuOFROtF6ZZyyj5EaW7cwu355GzthAKJTmVdXvqPk7SxpEBaDGkWUJmnN3tECT9CcWjHZBi_xdEFAuCXQaNxPo0D54dwh2wO8B2lIoaIfvx717fYdxhbzq6-E5Nd6LnT8';
  static String urlNotification = "https://fcm.googleapis.com/fcm/send";
  static Future createNotification({String processName}) async {
    try {
      // send now
      String fcmToken = await FirebaseMessaging.instance.getToken();
      Dio dio = Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = notificationKey;
      await dio.post(urlNotification, data: {
        "to": fcmToken,
        "content_available": true,
        "time_to_live": 100,
        "notification": {
          "title": 'processName',
          "body": 'processName',
        },
        "data": {
          "title": 'titleData',
          "body": {'ttt': 'tttt'},
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "sound": "default",
          "status": "done",
        },
      });
    } catch (e) {
      throw e;
    }
  }
}
