import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shici/themes/dark.dart';
import 'package:shici/themes/light.dart';

class ThemeDataInfo {
  static ThemeDataInfo _themeDataInfo;

  ThemeDataInfo._init();

  factory ThemeDataInfo() {
    if (_themeDataInfo == null) {
      _themeDataInfo = ThemeDataInfo._init();
    }
    return _themeDataInfo;
  }

  Map<String, Color> colors = {};

  ThemeData operator [](String key) {
    return _map[key];
  }

  Map<String, ThemeData> _map = {
    'light': themeLight,
    'dark': themeDark,
  };

  ThemeData get theme => _map[Get.isDarkMode ? 'dark' : 'light'];
}
