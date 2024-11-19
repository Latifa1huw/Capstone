import 'package:template/shared/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:template/main.dart';

String translate(String key, {BuildContext? context}) {
  return AppLocalizations.of(context ?? navigatorKey.currentContext!)
          ?.translate(key) ??
      key;
}

abstract class AppConstants {
  static const String defualtImage = "https://firebasestorage.googleapis.com/v0/b/salon-ea188.appspot.com/o/image.png?alt=media&token=387c53bb-77c6-4a40-86e9-e9c370f683e4";
  static const String base64Padding = "data:image/jpeg;base64,";
  static const String googleMapApiKey =
      "AIzaSyA557TV201eLUIup6QuJZUkE2gl0a5X6EQ";
  static const int successStatusCode = 200;
  static RegExp saudiPhoneRegex = RegExp(r'^5(5|0|3|6|4|9|1|8|7|2)\d{7}$');
  static RegExp emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

  static List<String> allowedFileTypes = [
    'jpg',
    'jpeg',
    'png',
    'dco',
    'docx',
    "pdf"
  ];
}
