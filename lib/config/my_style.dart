import 'package:flutter/material.dart';

class MyStyle {
  // คลาส กำหนดค่าสี สไตล์ โลโก้
  Color darkColor = Color(0xFF9C5F28); //  ตัวแปรที่เก็บค่าสีเข้ม

  TextStyle darkStyle() => TextStyle(color: darkColor); // กำหนดสีข้อความ

  Widget showLogo() => Image.asset(
        // ฟังก์ชันที่คืนค่า Widget
        "asset/image/robot.png",
      );
}
