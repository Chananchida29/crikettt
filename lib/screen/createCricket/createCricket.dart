// ignore_for_file: must_be_immutable

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:newtest/config/constant.dart';
import 'package:flutter/material.dart';
import 'package:newtest/model/cricket_model.dart';
import 'package:newtest/screen/createCricket/provider/createCricketProvider.dart';
import 'package:newtest/screen/createCricket/step1.dart';
import 'package:newtest/screen/createCricket/step2.dart';
import 'package:newtest/screen/createCricket/step3.dart';
import 'package:newtest/utils/dialog.dart';
import 'package:provider/provider.dart';

class CreateEditCricket extends StatefulWidget {
  // หน้าจอหลัก สำหรับการสร้างหรือแก้ไขข้อมูล
  CricketModel cricketModel;
  bool resetStatus;
  CreateEditCricket({this.cricketModel, this.resetStatus = false});
  @override
  _CreateEditCricketState createState() => _CreateEditCricketState();
}

class _CreateEditCricketState extends State<CreateEditCricket> {
  // กำหนด State สำหรับหน้าจอ Create/Edit Cricket
  int currentStep = 0; // ใช้เพื่อเก็บขั้นตอนปัจจุบัน
  bool isCompleted =
      false; // ใช้เพื่อเก็บข้อมูลเกี่ยวกับการทำงานเสร็จสมบูรณ์ของขั้นตอนทั้งหมดหรือไม่
  double screenWidth; // ใช้เพื่อเก็บความกว้างของหน้าจอ

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider<CreateEditCricketProvider>(
      //
      create: widget.cricketModel != null
          ? (context) =>
              CreateEditCricketProvider(cricketModel: widget.cricketModel)
          : (context) => CreateEditCricketProvider(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: widget.cricketModel == null
                ? Text('CreateCricket')
                : Text('EditCricket'),
            centerTitle: true,
            backgroundColor: pColor,
          ),
          backgroundColor: Color(0xFFEAEED7),
          body: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(primary: Colors.red),
            ),
            child: Stepper(
                // แสดงขั้นตอนการกรอกข้อมูลและจะต้องระบุ type
                type: StepperType.horizontal, // แสดงเป็นแนวนอน
                steps: getSteps(),
                currentStep: currentStep,
                onStepContinue: () {
                  final isLastStep = currentStep == getSteps().length - 1;
                  if (isLastStep) {
                    setState(() => isCompleted = true);
                  } else {
                    setState(() => currentStep += 1);
                  }
                },
                onStepTapped: (step) => null,
                onStepCancel: currentStep == 0
                    ? null
                    : () => setState(() => currentStep -= 1),
                controlsBuilder: (context, details) {
                  // กำหนดวิธีการแสดงกลับ ("BACK") และปุ่มตกลง (CONFIRM / NEXT)
                  final isLastStep = currentStep == getSteps().length - 1;
                  return Container(
                      margin: EdgeInsets.only(top: 50),
                      child: Row(children: [
                        if (currentStep !=
                            0) // ตรวจสอบว่าอยู่ที่ขั้นตอนไหน ถ้าไม่ใช่ขั้นตอนแรกก็จะแสดงปุ่มกลับ
                          Expanded(
                            child: ElevatedButton(
                              child: Text('BACK'),
                              onPressed: details.onStepCancel,
                            ),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                              child: Text(isLastStep
                                  ? 'CONFIRM'
                                  : 'NEXT'), //  ตรวจสอบว่า isLastStep ถ้าเป็น true ก็จะแสดงปุ่มตกลงเป็น CONFIRM มิฉะนั้นจะแสดงเป็น NEXT
                              onPressed: () async {
                                // มีเงื่อนไขเพื่อตรวจสอบข้อมูลในขั้นตอนที่กำลังทำอยู่
                                CreateEditCricketProvider
                                    createCricketProvider =
                                    context.read<CreateEditCricketProvider>();
                                if (currentStep == 0 &&
                                    createCricketProvider
                                        .formKeyStep1.currentState
                                        .validate()) {
                                  if (createCricketProvider.speciesChoose ==
                                      null) {
                                    AlertUtils.normalDialog(
                                        context,
                                        'ยังไม่ได้เลือกสายพันธ์ุ',
                                        'กรุณาเลือกสายพันธุ์ด้วย');
                                  } else if (createCricketProvider
                                          .typePondChoose ==
                                      null) {
                                    AlertUtils.normalDialog(
                                        context,
                                        'ยังไม่ได้เลือกประเภทของบ่อเลี้ยง',
                                        'กรุณาเลือกประเภทของบ่อเลี้ยงด้วย');
                                  } else {
                                    details.onStepContinue();
                                  }
                                } else if (currentStep == 1 &&
                                    createCricketProvider
                                        .formKeyStep2.currentState
                                        .validate()) {
                                  createCricketProvider
                                      .calculateSizeOfPondAndGuideOfCricket();
                                  details.onStepContinue();
                                } else if (currentStep == 2) {
                                  try {
                                    await EasyLoading.show();
                                    if (widget.cricketModel != null) {
                                      await createCricketProvider
                                          .editCricketToFirebase(
                                              resetStatus: widget.resetStatus);
                                    } else {
                                      await createCricketProvider
                                          .createCricketToFirebase();
                                    }

                                    await EasyLoading.dismiss();
                                    Navigator.pop(
                                        context); // การปิดหน้าจอเพื่อกลับไปยังหน้าจอก่อนหน้านี้หลังจากทำงานเสร็จสมบูรณ์
                                  } catch (e) {
                                    await EasyLoading.dismiss();
                                    AlertUtils.dialogAlert(
                                        context: context,
                                        subTitle: e.toString());
                                  }
                                }
                              }),
                        ),
                      ]));
                }),
          ),
        ),
      ),
    );
  }

  List<Step> getSteps() => [
        // ฟังก์ชันที่สร้างและคืนรายการ
        Step(
            state: currentStep > 0
                ? StepState.complete
                : StepState
                    .indexed, // ตรวจสอบว่าขั้นตอนนี้ถูกทำสำเร็จหรือไม่ ถ้ามากกว่า 0 จะเป็น complete
            isActive: currentStep >= 0,
            title: Text('General'),
            content: CreateCricketStep1(
              cricketModel: widget.cricketModel,
            )),
        Step(
            state: currentStep > 1
                ? StepState.complete
                : StepState
                    .indexed, // คล้ายกับ Step แรก แต่เช็ค currentStep ว่ามากกว่าหรือเท่ากับ 1
            isActive: currentStep >= 1,
            title: Text('Size ponds'),
            content: CreateCricketStep2(
              cricketModel: widget.cricketModel,
            )),
        Step(
            isActive: currentStep >=
                2, // isActive จะถูกตั้งค่าเป็น true ถ้า currentStep มากกว่าหรือเท่ากับ 2
            title: Text('Complete'),
            content: CreateCricketStep3(
              cricketModel: widget.cricketModel,
            )),
      ];
}
