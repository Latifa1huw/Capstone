import 'package:template/shared/constants/constants.dart';
import 'package:flutter/cupertino.dart';

extension StringExtensions on String {
  String tr({BuildContext? context}) {
    return translate(this, context: context);
  }
}
