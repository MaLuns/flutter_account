import 'package:get/get.dart';
import 'package:shici/data/models/account_info_model.dart';

abstract class AbstractAccountMange extends GetxController {
  void deleteAccount(int id);
  Future<int> addAccount(AccountInfoModel model);
}
