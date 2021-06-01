import 'package:flutter/material.dart';
import 'package:shici/data/models/account_info_model.dart';
import 'package:shici/data/models/sum_account_model.dart';
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
        payMoney DECIMAL(10,2) NOT NULL DEFAULT 0,
        incomeMoney DECIMAL(10,2) NOT NULL DEFAULT 0,
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

  Future<int> insertAccount({@required int projectID, @required double money, @required String date, int type = 1, String remark = ''}) async {
    Database db = await getDataBase();
    double payMoney = type == 1 ? money : 0;
    double incomeMoney = type == 1 ? 0 : money;
    return db.rawInsert('''INSERT INTO account (projectID,payMoney,incomeMoney,type,date,remark) VALUES($projectID,$payMoney,$incomeMoney,$type,'$date','$remark')''');
  }

  Future<List<AccountInfoModel>> getAccountInfo(String date) async {
    Database db = await getDataBase();
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT a.id,a.projectID,p.name,a.type,p.icon,a.date,a.remark,CASE WHEN a.type = 1 THEN a.payMoney ELSE a.incomeMoney END money
      FROM account a LEFT JOIN project p on a.projectID=p.id
      WHERE  strftime('%Y-%m-%d',a.date)='$date'
    ''');
    return List.generate(maps.length, (i) {
      return AccountInfoModel(
        id: maps[i]['id'],
        projectID: maps[i]['projectID'],
        money: (maps[i]['money'] as num).toDouble(),
        name: maps[i]['name'],
        type: maps[i]['type'],
        icon: maps[i]['icon'],
        date: maps[i]['date'],
        remark: maps[i]['remark'],
      );
    });
  }

  Future<List<SumAccountModel>> getTimi(String date) async {
    Database db = await getDataBase();
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT SUM(a.payMoney) payMoney,SUM(a.incomeMoney) incomeMoney,strftime('%w',a.date) weekday,strftime('%Y-%m-%d',a.date) date
      FROM account a WHERE strftime('%Y-%m',a.date)='$date'
      GROUP BY strftime('%Y-%m-%d',a.date) ORDER BY a.date DESC
    ''');

    List<SumAccountModel> _list = [];
    for (var i = 0; i < maps.length; i++) {
      List<AccountInfoModel> childen = await getAccountInfo(maps[i]['date']);
      _list.add(SumAccountModel(
        payMoney: (maps[i]["payMoney"] as num).toDouble(),
        incomeMoney: (maps[i]['incomeMoney'] as num).toDouble(),
        weekday: maps[i]['weekday'],
        date: maps[i]['date'],
        childen: childen,
      ));
    }
    return _list;
  }
}
