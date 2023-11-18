// ignore_for_file: missing_return

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:newtest/config/checkbox.dart';
import 'package:newtest/config/constant.dart';
import 'package:newtest/model/cricket_model.dart';
import 'package:newtest/provider/notification_provider.dart';
import 'package:newtest/screen/createCricket/createCricket.dart';
import 'package:newtest/screen/home/provider/home_provider.dart';
import 'package:newtest/screen/notification/notification_list_screen.dart';
import 'package:newtest/services/firebase_database_service.dart';
import 'package:newtest/utils/dialog.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final double buttonSize = 40;
  final animationDuration = Duration(milliseconds: 800);
  @override
  Widget build(BuildContext ctx) {
    return ChangeNotifierProvider<HomeProvider>(
      create: (context) => HomeProvider(),
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Cricket Farming'),
              backgroundColor: pColor,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          ctx,
                          MaterialPageRoute(
                            builder: (context) => NotificationListPage(),
                          ));
                    },
                    icon: ctx.watch<NotificationProvider>().notificationList.length != 0
                        ? badges.Badge(
                            badgeContent: Text('${ctx.watch<NotificationProvider>().notificationList.length}'),
                            child: Icon(Icons.notifications_none))
                        : Icon(Icons.notifications_none))
              ],
            ),
            backgroundColor: Colors.transparent,
            body: Consumer<HomeProvider>(
              builder: (context, value, child) {
                if (context.read<HomeProvider>().isLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return SingleChildScrollView(
                  child: Container(
                      child: FirebaseAnimatedList(
                    query: FirebaseDataUtils.dbfirebaseCricket,
                    shrinkWrap: true,
                    duration: const Duration(milliseconds: 300),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, snapshot, animation, index) {
                      Map dataCricket = snapshot.value as Map;
                      dataCricket.addAll({'cricketId': snapshot.key});
                      CricketModel cricketModel = CricketModel.fromJson(dataCricket);
                      context.read<HomeProvider>().setCricket(cricket: cricketModel);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpansionTile(
                          key: Key(index.toString()),
                          backgroundColor: uColor,
                          collapsedBackgroundColor: uColor,
                          initiallyExpanded: true,
                          title: Text(cricketModel.nameOfPond,
                              style: TextStyle(color: Color(0xFF09216B), fontSize: 17.0, fontWeight: FontWeight.bold)),
                          children: <Widget>[
                            SingleChildScrollView(
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: cricketModel.toDoList.length,
                                physics: NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) {
                                  return Divider();
                                },
                                itemBuilder: (context, index) {
                                  DateTime timeAbleToClickCheck =
                                      cricketModel.toDoList[index].timeAbleToCanClickCheckBox;
                                  bool thisTimeCanClickCheck = timeAbleToClickCheck != null;
                                  bool canClickThisTime = false;
                                  if (thisTimeCanClickCheck) {
                                    DateTime dateTimeNow = DateTime.now();
                                    if (timeAbleToClickCheck.isBefore(dateTimeNow)) {
                                      canClickThisTime = true;
                                    }
                                  }
                                  bool isAbleToCheck = false;
                                  if (thisTimeCanClickCheck) {
                                    isAbleToCheck =
                                        (index != 0 ? cricketModel.toDoList[index - 1].subToDoAllDone : true) &&
                                            canClickThisTime;
                                  } else {
                                    isAbleToCheck = index != 0 ? cricketModel.toDoList[index - 1].subToDoAllDone : true;
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10, bottom: 10),
                                          child: Text('${cricketModel.toDoList[index].status}',
                                              style: TextStyle(
                                                  color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.bold)),
                                        ),
                                        Container(
                                          height: (cricketModel.toDoList[index].subToDoList.length.toDouble()) * 80,
                                          child: ListView.separated(
                                            itemCount: cricketModel.toDoList[index].subToDoList.length,
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            separatorBuilder: (context, index) {
                                              return Divider();
                                            },
                                            itemBuilder: (context, i) {
                                              bool isLiked = cricketModel.toDoList[index].subToDoList[i].done;
                                              return Column(
                                                children: [
                                                  Container(
                                                      margin: EdgeInsets.fromLTRB(3, 3, 3, 3),
                                                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          CustomCheckbox(
                                                            isAbleToCheck: !isLiked && isAbleToCheck,
                                                            isChecked: isLiked,
                                                            onChange: (value) async {
                                                              if (!isLiked && isAbleToCheck) {
                                                                try {
                                                                  CricketModel cricketModelResult = await context
                                                                      .read<HomeProvider>()
                                                                      .editCricketToDoToFirebase(
                                                                        cricketModel: cricketModel,
                                                                        dateTime: DateTime.now(),
                                                                        status: cricketModel.toDoList[index].status,
                                                                        process: cricketModel
                                                                            .toDoList[index].subToDoList[i].process,
                                                                        statusOfProcess: isLiked,
                                                                      );
                                                                  if (cricketModelResult.toDoList.last.subToDoAllDone) {
                                                                    AlertUtils.selectDialogAlert(
                                                                        context: context,
                                                                        icon: Icon(Icons.delete),
                                                                        title: 'จบการเลี้ยง',
                                                                        textButton1: 'เริ่มเลี้ยงใหม่',
                                                                        textButton2: 'ตกลง',
                                                                        onPress1: () async {
                                                                          context.read<HomeProvider>().clearCricket();
                                                                          try {
                                                                            await Navigator.push(
                                                                              ctx,
                                                                              MaterialPageRoute(
                                                                                  builder: (_) => CreateEditCricket(
                                                                                        cricketModel: cricketModel,
                                                                                        resetStatus: true,
                                                                                      )),
                                                                            ).then((value) => setState(() {
                                                                                  context
                                                                                      .read<HomeProvider>()
                                                                                      .forceRebuild();
                                                                                }));
                                                                          } catch (e) {
                                                                            AlertUtils.dialogAlert(
                                                                                context: context,
                                                                                subTitle: e.toString());
                                                                          }
                                                                        },
                                                                        onPress2: () async {
                                                                          try {
                                                                            await EasyLoading.show();
                                                                            await FirebaseDataUtils
                                                                                .deleteCricketFirebase(
                                                                                    cricketId: cricketModel.cricketId);
                                                                            await EasyLoading.dismiss();
                                                                          } catch (e) {
                                                                            await EasyLoading.dismiss();
                                                                            AlertUtils.dialogAlert(
                                                                                context: context,
                                                                                subTitle: e.toString());
                                                                          }
                                                                        });
                                                                  }
                                                                } catch (e) {
                                                                  AlertUtils.dialogAlert(
                                                                      context: context, subTitle: e.toString());
                                                                }
                                                              }
                                                            },
                                                            backgroundColor: tColor,
                                                            borderColor: tColor,
                                                            icon: Icons.check,
                                                            size: 26,
                                                            iconSize: 25,
                                                          ),
                                                          Flexible(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 20),
                                                              child: Text(
                                                                  '${cricketModel.toDoList[index].subToDoList[i].process}',
                                                                  overflow: TextOverflow.visible,
                                                                  maxLines: 3),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                  cricketModel.toDoList[index].subToDoList.length - 1 == i
                                                      ? Divider()
                                                      : Container()
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                          onExpansionChanged: ((newState) {
                            if (newState)
                              setState(() {
                                Duration(seconds: 20000);
                              });
                          }),
                        ),
                      );
                    },
                  )),
                );
              },
            )),
      ),
    );
  }
}
