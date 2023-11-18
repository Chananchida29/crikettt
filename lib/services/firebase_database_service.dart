// ignore_for_file: missing_return

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:newtest/model/cricket_model.dart';
import 'package:newtest/model/money_model.dart';

class FirebaseDataUtils {
  static String uidUser = FirebaseAuth.instance.currentUser.uid;
  static DatabaseReference dbfirebaseCricket = FirebaseDatabase.instance.ref().child('Cricket/$uidUser');
  static DatabaseReference dbfirebaseMoney = FirebaseDatabase.instance.ref().child('Money/$uidUser');
  static DatabaseReference databaseNotificationScheduleJobs =
      FirebaseDatabase.instance.ref().child('NotificationScheduleJobs');

  static Future<void> createCricketToFirebase(
      {String nameOfPond,
      DateTime dateStartRaise,
      String speciesChoose,
      double sizePond,
      int guideCricket,
      String typePond,
      double diameterOfPond,
      double widthOfPond,
      double heightOfPond,
      double lengthOfPond}) async {
    List statusList = [
      {'status': "เตรียมบ่อเลี้ยง", 'date': dateStartRaise.toString()}
    ];
    await dbfirebaseCricket.push().set({
      'namePond': nameOfPond,
      'spieces': speciesChoose,
      'sizePond': sizePond,
      'guideCricket': guideCricket,
      'typePond': typePond,
      'statusList': statusList,
      'dimension': {
        'diameterOfPond': diameterOfPond,
        'widthOfPond': widthOfPond,
        'heightOfPond': heightOfPond,
        'lengthOfPond': lengthOfPond
      },
      'todo': {
        0: {
          'status': 'เตรียมสถานที่ (แนะนำ)',
          'sub_to_do': {
            0: {'process': 'อากาศถ่ายเท ห้ามมีควันไฟรบกวน', 'date': dateStartRaise.toString(), 'done': false},
            1: {'process': 'สร้างบ่อเลี้ยง', 'date': dateStartRaise.toString(), 'done': false},
            2: {'process': 'ติดเทปกาวขอบบ่อด้านใน', 'date': dateStartRaise.toString(), 'done': false}
          }
        },
        1: {
          'status': 'เตรียมอุปกรณ์',
          'sub_to_do': {
            0: {'process': 'เรียงแผงไข่ (กระดาษ)', 'date': dateStartRaise.toString(), 'done': false},
            1: {'process': 'ภาชนะใส่น้ำ', 'date': dateStartRaise.toString(), 'done': false},
            2: {'process': 'ภาชนะใส่อาหาร/ชื้ออาหาร', 'date': dateStartRaise.toString(), 'done': false},
            3: {'process': 'เตรียมไข่จิ้งหรีดที่บ่มอยู่', 'date': dateStartRaise.toString(), 'done': false},
          }
        },
        2: {
          'status': 'บ่มไข่จิ้งหรีด',
          'sub_to_do': {
            0: {
              'process':
                  'ค่อยสังเกตจิ้งหรีดเริ่มฟักตัว ให้เปิดปากกระสอบที่ใช้อบ ปล่อยให้จิ้งหรีดไต่ออกมาจากกระสอบ เอาน้ำเอาอาหารวางไว้',
              'date': dateStartRaise.toString(),
              'done': false
            }
          },
        },
        3: {
          'status': 'จิ้งหรีดเจริญเติบโต',
          'sub_to_do': {
            0: {'process': 'คอยสังเกตเมื่อจิ้งหรีดเริ่มส่งเสียงร้อง', 'date': dateStartRaise.toString(), 'done': false}
          },
        },
        4: {
          'status': 'จิ้งหรีดวางไข่',
          'sub_to_do': {
            0: {
              'process': 'นำถาดใส่ขี้เถ้าแกลบรดน้ำให้ชุ่มพอประมาณมาวาง',
              'date': dateStartRaise.toString(),
              'done': false
            }
          }
        },
        5: {
          'status': 'เก็บไข่จิ้งหรีด',
          'sub_to_do': {
            0: {
              'process': 'นำไข่จิ้งหรีดใส่ถุงกระสอบ ปิดปากถุงกระสอบไม่ต้องปิดแน่นมาก ให้ปิดพอหลวม',
              'date': dateStartRaise.toString(),
              'done': false
            }
          }
        },
        6: {
          'status': 'ทำความสะอาดบ่อ',
          'sub_to_do': {
            0: {'process': 'เก็บแผงไข่', 'date': dateStartRaise.toString(), 'done': false},
            1: {'process': 'เก็บแมลง', 'date': dateStartRaise.toString(), 'done': false},
            2: {'process': 'ล้างบ่อเลี้ยง', 'date': dateStartRaise.toString(), 'done': false}
          }
        },
      }
    });
  }

