import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:intl/intl.dart';
import 'package:newtest/config/constant.dart';
import 'package:newtest/model/money_model.dart';
import 'package:newtest/screen/Money/provider/money_provider.dart';
import 'package:newtest/utils/dialog.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ChartYearsPage extends StatefulWidget {
  ChartYearsPageState createState() => ChartYearsPageState();
}

class ChartYearsPageState extends State<ChartYearsPage> {
  var _key = Key(DateTime.now().millisecondsSinceEpoch.toString());
  List<double> money = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: false);
    context.read<MoneyProvider>().getSelectedYearDate(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xFFEAEED7),
          appBar: AppBar(
            title: Text('บัญชีรายปีของฉัน'),
            centerTitle: true,
            backgroundColor: pColor,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          legend: Legend(isVisible: false),
                          tooltipBehavior: _tooltipBehavior,
                          series: <LineSeries<GraphMoneyModel, String>>[
                        LineSeries<GraphMoneyModel, String>(
                            dataSource: context
                                .watch<MoneyProvider>()
                                .dataGraphMoneyModelOfYearList,
                            xValueMapper:
                                (GraphMoneyModel graphMoneyModel, _) =>
                                    graphMoneyModel.month,
                            yValueMapper:
                                (GraphMoneyModel graphMoneyModel, _) =>
                                    graphMoneyModel.balance,
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true))
                      ])),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "รายการบัญชี :",
                      style: TextStyle(fontSize: 18),
                    ),
                    TextButton(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Text(
                                '${DateFormat("yyyy").format(context.watch<MoneyProvider>().selectDateYear)}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Icon(Icons.expand_more)
                          ],
                        ),
                        onPressed: () => AlertUtils.selectYearDialog(
                            context: context,
                            onPress: (DateTime dateTime) {
                              context
                                  .read<MoneyProvider>()
                                  .getSelectedYearDate(dateTime);
                            })),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Table(
                    border: TableBorder.all(color: Colors.grey, width: 2),
                    children:
                        context.watch<MoneyProvider>().tableMoneyPerMonthOfYear,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
