import 'package:template/main.dart';
import 'package:template/shared/models/custom_message_model.dart';
import 'package:template/shared/ui/componants/custom_app_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UI {
  static push(page, {arguments, context}) async {
    return await Navigator.of(context ?? navigatorKey.currentContext!)
        .pushNamed(page, arguments: arguments);
  }

  static void pop() {
    Navigator.of(navigatorKey.currentContext!).pop();
  }

  static void pushWithRemove(page, {arguments}) {
    Navigator.of(navigatorKey.currentContext!).pushNamedAndRemoveUntil(
      page,
      (_) => false,
      arguments: arguments,
    );
  }

  static void showCustomMessage(message,
      {CustomMessageType type = CustomMessageType.error, Function? callBack}) {
    showCupertinoModalPopup(
      context: navigatorKey.currentContext!,
      semanticsDismissible: false,
      builder: (_) => CustomAppMessage(
        message: message,
        callBack: callBack,
        customMessageModel: CustomMessageModel(messageType: type),
      ),
    );
  }

  static void showMessage(message) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  static void removeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
