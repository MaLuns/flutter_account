import 'package:get/get.dart';
import 'package:shici/data/models/account_info_model.dart';
import 'package:shici/data/models/sum_account_model.dart';

abstract class AbstractAccountMange extends GetxController {
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
