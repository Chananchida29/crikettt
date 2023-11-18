// ignore_for_file: non_constant_identifier_names

class CricketModel {
  String cricketId;
  String nameOfPond;
  String spieces;
  double sizePond;
  int guideCricket;
  String typePond;
  List<StatusModel> statusModelList;
  List statusList;
  Dimension dimension;
  List<ToDoModel> toDoList;
  CricketModel(
      this.cricketId,
      this.nameOfPond,
      this.spieces,
      this.sizePond,
      this.guideCricket,
      this.typePond,
      this.statusModelList,
      this.dimension,
      this.statusList,
      this.toDoList);
  factory CricketModel.fromJson(Map parsedJson) {
    List statusList = parsedJson['statusList'] ?? [];
    List<StatusModel> statusModelList = [];
    statusList.forEach(
      (element) {
        statusModelList.add(StatusModel.fromJson(element));
      },
    );
    List toToList = parsedJson['todo'] ?? [];
    List<ToDoModel> toDoModelList = [];
    toToList.forEach(
      (element) {
        toDoModelList.add(ToDoModel.fromJson(element));
      },
    );
    return CricketModel(
        parsedJson['cricketId'],
        parsedJson['namePond'],
        parsedJson['spieces'],
        double.parse(parsedJson['sizePond'].toString()),
        parsedJson['guideCricket'],
        parsedJson['typePond'],
        statusModelList ?? [],
        Dimension.fromJson(parsedJson['dimension']),
        parsedJson['statusList'],
        toDoModelList);
  }
  DateTime get dateTime {
    return statusModelList.last.dateTime;
  }

  String get status {
    return statusModelList.last.status;
  }
}

class StatusModel {
  // คลาส ใช้ในการเก็บข้อมูลเกี่ยวกับสถานะและเวลา
  String status;
  DateTime dateTime;
  StatusModel(this.status, this.dateTime);
  factory StatusModel.fromJson(Map parsedJson) {
    return StatusModel(
      parsedJson['status'],
      DateTime.parse(parsedJson['date']),
    );
  }
}

class Dimension {
  // คลาส ใช้ในการเก็บข้อมูลเกี่ยวกับขนาดของ Pond
  double diameterOfPond;
  double heightOfPond;
  double lengthOfPond;
  double widthOfPond;
  Dimension(
      {this.diameterOfPond,
      this.heightOfPond,
      this.lengthOfPond,
      this.widthOfPond});
  factory Dimension.fromJson(Map parsedJson) {
    return Dimension(
        diameterOfPond: parsedJson['diameterOfPond'] != null
            ? double.parse(parsedJson['diameterOfPond'].toString())
            : null,
        heightOfPond: parsedJson['heightOfPond'] != null
            ? double.parse(parsedJson['heightOfPond'].toString())
            : null,
        lengthOfPond: parsedJson['lengthOfPond'] != null
            ? double.parse(parsedJson['lengthOfPond'].toString())
            : null,
        widthOfPond: parsedJson['widthOfPond'] != null
            ? double.parse(parsedJson['widthOfPond'].toString())
            : null);
  }
}

class ToDoModel {
  // คลาสใช้ในการเก็บข้อมูลเกี่ยวกับรายการที่ต้องทำที่เกี่ยวข้องกับ Cricket Pond.
  String status;
  List<SubToDoModel> subToDoList;
  DateTime timeAbleToCanClickCheckBox;
  bool subToDoAllDone;
  ToDoModel(this.status, this.subToDoList, this.subToDoAllDone,
      this.timeAbleToCanClickCheckBox);
  factory ToDoModel.fromJson(Map parsedJson) {
    List subToDoList = parsedJson['sub_to_do'] ?? [];
    DateTime dateTimeAbleToCheck =
        parsedJson['time_able_to_click_check'] != null
            ? DateTime.parse(parsedJson['time_able_to_click_check'])
            : null;
    List<SubToDoModel> subTodo = [];
    subToDoList.forEach(
      (element) {
        subTodo.add(SubToDoModel.fromJson(element));
      },
    );
    bool subToDoAllDone = subTodo.every(
      (element) => element.done,
    );
    return ToDoModel(
        parsedJson['status'], subTodo, subToDoAllDone, dateTimeAbleToCheck);
  }
}

class SubToDoModel {
  //  คลาสใช้ในการเก็บข้อมูลเกี่ยวกับ งานย่อยในรายการที่ต้องทำ
  String process;
  DateTime dateTime;
  bool done;
  SubToDoModel(this.process, this.dateTime, this.done);
  factory SubToDoModel.fromJson(Map parsedJson) {
    return SubToDoModel(parsedJson['process'],
        DateTime.parse(parsedJson['date']), parsedJson['done']);
  }
}
