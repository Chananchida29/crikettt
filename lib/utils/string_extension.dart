extension Month on String {
  String monthInThaiCompareWord() {
    switch (this) {
      case '01':
        return 'ม.ค';
      case '02':
        return 'ก.พ';
      case '03':
        return 'มี.ค';
      case '04':
        return 'เม.ย';
      case '05':
        return 'พ.ค';
      case '06':
        return 'มิ.ย';
      case '07':
        return 'ก.ค';
      case '08':
        return 'ส.ค';
      case '09':
        return 'ก.ย';
      case '10':
        return 'ต.ค';
      case '11':
        return 'พ.ย';
      case '12':
        return 'ธ.ค';
    }
  }
}
