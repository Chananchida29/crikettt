import 'package:flutter/material.dart';
import 'package:newtest/model/money_model.dart';
import 'package:newtest/services/firebase_database_service.dart';

class MoneyProvider extends ChangeNotifier {
  List<MoneyModel> moneyModelOfMonthList =
      []; // ธุรกรรมทางการเงิน  สำหรับเดือนที่เลือก
  DateTime _selectDateMonth = DateTime.now(); // ดึงข้อมูล วันที่และเวลาปัจจุบัน
  double totalInComeThisMonth = 0; // รายได้รวม สำหรับเดือนที่เลือก
  double totalExpensesThisMonth = 0; // ค่าใช้จ่ายรวม สำหรับเดือนที่เลือก
  double totalBalanceThisMonth = 0; // ยอดคงเหลือ รวม สำหรับเดือนที่เลือก
  Map<String, double> dataMapOfPieChart =
      <String, double>{}; // แผนที่ ที่มีข้อมูลแผนภูมิ
  void getSelectedMonthDate(DateTime selectDate) {
    _selectDateMonth = selectDate;
  }

  void getSelectedYearDate(DateTime selectDate) async {
    _selectDateYear = selectDate; // ดึงข้อมูลรายปี
    await queryMoneyDataByYear();
  }

  Future queryMoneyDataByMonth() async {
    moneyModelOfMonthList = // ธุรกรรมทางการเงิน  สำหรับปีที่เลือก
        await FirebaseDataUtils.queryMoneyDataByMonth(_selectDateMonth);
    // caculate for pie chart
    totalInComeThisMonth = 0; // สรุปรายเดือน ของปีที่เลือก
    totalExpensesThisMonth = 0; // ข้อมูลสำหรับกราฟ ของปีที่เลือก
    moneyModelOfMonthList.forEach(
      (element) {
        // การคำนวณข้อมูล
        if (element.typeMoneyChoose == 'รายรับ') {
          totalInComeThisMonth = totalInComeThisMonth + element.price;
        } else if (element.typeMoneyChoose == 'รายจ่าย') {
          totalExpensesThisMonth = totalExpensesThisMonth + element.price;
        }
      },
    );
    dataMapOfPieChart = <String, double>{
      // สร้าง map ที่เก็บข้อมูลรายรับรายจ่าย  ในแผนภูมิวงกลม
      "รายรับ": totalInComeThisMonth,
      "รายจ่าย": totalExpensesThisMonth,
    };
    totalBalanceThisMonth =
        totalInComeThisMonth - totalExpensesThisMonth; // ยอดคงเหลือ
    notifyListeners(); // แจ้งเตือนที่ต้องการ แล้วอัพไปยังหน้า UI
  }

  DateTime _selectDateYear = DateTime.now();
  DateTime get selectDateYear => _selectDateYear;
  List<MoneyModel> moneyModelOfYearList = [];
  List<MoneyMonthModel> dataMoneyPerMonthListOfYear = [];
  List<GraphMoneyModel> dataGraphMoneyModelOfYearList = [];
  List<TableRow> tableMoneyPerMonthOfYear = [];
  Future queryMoneyDataByYear() async {
    moneyModelOfYearList =
        await FirebaseDataUtils.queryMoneyDataByYear(_selectDateYear.year);
    dataMoneyPerMonthListOfYear.clear();
    dataGraphMoneyModelOfYearList.clear();
    tableMoneyPerMonthOfYear.clear();
    for (int i = 1; i < 13; i++) {
      List<MoneyModel> moneyModelList = [];
      double totalInComeIndexMonth = 0;
      double totalExpensesIndexMonth = 0;
      double totalBalanceIndexMonth = 0;
      moneyModelOfYearList.forEach((element) {
        if (element.dateTime.month == i) {
          moneyModelList.add(element);
        }
      });
      for (int i = 0; i < moneyModelList.length; i++) {
        if (moneyModelList[i].typeMoneyChoose == 'รายรับ') {
          totalInComeIndexMonth =
              totalInComeIndexMonth + moneyModelList[i].price;
        } else if (moneyModelList[i].typeMoneyChoose == 'รายจ่าย') {
          totalExpensesIndexMonth =
              totalExpensesIndexMonth + moneyModelList[i].price;
        }
      }
      totalBalanceIndexMonth = totalInComeIndexMonth - totalExpensesIndexMonth;
      MoneyMonthModel moneyMonthModel = MoneyMonthModel(
          month: i,
          moneyModelList: moneyModelList,
          totalIncome: totalInComeIndexMonth,
          totalExpense: totalExpensesIndexMonth,
          balance: totalBalanceIndexMonth);
      dataMoneyPerMonthListOfYear.add(moneyMonthModel);
    }
    tableMoneyPerMonthOfYear.add(TableRow(children: [
      Container(
        color: Colors.blueAccent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            'เดือน',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      Container(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            'รับ',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      Container(
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            'จ่่าย',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      Container(
        color: Color.fromARGB(255, 182, 165, 9),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            'คงเหลือ',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ]));
    dataMoneyPerMonthListOfYear.forEach(
      (element) {
        dataGraphMoneyModelOfYearList.add(GraphMoneyModel(
            month: element.monthLable, balance: element.balance));
        tableMoneyPerMonthOfYear.add(TableRow(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              element.monthLable,
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              element.totalIncome != 0 ? element.totalIncome.toString() : '-',
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              element.totalExpense != 0 ? element.totalExpense.toString() : '-',
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.red,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              element.balance != 0 ? element.balance.toString() : '-',
              style: TextStyle(
                  fontSize: 15.0,
                  color: Color.fromARGB(255, 182, 165, 9),
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ]));
      },
    );
    notifyListeners(); // การแจ้งเตือน เพื่อเรียกใช้การสร้างหน้าจอใหม่
  }

  Future addMoneyData(
      {String typeMoneyChoose,
      String nameMoney,
      double priceMoney,
      DateTime dateTime}) async {
    await FirebaseDataUtils.addMoneyData(
        typeMoneyChoose: typeMoneyChoose,
        nameMoney: nameMoney,
        price: priceMoney,
        date: dateTime);
    await queryMoneyDataByMonth();
  }

  Future editMoneyData(
      {String moneyId,
      String typeMoneyChoose,
      String nameMoney,
      double priceMoney,
      DateTime dateTime}) async {
    await FirebaseDataUtils.editMoneyData(
        moneyId: moneyId,
        typeMoneyChoose: typeMoneyChoose,
        nameMoney: nameMoney,
        price: priceMoney,
        date: dateTime);
    await queryMoneyDataByMonth();
  }

  Future deleteMoneyData(String moneyKey) async {
    await FirebaseDataUtils.deleteMoneyData(mondeyKey: moneyKey);
    await queryMoneyDataByMonth();
  }
}
