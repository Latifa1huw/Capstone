import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';
/*

AppBar customAppBar(BuildContext context, {VoidCallback? ontTap}) {
  return AppBar(
    backgroundColor: AppColors.kMainColor,
    centerTitle: true,
    elevation: 0,
    leading: InkWell(
      onTap: () => UI.push(AppRoutes.profilePage),
      child: Padding(
        padding: EdgeInsets.all(5.sp),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.kWhiteColor, width: 2),
            image: DecorationImage(
              image: NetworkImage(
                PrefManager.currentUser?.profile_image ?? "",
              ),
              fit: BoxFit.cover,
            )
          ),
          height: 40.sp,
          width: 40.sp,
        ),
      ),
    ),
    title: Image.asset(Resources.logoHome, height: 50.sp,),
    actions: [
      InkWell(
          onTap: ontTap,
          child: Image.asset(Resources.list, height: 25.sp)
      ),
      AppSize.h20.pw
    ],
  );
}
*/


Row customAppBar(BuildContext context, {VoidCallback? ontTap}) {
  print(PrefManager.currentUser?.profile_image);
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          AppSize.h10.pw,
          InkWell(
              onTap: ontTap,
              child: Image.asset(Resources.list, height: 25.sp)
          ),
        ],
      ),
      Row(
        children: [
          Image.asset(Resources.logoHome, height: 60.sp,),
         /* InkWell(
            onTap: () => UI.push(AppRoutes.profilePage),
            child: Padding(
              padding: EdgeInsets.all(5.sp),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.kWhiteColor, width: 2),
                    image:  PrefManager.currentUser?.profile_image != null ? DecorationImage(
                      image: NetworkImage(
                        PrefManager.currentUser?.profile_image ?? "",
                      ),
                      fit: BoxFit.fill,
                    ) : DecorationImage(
                      image: AssetImage(Resources.user),
                      fit: BoxFit.fill,
                    )
                ),
                height: 40.sp,
                width: 40.sp,
              ),
            ),
          ),*/
          // AppSize.h20.pw
        ],
      )
    ],
  );
}