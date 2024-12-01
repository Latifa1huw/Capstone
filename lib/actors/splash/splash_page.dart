import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';

class AnimatedCircleScreen extends StatefulWidget {
  @override
  _AnimatedCircleScreenState createState() => _AnimatedCircleScreenState();
}

class _AnimatedCircleScreenState extends State<AnimatedCircleScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), (){
      if(PrefManager.currentUser?.type == null){
        UI.push(AppRoutes.toggleBetweenUsers);
      }else{
        if(PrefManager.currentUser?.type == 1){
          UI.push(AppRoutes.adminStartPage);
        }else if(PrefManager.currentUser?.type == 2){
          UI.push(AppRoutes.customerStartPage);
        } else if(PrefManager.currentUser?.type == 3){
          UI.push(AppRoutes.salonStartPage);
        }else{
          UI.push(AppRoutes.toggleBetweenUsers);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kMainColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(Resources.logo),
            Image.asset(Resources.HEREWEglow, height: 125.sp,),
          ],
        ),
      ),
    );
  }
}
