// ignore_for_file: missing_return

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:newtest/config/constant.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:newtest/model/money_model.dart';
import 'package:newtest/screen/Money/chartyear.dart';
import 'package:newtest/screen/Money/provider/money_provider.dart';
import 'package:newtest/screen/Money/viewdata.dart';
import 'package:newtest/services/firebase_database_service.dart';
import 'package:newtest/utils/dialog.dart';
import 'package:provider/provider.dart';

class AddDataOrEditIncomeAndExpense extends StatefulWidget {
  final MoneyModel moneyModel;
  const AddDataOrEditIncomeAndExpense({Key key, this.moneyModel})
      : super(key: key);

  @override
  _AddDataOrEditIncomeAndExpenseState createState() =>
      _AddDataOrEditIncomeAndExpenseState();
}

class _AddDataOrEditIncomeAndExpenseState
    extends State<AddDataOrEditIncomeAndExpense> {
  String name, price;
  double screenWidth;

  List<String> typeMoneyitems = ['รายรับ', 'รายจ่าย'];
  String typeMoneyChoose;

  DateTime _date;

  final formKey = GlobalKey<FormState>();

  TextEditingController nameMoney;
  TextEditingController dateMoney;
  TextEditingController priceMoney;

  Future<void> _selectDate(BuildContext context) async {
    DateTime newDate = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(1980),
        lastDate: DateTime(2300));
    if (newDate != null) {
      setState(() {
        _date = newDate;
      });
    }
  }

  @override
  void initState() {
    if (widget.moneyModel != null) {
      // edit
      typeMoneyChoose = widget.moneyModel.typeMoneyChoose;
      nameMoney = TextEditingController(text: widget.moneyModel.name);
      dateMoney =
          TextEditingController(text: widget.moneyModel.dateTime.toString());
      priceMoney =
          TextEditingController(text: widget.moneyModel.price.toString());
      _date = widget.moneyModel.dateTime;
    } else {
      _date = DateTime.now();
      nameMoney = TextEditingController();
      dateMoney = TextEditingController();
      priceMoney = TextEditingController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มรายการ'),
        centerTitle: true,
        backgroundColor: pColor,
      ),
      backgroundColor: Color(0xFFEAEED7),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              txtTypeMoney(),
              txtDateMoney(),
              txtNameMoney(),
              txtPriceMoney(),
              btnSubmit(),
            ],
          ),
        ),
      ),
    );
  }

  Widget txtTypeMoney() {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 30, 30, 15),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[400], width: 2)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: Text('ประเภทบัญชี'),
          dropdownColor: Color(0xFFFCFFEB),
          isExpanded: true,
          value: typeMoneyChoose,
          onChanged: (newValue) {
            setState(() {
              typeMoneyChoose = newValue as String;
            });
          },
          items: typeMoneyitems.map((valueItems) {
            return DropdownMenuItem(value: valueItems, child: Text(valueItems));
          }).toList(),
        ),
      ),
    );
  }

  Widget txtDateMoney() {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 10, 30, 15),
      child: TextFormField(
        readOnly: true,
        keyboardType: TextInputType.datetime,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
        onTap: () async {
          setState(() {
            _selectDate(context);
          });
        },
        controller: dateMoney,
        decoration: InputDecoration(
            labelText: 'วันที่ : ',
            hintText:
                '${_date.day.toString().padLeft(2, '0')}-${_date.month.toString().padLeft(2, '0')}-${_date.year}',
            hintStyle: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            suffixIcon: Icon(
              Icons.today_rounded,
              color: tColor,
            )),
        validator: (value) {
          if (value == null) {
            return 'กรุณาเลือกวันที่';
          }
        },
      ),
    );
  }

  Widget txtNameMoney() {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 15, 30, 15),
      child: TextFormField(
        controller: nameMoney,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          labelText: ' ชื่อรายการ : ',
          hintText: ' ใส่ชื่อรายการ ',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'กรุณากรอกชื่อรายการ';
          }
        },
      ),
    );
  }

  Widget txtPriceMoney() {
    return Container(
        margin: EdgeInsets.fromLTRB(30, 15, 30, 50),
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: priceMoney,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            labelText: 'จำนวนเงิน : ',
            hintText: 'ใส่ราคา',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'กรุณากรอกจำนวนเงิน';
            }
          },
        ));
  }

  Widget btnSubmit() => ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: sColor,
            padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
            shape: StadiumBorder(),
            fixedSize: const Size(300, 50)),
        child: Text(
          widget.moneyModel != null ? 'แก้ไข' : 'เพิ่ม',
          style: TextStyle(fontSize: 16),
        ),
        onPressed: () async {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            if (typeMoneyChoose == null) {
              AlertUtils.dialogAlert(
                title: 'กรอกข้อมูลไม่ครบถ้วน',
                subTitle: 'กรุณาเลือกประเภทบัญชี',
                context: context,
              );
            } else {
              try {
                await EasyLoading.show();
                if (widget.moneyModel != null) {
                  // edit
                  await context.read<MoneyProvider>().editMoneyData(
                      moneyId: widget.moneyModel.moneyId,
                      typeMoneyChoose: typeMoneyChoose,
                      nameMoney: nameMoney.text.trim(),
                      priceMoney: double.parse(priceMoney.text.trim()),
                      dateTime: _date);
                } else {
                  // add
                  await context.read<MoneyProvider>().addMoneyData(
                      typeMoneyChoose: typeMoneyChoose,
                      nameMoney: nameMoney.text.trim(),
                      priceMoney: double.parse(priceMoney.text.trim()),
                      dateTime: _date);
                }
                await EasyLoading.dismiss();
                Navigator.pop(context);
              } catch (e) {
                await EasyLoading.dismiss();
                AlertUtils.dialogAlert(
                    context: context, subTitle: e.toString());
              }
            }
          }
        },
      );
}

class MenuItems {
  static const List<MenuItem> itemsFirst = [itemSettings];

  static const itemSettings = MenuItem(
    text: 'Settings',
    icon: Icons.settings,
  );
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    this.text,
    this.icon,
  });
}