  static Future<void> editCricketToDoToFirebase(
      {CricketModel cricketModel,
      DateTime updateDateTime,
      String status,
      String process,
      bool statusOfProcess,
      String statusMustSetTime}) async {
    Map<int, dynamic> statusSetUpPlace = {
      0: {
        'status': 'เตรียมสถานที่ (แนะนำ)',
        'sub_to_do': {
          0: {
            'process': 'อากาศถ่ายเท ห้ามมีควันไฟรบกวน',
            'date': cricketModel.toDoList[0].subToDoList[0].dateTime.toString(),
            'done': cricketModel.toDoList[0].subToDoList[0].done
          },
          1: {
            'process': 'สร้างบ่อเลี้ยง',
            'date': cricketModel.toDoList[0].subToDoList[1].dateTime.toString(),
            'done': cricketModel.toDoList[0].subToDoList[1].done
          },
          2: {
            'process': 'ติดเทปกาวขอบบ่อด้านใน',
            'date': cricketModel.toDoList[0].subToDoList[2].dateTime.toString(),
            'done': cricketModel.toDoList[0].subToDoList[2].done
          }
        }
      }
    };
    Map<int, dynamic> statusSetUpEquipment = {
      1: {
        'status': 'เตรียมอุปกรณ์',
        'sub_to_do': {
          0: {
            'process': 'เรียงแผงไข่ (กระดาษ)',
            'date': cricketModel.toDoList[1].subToDoList[0].dateTime.toString(),
            'done': cricketModel.toDoList[1].subToDoList[0].done
          },
          1: {
            'process': 'ภาชนะใส่น้ำ',
            'date': cricketModel.toDoList[1].subToDoList[1].dateTime.toString(),
            'done': cricketModel.toDoList[1].subToDoList[1].done
          },
          2: {
            'process': 'ภาชนะใส่อาหาร/ชื้ออาหาร',
            'date': cricketModel.toDoList[1].subToDoList[2].dateTime.toString(),
            'done': cricketModel.toDoList[1].subToDoList[2].done
          },
          3: {
            'process': 'เตรียมไข่จิ้งหรีดที่บ่มอยู่',
            'date': cricketModel.toDoList[1].subToDoList[3].dateTime.toString(),
            'done': cricketModel.toDoList[1].subToDoList[3].done
          },
        }
      }
    };
    Map<int, dynamic> statusSetUpIncubateEgg = {
      2: {
        'status': 'บ่มไข่จิ้งหรีด',
        'sub_to_do': {
          0: {
            'process':
                'ค่อยสังเกตจิ้งหรีดเริ่มฟักตัว ให้เปิดปากกระสอบที่ใช้อบ ปล่อยให้จิ้งหรีดไต่ออกมาจากกระสอบ เอาน้ำเอาอาหารวางไว้',
            'date': cricketModel.toDoList[2].subToDoList[0].dateTime.toString(),
            'done': cricketModel.toDoList[2].subToDoList[0].done
          }
        },
      },
    };
    Map<int, dynamic> statusWaitCricketGrowth = {
      3: {
        'status': 'จิ้งหรีดเจริญเติบโต',
        'sub_to_do': {
          0: {
            'process': 'คอยสังเกตเมื่อจิ้งหรีดเริ่มส่งเสียงร้อง',
            'date': cricketModel.toDoList[3].subToDoList[0].dateTime.toString(),
            'done': cricketModel.toDoList[3].subToDoList[0].done
          }
        },
      }
    };
    Map<int, dynamic> statusSpawnEgg = {
      4: {
        'status': 'จิ้งหรีดวางไข่',
        'sub_to_do': {
          0: {
            'process': 'นำถาดใส่ขี้เถ้าแกลบรดน้ำให้ชุ่มพอประมาณมาวาง',
            'date': cricketModel.toDoList[4].subToDoList[0].dateTime.toString(),
            'done': cricketModel.toDoList[4].subToDoList[0].done
          }
        }
      }
    };
    Map<int, dynamic> statusCollectEgg = {
      5: {
        'status': 'เก็บไข่จิ้งหรีด',
        'sub_to_do': {
          0: {
            'process': 'นำไข่จิ้งหรีดใส่ถุงกระสอบ ปิดปากถุงกระสอบไม่ต้องปิดแน่นมาก ให้ปิดพอหลวม',
            'date': cricketModel.toDoList[5].subToDoList[0].dateTime.toString(),
            'done': cricketModel.toDoList[5].subToDoList[0].done
          }
        }
      },
    };
    Map<int, dynamic> statusCleanPond = {
      6: {
        'status': 'ทำความสะอาดบ่อ',
        'sub_to_do': {
          0: {
            'process': 'เก็บแผงไข่',
            'date': cricketModel.toDoList[6].subToDoList[0].dateTime.toString(),
            'done': cricketModel.toDoList[6].subToDoList[0].done
          },
          1: {
            'process': 'เก็บแมลง',
            'date': cricketModel.toDoList[6].subToDoList[1].dateTime.toString(),
            'done': cricketModel.toDoList[6].subToDoList[1].done
          },
          2: {
            'process': 'ล้างบ่อเลี้ยง',
            'date': cricketModel.toDoList[6].subToDoList[1].dateTime.toString(),
            'done': cricketModel.toDoList[6].subToDoList[1].done
          }
        }
      },
    };
    switch (status) {
      case 'เตรียมสถานที่ (แนะนำ)':
        if (process == 'อากาศถ่ายเท ห้ามมีควันไฟรบกวน') {
          statusSetUpPlace = {
            0: {
              'status': 'เตรียมสถานที่ (แนะนำ)',
              'sub_to_do': {
                0: {
                  'process': 'อากาศถ่ายเท ห้ามมีควันไฟรบกวน',
                  'date': updateDateTime.toString(),
                  'done': !statusOfProcess
                },
                1: {
                  'process': 'สร้างบ่อเลี้ยง',
                  'date': cricketModel.toDoList[0].subToDoList[1].dateTime.toString(),
                  'done': cricketModel.toDoList[0].subToDoList[1].done
                },
                2: {
                  'process': 'ติดเทปกาวขอบบ่อด้านใน',
                  'date': cricketModel.toDoList[0].subToDoList[2].dateTime.toString(),
                  'done': cricketModel.toDoList[0].subToDoList[2].done
                }
              }
            }
          };
        } else if (process == 'สร้างบ่อเลี้ยง') {
          statusSetUpPlace = {
            0: {
              'status': 'เตรียมสถานที่ (แนะนำ)',
              'sub_to_do': {
                0: {
                  'process': 'อากาศถ่ายเท ห้ามมีควันไฟรบกวน',
                  'date': cricketModel.toDoList[0].subToDoList[0].dateTime.toString(),
                  'done': cricketModel.toDoList[0].subToDoList[0].done
                },
                1: {'process': 'สร้างบ่อเลี้ยง', 'date': updateDateTime.toString(), 'done': !statusOfProcess},
                2: {
                  'process': 'ติดเทปกาวขอบบ่อด้านใน',
                  'date': cricketModel.toDoList[0].subToDoList[2].dateTime.toString(),
                  'done': cricketModel.toDoList[0].subToDoList[2].done
                }
              }
            }
          };
        } else if (process == 'ติดเทปกาวขอบบ่อด้านใน') {
          statusSetUpPlace = {
            0: {
              'status': 'เตรียมสถานที่ (แนะนำ)',
              'sub_to_do': {
                0: {
                  'process': 'อากาศถ่ายเท ห้ามมีควันไฟรบกวน',
                  'date': cricketModel.toDoList[0].subToDoList[0].dateTime.toString(),
                  'done': cricketModel.toDoList[0].subToDoList[0].done
                },
                1: {
                  'process': 'สร้างบ่อเลี้ยง',
                  'date': cricketModel.toDoList[0].subToDoList[1].dateTime.toString(),
                  'done': cricketModel.toDoList[0].subToDoList[1].done
                },
                2: {'process': 'ติดเทปกาวขอบบ่อด้านใน', 'date': updateDateTime.toString(), 'done': !statusOfProcess}
              }
            }
          };
        }
        break;
      case 'เตรียมอุปกรณ์':
        if (process == 'เรียงแผงไข่ (กระดาษ)') {
          statusSetUpEquipment = {
            1: {
              'status': 'เตรียมอุปกรณ์',
              'sub_to_do': {
                0: {'process': 'เรียงแผงไข่ (กระดาษ)', 'date': updateDateTime.toString(), 'done': !statusOfProcess},
                1: {
                  'process': 'ภาชนะใส่น้ำ',
                  'date': cricketModel.toDoList[1].subToDoList[1].dateTime.toString(),
                  'done': cricketModel.toDoList[1].subToDoList[1].done
                },
                2: {
                  'process': 'ภาชนะใส่อาหาร/ชื้ออาหาร',
                  'date': cricketModel.toDoList[1].subToDoList[2].dateTime.toString(),
                  'done': cricketModel.toDoList[1].subToDoList[2].done
                },
                3: {
                  'process': 'เตรียมไข่จิ้งหรีดที่บ่มอยู่',
                  'date': cricketModel.toDoList[1].subToDoList[3].dateTime.toString(),
                  'done': cricketModel.toDoList[1].subToDoList[3].done
                },
              }
            }
          };
        } else if (process == 'ภาชนะใส่น้ำ') {
          statusSetUpEquipment = {
            1: {
              'status': 'เตรียมอุปกรณ์',
              'sub_to_do': {
                0: {
                  'process': 'เรียงแผงไข่ (กระดาษ)',
                  'date': cricketModel.toDoList[1].subToDoList[0].dateTime.toString(),
                  'done': cricketModel.toDoList[1].subToDoList[0].done
                },
                1: {'process': 'ภาชนะใส่น้ำ', 'date': updateDateTime.toString(), 'done': !statusOfProcess},
                2: {
                  'process': 'ภาชนะใส่อาหาร/ชื้ออาหาร',
                  'date': cricketModel.toDoList[1].subToDoList[2].dateTime.toString(),
                  'done': cricketModel.toDoList[1].subToDoList[2].done
                },
                3: {
                  'process': 'เตรียมไข่จิ้งหรีดที่บ่มอยู่',
                  'date': cricketModel.toDoList[1].subToDoList[3].dateTime.toString(),
                  'done': cricketModel.toDoList[1].subToDoList[3].done
                },
              }
            }
          };
        } else if (process == 'ภาชนะใส่อาหาร/ชื้ออาหาร') {
          statusSetUpEquipment = {
            1: {
              'status': 'เตรียมอุปกรณ์',
              'sub_to_do': {
                0: {
                  'process': 'เรียงแผงไข่ (กระดาษ)',
                  'date': cricketModel.toDoList[1].subToDoList[0].dateTime.toString(),
                  'done': cricketModel.toDoList[1].subToDoList[0].done
                },
                1: {
                  'process': 'ภาชนะใส่น้ำ',
                  'date': cricketModel.toDoList[1].subToDoList[1].dateTime.toString(),
                  'done': cricketModel.toDoList[1].subToDoList[1].done
                },
                2: {'process': 'ภาชนะใส่อาหาร/ชื้ออาหาร', 'date': updateDateTime.toString(), 'done': !statusOfProcess},
                3: {
                  'process': 'เตรียมไข่จิ้งหรีดที่บ่มอยู่',
                  'date': cricketModel.toDoList[1].subToDoList[3].dateTime.toString(),
                  'done': cricketModel.toDoList[1].subToDoList[3].done
                },
              }
            }
          };
        } else if (process == 'เตรียมไข่จิ้งหรีดที่บ่มอยู่') {
          statusSetUpEquipment = {
            1: {
              'status': 'เตรียมอุปกรณ์',
              'sub_to_do': {
                0: {
                  'process': 'เรียงแผงไข่ (กระดาษ)',
                  'date': cricketModel.toDoList[1].subToDoList[0].dateTime.toString(),
                  'done': cricketModel.toDoList[1].subToDoList[0].done
                },
                1: {
                  'process': 'ภาชนะใส่น้ำ',
                  'date': cricketModel.toDoList[1].subToDoList[1].dateTime.toString(),
                  'done': cricketModel.toDoList[1].subToDoList[1].done
                },
                2: {
                  'process': 'ภาชนะใส่อาหาร/ชื้ออาหาร',
                  'date': cricketModel.toDoList[1].subToDoList[2].dateTime.toString(),
                  'done': cricketModel.toDoList[1].subToDoList[2].done
                },
                3: {
                  'process': 'เตรียมไข่จิ้งหรีดที่บ่มอยู่',
                  'date': updateDateTime.toString(),
                  'done': !statusOfProcess
                },
              }
            }
          };
        }
        break;
      case 'บ่มไข่จิ้งหรีด':
        if (process ==
            'ค่อยสังเกตจิ้งหรีดเริ่มฟักตัว ให้เปิดปากกระสอบที่ใช้อบ ปล่อยให้จิ้งหรีดไต่ออกมาจากกระสอบ เอาน้ำเอาอาหารวางไว้') {
          DateTime timeAbleToClickCheck = updateDateTime.add(Duration(days: 5));
          statusSetUpIncubateEgg = {
            2: {
              'status': 'บ่มไข่จิ้งหรีด',
              'time_able_to_click_check': cricketModel.toDoList[2].timeAbleToCanClickCheckBox == null
                  ? statusMustSetTime == 'wait_5_day_incubate_eggs'
                      ? timeAbleToClickCheck.toString()
                      : null
                  : cricketModel.toDoList[2].timeAbleToCanClickCheckBox.toString(),
              'sub_to_do': {
                0: {
                  'process':
                      'ค่อยสังเกตจิ้งหรีดเริ่มฟักตัว ให้เปิดปากกระสอบที่ใช้อบ ปล่อยให้จิ้งหรีดไต่ออกมาจากกระสอบ เอาน้ำเอาอาหารวางไว้',
                  'date': updateDateTime.toString(),
                  'done': !statusOfProcess
                }
              },
            },
          };
        }
        break;
      case 'จิ้งหรีดเจริญเติบโต':
        if (process == 'คอยสังเกตเมื่อจิ้งหรีดเริ่มส่งเสียงร้อง') {
          statusWaitCricketGrowth = {
            3: {
              'status': 'จิ้งหรีดเจริญเติบโต',
              'sub_to_do': {
                0: {
                  'process': 'คอยสังเกตเมื่อจิ้งหรีดเริ่มส่งเสียงร้อง',
                  'date': updateDateTime.toString(),
                  'done': !statusOfProcess
                }
              },
            }
          };
        }
        break;
      case 'จิ้งหรีดวางไข่':
        if (process == 'นำถาดใส่ขี้เถ้าแกลบรดน้ำให้ชุ่มพอประมาณมาวาง') {
          statusSpawnEgg = {
            4: {
              'status': 'จิ้งหรีดวางไข่',
              'sub_to_do': {
                0: {
                  'process': 'นำถาดใส่ขี้เถ้าแกลบรดน้ำให้ชุ่มพอประมาณมาวาง',
                  'date': updateDateTime.toString(),
                  'done': !statusOfProcess
                }
              }
            }
          };
        }
        break;
      case 'เก็บไข่จิ้งหรีด':
        if (process == 'นำไข่จิ้งหรีดใส่ถุงกระสอบ ปิดปากถุงกระสอบไม่ต้องปิดแน่นมาก ให้ปิดพอหลวม') {
          DateTime timeAbleToClickCheck = updateDateTime.add(Duration(hours: 12));
          statusCollectEgg = {
            5: {
              'status': 'เก็บไข่จิ้งหรีด',
              'time_able_to_click_check': cricketModel.toDoList[5].timeAbleToCanClickCheckBox == null
                  ? statusMustSetTime == 'wait_12_hour_collect_eggs'
                      ? timeAbleToClickCheck.toString()
                      : null
                  : cricketModel.toDoList[5].timeAbleToCanClickCheckBox.toString(),
              'sub_to_do': {
                0: {
                  'process': 'นำไข่จิ้งหรีดใส่ถุงกระสอบ ปิดปากถุงกระสอบไม่ต้องปิดแน่นมาก ให้ปิดพอหลวม',
                  'date': updateDateTime.toString(),
                  'done': !statusOfProcess
                }
              }
            },
          };
        }
        break;
      case 'ทำความสะอาดบ่อ':
        if (process == 'เก็บแผงไข่') {
          statusCleanPond = {
            6: {
              'status': 'ทำความสะอาดบ่อ',
              'sub_to_do': {
                0: {'process': 'เก็บแผงไข่', 'date': updateDateTime.toString(), 'done': !statusOfProcess},
                1: {
                  'process': 'เก็บแมลง',
                  'date': cricketModel.toDoList[6].subToDoList[1].dateTime.toString(),
                  'done': cricketModel.toDoList[6].subToDoList[1].done
                },
                2: {
                  'process': 'ล้างบ่อเลี้ยง',
                  'date': cricketModel.toDoList[6].subToDoList[2].dateTime.toString(),
                  'done': cricketModel.toDoList[6].subToDoList[2].done
                }
              }
            },
          };
        } else if (process == 'เก็บแมลง') {
          statusCleanPond = {
            6: {
              'status': 'ทำความสะอาดบ่อ',
              'sub_to_do': {
                0: {
                  'process': 'เก็บแผงไข่',
                  'date': cricketModel.toDoList[6].subToDoList[0].dateTime.toString(),
                  'done': cricketModel.toDoList[6].subToDoList[0].done
                },
                1: {'process': 'เก็บแมลง', 'date': updateDateTime.toString(), 'done': !statusOfProcess},
                2: {
                  'process': 'ล้างบ่อเลี้ยง',
                  'date': cricketModel.toDoList[6].subToDoList[2].dateTime.toString(),
                  'done': cricketModel.toDoList[6].subToDoList[2].done
                }
              }
            },
          };
        } else if (process == 'ล้างบ่อเลี้ยง') {
          statusCleanPond = {
            6: {
              'status': 'ทำความสะอาดบ่อ',
              'sub_to_do': {
                0: {
                  'process': 'เก็บแผงไข่',
                  'date': cricketModel.toDoList[6].subToDoList[0].dateTime.toString(),
                  'done': cricketModel.toDoList[6].subToDoList[0].done
                },
                1: {
                  'process': 'เก็บแมลง',
                  'date': cricketModel.toDoList[6].subToDoList[1].dateTime.toString(),
                  'done': cricketModel.toDoList[6].subToDoList[1].done
                },
                2: {'process': 'ล้างบ่อเลี้ยง', 'date': updateDateTime.toString(), 'done': !statusOfProcess}
              }
            },
          };
        }
        break;
      default:
        return;
    }
    await dbfirebaseCricket.child(cricketModel.cricketId).update({
      'todo': {
        0: statusSetUpPlace[0],
        1: statusSetUpEquipment[1],
        2: statusSetUpIncubateEgg[2],
        3: statusWaitCricketGrowth[3],
        4: statusSpawnEgg[4],
        5: statusCollectEgg[5],
        6: statusCleanPond[6],
      }
    });
  }

