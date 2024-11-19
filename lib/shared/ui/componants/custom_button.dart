import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onClick;
  final String? icon;
  final double? height;
  final double? width;
  final double? textSize;
  final double? radius;
  final Color? btnColor;
  final Color? textColor;
  final TextStyle? textStyle;

  const CustomButton({
    required this.title,
    required this.onClick,
    this.height,
    this.textSize,
    this.radius = 30,
    this.width = double.infinity,
    this.btnColor = AppColors.kButtonColor,
    this.textColor = Colors.white,
    this.textStyle,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      height: height ?? AppSize.h44,
      minWidth: width,
      color: btnColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular((radius ?? AppSize.w8).r),
      ),
      onPressed: onClick,
      child: icon == null? Text(
        title,
        style: textStyle ??
            AppStyles.kTextStyleHeader18.copyWith(color: textColor, fontSize: textSize?? 18.sp),
      ):Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon ?? "", height: 18.sp, width: 18.sp,),
          AppSize.h5.pw,
          Text(
            title,
            style: textStyle ??
                AppStyles.kTextStyleHeader14.copyWith(color: textColor, fontSize: textSize?? 14.sp),
          ),
        ],
      ),
    );
  }
}
