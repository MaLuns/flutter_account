class ProjectModel {
  int id;
  String name;
  int type;
  String icon;
  bool deleted;
  bool isDefault;
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
