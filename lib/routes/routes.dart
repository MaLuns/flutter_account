import 'package:get/get.dart';
import 'package:shici/pages/add_account/add_account_binding.dart';
import 'package:shici/pages/project_mange/add_project_page.dart';
import 'package:shici/pages/project_mange/set_project_page.dart';
import 'package:shici/pages/project_mange/project_mange_binding.dart';
import 'package:shici/pages/add_account/add_account_page.dart';
import 'package:shici/pages/tab_page/index.dart';

abstract class AppRoutes {
  static const Initial = '/';
  static const NextScreen = '/NextScreen';
  static const AddAccount = '/AddAccount';
  static const SetProject = '/SetProject';
  static const AddProject = '/AddProject';

  static final pages = [
    GetPage(
      name: AppRoutes.Initial,
      page: () => HomaPage(),
    ),
    GetPage(
      name: AppRoutes.AddAccount,
      binding: AddAccountBinding(),
      page: () => AddAccountPage(),
    ),
    GetPage(
      name: AppRoutes.SetProject,
      binding: ProjectMangeBinding(),
      page: () => SetProjectPage(),
    ),
    GetPage(
      name: AppRoutes.AddProject,
      binding: ProjectMangeBinding(),
      page: () => AddProjectPage(),
    ),
  ];
}
