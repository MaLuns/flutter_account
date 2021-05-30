class ProjectModel {
  /// id
  int id;

  /// 名称
  String name;

  /// 类型 1 支出 2 收入
  int type;

  /// 图标
  String icon;

  /// 是否删除
  bool deleted;

  /// 是否是内置默认类型
  bool isDefault;

  /// 排序
  int sort;
  String updateTime;

  ProjectModel({this.id, this.name, this.type, this.icon, this.isDefault = false, this.deleted = false, this.updateTime, this.sort});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'icon': icon,
      'sort': sort,
      'isDefault': isDefault,
      'deleted': deleted,
      'updateTime': updateTime,
    };
  }
}
