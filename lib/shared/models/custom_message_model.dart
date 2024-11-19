import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/resources.dart';
import 'package:flutter/material.dart';

enum CustomMessageType { error, success, info, warning }

class CustomMessageModel {
  CustomMessageType messageType;

  CustomMessageModel({required this.messageType});

  String get icon {
    switch (messageType) {
      case CustomMessageType.error:
        return Resources.issueIcon;
      case CustomMessageType.success:
        return Resources.successIcon;
      case CustomMessageType.info:
        return Resources.infoIcon;
      case CustomMessageType.warning:
        return Resources.warningIcon;
      default:
        return Resources.issueIcon;
    }
  }

  Color get color {
    switch (messageType) {
      case CustomMessageType.error:
        return AppColors.redColor757;
      case CustomMessageType.success:
        return AppColors.greenColor580;
      case CustomMessageType.info:
        return AppColors.blueColor4F3;
      case CustomMessageType.warning:
        return AppColors.orangeColorF4D;
      default:
        return AppColors.redColor757;
    }
  }
}
