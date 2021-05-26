import 'package:flutter/widgets.dart';
import 'package:shici/data/provider/base_db_provider.dart';
import 'package:shici/data/models/project_model.dart';
import 'package:sqflite/sqflite.dart';

class ProjectDbProvider extends BaseDbProvider {
  final String name = 'project';

  // 静态私有成员，没有初始化
  static ProjectDbProvider _instance;

  // 单例公开访问点
  factory ProjectDbProvider() => _sharedInstance();

  ProjectDbProvider._();

  static ProjectDbProvider _sharedInstance() {
    if (_instance == null) _instance = ProjectDbProvider._();
    return _instance;
  }

  @override
  String createTableString() {
    return '''
    CREATE TABLE project(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type INTEGER NOT NULL,
        icon TEXT NOT NULL,
        sort INTEGER NOT NULL,
        isDefault BOOLEAN DEFAULT false,
        deleted BOOLEAN DEFAULT false,
        updateTime DATETIME DEFAULT (datetime('now'))
    );
   ''';
  }

  @override
  String tableName() => name;

  @override
  Future<void> initTable() async {
    final Database db = await getDataBase();
    Map<String, String> a = {
      'canyin_': '餐饮',
      'gouwu': '购物',
      'riyong': '日用',
      'jiaotong_': '交通',
      'huluobushucaiqu': '蔬菜',
      'shuiguo': '水果',
      'lingshi': '零食',
      'yundong': '运动',
      'yule': '娱乐',
      'tongxun': '通讯',
      'fushi': '服饰',
      'beautiful_jf': '美容',
      'zhufang': '住房',
      'jujia_copy': '居家',
      'haizi': '孩子',
      'changbei': '长辈',
      'shejiao': '社交',
      'lvhang': '旅行',
      'yanjiu': '烟酒',
      'shumachanpin': '数码',
      'car_hy': '汽车',
      'yiliao': '医疗',
      'shuji': '书籍',
      'xuexi': '学习',
      'chongwu': '宠物',
      'lijin': '礼金',
      'liwu': '礼物',
      'bangong': '办公',
      'weixiu2': '维修',
      'juanzeng': '捐赠',
      'caipiao': '彩票',
      'qinyoutuisong': '亲友',
      'kuaidi': '快递',
    };

    Map<String, String> b = {
      'gongzi': '工资',
      'jianzhi': '兼职',
      'licai1': '理财',
      'lijin': '礼金',
      'qita': '其他',
    };

    await _initProject(a, db, 1);
    await _initProject(b, db, 2);
  }

  Future<void> _initProject(Map<String, String> map, Database db, int type) {
    int _index = 0;
    var batch = db.batch();
    map.forEach((key, value) async {
      batch.rawInsert(insertProject(name: value, iconStr: key, type: type, sort: _index, isDefault: true));
      _index++;
    });
    return batch.commit();
  }

  // 新增
  String insertProject({@required String name, @required int sort, int type = 1, @required String iconStr, bool isDefault = false}) {
    return '''
    INSERT INTO project (name,type,icon,sort,isDefault) VALUES('$name',$type,'$iconStr',$sort,$isDefault);
    ''';
  }

  // 修改排序
  Future<int> updateProjectSort(int sort, int id) async {
    final Database db = await getDataBase();
    return db.rawUpdate('UPDATE project SET sort=$sort WHERE id=$id');
  }

  // 查询
  Future<List<ProjectModel>> projects({String where = '1=1'}) async {
    final Database db = await getDataBase();
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
