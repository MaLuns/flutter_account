import 'package:flutter/material.dart';

final ThemeData themeLight = ThemeData(
  colorScheme: ColorScheme.light(
    brightness: Brightness.light,
  ),
  highlightColor: Color.fromRGBO(0, 0, 0, 0),
  splashColor: Color.fromRGBO(0, 0, 0, 0),
  primaryColor: Colors.yellow[600],
  tabBarTheme: TabBarTheme(
    labelColor: Colors.black,
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.black,
          width: 2,
        ),
      ),
    ),
  ),
);
