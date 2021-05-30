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

// ignore: must_be_immutable
class AddAccountPage extends GetView<AbstractAccountMange> {
  var payProjectID = 0;
  var incomeProjectID = 0;

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
        appBar: AppBar(
          elevation: 0.0,
          title: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            tabs: <Widget>[
              Tab(text: '支出'),
              Tab(text: '收入'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Expanded(
                  child: ProjectGridView(projectType: 'pay', callback: (id) => payProjectID = id),
                ),
                CalculatorWidget(
                  callback: (double money, DateTime date, String remark) {
                    _save(1, payProjectID, money, date.toString(), remark);
                  },
                ),
              ],
            ),
            Column(
              children: [
                Expanded(
                  child: ProjectGridView(projectType: 'income', callback: (id) => incomeProjectID = id),
                ),
                CalculatorWidget(
                  callback: (double money, DateTime date, String remark) {
                    _save(2, incomeProjectID, money, date.toString(), remark);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 类别格子
class ProjectGridView extends GetView<AbstractProjectMange> {
  ProjectGridView({Key key, @required this.projectType, this.callback}) : super(key: key);
  final String projectType;
  final Function callback;
  final _index = 0.obs;

  @override
  Widget build(BuildContext context) {
    print(_index.value);
    return GetBuilder<AbstractProjectMange>(
      init: controller,
      builder: (_) {
        return GridView.builder(
          itemCount: _.projectMap[projectType].length + 1,
          shrinkWrap: true,
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1 / 1,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return _.projectMap[projectType].length == index
                ? GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.SetProject, arguments: {
                        'type': projectType,
                      });
                    },
                    child: ProjectItem(
                      item: ProjectModel(name: '设置', icon: 'shezhi'),
                      color: Color(0xfff2f2f2),
                    ),
                  )
                : Obx(() => GestureDetector(
                      onTap: () {
                        _index.value = _.projectMap[projectType][index].id;
                        if (callback != null) {
                          callback(_index.value);
                        }
                      },
                      child: ProjectItem(
                        item: _.projectMap[projectType][index],
                        color: _index.value == _.projectMap[projectType][index].id ? Colors.yellow[600] : Color(0xfff2f2f2),
                      ),
                    ));
          },
        );
      },
    );
  }
}

class ProjectItem extends StatelessWidget {
  const ProjectItem({Key key, @required this.item, @required this.color}) : super(key: key);
  final Color color;
  final ProjectModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 10),
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
