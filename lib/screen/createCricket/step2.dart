// ignore_for_file: missing_return

import 'package:flutter/material.dart';
import 'package:newtest/model/cricket_model.dart';
import 'package:newtest/screen/createCricket/provider/createCricketProvider.dart';
import 'package:provider/provider.dart';

class CreateCricketStep2 extends StatefulWidget {
  CricketModel cricketModel;
  CreateCricketStep2({Key key, this.cricketModel}) : super(key: key);

  @override
  State<CreateCricketStep2> createState() => _CreateCricketStep2State();
}

class _CreateCricketStep2State extends State<CreateCricketStep2> {
  TextEditingController widthController;
  TextEditingController lengthController;
  TextEditingController heightController;
  TextEditingController diameterController;
  @override
  void initState() {
    widthController = TextEditingController();
    lengthController = TextEditingController();
    heightController = TextEditingController();
    diameterController = TextEditingController();
    if (widget.cricketModel != null) {
      // edit
      if (widget.cricketModel.dimension.widthOfPond != null) {
        widthController = TextEditingController(
            text: widget.cricketModel.dimension.widthOfPond.toString() ?? '');
        context.read<CreateEditCricketProvider>().getWidthOfPond(
            width: widget.cricketModel.dimension.widthOfPond.toString());
      }
      if (widget.cricketModel.dimension.lengthOfPond != null) {
        lengthController = TextEditingController(
            text: widget.cricketModel.dimension.lengthOfPond.toString() ?? '');
        context.read<CreateEditCricketProvider>().getLengthOfPond(
            length: widget.cricketModel.dimension.lengthOfPond.toString());
      }
      if (widget.cricketModel.dimension.heightOfPond != null) {
        heightController = TextEditingController(
            text: widget.cricketModel.dimension.heightOfPond.toString() ?? '');
        context.read<CreateEditCricketProvider>().getHeightOfPond(
            height: widget.cricketModel.dimension.heightOfPond.toString());
      }
      if (widget.cricketModel.dimension.diameterOfPond != null) {
        diameterController = TextEditingController(
            text:
                widget.cricketModel.dimension.diameterOfPond.toString() ?? '');
        context.read<CreateEditCricketProvider>().getDiameterOfPond(
            diameter:
                widget.cricketModel.dimension.diameterOfPond.toString() ?? '');
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CreateEditCricketProvider createCricketProvider =
        context.read<CreateEditCricketProvider>();
    Widget txtDiameter() {
      return Container(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: TextFormField(
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
          controller: diameterController,
          onChanged: (value) {
            createCricketProvider.getDiameterOfPond(diameter: value);
          },
          decoration: InputDecoration(
              labelText: 'เส้นผ่านศุนย์กลาง',
              hintText: 'Input Diameter ',
              suffix: Text('เมตร')),
          validator: (valueRS) {
            if (createCricketProvider.typePondChoose == 'บ่อกลม') {
              if (valueRS.isEmpty) {
                return 'กรุณากรอกข้อมูล';
              }
            }
          },
        ),
      );
    }

    Widget txtWidth() {
      return Container(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: TextFormField(
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
          controller: widthController,
          onChanged: (value) {
            createCricketProvider.getWidthOfPond(width: value);
          },
          decoration: InputDecoration(
              labelText: 'ความกว้าง',
              hintText: 'Input Width ',
              suffix: Text('เมตร')),
          validator: (valueWidth) {
            if (createCricketProvider.typePondChoose == 'บ่อสี่เหลี่ยม') {
              if (valueWidth.isEmpty) {
                return 'กรุณากรอกข้อมูล';
              }
            }
          },
        ),
      );
    }

    Widget txtLength() {
      return Container(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: TextFormField(
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
          controller: lengthController,
          onChanged: (value) {
            createCricketProvider.getLengthOfPond(length: value);
          },
          decoration: InputDecoration(
              labelText: 'ความยาว',
              hintText: 'Input length',
              suffix: Text('เมตร')),
          validator: (valueLength) {
            if (createCricketProvider.typePondChoose == 'บ่อสี่เหลี่ยม') {
              if (valueLength.isEmpty) {
                return 'กรุณากรอกข้อมูล';
              }
            }
          },
        ),
      );
    }

    Widget txtHeight() {
      return Container(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: TextFormField(
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
          controller: heightController,
          onChanged: (value) {
            createCricketProvider.getHeightOfPond(height: value);
          },
          decoration: InputDecoration(
              labelText: 'ความสูง',
              hintText: 'Input height',
              suffix: Text('เมตร')),
          validator: (valueHeight) {
            if (createCricketProvider.typePondChoose == 'บ่อสี่เหลี่ยม') {
              if (valueHeight.isEmpty) {
                return 'กรุณากรอกข้อมูล';
              }
            }
          },
        ),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
      behavior: HitTestBehavior.opaque,
      child: Form(
        key: createCricketProvider.formKeyStep2,
        child: Column(
          children: createCricketProvider.typePondChoose == 'บ่อสี่เหลี่ยม'
              ? [
                  txtWidth(),
                  txtLength(),
                  txtHeight(),
                ]
              : [
                  txtDiameter(),
                ],
        ),
      ),
    );
  }
}
