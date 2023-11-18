import 'package:flutter/material.dart';
import 'package:newtest/config/my_style.dart';

abstract class AlertUtils {
  static Future<void> dialogAlert(
      {BuildContext context,
      String title = 'พบข้อผิดพลาด',
      String subTitle,
      Icon icon = const Icon(
        Icons.error,
        color: Colors.red,
        size: 48,
      ),
      String textButton = 'ปิด',
      Function onPress}) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: icon,
            title: Text(
              title,
              style: TextStyle(
                color: Colors.red,
                fontSize: 24,
              ),
            ),
            content: Text(subTitle),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (onPress != null) {
                    onPress();
                  }
                },
                child: Text(textButton),
              )
            ],
          );
        });
  }

  static Future<void> selectDialogAlert({
    BuildContext context,
    String title = 'พบข้อผิดพลาด',
    String subTitle,
    Icon icon = const Icon(
      Icons.error,
      color: Colors.red,
      size: 48,
    ),
    String textButton1 = 'ปิด',
    String textButton2 = 'ปิด',
    Function onPress1,
    Function onPress2,
  }) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: icon,
            title: Text(
              title,
              style: TextStyle(
                color: Colors.red,
                fontSize: 24,
              ),
            ),
            content: subTitle != null ? Text(subTitle) : null,
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (onPress1 != null) {
                    onPress1();
                  }
                },
                child: Text(textButton1),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (onPress2 != null) {
                    onPress2();
                  }
                },
                child: Text(textButton2),
              )
            ],
          );
        });
  }

  static Future<void> normalDialog(BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: MyStyle().showLogo(),
          title: Text(
            title,
            style: MyStyle().darkStyle(),
          ),
          subtitle: Text(message),
        ),
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  static Future<void> selectYearDialog({BuildContext context, Function(DateTime dateTime) onPress}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Year"),
          content: Container(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year - 100, 1),
              lastDate: DateTime(DateTime.now().year + 100, 1),
              initialDate: DateTime.now(),
              selectedDate: DateTime.now(),
              onChanged: (DateTime dateTime) {
                Navigator.pop(context);
                if (onPress != null) {
                  onPress(dateTime);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
