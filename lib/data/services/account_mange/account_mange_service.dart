import 'package:shici/data/models/account_info_model.dart';
import 'package:shici/data/models/sum_account_model.dart';
import 'package:shici/data/provider/account_db_provider.dart';
import 'package:shici/data/services/account_mange/account_mange_abstract.dart';

class AccountMangeService extends AbstractAccountMange {
  @override
  void deleteAccount(int id) {}

  @override
  Future<int> addAccount(AccountInfoModel model) {
    AccountDbProvider adp = AccountDbProvider();
    return adp.insertAccount(projectID: model.projectID, money: model.money, date: model.date, remark: model.remark, type: model.type);
  }

  @override
  Future<List<SumAccountModel>> getSumAccount(String date) async {
    AccountDbProvider adp = AccountDbProvider();
    sumAccountModelList = await adp.getSumAccount(date);
    await getMonthSum(date);
    update();
    return sumAccountModelList;
  }

  @override
  Future<void> getMonthSum(String date) async {
    AccountDbProvider adp = AccountDbProvider();
    monthSum = await adp.getMonthSum(date);
  }

  @override
  void onReady() {
    super.onReady();
    final month = DateTime.now().toString().substring(0, 7);
    getSumAccount(month);
    print('ready');
  }
}
