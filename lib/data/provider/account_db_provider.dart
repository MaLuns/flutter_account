import 'package:flutter/material.dart';
import 'package:shici/common/db_helper.dart';
import 'package:shici/data/models/account_info_model.dart';
import 'package:shici/data/models/sum_account_model.dart';
import 'package:sqflite/sqlite_api.dart';

class AccountDbProvider {
  final String tableName = 'account';

  AccountDbProvider._();
  factory AccountDbProvider() => _sharedInstance();
  static AccountDbProvider _instance;
  static AccountDbProvider _sharedInstance() {
    if (_instance == null) _instance = AccountDbProvider._();
    return _instance;
  }

  /// 插入账目
  Future<int> insertAccount({@required int projectID, @required double money, @required String date, int type = 1, String remark = ''}) async {
    Database db = await DbHelper.getDb();
    double payMoney = type == 1 ? money : 0;
    double incomeMoney = type == 1 ? 0 : money;
    return db.rawInsert('''INSERT INTO account (projectID,payMoney,incomeMoney,type,date,remark) VALUES($projectID,$payMoney,$incomeMoney,$type,'$date','$remark')''');
  }

  /// 获取每日列表数据
  Future<List<AccountInfoModel>> getAccountInfo(String date) async {
    Database db = await DbHelper.getDb();
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

  /// 获取当月每日合计列表
  Future<List<SumAccountModel>> getSumAccount(String date) async {
    Database db = await DbHelper.getDb();
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

  /// 获取当月合计
  Future<Map<String, double>> getMonthSum(String date) async {
    Database db = await DbHelper.getDb();
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT ifnull(SUM(a.payMoney), 0) payMoney,ifnull(SUM(a.incomeMoney), 0) incomeMoney
      FROM account a
      WHERE strftime('%Y-%m', a.date) = '$date';
    ''');
    return {
      'payMoney': (maps[0]['payMoney'] as num).toDouble(),
      'incomeMoney': (maps[0]['incomeMoney'] as num).toDouble(),
    };
  }
}
