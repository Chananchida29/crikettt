import 'package:flutter/material.dart';
import 'package:newtest/config/constant.dart';
import 'package:newtest/model/cricket_model.dart';
import 'package:newtest/screen/createCricket/provider/createCricketProvider.dart';
import 'package:provider/provider.dart';

class CreateCricketStep3 extends StatefulWidget {
  CricketModel cricketModel;

  CreateCricketStep3({Key key, this.cricketModel}) : super(key: key);

  @override
  State<CreateCricketStep3> createState() => _CreateCricketStep3State();
}

class _CreateCricketStep3State extends State<CreateCricketStep3> {
  @override
  Widget build(BuildContext context) {
    CreateEditCricketProvider createCricketProvider =
        context.read<CreateEditCricketProvider>();
    Widget txt({String title, String text}) {
      return RichText(
        text: TextSpan(
            text: title,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                  text: text,
                  style: TextStyle(
                    color: pColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ))
            ]),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: <Widget>[
          txt(title: 'ชื่อบ่อ : ', text: createCricketProvider.nameOfPond),
          const SizedBox(height: 10),
          txt(
              title: 'วันที่ : ',
              text:
                  '${createCricketProvider.dateStartRaise.day.toString().padLeft(2, '0')}-${createCricketProvider.dateStartRaise.month.toString().padLeft(2, '0')}-${createCricketProvider.dateStartRaise.year}'),
          const SizedBox(height: 10),
          txt(title: 'สายพันธุ์ : ', text: createCricketProvider.speciesChoose),
          const SizedBox(height: 10),
          txt(
              title: 'ขนาดบ่อ : ',
              text: createCricketProvider.sizePond.toString()),
          const SizedBox(height: 10),
          txt(
              title: 'แนะนำจำนวนขัน : ',
              text: createCricketProvider.guideCricket.toString()),
        ],
      ),
    );
  }
}