  static Future<void> editCricketToFirebase(
      {CricketModel cricketModel,
      String nameOfPond,
      DateTime dateStartRaise,
      String speciesChoose,
      double sizePond,
      int guideCricket,
      String typePond,
      double diameterOfPond,
      double widthOfPond,
      double heightOfPond,
      double lengthOfPond,
      bool resetStatus}) async {
    List statusList = [];
    if (resetStatus) {
      statusList = [
        {'status': "เตรียมบ่อเลี้ยง", 'date': dateStartRaise.toString()}
      ];
    } else {
      statusList = [...cricketModel.statusList];
    }
    if (resetStatus) {
      await dbfirebaseCricket.child(cricketModel.cricketId).update({
        'namePond': nameOfPond,
        'spieces': speciesChoose,
        'sizePond': sizePond,
        'guideCricket': guideCricket,
        'typePond': typePond,
        'statusList': statusList,
        'dimension': {
          'diameterOfPond': diameterOfPond,
          'widthOfPond': widthOfPond,
          'heightOfPond': heightOfPond,
          'lengthOfPond': lengthOfPond
        },
        'todo': {
          0: {
            'status': 'เตรียมสถานที่ (แนะนำ)',
            'sub_to_do': {
              0: {'process': 'อากาศถ่ายเท ห้ามมีควันไฟรบกวน', 'date': dateStartRaise.toString(), 'done': false},
              1: {'process': 'สร้างบ่อเลี้ยง', 'date': dateStartRaise.toString(), 'done': false},
              2: {'process': 'ติดเทปกาวขอบบ่อด้านใน', 'date': dateStartRaise.toString(), 'done': false}
            }
          },
          1: {
            'status': 'เตรียมอุปกรณ์',
            'sub_to_do': {
              0: {'process': 'เรียงแผงไข่ (กระดาษ)', 'date': dateStartRaise.toString(), 'done': false},
              1: {'process': 'ภาชนะใส่น้ำ', 'date': dateStartRaise.toString(), 'done': false},
              2: {'process': 'ภาชนะใส่อาหาร/ชื้ออาหาร', 'date': dateStartRaise.toString(), 'done': false},
              3: {'process': 'เตรียมไข่จิ้งหรีดที่บ่มอยู่', 'date': dateStartRaise.toString(), 'done': false},
            }
          },
          2: {
            'status': 'บ่มไข่จิ้งหรีด',
            'sub_to_do': {
              0: {
                'process':
                    'ค่อยสังเกตจิ้งหรีดเริ่มฟักตัว ให้เปิดปากกระสอบที่ใช้อบ ปล่อยให้จิ้งหรีดไต่ออกมาจากกระสอบ เอาน้ำเอาอาหารวางไว้',
                'date': dateStartRaise.toString(),
                'done': false
              }
            },
          },
          3: {
            'status': 'จิ้งหรีดเจริญเติบโต',
            'sub_to_do': {
              0: {
                'process': 'คอยสังเกตเมื่อจิ้งหรีดเริ่มส่งเสียงร้อง',
                'date': dateStartRaise.toString(),
                'done': false
              }
            },
          },
          4: {
            'status': 'จิ้งหรีดวางไข่',
            'sub_to_do': {
              0: {
                'process': 'นำถาดใส่ขี้เถ้าแกลบรดน้ำให้ชุ่มพอประมาณมาวาง',
                'date': dateStartRaise.toString(),
                'done': false
              }
            }
          },
          5: {
            'status': 'เก็บไข่จิ้งหรีด',
            'sub_to_do': {
              0: {
                'process': 'นำไข่จิ้งหรีดใส่ถุงกระสอบ ปิดปากถุงกระสอบไม่ต้องปิดแน่นมาก ให้ปิดพอหลวม',
                'date': dateStartRaise.toString(),
                'done': false
              }
            }
          },
          6: {
            'status': 'ทำความสะอาดบ่อ',
            'sub_to_do': {
              0: {'process': 'เก็บแผงไข่', 'date': dateStartRaise.toString(), 'done': false},
              1: {'process': 'เก็บแมลง', 'date': dateStartRaise.toString(), 'done': false},
              2: {'process': 'ล้างบ่อเลี้ยง', 'date': dateStartRaise.toString(), 'done': false}
            }
          },
        }
      });
    } else {
      await dbfirebaseCricket.child(cricketModel.cricketId).update({
        'namePond': nameOfPond,
        'spieces': speciesChoose,
        'sizePond': sizePond,
        'guideCricket': guideCricket,
        'typePond': typePond,
        'statusList': statusList,
        'dimension': {
          'diameterOfPond': diameterOfPond,
          'widthOfPond': widthOfPond,
          'heightOfPond': heightOfPond,
          'lengthOfPond': lengthOfPond
        }
      });
    }
  }

