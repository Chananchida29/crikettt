// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:newtest/config/constant.dart';
import 'package:newtest/model/cricket_model.dart';
import 'package:newtest/screen/Cricket/timeline/provider/timeline_cricket_provider.dart';
import 'package:newtest/screen/createCricket/createCricket.dart';
import 'package:newtest/utils/dialog.dart';
import 'package:provider/provider.dart';

import 'timelineprogressCricket.dart';

class TimelinePage extends StatefulWidget {
  CricketModel cricketModel;
  TimelinePage({this.cricketModel});
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimeLineCircketProvider>(
      create: (context) =>
          TimeLineCircketProvider(cricketModel: widget.cricketModel),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('จัดการบ่อเลี้ยง'),
            centerTitle: true,
            backgroundColor: pColor,
          ),
          backgroundColor: Color(0xFFEAEED7),
          body: Builder(builder: (context) {
            return Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 60),
                          Consumer<TimeLineCircketProvider>(
                            builder: (context, timeLineCircketProvider, child) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      'ชื่อบ่อ : ${timeLineCircketProvider.cricketModel.nameOfPond}'),
                                  Text(
                                      'วันที่สร้าง : ${timeLineCircketProvider.cricketModel.dateTime.day}-${timeLineCircketProvider.cricketModel.dateTime.month}-${timeLineCircketProvider.cricketModel.dateTime.year}'),
                                  Text(
                                      'สายพันธุ์ : ${timeLineCircketProvider.cricketModel.spieces}'),
                                  Text(
                                      'ประเภทบ่อเลี้ยง : ${timeLineCircketProvider.cricketModel.sizePond}'),
                                  Text(
                                      'จำนวนขัน : ${timeLineCircketProvider.cricketModel.guideCricket}')
                                ],
                              );
                            },
                          ),
                          IconButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CreateEditCricket(
                                            cricketModel: context
                                                .read<TimeLineCircketProvider>()
                                                .cricketModel,
                                            resetStatus: false,
                                          )),
                                );
                                await context
                                    .read<TimeLineCircketProvider>()
                                    .fetchData(context: context);
                              },
                              icon: Icon(Icons.edit))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: ProgressTimeline(),
                    ),
                    // Consumer<TimeLineCircketProvider>(
                    //   builder: (context, value, child) {
                    //     return value.cricketModel.status != 'บ่อว่าง'
                    //         ? TextButton(
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(15.0),
                    //               child: Text(
                    //                 " ถัดไป ",
                    //                 style: TextStyle(
                    //                     fontSize: 20, color: Colors.white),
                    //               ),
                    //             ),
                    //             style: TextButton.styleFrom(
                    //               backgroundColor: Colors.green,
                    //               shape: new RoundedRectangleBorder(
                    //                   borderRadius:
                    //                       new BorderRadius.circular(20.0)),
                    //             ),
                    //             onPressed: () async {
                    //               if (context
                    //                       .read<TimeLineCircketProvider>()
                    //                       .cricketModel
                    //                       .statusModelList
                    //                       .length ==
                    //                   7) {
                    //                 await context
                    //                     .read<TimeLineCircketProvider>()
                    //                     .resetStep(context: context);
                    //               } else {
                    //                 await context
                    //                     .read<TimeLineCircketProvider>()
                    //                     .onPressNextStep(context: context);
                    //               }
                    //             },
                    //           )
                    //         : SizedBox.shrink();
                    //   },
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          " เริ่มเลี้ยงใหม่ ",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0)),
                      ),
                      onPressed: () async {
                        // edit
                        try {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CreateEditCricket(
                                      cricketModel: context
                                          .read<TimeLineCircketProvider>()
                                          .cricketModel,
                                      resetStatus: true,
                                    )),
                          );
                          await context
                              .read<TimeLineCircketProvider>()
                              .fetchData(context: context);
                        } catch (e) {
                          AlertUtils.dialogAlert(
                              context: context, subTitle: e.toString());
                        }
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
