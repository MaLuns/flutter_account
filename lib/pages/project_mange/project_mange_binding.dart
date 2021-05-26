import 'package:get/get.dart';
import 'package:shici/data/services/project_mange/project_mange_abstract.dart';
import 'package:shici/data/services/project_mange/project_mange_service.dart';

class ProjectMangeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AbstractProjectMange>(() => ProjectMangeService());
  }
}
