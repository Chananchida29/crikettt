import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:newtest/model/cricket_model.dart';
import 'package:newtest/screen/Cricket/timeline/timelineprogressCricket.dart';
import 'package:newtest/services/firebase_database_service.dart';
import 'package:newtest/utils/dialog.dart';

class TimeLineCircketProvider extends ChangeNotifier {
  TimeLineCircketProvider({this.cricketModel});
  CricketModel cricketModel;
  SingleState singleState1 = SingleState(stateTitle: "เตรียมบ่อเลี้ยง");
  SingleState singleState2 = SingleState(stateTitle: "บ่มไข่จิ้งหรีด");
  SingleState singleState3 = SingleState(stateTitle: "จิ้งหรีดเจริญเติบโต");
  SingleState singleState4 = SingleState(stateTitle: "จิ้งหรีดวางไข่");
  SingleState singleState5 = SingleState(stateTitle: "เก็บไข่จิ้งหรีด");
  SingleState singleState6 = SingleState(stateTitle: "ทำความสะอาดบ่อ");
  SingleState singleState7 = SingleState(stateTitle: "บ่อว่าง");
  List<SingleState> allStages = [];
  int currentStep = 0;

  void setCricket({CricketModel cricket}) {
    cricketModel = cricket;
  }

  void setSingleStateList() {
    allStages.clear();
    singleState1 = SingleState(stateTitle: "เตรียมบ่อเลี้ยง");
    singleState2 = SingleState(stateTitle: "บ่มไข่จิ้งหรีด");
    singleState3 = SingleState(stateTitle: "จิ้งหรีดเจริญเติบโต");
    singleState4 = SingleState(stateTitle: "จิ้งหรีดวางไข่");
    singleState5 = SingleState(stateTitle: "เก็บไข่จิ้งหรีด");
    singleState6 = SingleState(stateTitle: "ทำความสะอาดบ่อ");
    singleState7 = SingleState(stateTitle: "บ่อว่าง");
    for (int i = 0; i < cricketModel.statusModelList.length; i++) {
      if (cricketModel.statusModelList[i].status == 'เตรียมบ่อเลี้ยง') {
        singleState1 = SingleState(
            stateTitle: "เตรียมบ่อเลี้ยง",
            dateTime: cricketModel.statusModelList[i].dateTime);
      } else if (cricketModel.statusModelList[i].status == 'บ่มไข่จิ้งหรีด') {
        singleState2 = SingleState(
            stateTitle: "บ่มไข่จิ้งหรีด",
            dateTime: cricketModel.statusModelList[i].dateTime);
      } else if (cricketModel.statusModelList[i].status ==
          'จิ้งหรีดเจริญเติบโต') {
        singleState3 = SingleState(
            stateTitle: "จิ้งหรีดเจริญเติบโต",
            dateTime: cricketModel.statusModelList[i].dateTime);
      } else if (cricketModel.statusModelList[i].status == 'จิ้งหรีดวางไข่') {
        singleState4 = SingleState(
            stateTitle: "จิ้งหรีดวางไข่",
            dateTime: cricketModel.statusModelList[i].dateTime);
      } else if (cricketModel.statusModelList[i].status == 'เก็บไข่จิ้งหรีด') {
        singleState5 = SingleState(
            stateTitle: "เก็บไข่จิ้งหรีด",
            dateTime: cricketModel.statusModelList[i].dateTime);
      } else if (cricketModel.statusModelList[i].status == 'ทำความสะอาดบ่อ') {
        singleState6 = SingleState(
            stateTitle: "ทำความสะอาดบ่อ",
            dateTime: cricketModel.statusModelList[i].dateTime);
      } else if (cricketModel.statusModelList[i].status == 'บ่อว่าง') {
        singleState7 = SingleState(
            stateTitle: "บ่อว่าง",
            dateTime: cricketModel.statusModelList[i].dateTime);
      }
    }
    allStages.add(singleState1);
    allStages.add(singleState2);
    allStages.add(singleState3);
    allStages.add(singleState4);
    allStages.add(singleState5);
    allStages.add(singleState6);
    allStages.add(singleState7);
    for (int i = 0; i < allStages.length; i++) {
      if (cricketModel.status == allStages[i].stateTitle) {
        currentStep = i + 1;
        break;
      }
    }
  }

  Future<void> onPressNextStep({BuildContext context}) async {
    try {
      await EasyLoading.show();
      await FirebaseDataUtils.updateStatusCricketFirebase(
          cricketModel: cricketModel,
          status: allStages[currentStep].stateTitle,
          dateTime: DateTime.now());

      cricketModel =
          await FirebaseDataUtils.getCricket(cricketId: cricketModel.cricketId);
      setSingleStateList();
      await EasyLoading.dismiss();
      notifyListeners();
    } catch (e) {
      await EasyLoading.dismiss();
      AlertUtils.dialogAlert(context: context, subTitle: e.toString());
    }
  }

  Future<void> fetchData({BuildContext context}) async {
    try {
      await EasyLoading.show();
      cricketModel =
          await FirebaseDataUtils.getCricket(cricketId: cricketModel.cricketId);
      setSingleStateList();
      await EasyLoading.dismiss();
      notifyListeners();
    } catch (e) {
      await EasyLoading.dismiss();
      AlertUtils.dialogAlert(context: context, subTitle: e.toString());
    }
  }

  Future<void> resetStep({BuildContext context}) async {
    try {
      await EasyLoading.show();
      await FirebaseDataUtils.clearStatusCricketFirebase(
          cricketId: cricketModel.cricketId, dateTime: DateTime.now());
      cricketModel =
          await FirebaseDataUtils.getCricket(cricketId: cricketModel.cricketId);
      setSingleStateList();
      await EasyLoading.dismiss();
      notifyListeners();
    } catch (e) {
      await EasyLoading.dismiss();
      AlertUtils.dialogAlert(context: context, subTitle: e.toString());
    }
  }
}
