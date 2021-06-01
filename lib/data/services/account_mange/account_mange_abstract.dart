import 'package:get/get.dart';
import 'package:shici/data/models/account_info_model.dart';
import 'package:shici/data/models/sum_account_model.dart';

abstract class AbstractAccountMange extends GetxController {
  List<SumAccountModel> sumAccountModelList = [];

  void deleteAccount(int id);
  Future<int> addAccount(AccountInfoModel model);
  Future<List<SumAccountModel>> getSumAccount(String date);
}
