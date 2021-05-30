import 'package:shici/data/models/account_info_model.dart';

class SumAccountModel {
  /// 支出金额
  double payMoney;

  /// 收入金额
  double incomeMoney;

  /// 周几 0-6 （0=周日）
  String weekday;

  /// 日期
  String date;

  ///
  List<AccountInfoModel> childen;

  SumAccountModel({this.payMoney, this.incomeMoney, this.weekday, this.date, this.childen});
}
