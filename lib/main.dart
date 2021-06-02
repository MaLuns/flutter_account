/* import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_function/cloudbase_function.dart'; */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shici/pages/tab_page/index.dart';
import 'package:shici/routes/routes.dart';
import 'package:shici/themes/light.dart';
import 'package:shici/themes/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  print(ThemeDataInfo() == ThemeDataInfo());

  runApp(
    GetMaterialApp(
      title: '哈哈',
      theme: themeLight,
      initialRoute: '/',
      defaultTransition: Transition.fade,
      getPages: AppRoutes.pages,
      home: HomaPage(),
    ),
  );
}
