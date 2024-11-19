import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/resources.dart';

PreferredSize customAppBarWithoutBack(BuildContext context, {String? title, bool isBack = true}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(50.sp),
    child: AppBar(
      backgroundColor: AppColors.kMainColor,
      elevation: 0,
      shape: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40)
        )
      ),
      centerTitle: true,
      toolbarHeight: 50.sp,
      automaticallyImplyLeading: isBack,
      title: Text(
          title ?? 'Welcome To Bling Salon',
        textAlign: TextAlign.center,
        style: AppStyles.kTextStyle22.copyWith(
          // color: AppColors.kWhiteColor,
          fontWeight: FontWeight.bold
        ),
      ),
    ),
  );
}


PreferredSize customAppBarWithLogo(BuildContext context) {
  return PreferredSize(
    preferredSize: Size.fromHeight(170.sp),
    child: AppBar(
      backgroundColor: AppColors.kMainColor,
      elevation: 0,
      shape: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40)
        )
      ),
      centerTitle: true,
      toolbarHeight: 170.sp,
      title: Image.asset(
        Resources.logo,
        height: 320.sp,
        fit: BoxFit.fill,
      ),
    ),
  );
}

/*
Container customAppBarWithoutBack(BuildContext context, {String? title}) {
  return Container(
    color: AppColors.kMainColor,
    child: Row(
      children: [
        Icon(Icons.keyboard_backspace, size: 25.sp,),
        Text(
          title ?? 'Welcome To Bling Salon',
          style: AppStyles.kTextStyle22.copyWith(
              color: AppColors.kWhiteColor,
              fontWeight: FontWeight.bold
          ),
        ),
      ],
    ),
  );
}
*/
