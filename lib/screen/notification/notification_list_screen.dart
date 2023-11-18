import 'package:flutter/material.dart';
import 'package:newtest/config/constant.dart';
import 'package:newtest/provider/notification_provider.dart';
import 'package:provider/provider.dart';

class NotificationListPage extends StatefulWidget {
  // คลาส  Noti ขยายการทำงาน
  NotificationListPage({Key key}) : super(key: key);

  @override
  State<NotificationListPage> createState() =>
      _NotificationListPageState(); // ส่วนสร้าง UI ฟังก์ชั่นต่างๆ
}

class _NotificationListPageState extends State<NotificationListPage> {
  @override
  void initState() {
    // เมธอด สร้าง state ของ widget เพื่อตั้งค่าเริ่มต้น
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // เมื่อเฟรมถูกใช้งานจะทำการ callback ที่ได้รับ
      await context.read<NotificationProvider>().getNotificationList();
    });
  } // ดึงข้อมูลการทำงานอื่น ๆ เกี่ยวกับการแจ้งเตือน

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // สร้างหน้าจอหลัก
      backgroundColor: Color(0xFFEAEED7),
      appBar: AppBar(
        title: Text('การเเจ้งเตือนของฉัน'),
        centerTitle: true,
        backgroundColor: pColor,
      ),
      body: context.watch<NotificationProvider>().notificationList.length != 0
          ? ListView.separated(
              // ListView ที่สามารถเลื่อนได้และแยกรายการ
              itemBuilder: (context, index) {
                return Card(
                  // แสดงข้อความจากการแจ้งเตือน
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(context
                            .read<NotificationProvider>()
                            .notificationList[index]
                            .title),
                        SizedBox(
                          height: 10,
                        ),
                        Text(context
                            .read<NotificationProvider>()
                            .notificationList[index]
                            .subTitle)
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 0.5,
                );
              },
              itemCount:
                  context.read<NotificationProvider>().notificationList.length)
          : Center(
              // ไม่มีการแจ้งเตือน จะแสดงข้อความ "ยังไม่มีการแจ้งเตือน
              child: Text('ยังไม่มีการแจ้งเตือน'),
            ),
    );
  } // ส่วนที่สำคัญของการสร้าง UI
}
