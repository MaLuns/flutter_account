import 'package:shici/data/services/project_mange/project_mange_abstract.dart';
import 'package:shici/data/services/project_mange/project_mange_service.dart';
import 'package:get/get.dart';

class AddAccountBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AbstractProjectMange>(() => ProjectMangeService());
  }
}
