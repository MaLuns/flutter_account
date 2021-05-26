import 'package:shici/data/models/project_model.dart';
import 'package:shici/data/provider/project_db_provider.dart';
import 'package:shici/data/services/project_mange/project_mange_abstract.dart';
import 'package:sqflite/sqlite_api.dart';

class ProjectMangeService extends AbstractProjectMange {
  List<ProjectModel> get payProjects => projectMap['pay'];
  List<ProjectModel> get incomeProjects => projectMap['income'];

  @override
  Future<void> loadPayProjects() async {
    try {
      projectMap['pay'] = await ProjectDbProvider().projects(where: ' type=1 and deleted=0');
      update();
    } catch (e) {
      print('_load' + e.toString());
      return null;
    }
  }

  @override
  Future<void> loadIncomeProjects() async {
    try {
      projectMap['income'] = await ProjectDbProvider().projects(where: ' type=2 and deleted=0');
      update();
    } catch (e) {
      print('_load' + e.toString());
      return null;
    }
  }

  @override
  void sortProject(String type, int oldIndex, int newIndex) {
    List<ProjectModel> list = projectMap[type];
    /* ProjectModel _item = list[oldIndex];
    list[oldIndex] = list[newIndex];
    list[newIndex] = _item; */
    if (oldIndex > newIndex) {
      list.insert(newIndex, list[oldIndex]);
      list.removeAt(oldIndex + 1);
    } else {
      list.insert(newIndex + 1, list[oldIndex]);
      list.removeAt(oldIndex);
    }
    ProjectDbProvider pr = ProjectDbProvider();
    for (var i = 0; i < list.length; i++) {
      ProjectModel pm = list[i];
      pr.updateProjectSort(i, pm.id);
    }
    update();
  }

  @override
  Future<void> addProject(String name, String iconStr, String type) async {
    ProjectDbProvider pr = ProjectDbProvider();
    String sql = pr.insertProject(
      name: name,
      sort: projectMap[type].length,
      iconStr: iconStr,
      type: type == 'pay' ? 1 : 2,
    );
    Database db = await pr.getDataBase();
    await db.rawInsert(sql);
    if (type == 'pay') {
      loadPayProjects();
    } else {
      loadIncomeProjects();
    }
  }

  @override
  Future<void> stopOrStartProject(ProjectModel pm, String type) async {
    ProjectDbProvider pr = ProjectDbProvider();
    Database db = await pr.getDataBase();
    await db.update(pr.tableName(), {'deleted': 1}, where: ' id=${pm.id}');
    projectMap[type].remove(pm);
    update();
  }

  @override
  void onReady() {
    super.onReady();
    loadPayProjects();
    loadIncomeProjects();
  }
}
