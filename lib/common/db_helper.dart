import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static String _dbName = 'app_database.db';
  static int _version = 1;
  static Database _db;

  static Future<Database> getDb() async {
    if (_db == null) {
      debugPrint('open database');
      _db = await openDatabase(
        join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async {
          print(db);
          debugPrint('create');
          await _initTable(db);
          await _initData(db);
        },
        onUpgrade: (db, oldVersion, newVersion) {
          debugPrint('oldVersion:$oldVersion newVersion:$newVersion ');
        },
        version: DbHelper._version,
      );
      debugPrint('open datebase end');
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

  /// 创建时候 初始化
  static Future<void> _initTable(Database db) async {
    await db.execute('''
    CREATE TABLE project(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL, -- 类别名称
        type INTEGER NOT NULL, -- 类型 1 支出 2 收入
        icon TEXT NOT NULL,  -- 图标
        sort INTEGER NOT NULL, -- 排序
        isDefault BOOLEAN DEFAULT false, -- 是否默认内置
        deleted BOOLEAN DEFAULT false, -- 删除标识
        updateTime DATETIME DEFAULT (datetime('now'))
    );
    ''');

    await db.execute('''
    CREATE TABLE account (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        projectID INTEGER NOT NULL,  -- 类别ID
        payMoney DECIMAL(10,2) NOT NULL DEFAULT 0, -- 支出金额
        incomeMoney DECIMAL(10,2) NOT NULL DEFAULT 0, -- 收入金额
        type INTEGER NOT NULL, -- 类型 1 支出 2 收入
        date TEXT NOT NULL, -- 日期
        remark TEXT, -- 备注
        deleted BOOLEAN DEFAULT false, -- 删除标识
        updateTime DATETIME DEFAULT (datetime('now'))
    );
    ''');
  }

  /// 初始化数据
  static Future<void> _initData(Database db) async {
    Map<String, String> pay = {
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

    Map<String, String> income = {
      'gongzi': '工资',
      'jianzhi': '兼职',
      'licai1': '理财',
      'lijin': '礼金',
      'qita': '其他',
    };

    await _initProject(pay, db, 1);
    await _initProject(income, db, 2);
  }

  static Future<void> _initProject(Map<String, String> map, Database db, int type) {
    int _index = 0;
    var batch = db.batch();
    map.forEach((key, value) async {
      batch.rawInsert(insertProject(name: value, iconStr: key, type: type, sort: _index, isDefault: true));
      _index++;
    });
    return batch.commit();
  }

  // 新增类别
  static String insertProject({@required String name, @required int sort, int type = 1, @required String iconStr, bool isDefault = false}) {
    return '''INSERT INTO project (name,type,icon,sort,isDefault) VALUES('$name',$type,'$iconStr',$sort,$isDefault);''';
  }
}
