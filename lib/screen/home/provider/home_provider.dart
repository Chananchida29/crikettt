import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:newtest/model/cricket_model.dart';
import 'package:newtest/services/firebase_database_service.dart';

class HomeProvider extends ChangeNotifier {
  List<CricketModel> cricketModelList = [];
  List<String> allStages = [
    "เตรียมบ่อเลี้ยง",
    "บ่มไข่จิ้งหรีด",
    "จิ้งหรีดเจริญเติบโต",
    "จิ้งหรีดวางไข่",
    "เก็บไข่จิ้งจิ้งหรีดวางไข่หรีด",
    "ทำความสะอาดบ่อ",
    "บ่อว่าง",
  ];
  int currentStep = 0;

  void setCricket({CricketModel cricket}) {
    cricketModelList.add(cricket);
  }

  void clearCricket() {
    cricketModelList.clear();
    notifyListeners();
  }

  bool isLoading = false;
  void forceRebuild() async {
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    isLoading = false;
    notifyListeners();
  }

  Future<CricketModel> editCricketToDoToFirebase(
      {CricketModel cricketModel, DateTime dateTime, String status, String process, bool statusOfProcess}) async {
    await FirebaseDataUtils.editCricketToDoToFirebase(
        cricketModel: cricketModel,
        updateDateTime: dateTime,
        status: status,
        statusOfProcess: statusOfProcess,
        process: process);
    CricketModel cricketModelCheck = await FirebaseDataUtils.getCricket(cricketId: cricketModel.cricketId);
    if (cricketModelCheck.toDoList[1].subToDoAllDone &&
        !cricketModelCheck.toDoList[2].subToDoAllDone &&
        status == 'เตรียมอุปกรณ์') {
      await FirebaseDataUtils.editCricketToDoToFirebase(
          cricketModel: cricketModelCheck,
          updateDateTime: dateTime,
          statusMustSetTime: 'wait_5_day_incubate_eggs',
          status: 'บ่มไข่จิ้งหรีด',
          statusOfProcess: true,
          process:
              'ค่อยสังเกตจิ้งหรีดเริ่มฟักตัว ให้เปิดปากกระสอบที่ใช้อบ ปล่อยให้จิ้งหรีดไต่ออกมาจากกระสอบ เอาน้ำเอาอาหารวางไว้');
      String fcmToken = await FirebaseMessaging.instance.getToken();
      await FirebaseDataUtils.recordNotificationScheduleJobs(
        fcmToken: fcmToken,
        idMyCK: cricketModelCheck.cricketId,
        dailyTimeToSend: 6,
        notificationDetail: "${cricketModel.nameOfPond} : เริ่มฟักตัวรึยังจ๊ะ ?",
        notificationName: 'สังเกตจิ้งหรีด',
      );
    } else if (status == 'บ่มไข่จิ้งหรีด') {
      await FirebaseDataUtils.removeRecordNotificationSheduleJobs(cricketModelCheck.cricketId);
      String fcmToken = await FirebaseMessaging.instance.getToken();
      await FirebaseDataUtils.recordNotificationScheduleJobs(
        fcmToken: fcmToken,
        idMyCK: cricketModelCheck.cricketId,
        notificationDetail: "${cricketModel.nameOfPond} นะจ๊ะ",
        sendNotificationBothIn6AmAnd6Pm: true,
        notificationName: 'อย่าลืมให้อาหารจิ้งหรีด',
      );
      await FirebaseDataUtils.recordNotificationScheduleJobs(
        fcmToken: fcmToken,
        idMyCK: cricketModelCheck.cricketId,
        notificationDetail: "เตรียมรองไข่จิ้งหรีดกัน ",
        notificationName: 'จิ้งหรีดจะวางไข่แล้ว !',
      );
    } else if (status == 'จิ้งหรีดวางไข่') {
      String fcmToken = await FirebaseMessaging.instance.getToken();
      await FirebaseDataUtils.recordNotificationScheduleJobs(
        fcmToken: fcmToken,
        idMyCK: cricketModelCheck.cricketId,
        dailyTimeToSend: 6,
        notificationDetail: "",
        notificationName: 'ได้เวลาเก็บจิ้งหรีดแล้วนะ',
      );
      await FirebaseDataUtils.editCricketToDoToFirebase(
          cricketModel: cricketModelCheck,
          updateDateTime: dateTime,
          statusMustSetTime: 'wait_12_hour_collect_eggs',
          status: 'เก็บไข่จิ้งหรีด',
          statusOfProcess: true,
          process: 'นำไข่จิ้งหรีดใส่ถุงกระสอบ ปิดปากถุงกระสอบไม่ต้องปิดแน่นมาก ให้ปิดพอหลวม');
    } else if (status == 'เก็บไข่จิ้งหรีด') {
      await FirebaseDataUtils.removeRecordNotificationSheduleJobs(cricketModelCheck.cricketId);
    }
    CricketModel resultCricketModel = await FirebaseDataUtils.getCricket(cricketId: cricketModelCheck.cricketId);
    return resultCricketModel;
  }
}
