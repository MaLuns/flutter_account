import 'package:flutter/widgets.dart';
import 'package:shici/common/db_helper.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDbProvider {
  bool isTableExits = false;

  String tableName();

  String createTableString();

  ///初始化表数据
  Future<void> initTable() async {}

  Future<Database> getDataBase() async => await open();

  ///super 函数对父类进行初始化
  @mustCallSuper
  Future<void> prepare(name, String createSql) async {
    isTableExits = await DbHelper.isTableExits(name);
    if (!isTableExits) {
      Database db = await DbHelper.getDb();
      await db.execute(createSql);
      await initTable();
    }
  }

  @mustCallSuper
  Future<Database> open() async {
    if (!isTableExits) {
      await prepare(tableName(), createTableString());
    }
    return await DbHelper.getDb();
  }
}
