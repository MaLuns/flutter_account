import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shici/common/iconfont.dart';
import 'package:shici/data/models/project_model.dart';
import 'package:shici/data/services/project_mange/project_mange_abstract.dart';
import 'package:shici/routes/routes.dart';

class SetProjectPage extends StatelessWidget {
  final _type = 'pay'.obs;

  SetProjectPage() {
    final details = Get.arguments as Map;
    _type.value = details['type'];
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      appBar: AppBar(
        title: Text('类别设置'),
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
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => _type.value = 'pay',
                    child: Obx(
                      () => Container(
                        alignment: Alignment.center,
                        child: Text('支出', style: TextStyle(color: _type.value == 'pay' ? Theme.of(context).primaryColor : null)),
                        color: _type.value == 'pay' ? Colors.black : null,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => _type.value = 'income',
                    child: Obx(
                      () => Container(
                        alignment: Alignment.center,
                        child: Text('收入', style: TextStyle(color: _type.value == 'income' ? Theme.of(context).primaryColor : null)),
                        color: _type.value == 'income' ? Colors.black : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 16),
            child: Obx(() => SortProject(type: _type.value)),
            color: Colors.white10,
          ),
          Positioned(
            bottom: 0,
            height: 50 + bottom,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.AddProject, arguments: {
                  'type': _type.value,
                });
              },
              child: Container(
                padding: EdgeInsets.only(bottom: bottom),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Color(0x11000000), blurRadius: 10)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    Text('新增类别'),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SortProject extends GetView<AbstractProjectMange> {
  const SortProject({Key key, @required this.type}) : super(key: key);
  final String type;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AbstractProjectMange>(
      init: controller,
      builder: (_) => buildDragAndDropLists(_), // buildReorderableListView(_),
    );
  }

  Widget buildDragAndDropLists(AbstractProjectMange _) {
    return DragAndDropLists(
      onItemReorder: (int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
        print('$oldItemIndex 移动到 $newItemIndex');
        _.sortProject(type, oldItemIndex, newItemIndex);
      },
      onListReorder: (int oldListIndex, int newListIndex) {},
      itemDragHandle: DragHandle(
        child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: Icon(Icons.menu),
        ),
      ),
      itemDivider: Divider(height: 1, color: Color(0xffeeeeee)),
      children: [
        DragAndDropList(
          canDrag: false,
          children: List.generate(
            _.projectMap[type].length,
            (index) => buildDragAndDropItem(_.projectMap[type][index]),
          ).toList(),
        )
      ],
    );
  }

  DragAndDropItem buildDragAndDropItem(ProjectModel item) {
    return DragAndDropItem(
      child: Container(
        color: Colors.white,
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 4, right: 10),
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () {
                  print(item.id);
                  controller.stopOrStartProject(item, type);
                },
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xfff3f3f3),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(IconFont.icon[item.icon], size: 18),
              ),
            ],
          ),
          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: item.name),
                TextSpan(text: '${item.isDefault ? '' : '（自定义）'}'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListTile({AbstractProjectMange aac, ProjectModel item, bool move, int index, BuildContext context}) {
    final child = Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: move ? [BoxShadow(color: Color(0x11000000), blurRadius: 5)] : [],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xffeeeeee),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(IconFont.icon[item.icon]),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              item.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          SizedBox(width: 16),
          Icon(Icons.menu),
        ],
      ),
    );

    return move
        ? child
        : DragTarget<int>(
            builder: (_, __, ___) => child,
            onAccept: (int oldIndex) {
              print('将 $oldIndex 拖动到 $index 了');
              aac.sortProject(type, oldIndex, index);
            },
          );
  }

  ListView buildDraggable(AbstractProjectMange _) {
    return ListView.builder(
      itemCount: _.projectMap[type].length,
      itemBuilder: (context, index) {
        ProjectModel item = _.projectMap[type][index];
        return Draggable<int>(
          data: index,
          axis: Axis.vertical,
          ignoringFeedbackSemantics: false,
          feedback: buildListTile(
            aac: _,
            item: item,
            move: true,
            index: index,
            context: context,
          ),
          child: buildListTile(
            aac: _,
            item: item,
            move: false,
            index: index,
            context: context,
          ),
          /* childWhenDragging: Container(
            height: 60,
            color: Colors.transparent,
          ), */
        );
      },
    );
  }

  ReorderableListView buildReorderableListView(AbstractProjectMange _) {
    return ReorderableListView(
      onReorder: (int oldIndex, int newIndex) {
        print(oldIndex);
        print(newIndex);
        _.sortProject(type, oldIndex, newIndex);
      },
      children: _.projectMap[type].map((ProjectModel e) {
        return Container(
          key: ValueKey(e.id),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(width: 1, color: Color(0xfffafafa)),
            ),
          ),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xffeeeeee),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(IconFont.icon[e.icon]),
            ),
            title: Text(e.name),
          ),
        );
      }).toList(),
    );
  }
}
