import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:newtest/config/constant.dart';
import 'package:newtest/model/money_model.dart';
import 'package:newtest/screen/Money/addmoney.dart';
import 'package:newtest/screen/Money/chartyear.dart';
import 'package:newtest/screen/Money/provider/money_provider.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:newtest/utils/dialog.dart';
import 'package:newtest/utils/string_extension.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class ViewData extends StatefulWidget {
  const ViewData({Key key}) : super(key: key);

  @override
  _ViewDataState createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  DateTime _date = DateTime.now();
  DateTime _selected = DateTime.now();
  List<double> money = [1, 0, 0];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<MoneyProvider>().queryMoneyDataByMonth();
    });
  }

  final colorList = <Color>[
    Colors.green,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('บัญชีของฉัน'),
          centerTitle: true,
          backgroundColor: pColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_month),
              tooltip: 'รายงานสรุปยอด',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChartYearsPage()),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                context.watch<MoneyProvider>().dataMapOfPieChart.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: PieChart(
                          dataMap:
                              context.watch<MoneyProvider>().dataMapOfPieChart,
                          animationDuration: Duration(milliseconds: 800),
                          chartLegendSpacing: 32, // ระยะห่างของคำอธิบาย
                          chartRadius: MediaQuery.of(context).size.width / 3.2,
                          colorList: colorList,
                          initialAngleInDegree: 0,
                          chartType: ChartType.ring,
                          ringStrokeWidth: 16,
                          centerText:
                              "คงเหลือเงิน \n ${context.watch<MoneyProvider>().totalBalanceThisMonth} บาท",
                          legendOptions: LegendOptions(
                            showLegendsInRow: false,
                            legendPosition: LegendPosition.right,
                            showLegends: true,
                            legendShape: BoxShape.circle,
                            legendTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          chartValuesOptions: ChartValuesOptions(
                            showChartValueBackground: true,
                            showChartValues: true,
                            showChartValuesInPercentage: false,
                            showChartValuesOutside: true,
                            decimalPlaces: 2,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
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
                              '${DateFormat("MM").format(_selected).monthInThaiCompareWord()} ${DateFormat("yyyy").format(_selected)}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Icon(Icons.expand_more)
                        ],
                      ),
                      onPressed: () => _onPressed(context: context),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        MoneyModel moneyModel = context
                            .watch<MoneyProvider>()
                            .moneyModelOfMonthList[index];
                        return Column(
                          children: [
                            Slidable(
                              endActionPane: ActionPane(
                                motion: ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (_) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return AddDataOrEditIncomeAndExpense(
                                            moneyModel: moneyModel,
                                          );
                                        }),
                                      );
                                    },
                                    backgroundColor:
                                        Color.fromRGBO(234, 238, 215, 1),
                                    foregroundColor: Colors.grey,
                                    icon: Icons.create_outlined,
                                    label: 'edit',
                                  ),
                                  SlidableAction(
                                    onPressed: (_) async {
                                      try {
                                        await EasyLoading.show();
                                        await context
                                            .read<MoneyProvider>()
                                            .deleteMoneyData(
                                                moneyModel.moneyId);
                                        await EasyLoading.dismiss();
                                      } catch (e) {
                                        await EasyLoading.dismiss();
                                        AlertUtils.dialogAlert(
                                            context: context,
                                            subTitle: e.toString());
                                      }
                                    },
                                    backgroundColor:
                                        Color.fromRGBO(234, 238, 215, 1),
                                    foregroundColor: Colors.grey,
                                    icon: Icons.delete,
                                    label: 'delete',
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${moneyModel.name}',
                                      style: TextStyle(
                                          color: moneyModel.typeMoneyChoose ==
                                                  'รายจ่าย'
                                              ? Colors.red
                                              : Colors.green,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${moneyModel.price}',
                                      style: TextStyle(
                                          color: moneyModel.typeMoneyChoose ==
                                                  'รายจ่าย'
                                              ? Colors.red
                                              : Colors.green,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            index ==
                                    context
                                            .watch<MoneyProvider>()
                                            .moneyModelOfMonthList
                                            .length -
                                        1
                                ? Divider(
                                    height: 3,
                                    thickness: 3,
                                  )
                                : const SizedBox.shrink()
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 3,
                          thickness: 3,
                        );
                      },
                      itemCount: context
                          .watch<MoneyProvider>()
                          .moneyModelOfMonthList
                          .length),
                ),
              ]),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            elevation: 30,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return AddDataOrEditIncomeAndExpense();
                }),
              );
            }),
      ),
    );
  }

  PopupMenuItem buildItem(item) => PopupMenuItem(
        value: item,
        child: Row(children: [
          Icon(item.icon, color: Colors.black, size: 20),
          const SizedBox(
            width: 12,
          ),
          Text(item.text)
        ]),
      );

  void onSelected(BuildContext context, item) {
    switch (item) {
      case MenuItems.itemSettings:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ChartYearsPage()));
        break;
    }
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );

  Future<void> _onPressed({
    BuildContext context,
    String locale,
  }) async {
    final localeObj = locale != null ? Locale(locale) : null;
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2019),
      lastDate: DateTime(2030),
      locale: localeObj,
    );
    if (selected != null) {
      _selected = selected;
      context.read<MoneyProvider>().getSelectedMonthDate(_selected);
      context.read<MoneyProvider>().queryMoneyDataByMonth();
    }
  }
}
