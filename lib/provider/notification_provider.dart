import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newtest/model/money_model.dart';
import 'package:newtest/model/notification_model.dart';
import 'package:newtest/services/firebase_database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> notificationList =
      []; // ลิสต์ที่ใช้ในการเก็บข้อมูลทั้งหมด

  Future<void> getNotificationList() async {
    // ฟังก์ชันที่ใช้ในการดึงข้อมูลการแจ้งเตือน
    notificationList.clear();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('notificationList') != null) {
      List notificationSharedPreferencesList =
          jsonDecode(sharedPreferences.getString('notificationList'));
      List notificationJsonList = notificationSharedPreferencesList;
      notificationJsonList.forEach((element) {
        notificationList.add(NotificationModel(
            readed: element['readed'],
            subTitle: element['subTitle'],
            title: element['title']));
      });
    }
    notifyListeners();
  }

  void addNotification(NotificationModel notificationModel) {
    // ฟังก์ชันที่ใช้ในการเพิ่ม Noti
    notificationList.add(notificationModel);
    notifyListeners();
  }

  void removeNotification(int index) {
    // ฟังก์ชันที่ใช้ในการลบ Noti
    notificationList.removeAt(index);
    notifyListeners();
  }

  void readNotificationIndex(int index) {
    // ฟังก์ชันที่ใช้ในการเปลี่ยนสถานะ readed เป็น true
    notificationList[index].readed = true;
    notifyListeners();
  }
}
