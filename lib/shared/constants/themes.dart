import 'package:flutter/material.dart';

class AppTheme{
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    // primaryColor: AppColors.mainColorEF6,
    scaffoldBackgroundColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    // primaryColor: AppColors.mainColorEF6,
    // scaffoldBackgroundColor: AppColors.darkColorE1E,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}