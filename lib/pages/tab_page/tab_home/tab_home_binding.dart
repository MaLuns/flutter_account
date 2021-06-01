import 'package:get/get.dart';
import 'package:shici/data/services/account_mange/account_mange_abstract.dart';
import 'package:shici/data/services/account_mange/account_mange_service.dart';

class TabHomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AbstractAccountMange>(() => AccountMangeService());
  }
}
