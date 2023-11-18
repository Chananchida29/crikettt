// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:newtest/config/constant.dart';

class CustomCheckbox extends StatefulWidget {
  double size;
  double iconSize;
  Function onChange;
  Color backgroundColor;
  Color iconColor;
  Color borderColor;
  IconData icon;
  bool isChecked;
  bool isAbleToCheck;

  CustomCheckbox(
      //ส่วนที่ต้องการในการสร้าง Checkbox
      {Key key, // ระบุค่า key เพื่อการจำแนก Widget แต่ละตัว
      this.size,
      this.iconSize,
      this.onChange,
      this.backgroundColor,
      this.iconColor,
      this.icon,
      this.borderColor,
      this.isChecked,
      this.isAbleToCheck})
      : super(key: key);

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // ตรวจจับการแตะ tap บน Widget
      onTap: () {
        if (widget.isAbleToCheck) {
          // ตรวจสอบ checkbox ถ้าถูกเลือกจะอัปเดต
          setState(() {
            isChecked = !isChecked;
            widget.onChange(isChecked);
          });
        }
      },
      child: AnimatedContainer(
          // สร้าง Container กว้าง สูง สีพื้นหลัง เส้นขอบ
          height: widget.size ?? 30,
          width: widget.size ?? 30,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn,
          decoration: BoxDecoration(
              // กำหนดรูปทรง สี
              borderRadius: BorderRadius.circular(8.0),
              color: isChecked
                  ? widget.backgroundColor ?? tColor
                  : Colors.transparent,
              border: Border.all(color: widget.borderColor ?? tColor)),
          child: isChecked
              ? Icon(
                  //
                  widget.icon ?? Icons.check,
                  color: widget.iconColor ?? Colors.white,
                  size: widget.iconSize ?? 20,
                )
              : null),
    );
  }
}
