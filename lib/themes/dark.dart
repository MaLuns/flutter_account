import 'package:flutter/material.dart';

final ThemeData themeDark = ThemeData(
  colorScheme: ColorScheme.dark(),
  tabBarTheme: TabBarTheme(
    labelColor: Colors.white,
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.white,
          width: 2,
        ),
      ),
    ),
  ),
);
