import 'package:flutter/material.dart';
import 'package:newtest/config/my_style.dart';

Future<Null> normalDialog(
    BuildContext context, String title, String message) async {
  showDialog(
    // เมธอดแสดง Dialog
    context: context,
    builder: (context) => SimpleDialog(
      // Widget ที่ใช้ในการสร้าง Dialog
      title: ListTile(
        leading: MyStyle().showLogo(), // เมธอดของคลาส MyStyle ใช้ในการแสดงโลโก้
        title: Text(
          title,
          style: MyStyle()
              .darkStyle(), // เมธอดของคลาส MyStyle ใช้ในการกำหนดสไตล์ของข้อความ
        ),
        subtitle: Text(message),
      ),
      children: [
        TextButton(
          // ปุ่มปิด
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        )
      ],
    ),
  );
}
