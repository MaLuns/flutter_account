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
      title: '三元',
      theme: themeLight,
      initialRoute: '/',
      defaultTransition: Transition.fade,
      getPages: AppRoutes.pages,
      home: HomaPage(),
    ),
  );
  // 初始化 CloudBase
  /* CloudBaseCore core = CloudBaseCore.init({
    'env': 'h-17b316',
    'appAccess': {'key': 'd4979f35e570c228e2ece68bf5717624', 'version': '1'},
    'timeout': 3000
  });

  CloudBaseAuth auth = CloudBaseAuth(core);
  CloudBaseAuthState authState = await auth.getAuthState();

  if (authState == null) {
    await auth.signInAnonymously();
    authState = await auth.getAuthState();
    print(authState);
  } */

  /* CloudBaseFunction cloudbase = CloudBaseFunction(core);
  Map<String, dynamic> data = {'a': 1, 'b': 2};
  CloudBaseResponse res = await cloudbase.callFunction('oneday', data);
  print(res.data); */
}
