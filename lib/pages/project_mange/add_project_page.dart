import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shici/common/iconfont.dart';
import 'package:shici/data/services/project_mange/project_mange_abstract.dart';

// ignore: must_be_immutable
class AddProjectPage extends GetView<AbstractProjectMange> {
  final _type = 'pay'.obs;
  final _iconStr = ''.obs;
  String name = "";

  OutlineInputBorder _getOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Color(0x00000000)),
      borderRadius: BorderRadius.all(
        Radius.circular(3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final details = Get.arguments as Map;
    _type.value = details['type'];
    _iconStr.value = IconFont.icon.keys.elementAt(0);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Obx(() => Text('添加${_type.value == 'pay' ? '支出' : '收入'}类别')),
        actions: [
          IconButton(
            icon: Text('完成', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            onPressed: () {
              if (name.trim() != '') {
                controller.addProject(name, _iconStr.value, _type.value);
                Get.back();
              } else {
                Fluttertoast.showToast(
                  msg: "请填写类别",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black87,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 80,
              color: Colors.white,
              child: Row(
                children: [
                  SizedBox(width: 16),
                  Obx(
                    () => Container(
                      height: 60,
                      width: 60,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.yellow[600], borderRadius: BorderRadius.circular(100)),
                      child: Icon(IconFont.icon[_iconStr.value], size: 32),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      maxLines: 1,
                      maxLength: 4,
                      decoration: InputDecoration(
                        hintText: "请输入类别名称（不超过4个字）",
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        enabledBorder: _getOutlineInputBorder(),
                        focusedBorder: _getOutlineInputBorder(),
                        counterText: '',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        name = value;
                        print(name);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            Expanded(child: buildIconItem()),
          ],
        ),
      ),
    );
  }

  Widget buildIconItem() {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          alignment: Alignment.center,
          child: Wrap(
            spacing: 16.0, // 主轴(水平)方向间距
            runSpacing: 24.0, // 纵轴（垂直）方向间距
            children: IconFont.icon.keys
                .map((iconStr) => GestureDetector(
                      onTap: () => _iconStr.value = iconStr,
                      child: Obx(
                        () => Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: iconStr == _iconStr.value ? Colors.yellow[600] : Color(0xfff2f2f2),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(IconFont.icon[iconStr], size: 32),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
