import 'package:flutter/material.dart';
import 'package:shici/data/provider/base_db_provider.dart';
import 'package:sqflite/sqlite_api.dart';

class AccountDbProvider extends BaseDbProvider {
  final String name = 'account';

  factory AccountDbProvider() => _sharedInstance();
  AccountDbProvider._();
  static AccountDbProvider _instance;
  static AccountDbProvider _sharedInstance() {
    if (_instance == null) _instance = AccountDbProvider._();
    return _instance;
  }

  @override
  createTableString() {
    return '''
    CREATE TABLE account (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        projectID INTEGER NOT NULL,
        money DECIMAL(10,2) NOT NULL,
        type INTEGER NOT NULL,
        date DATE NOT NULL,
        remark TEXT,
        deleted BOOLEAN DEFAULT false,
        updateTime DATETIME DEFAULT (datetime('now'))
    );
    ''';
  }

  @override
  tableName() => name;

  insertProject({@required int projectID, @required double money, @required String date, int type = 1, String remark = ''}) async {
    Database db = await getDataBase();
    int res = await db.rawInsert('''INSERT INTO account (projectID,money,type，date,remark) VALUES($projectID,$money,$type,'$date','$remark')''');
    print(res);
  }
}
