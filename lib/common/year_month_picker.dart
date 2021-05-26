import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class YearMonthPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  YearMonthPicker({DateTime currentTime, LocaleType locale}) : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.year);
    this.setMiddleIndex(this.currentTime.month);
    this.setRightIndex(0);
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 2000 && index < 2050) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index > 0 && index <= 12) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  List<int> layoutProportions() {
    return [1, 1, 0];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            1,
          )
        : DateTime(
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            1,
          );
  }
}
