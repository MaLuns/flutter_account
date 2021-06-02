import 'package:flutter/widgets.dart';
import 'package:shici/common/db_helper.dart';
import 'package:shici/data/models/project_model.dart';
import 'package:sqflite/sqflite.dart';

class ProjectDbProvider {
  final String tableName = 'project';

  // 静态私有成员，没有初始化
  static ProjectDbProvider _instance;

  // 单例公开访问点
  factory ProjectDbProvider() => _sharedInstance();

  ProjectDbProvider._();

  static ProjectDbProvider _sharedInstance() {
    if (_instance == null) _instance = ProjectDbProvider._();
    return _instance;
  }

  // 新增
  String insertProject({@required String name, @required int sort, int type = 1, @required String iconStr, bool isDefault = false}) {
    return '''
    INSERT INTO project (name,type,icon,sort,isDefault) VALUES('$name',$type,'$iconStr',$sort,$isDefault);
    ''';
  }

  // 修改排序
  Future<int> updateProjectSort(int sort, int id) async {
    final Database db = await DbHelper.getDb();
    return db.rawUpdate('UPDATE project SET sort=$sort WHERE id=$id');
  }

  // 查询
  Future<List<ProjectModel>> projects({String where = '1=1'}) async {
    final Database db = await DbHelper.getDb();
    print(db);
    final List<Map<String, dynamic>> maps = await db.rawQuery('''select id,name,type,icon,sort,isDefault,deleted,updateTime from project where $where''');
    return List.generate(maps.length, (i) {
      return ProjectModel(
        id: maps[i]['id'],
        name: maps[i]['name'],
        type: maps[i]['type'],
        icon: maps[i]['icon'],
        sort: maps[i]['sort'],
        isDefault: maps[i]['isDefault'] == 1,
        deleted: maps[i]['deleted'] == 1,
        updateTime: maps[i]['updateTime'],
      );
    });
  }
}
