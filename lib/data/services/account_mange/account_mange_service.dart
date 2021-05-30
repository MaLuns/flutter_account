import 'package:shici/data/models/account_info_model.dart';
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
}