  static Future<void> deleteCricketFirebase({String cricketId}) async {
    await dbfirebaseCricket.child(cricketId).remove();
    await removeRecordNotificationSheduleJobs(cricketId);
  }

  static Future<void> updateStatusCricketFirebase({String status, CricketModel cricketModel, DateTime dateTime}) async {
    List statusList = [...cricketModel.statusList];
    DateTime dateTime = DateTime.now();
    statusList.add({'status': status, 'date': dateTime.toString()});
    await dbfirebaseCricket.child(cricketModel.cricketId).update({
      'statusList': statusList,
    });
  }

  static Future<void> clearStatusCricketFirebase({String cricketId, DateTime dateTime}) async {
    List statusList = [
      {'status': "เตรียมบ่อเลี้ยง", 'date': dateTime.toString()}
    ];
    await dbfirebaseCricket.child(cricketId).update({
      'update': dateTime.toString(),
      'status': "เตรียมบ่อเลี้ยง",
      'statusList': statusList,
    });
  }

  static Future<CricketModel> getCricket({String cricketId}) async {
    DataSnapshot dataCricket = await dbfirebaseCricket.child(cricketId).get();
    Map dataCricketMap = dataCricket.value as Map;
    dataCricketMap.addAll({'cricketId': dataCricket.key});
    CricketModel cricketModel = CricketModel.fromJson(dataCricketMap);
    return cricketModel;
  }

