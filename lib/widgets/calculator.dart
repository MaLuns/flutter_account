import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';

class CalculatorWidget extends StatelessWidget {
  CalculatorWidget({Key key, this.callback}) : super(key: key);

  final Function callback;
  final _number = '0'.obs;
  final _opt = ''.obs;
  final _numberTwo = ''.obs;
  final _dateTime = DateTime.now().obs;
  final _todayStr = DateTime.now().toString().substring(0, 10);

  Widget _renderItem({Widget child, String text, Function fun}) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          fun(text);
          HapticFeedback.heavyImpact();
        },
        onLongPress: text == 'delete'
            ? () {
                _number.value = '0';
                _opt.value = '';
                _numberTwo.value = '';
              }
            : null,
        child: Container(
          color: Color(0xfff5f5f5),
          margin: EdgeInsets.all(.5),
          child: Center(
            child: child != null ? child : Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          ),
        ),
      ),
    );
  }

  /// 计算
  void _compute({opt = ''}) {
    num res;
    if (_opt.value == '-') {
      res = (num.parse(_number.value) * 100 - num.parse(_numberTwo.value) * 100) / 100;
    } else {
      res = (num.parse(_number.value) * 100 + num.parse(_numberTwo.value) * 100) / 100;
    }
    _number.value = (res == 0 ? 0 : (res % res.toInt() == 0 ? res.toInt() : res)).toString();
    _opt.value = opt;
    _numberTwo.value = '';
  }

  /// 是否是Int
  bool isInteger(String text) {
    RegExp number = RegExp(r"[0-9]+");
    return number.hasMatch(text) && !text.contains("\.");
  }

  /// 是否是数字
  bool isNumber(String text) {
    RegExp number = RegExp(r"^[-]*[0-9]{0,8}.?[0-9]{0,2}$");
    return number.hasMatch(text);
  }

  /// 操作
  void _update(String optkey) {
    switch (optkey) {
      case '0':
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
        String _num;
        if (_opt.value == '') {
          _num = _number.value == '0' ? optkey : _number.value + optkey;
          if (isNumber(_num)) _number.value = _num;
        } else {
          _num = _numberTwo.value == '0' ? optkey : _numberTwo.value + optkey;
          if (isNumber(_num)) _numberTwo.value = _num;
        }
        break;
      case '.':
        if (_opt.value == '') {
          if (isInteger(_number.value)) {
            _number.value += '.';
          }
        } else {
          if (isInteger(_numberTwo.value)) {
            _numberTwo.value += '.';
          }
        }
        break;
      case '+':
      case '-':
        if (_numberTwo.value == '' && _number.value != '0') _opt.value = optkey;
        if (_numberTwo.value != '') _compute(opt: optkey);
        break;
      case '=':
        if (_numberTwo.value == '') _numberTwo.value = '0';
        _compute(opt: '');
        break;
      case 'delete':
        if (_numberTwo.value.length > 0) {
          _numberTwo.value = _numberTwo.value.substring(0, _numberTwo.value.length - 1);
        } else if (_opt.value != '') {
          _opt.value = '';
        } else if (_number.value.length > 1) {
          _number.value = _number.value.substring(0, _number.value.length - 1);
        } else {
          _number.value = '0';
        }
        break;
      case '完成':
        callback(double.parse(_number.value), _dateTime.value, '');
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: 350,
      color: Color(0xffeeeeee),
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(padding: EdgeInsets.only(right: 16)),
                Container(
                  child: Center(
                    child: Text(
                      '备注：',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: "点击写入备注",
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      fillColor: Colors.transparent,
                      filled: false,
                      enabledBorder: _getOutlineInputBorder(),
                      focusedBorder: _getOutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(
                    () => Text(
                      _number.value + _opt.value + _numberTwo.value,
                      maxLines: 2,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 16))
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['7', '8', '9'].map((e) => _renderItem(text: e, fun: _update)).toList()
                ..add(_renderItem(
                  text: 'date',
                  fun: (text) {
                    DatePicker.showDatePicker(
                      context,
                      showTitleActions: true, // 是否展示顶部操作按钮
                      minTime: DateTime(2010, 1, 1), // 最小时间
                      maxTime: DateTime(2050, 12, 31), // 最大时间
                      onConfirm: (date) => _dateTime.value = date,
                      currentTime: _dateTime.value,
                      locale: LocaleType.zh,
                    );
                  },
                  child: ObxValue((data) {
                    return data.value.toString().substring(0, 10) == _todayStr
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.date_range_outlined,
                                color: Colors.black,
                              ),
                              Text('今天'),
                            ],
                          )
                        : Text(data.value.toString().substring(5, 10));
                  }, _dateTime),
                )),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['4', '5', '6', '+'].map((e) => _renderItem(text: e, fun: _update)).toList(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['1', '2', '3', '-'].map((e) => _renderItem(text: e, fun: _update)).toList(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                '.',
                '0',
              ].map((e) => _renderItem(text: e, fun: _update)).toList()
                ..add(_renderItem(text: 'delete', fun: _update, child: Icon(Icons.backspace_outlined, color: Colors.black)))
                ..add(ObxValue((data) => _renderItem(text: (data.value == '' ? '完成' : '='), fun: _update), _opt)),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _getOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Color(0x00000000)),
      borderRadius: BorderRadius.all(
        Radius.circular(3),
      ),
    );
  }
}
