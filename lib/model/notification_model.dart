class NotificationModel {
  // คลาส การเก็บข้อมูลที่เกี่ยวกับการแจ้งเตือน
  String title; // สตริงที่เก็บข้อความหัวเรื่อง
  String subTitle; // สตริงที่เก็บข้อความรายละเอียด
  bool
      readed; // ตัวแปรที่บ่งชี้ว่าการแจ้งเตือนถูกอ่านหรือไม่ (true หากถูกอ่าน, false หากยังไม่ถูกอ่าน)
  NotificationModel({this.title, this.subTitle, this.readed});
}
