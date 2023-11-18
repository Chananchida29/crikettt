class MoneyModel {
  String moneyId;
  DateTime dateTime;
  String typeMoneyChoose;
  String name;
  double price;
  MoneyModel(
      this.moneyId, this.dateTime, this.typeMoneyChoose, this.name, this.price);
  factory MoneyModel.fromJson(Map parsedJson) {
    return MoneyModel(
        parsedJson['moneyId'],
        DateTime.parse(parsedJson["date"]),
        parsedJson['typeMoneyChoose'],
        parsedJson['name'],
        double.parse(parsedJson['price'].toString()));
  }
}

class MoneyMonthModel {
  // เก็บข้อมูลเกี่ยวกับการเงินของแต่ละเดือน
  int month;
  List<MoneyModel> moneyModelList;
  double totalIncome;
  double totalExpense;
  double balance;
  MoneyMonthModel(
      {this.month,
      this.moneyModelList,
      this.totalIncome,
      this.totalExpense,
      this.balance});

  String get monthLable {
    switch (month) {
      case 1:
        return 'ม.ค';
      case 2:
        return 'ก.พ';
      case 3:
        return 'มี.ค';
      case 4:
        return 'เม.ย';
      case 5:
        return 'พ.ค';
      case 6:
        return 'มิ.ย';
      case 7:
        return 'ก.ค';
      case 8:
        return 'ส.ค';
      case 9:
        return 'ก.ย';
      case 10:
        return 'ต.ค';
      case 11:
        return 'พ.ย';
      case 12:
        return 'ธ.ค';
    }
    return null;
  }
}

class GraphMoneyModel {
  String month;
  double balance;
  GraphMoneyModel({this.month, this.balance});
}
