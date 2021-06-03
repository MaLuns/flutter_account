import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shici/common/iconfont.dart';
import 'package:shici/data/models/account_info_model.dart';
import 'package:shici/data/models/project_model.dart';
import 'package:shici/data/services/account_mange/account_mange_abstract.dart';
import 'package:shici/data/services/project_mange/project_mange_abstract.dart';
import 'package:shici/routes/routes.dart';
import 'package:shici/widgets/calculator.dart';

class TypeModel {
  String key;
  String title;
  int id;
  int type; // 1支出  2 收入
  TypeModel({this.type, this.key, this.title, this.id});
}

class AddAccountPage extends GetView<AbstractAccountMange> {
  final List<TypeModel> _map = [
    TypeModel(key: 'pay', title: '支出', id: 0, type: 1),
    TypeModel(key: 'income', title: '收入', id: 0, type: 2),
  ];

  void _showToast(String title) {
    Fluttertoast.showToast(
      msg: title,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _save(int type, int id, double money, String date, String remark) async {
    if (id == 0) {
      _showToast('请选择收支分类');
      return;
    }
    if (money == 0) {
      _showToast('请输入收支金额');
      return;
    }
    int res = await controller.addAccount(AccountInfoModel(date: date, projectID: id, money: money, type: type));
    if (res > 0) {
      Get.back();
    } else {
      _showToast('新增失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0.0,
          title: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            tabs: _map.map((value) => Tab(text: value.title)).toList(),
          ),
        ),
        body: TabBarView(
          children: _map.map((e) => buildColumn(e)).toList(),
        ),
      ),
    );
  }

  Column buildColumn(TypeModel model) {
    return Column(
      children: [
        Expanded(
          child: ProjectGridView(
            projectType: model.key,
            callback: (id) => model.id = id,
          ),
        ),
        CalculatorWidget(
          callback: (double money, DateTime date, String remark) {
            _save(model.type, model.id, money, date.toString(), remark);
          },
        ),
      ],
    );
  }
}

// 类别格子
class ProjectGridView extends GetView<AbstractProjectMange> {
  ProjectGridView({Key key, @required this.projectType, this.callback}) : super(key: key);
  final String projectType;
  final Function callback;
  final _index = 0.obs;

  Widget builidss() {
    return Wrap();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      physics: BouncingScrollPhysics(),
      child: GetBuilder<AbstractProjectMange>(
        init: controller,
        builder: (_) {
          return Wrap(
            spacing: 16.0,
            runSpacing: 8.0,
            children: _.projectMap[projectType].map((e) => buildItemIcon(_, e)).toList()..add(buildSettingIcon()),
          );
        },
      ),
    );
  }

  Widget buildItemIcon(AbstractProjectMange _, ProjectModel project) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          _index.value = project.id;
          if (callback != null) {
            callback(_index.value);
          }
        },
        child: ProjectItem(
          item: project,
          color: _index.value == project.id ? Colors.yellow[600] : Color(0xfff2f2f2),
        ),
      ),
    );
  }

  Widget buildSettingIcon() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.SetProject,
          arguments: {
            'type': projectType,
          },
        );
      },
      child: ProjectItem(
        item: ProjectModel(name: '设置', icon: 'shezhi'),
        color: Color(0xfff2f2f2),
      ),
    );
  }
}

// 类别项
class ProjectItem extends StatelessWidget {
  const ProjectItem({Key key, @required this.item, @required this.color}) : super(key: key);
  final Color color;
  final ProjectModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 80,
      child: Column(
        children: [
          Container(
            height: 60,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              IconFont.icon[item.icon],
              size: 40,
              color: Colors.black,
            ),
          ),
          Text(item.name)
        ],
      ),
    );
  }
}
