import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:newtest/model/cricket_model.dart';
import 'package:newtest/services/firebase_database_service.dart';

class CreateEditCricketProvider extends ChangeNotifier {
  CricketModel cricketModel;
  CreateEditCricketProvider({this.cricketModel});

  /// ชื่อบ่อ
  String nameOfPond;

  /// สายพันธ์ที่เลือก
  String speciesChoose;

  /// ประเภทบ่อที่เลือก
  String typePondChoose;

  /// ขนาดของบ่อ
  double sizePond;

  /// จำนวนขัน
  int guideCricket;

  /// วันที่เริ่มเลี้ยง
  DateTime dateStartRaise = DateTime.now();

  GlobalKey<FormState> formKeyStep1 = GlobalKey<FormState>();

  GlobalKey<FormState> formKeyStep2 = GlobalKey<FormState>();

  void getNameOfPond({String name}) {
    nameOfPond = name;
  }

  void getSpecies({String species}) {
    speciesChoose = species;
  }

  void getTypePond({String pond}) {
    typePondChoose = pond;
  }

  void getDateStartRaise({DateTime date}) {
    dateStartRaise = date;
  }

  double widthOfPond;
  void getWidthOfPond({String width}) {
    if (width == null || width.trim().isEmpty) {
      widthOfPond = 0;
    } else {
      widthOfPond = double.parse(width);
    }
  }

  double heightOfPond;
  void getHeightOfPond({String height}) {
    if (height == null || height.trim().isEmpty) {
      heightOfPond = 0;
    } else {
      heightOfPond = double.parse(height);
    }
  }

  double lengthOfPond;
  void getLengthOfPond({String length}) {
    if (length == null || length.trim().isEmpty) {
      lengthOfPond = 0;
    } else {
      lengthOfPond = double.parse(length);
    }
  }

  double diameterOfPond;
  void getDiameterOfPond({String diameter}) {
    if (diameter == null || diameter.trim().isEmpty) {
      diameterOfPond = 0;
    } else {
      diameterOfPond = double.parse(diameter);
    }
  }

  void calculateSizeOfPondAndGuideOfCricket() {
    if (typePondChoose == 'บ่อกลม') {
      sizePond = 3.14 * (diameterOfPond / 2) * (diameterOfPond / 2);
      guideCricket = (sizePond / 0.35).round();
    } else if (typePondChoose == 'บ่อสี่เหลี่ยม') {
      sizePond = widthOfPond * lengthOfPond * heightOfPond;
      guideCricket = (sizePond / 0.35).round();
    }
  }

  Future<void> createCricketToFirebase() async {
    await FirebaseDataUtils.createCricketToFirebase(
      nameOfPond: nameOfPond,
      dateStartRaise: dateStartRaise,
      sizePond: sizePond,
      guideCricket: guideCricket,
      speciesChoose: speciesChoose,
      typePond: typePondChoose,
      diameterOfPond: diameterOfPond,
      heightOfPond: heightOfPond,
      lengthOfPond: lengthOfPond,
      widthOfPond: widthOfPond,
    );
  }

  Future<void> editCricketToFirebase({bool resetStatus = false}) async {
    if (typePondChoose == 'บ่อกลม') {
      widthOfPond = null;
      heightOfPond = null;
      lengthOfPond = null;
    } else if (typePondChoose == 'บ่อสี่เหลี่ยม') {
      diameterOfPond = null;
    }
    await FirebaseDataUtils.editCricketToFirebase(
        cricketModel: cricketModel,
        nameOfPond: nameOfPond,
        dateStartRaise: dateStartRaise,
        sizePond: sizePond,
        guideCricket: guideCricket,
        speciesChoose: speciesChoose,
        typePond: typePondChoose,
        diameterOfPond: diameterOfPond,
        heightOfPond: heightOfPond,
        lengthOfPond: lengthOfPond,
        widthOfPond: widthOfPond,
        resetStatus: resetStatus);
  }
}
