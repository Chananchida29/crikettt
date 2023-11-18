import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:newtest/config/constant.dart';
import 'package:newtest/model/cricket_model.dart';
import 'package:newtest/screen/Cricket/timeline/provider/timeline_cricket_provider.dart';
import 'package:newtest/screen/createCricket/createCricket.dart';
import 'package:newtest/services/firebase_database_service.dart';
import 'package:newtest/utils/dialog.dart';
import 'package:provider/provider.dart';

import 'timeline/timelineCricket.dart';

class ViewCricket extends StatefulWidget {
  const ViewCricket({Key key}) : super(key: key);

  @override
  _ViewCricketState createState() => _ViewCricketState();
}

class _ViewCricketState extends State<ViewCricket> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 70),
      child: Scaffold(
        appBar: AppBar(
          title: Text('บ่อจิ้งหรีด'),
          centerTitle: true,
          backgroundColor: pColor,
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          child: FirebaseAnimatedList(
            query: FirebaseDataUtils.dbfirebaseCricket,
            duration: Duration(milliseconds: 300),
            itemBuilder: (context, snapshot, animation, index) {
              Map dataCricket = snapshot.value as Map;
              dataCricket.addAll({'cricketId': snapshot.key});
              CricketModel cricketModel = CricketModel.fromJson(dataCricket);
              return Container(
                height: 150,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10,
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TimelinePage(
                              cricketModel: cricketModel,
                            ),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        child: Icon(
                          Icons.insert_emoticon_outlined,
                          size: 30,
                        ),
                        backgroundColor: Colors.green.shade100,
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(cricketModel.nameOfPond),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(" สายพันธุ์ : " + cricketModel.spieces),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(" Date " +
                                  '${cricketModel.dateTime.day} - ${cricketModel.dateTime.month} - ${cricketModel.dateTime.year}'),
                            ),
                            Text(' Status:: ${cricketModel.status}'),
                          ],
                        ),
                      ),
                      trailing: Column(
                        children: [
                          Expanded(
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                AlertUtils.selectDialogAlert(
                                    context: context,
                                    icon: Icon(Icons.delete),
                                    title: 'คุณต้องการลบข้อมูลหรือไม่',
                                    textButton1: 'ปิด',
                                    textButton2: 'ตกลง',
                                    onPress2: () async {
                                      try {
                                        await EasyLoading.show();
                                        await FirebaseDataUtils.deleteCricketFirebase(
                                            cricketId: cricketModel.cricketId);
                                        await EasyLoading.dismiss();
                                      } catch (e) {
                                        await EasyLoading.dismiss();
                                        AlertUtils.dialogAlert(context: context, subTitle: e.toString());
                                      }
                                    });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            elevation: 30,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateEditCricket()),
              );
            }),
      ),
    );
  }
}
