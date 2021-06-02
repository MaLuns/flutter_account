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

  String get weekdayStr {
    const _week = '星期';
    switch (weekday) {
      case '0':
        return '$_week日';
      case '1':
        return '$_week一';
      case '2':
        return '$_week二';
      case '3':
        return '$_week三';
      case '4':
        return '$_week四';
      case '5':
        return '$_week五';
      case '6':
        return '$_week六';
      default:
        return '';
    }
  }
}
