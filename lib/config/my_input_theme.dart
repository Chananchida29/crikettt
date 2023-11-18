import 'package:flutter/material.dart';
import 'package:newtest/config/constant.dart';

class MyInputTheme {
  TextStyle _builtTextStyle(Color color, {double size = 16.0}) {
    return TextStyle(
      color: color,
      fontSize: size,
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    // กำหนดรูปแบบเส้นขอบ
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        color: color,
        width: 2.0,
      ),
    );
  }

  InputDecorationTheme theme() => InputDecorationTheme(
        contentPadding: EdgeInsets.all(16), // กำหนดการเว้นระยะขอบ
        isDense: true, // กำหนดให้ Input เป็นแบบหนา
        floatingLabelBehavior: FloatingLabelBehavior
            .always, // การทำงานของ Label เมื่อ Input ได้รับการโฟกัส
        // constraints: BoxConstraints(maxWidth: 150),
        enabledBorder: _buildBorder(
            Colors.grey[400]), // ลักษณะของเส้นขอบเมื่อ Input ในสถานะปกติ
        errorBorder: _buildBorder(
            Colors.red), // ลักษณะของเส้นขอบเมื่อ Input มีข้อผิดพลาด
        focusedBorder:
            _buildBorder(tColor), // ลักษณะของเส้นขอบเมื่อ Input ได้รับการโฟกัส
        border: _buildBorder(
            Colors.yellow), // ลักษณะของเส้นขอบเมื่อ Input ไม่ได้รับการโฟกัส
        focusedErrorBorder: _buildBorder(Colors
            .red), // ลักษณะของเส้นขอบเมื่อ Input มีข้อผิดพลาดและได้รับการโฟกัส
        disabledBorder: _buildBorder(
            Colors.grey[400]), // ลักษณะของเส้นขอบเมื่อ Input ถูกปิดใช้งาน
        suffixStyle: _builtTextStyle(
            Colors.black), // สไตล์ของข้อความที่ปรากฎที่ด้านหลังของ Input
        counterStyle: _builtTextStyle(Colors.grey,
            size: 12.0), // สไตล์ของตัวนับ (counter)
        // floatingLabelStyle: _buildBorder(Colors.black),
        errorStyle:
            _builtTextStyle(Colors.red, size: 12.0), // สไตล์ของข้อผิดพลาด
        helperStyle: _builtTextStyle(Colors.black,
            size: 12.0), // สไตล์ของข้อความช่วยเหลือ.
        hintStyle: _builtTextStyle(Colors.grey), // สไตล์ของข้อความคำใบ้
        labelStyle: _builtTextStyle(Colors.black), // สไตล์ของ Labe
        prefixStyle: _builtTextStyle(Colors.black), // สไตล์ของข้อความต้นทาง
      );
}
