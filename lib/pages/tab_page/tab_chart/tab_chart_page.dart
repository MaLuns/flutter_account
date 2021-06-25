import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabChartPage extends StatelessWidget {
  final _type = 'month'.obs;
  final _list = [
    {'title': '周', 'key': 'week'},
    {'title': '月', 'key': 'month'},
    {'title': '年', 'key': 'year'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('类别设置'),
        centerTitle: true,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(36),
          child: Container(
            height: 36,
            margin: EdgeInsets.only(bottom: 10, left: 60, right: 60),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(width: 1, color: Colors.black),
            ),
            child: Row(
              children: _list
                  .map((e) => Expanded(
                        child: buildGestureDetector(context, e['title'], e['key']),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
      body: Container(
        height: 200,
      ),
    );
  }

  GestureDetector buildGestureDetector(BuildContext context, String title, String key) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _type.value = key,
      child: Obx(
        () => Container(
          alignment: Alignment.center,
          child: Text(title, style: TextStyle(color: _type.value == key ? Theme.of(context).primaryColor : null)),
          color: _type.value == key ? Colors.black : null,
        ),
      ),
    );
  }
}
