import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static String _dbName = 'app_database.db';
  static int _version = 1;
  static Database _db;

  static Future<Database> getDb() async {
    if (_db == null) {
      _db = await openDatabase(
        join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) {
          print(db);
        },
        version: DbHelper._version,
      );
    }
    return _db;
  }

  static Future<void> deletedDataBase() async {
    return deleteDatabase(join(await getDatabasesPath(), 'app_database.db'));
  }

  ///判断表是否存在
  static Future<bool> isTableExits(String tableName) async {
    await getDb();
    var res = await _db.rawQuery("select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res != null && res.length > 0;
  }
}