  static Future<void> addMoneyData({String typeMoneyChoose, DateTime date, String nameMoney, double price}) async {
    var format = DateFormat("yyyy-MM-dd");
    await dbfirebaseMoney.push().set({
      'name': nameMoney,
      'price': price,
      'date': format.format(date),
      'typeMoneyChoose': typeMoneyChoose,
      'create_date': DateTime.now().toString()
    });
  }

  static Future<void> editMoneyData(
      {String moneyId, String typeMoneyChoose, DateTime date, String nameMoney, double price}) async {
    var format = DateFormat("yyyy-MM-dd");
    await dbfirebaseMoney.child(moneyId).update({
      'name': nameMoney,
      'price': price,
      'date': format.format(date),
      'typeMoneyChoose': typeMoneyChoose,
      'create_date': DateTime.now().toString()
    });
  }

  static Future<void> deleteMoneyData({String mondeyKey}) async {
    await dbfirebaseMoney.child(mondeyKey).remove();
  }

  static Future<List<MoneyModel>> queryMoneyDataByMonth(DateTime selectDate) async {
    List<MoneyModel> moneyModelList = [];
    DataSnapshot dataSnapshot = await dbfirebaseMoney
        .orderByChild("date")
        .startAt("${DateFormat("yyyy-MM").format(selectDate)}-01")
        .endAt("${DateFormat("yyyy-MM").format(selectDate)}-31")
        .get();
    Map dataMap = dataSnapshot.value as Map;
    if (dataMap != null) {
      dataMap.forEach((key, value) {
        Map dataMapping = value as Map;
        dataMapping.addAll({'moneyId': key});
        MoneyModel moneyModel = MoneyModel.fromJson(dataMapping);
        moneyModelList.add(moneyModel);
      });
    }
    return moneyModelList;
  }

