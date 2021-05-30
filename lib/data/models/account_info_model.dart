class AccountInfoModel {
  /// id
  int id;

  /// 类别ID
  int projectID;

  /// 金额
  double money;

  /// 类别名称
  String name;

  /// 图标
  String icon;

  /// 支出类别 1 支出 2 收入
  int type;

  /// 账目时间
  String date;

  /// 备注
  String remark;

  AccountInfoModel({this.id, this.projectID, this.money, this.date, this.type, this.remark = '', this.name, this.icon});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectID': projectID,
      'type': type,
      'money': money,
      'date': date,
      'remark': remark,
      'name': name,
      'icon': icon,
    };
  }
}
