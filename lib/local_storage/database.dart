import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DBLocal {
  var dbname = "TCT"; // ตัวแปรที่เก็บชื่อของฐานข้อมูล

  Future<Database> connectDB() async {
    // ฟังก์ชันเชื่อมต่อฐานข้อมูล SQLite
    // หาตำแหน่งของ Path ในตัว Mobile Device
    dynamic directory =
        await getApplicationDocumentsDirectory(); // หาตำแหน่งที่เก็บข้อมูล
    // print(directory);
    var location = join(directory.path, this.dbname);
    // print(location);

    // การสร้าง DB File
    var createDB = databaseFactoryIo;
    var db = await createDB.openDatabase(location);
    // print(db);

    return db;
  }
}
