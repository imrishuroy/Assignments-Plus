import 'package:flutter/material.dart';

enum AppTheme { Light, Dark }

final appThemeData = {
  AppTheme.Light: ThemeData(
    primaryColor: Colors.green,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primarySwatch: Colors.green,
    brightness: Brightness.light,
  ),
  AppTheme.Dark: ThemeData(
    primaryColor: Colors.green,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.dark,
  )
};