  static Future<List<MoneyModel>> queryMoneyDataByYear(int year) async {
    List<MoneyModel> moneyModelList = [];
    DataSnapshot dataSnapshot =
        await dbfirebaseMoney.orderByChild("date").startAt("$year-01-01").endAt("$year-12-31").get();
    Map dataMap = dataSnapshot.value as Map;
    if (dataMap != null) {
      dataMap.forEach((key, value) {
        Map dataMapping = value as Map;
        dataMapping.addAll({'moneyId': key});
        MoneyModel moneyModel = MoneyModel.fromJson(dataMapping);
        moneyModelList.add(moneyModel);
      });
    }
    return moneyModelList;
  }

  static Future recordNotificationScheduleJobs(
      {String fcmToken,
      String notificationName,
      String notificationDetail,
      DateTime lengthDay,
      int dailyTimeToSend,
      String idMyCK,
      String payload,
      bool sendNotificationBothIn6AmAnd6Pm = false}) async {
    await databaseNotificationScheduleJobs.child(uidUser).child(idMyCK).push().set({
      'fcmToken': fcmToken,
      'daily_time_to_send': dailyTimeToSend,
      'notificationName': notificationName,
      'notificationDetail': notificationDetail,
      'payload': payload,
      'lengthDay': lengthDay != null ? lengthDay.toString() : null,
      'sendNotificationBothIn6AmAnd6Pm': sendNotificationBothIn6AmAnd6Pm,
      'create_date': DateTime.now().toString()
    });
  }

  static Future removeRecordNotificationSheduleJobs(String idMyCK) async {
    await databaseNotificationScheduleJobs.child(uidUser).child(idMyCK).remove();
  }
}
