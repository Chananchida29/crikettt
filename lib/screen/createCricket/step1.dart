// ignore_for_file: missing_return

import 'package:flutter/material.dart';
import 'package:newtest/config/constant.dart';
import 'package:newtest/model/cricket_model.dart';
import 'package:provider/provider.dart';

import 'provider/createCricketProvider.dart';

class CreateCricketStep1 extends StatefulWidget {
  CricketModel cricketModel;

  CreateCricketStep1({Key key, this.cricketModel}) : super(key: key);

  @override
  State<CreateCricketStep1> createState() => _CreateCricketStep1State();
}

class _CreateCricketStep1State extends State<CreateCricketStep1> {
  TextEditingController namePondController; // ผู้ใช้กรอกในช่องข้อมูล "ชื่อบ่อ
  TextEditingController dateController;
  List<String> speciesItems = ['จิ้งหรีด', 'จิ้งโกร่ง', 'สะดิ้ง'];
  List<String> typePondItems = ['บ่อสี่เหลี่ยม', 'บ่อกลม'];

  @override
  void initState() {
    if (widget.cricketModel != null) {
      // edit
      namePondController =
          TextEditingController(text: widget.cricketModel.nameOfPond);
      context
          .read<CreateEditCricketProvider>()
          .getNameOfPond(name: widget.cricketModel.nameOfPond);
      context
          .read<CreateEditCricketProvider>()
          .getSpecies(species: widget.cricketModel.spieces);
      context
          .read<CreateEditCricketProvider>()
          .getTypePond(pond: widget.cricketModel.typePond);
    } else {
      namePondController = TextEditingController();
    }
    dateController = TextEditingController(
        text:
            '${context.read<CreateEditCricketProvider>().dateStartRaise.year}-${context.read<CreateEditCricketProvider>().dateStartRaise.month}-${context.read<CreateEditCricketProvider>().dateStartRaise.day}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CreateEditCricketProvider createCricketProviderRead =
        context.read<CreateEditCricketProvider>();
    CreateEditCricketProvider createCricketProviderWatch =
        context.watch<CreateEditCricketProvider>();
    Widget txtName() {
      return Container(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: TextFormField(
          controller: namePondController,
          onChanged: (value) {
            createCricketProviderRead.getNameOfPond(name: value.trim());
          },
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            labelText: ' ชื่อบ่อ : ',
            hintText: 'Input Name',
          ),
          validator: (valueNamePond) {
            if (valueNamePond.isEmpty) {
              return 'กรุณาใส่ข้อมูลด้วย';
            } else if (valueNamePond.length < 2) {
              return 'กรุณาใส่ข้อมูลมากกว่า 2 ตัวอักษร';
            }
          },
        ),
      );
    }

    Future<void> _selectDate(BuildContext context) async {
      DateTime newDate = await showDatePicker(
          context: context,
          initialDate: createCricketProviderRead.dateStartRaise,
          firstDate: DateTime(1980),
          lastDate: DateTime(2300));
      if (newDate != null) {
        setState(() {
          dateController.text =
              '${newDate.year}-${newDate.month}-${newDate.day}';
          createCricketProviderRead.getDateStartRaise(date: newDate);
        });
      }
    }

    Widget txtDate() {
      return Container(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: TextFormField(
          keyboardType: TextInputType.datetime,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
          onTap: () {
            setState(() {
              _selectDate(context);
            });
          },
          controller: dateController,
          decoration: InputDecoration(
              labelText: 'วันที่ : ',
              hintText:
                  '${createCricketProviderRead.dateStartRaise.day.toString().padLeft(2, '0')}-${createCricketProviderRead.dateStartRaise.month.toString().padLeft(2, '0')}-${createCricketProviderRead.dateStartRaise.year}',
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              suffixIcon: Icon(
                Icons.today_rounded,
                color: tColor,
              )),
          validator: (value) {
            if (value.isEmpty) {
              return 'กรุณาเลือกวันเริ่มเลี้ยง';
            }
          },
        ),
      );
    }

    Widget txtSpeices() {
      return Container(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[400], width: 2)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            hint: Text('ชื่อสายพันธุ์'),
            dropdownColor: Color(0xFFFCFFEB),
            isExpanded: true,
            value: createCricketProviderWatch.speciesChoose,
            onChanged: (String newValue) {
              setState(() {
                createCricketProviderRead.getSpecies(species: newValue);
              });
            },
            items: speciesItems.map((valueItems) {
              return DropdownMenuItem(
                  value: valueItems, child: Text(valueItems));
            }).toList(),
          ),
        ),
      );
    }

    Widget txtTypePond() {
      return Container(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[400], width: 2)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            hint: Text('ลักษณะบ่อ'),
            dropdownColor: Color(0xFFFCFFEB),
            isExpanded: true,
            value: createCricketProviderWatch.typePondChoose,
            onChanged: (String newValue) {
              setState(() {
                createCricketProviderRead.getTypePond(pond: newValue);
              });
            },
            items: typePondItems.map((valueItems) {
              return DropdownMenuItem(
                  value: valueItems, child: Text(valueItems));
            }).toList(),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
      behavior: HitTestBehavior.opaque,
      child: SingleChildScrollView(
        child: Form(
          key: createCricketProviderRead.formKeyStep1,
          child: Column(
            children: <Widget>[
              txtName(),
              txtDate(),
              txtSpeices(),
              txtTypePond(),
            ],
          ),
        ),
      ),
    );
  }
}
