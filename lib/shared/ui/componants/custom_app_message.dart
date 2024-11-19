import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/models/custom_message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppMessage extends StatelessWidget {
  const CustomAppMessage(
      {Key? key,
      required this.message,
      required this.customMessageModel,
      this.callBack})
      : super(key: key);
  final String? message;
  final CustomMessageModel customMessageModel;
  final Function? callBack;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          Container(
            width: AppSize.currentScreenWidth,
            padding: EdgeInsets.symmetric(horizontal: AppSize.w26)
                .copyWith(top: AppSize.currentScreenTopPadding),
            decoration: BoxDecoration(
              color: customMessageModel.color,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(AppSize.r20),
                bottomLeft: Radius.circular(AppSize.r20),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSize.h16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(AppSize.w6),
                        child: Center(
                          child: SvgPicture.asset(customMessageModel.icon),
                        ),
                      ),
                      AppSize.w12.pw,
                      SizedBox(
                        width: AppSize.currentScreenWidth -
                            AppSize.w26 * 2 -
                            AppSize.sp32 * 2 -
                            AppSize.w12,
                        child: Text(
                          message ?? "",
                          style: AppStyles.kTextStyle16.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      if (callBack != null) {
                        callBack!();
                      }
                    },
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
