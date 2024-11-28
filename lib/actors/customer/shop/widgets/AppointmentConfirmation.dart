import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/customer/cart/cart_viewModel.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class AppointmentConfirmation extends StatefulWidget {
  // final User salon;
  // final CartViewModel cartViewModel;
  const AppointmentConfirmation({Key? key}) : super(key: key);

  @override
  State<AppointmentConfirmation> createState() => _AppointmentConfirmationState();
}

class _AppointmentConfirmationState extends State<AppointmentConfirmation> {

  @override
  void initState() {
    Future.delayed(Duration(seconds: 5), (){
      UI.pushWithRemove(AppRoutes.customerStartPage);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: customAppBarWithLogo(context),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Image.asset(Resources.done, height: 150.sp,),

                  Text("Dear ${PrefManager.currentUser?.name} \n The appointment has been \n confirmed successfully",
                    textAlign: TextAlign.center,
                    style: AppStyles.kTextStyle16.copyWith(

                    ),
                  ),
                ],
              ),
              Image.asset(Resources.HEREWEglow, height: 60.sp,),

              AppSize.h100.ph,

              // CustomButton(title: "Finish",
              //     width: 150,
              //     radius: 20,
              //     onClick: (){
              //   UI.pushWithRemove(AppRoutes.customerStartPage);
              // })
            ],
          ),
        ),
      ),
    );
  }
}
