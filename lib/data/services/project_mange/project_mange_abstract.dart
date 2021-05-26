import 'package:get/get.dart';
import 'package:shici/data/models/project_model.dart';

abstract class AbstractProjectMange extends GetxController {
  Map<String, List<ProjectModel>> projectMap = {
    'pay': [],
    'income': [],
  };
  Future<void> loadPayProjects();
  Future<void> loadIncomeProjects();
  void sortProject(String type, int oldIndex, int newIndex);
  void addProject(String name, String iconStr, String type);
  Future<void> stopOrStartProject(ProjectModel pm, String type);
}
