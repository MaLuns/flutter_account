import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shici/common/iconfont.dart';
import 'package:shici/common/year_month_picker.dart';
import 'package:get/get.dart';
import 'package:shici/data/models/account_info_model.dart';
import 'package:shici/data/models/sum_account_model.dart';
import 'package:shici/data/services/account_mange/account_mange_abstract.dart';
import 'package:shici/data/services/account_mange/account_mange_service.dart';

class TabHomePage extends StatefulWidget {
  @override
  _TabHomePageState createState() => _TabHomePageState();
}

class _TabHomePageState extends State<TabHomePage> with AutomaticKeepAliveClientMixin {
  final double _bgHeight = 170;
  final double _titleHeight = 50;
  final double _sumHeight = 80;
  final double _navHeight = 80;
  SlidableController _slidableController;

  @override
  void initState() {
    super.initState();
    _slidableController = SlidableController(
      onSlideIsOpenChanged: _handleSlideIsOpenChanged,
    );
  }

  void _handleSlideIsOpenChanged(bool isOpen) {
    print(isOpen);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double topPadding = MediaQuery.of(context).padding.top;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: SizedBox(
        height: double.maxFinite,
        child: Stack(
          children: [
            Container(height: _bgHeight + topPadding, color: Theme.of(context).primaryColor),
            Positioned(
              top: topPadding,
              left: 0,
              right: 0,
              height: _titleHeight,
              child: Center(child: Text('哈哈记账', style: TextStyle(fontSize: 20))),
            ),
            Positioned(
              top: _titleHeight + topPadding,
              left: 20,
              right: 10,
              height: _sumHeight,
              child: HomeSum(),
            ),
            Positioned(
              top: _sumHeight + _navHeight + _titleHeight + topPadding,
              left: 0,
              right: 0,
              bottom: 0,
              child: HomeList(slidableController: _slidableController),
            ),
            Positioned(
              top: _sumHeight + _titleHeight + topPadding,
              left: 10,
              right: 10,
              height: _navHeight,
              child: HomeNav(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// 列表
class HomeList extends StatelessWidget {
  const HomeList({Key key, @required SlidableController slidableController})
      : _slidableController = slidableController,
        super(key: key);

  final SlidableController _slidableController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AbstractAccountMange>(
      init: AccountMangeService(),
      builder: (_) {
        return ListView(
          padding: EdgeInsets.only(top: 0, bottom: 30),
          children: List.generate(
            _.sumAccountModelList.length,
            (index) => buildColumn(_.sumAccountModelList[index]),
          ),
        );
      },
    );
  }

  Column buildColumn(SumAccountModel model) {
    return Column(
      children: [
        Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xffe0e0e0), width: 1)),
          ),
          child: Row(
            children: [
              Text('${model.date}', style: TextStyle(color: Colors.black54)),
              SizedBox(width: 10),
              Text('星期${model.weekday}', style: TextStyle(color: Colors.black54)),
              Expanded(child: Container()),
              Text('支出：${model.payMoney}', style: TextStyle(color: Colors.black54)),
              SizedBox(width: 10),
              Text('收入：${model.incomeMoney}', style: TextStyle(color: Colors.black54)),
            ],
          ),
        ),
        ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: model.childen.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            AccountInfoModel mo = model.childen[index];
            return Slidable(
              actionExtentRatio: .15,
              actionPane: SlidableScrollActionPane(),
              controller: _slidableController,
              child: ListTile(
                onTap: () {
                  _slidableController.activeState?.close();
                },
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xffeeeeee),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(IconFont.icon[mo.icon]),
                ),
                title: Text(mo.name),
                //subtitle: index % 2 == 0 ? Text('备注信息') : null,
                trailing: Text('${mo.type == 1 ? '-' : ''}${mo.money}'),
              ),
              secondaryActions: <Widget>[
                Builder(
                  builder: (context) => SlideAction(
                    child: Text('删除', style: TextStyle(color: Colors.white)),
                    color: Colors.red,
                    closeOnTap: false,
                    onTap: () {
                      print(1);
                      _slidableController.activeState?.close();
                    },
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) => Divider(height: 0, thickness: 1, color: Color(0xFFeeeeee)),
        ),
      ],
    );
  }
}

// 菜单
class HomeNav extends StatelessWidget {
  const HomeNav({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0xfff2f2f2), blurRadius: 5.0)],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Icon(Icons.assignment_rounded, size: 32), Text('账单')],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Icon(Icons.attach_money_rounded, size: 32), Text('预算')],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Icon(Icons.verified_user_rounded, size: 32), Text('资产管理')],
            ),
          ),
        ],
      ),
    );
  }
}

// 收入支出合计
class HomeSum extends StatelessWidget {
  HomeSum({Key key}) : super(key: key);

  final _dateTime = DateTime.now().obs;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            DatePicker.showPicker(
              context,
              showTitleActions: true,
              locale: LocaleType.zh,
              pickerModel: YearMonthPicker(locale: LocaleType.zh, currentTime: _dateTime.value),
              onConfirm: (date) {
                _dateTime.value = date;
                print(date);
              },
            );
          },
          child: Container(
            width: 70,
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${_dateTime.value.year}年', style: TextStyle(color: Colors.black54)),
                  Text.rich(TextSpan(
                    children: [
                      TextSpan(text: '${_dateTime.value.month < 10 ? '0' : ''}${_dateTime.value.month}', style: TextStyle(fontSize: 32)),
                      TextSpan(text: '月'),
                      TextSpan(text: ' ▼'),
                    ],
                  )),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: 1,
          height: 30,
          color: Colors.black12,
          margin: EdgeInsets.only(right: 24, left: 16),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('收入', style: TextStyle(color: Colors.black54)),
                    Text(
                      '0.00',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('支出', style: TextStyle(color: Colors.black54)),
                    Text(
                      '0.00',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
