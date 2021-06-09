import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shici/data/models/account_info_model.dart';
import 'package:shici/data/models/sum_account_model.dart';

abstract class AbstractAccountMange extends GetxController {
  // 当前时间
  String curDate;
  // 过渡方向
  AxisDirection direction = AxisDirection.down;
  List<SumAccountModel> sumAccountModelList = [];
  Map<String, double> monthSum = {
    'payMoney': 0,
    'incomeMoney': 0,
  };

  void deleteAccount(int id);
  Future<int> addAccount(AccountInfoModel model);
  Future<List<SumAccountModel>> getSumAccount(String date);
  Future<void> getMonthSum(String date);
}
