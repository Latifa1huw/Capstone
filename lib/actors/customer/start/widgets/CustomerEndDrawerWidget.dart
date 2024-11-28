

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/features/authentication/user_viewModel.dart';
import 'package:template/features/authentication/widgets/change_password_page.dart';
import 'package:template/features/customer/orders/order_page.dart';
import 'package:template/features/customer/ratings/show_ratings_page.dart';
import 'package:template/features/customer/start/widgets/ListAdressesWidget.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class CustomerEndDrawerWidget extends StatefulWidget {
  const CustomerEndDrawerWidget({Key? key}) : super(key: key);

  @override
  State<CustomerEndDrawerWidget> createState() => _CustomerEndDrawerWidgetState();
}

class _CustomerEndDrawerWidgetState extends State<CustomerEndDrawerWidget> {

  UserViewModel viewModel = UserViewModel();

  @override
  void initState() {
    viewModel.getUserById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.kWhiteColor,
      width: MediaQuery.of(context).size.width*.6,
      child:  BlocBuilder<GenericCubit<User>, GenericCubitState<User>>(
          bloc: viewModel.userCubit,
          builder: (context, state) {
            User user = state.data;
            return Column(
            children: [
              Container(
                width: double.infinity,
                color: AppColors.kWhiteColor,
                height: 190.sp,
                child: state is GenericLoadingState ?
                const Loading() :
                InkWell(
                  onTap: () => UI.push(AppRoutes.profilePage),
                  child: Column(
                    children: [
                      AppSize.h50.ph,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(90),
                            child:  Image.asset(Resources.user,
                              height: 70.sp,
                              width: 70.sp,
                              fit: BoxFit.fill,
                            )
                        ),
                      ),
                      AppSize.h10.ph,
                      Text("Profile", style: AppStyles.kTextStyle20,),
                      /*Text("${user.owner_name ?? user.name}", style: AppStyles.kTextStyle20,),
                      Text("${user.email}", style: AppStyles.kTextStyle14,),
                      AppSize.h10.ph,*/
                    ],
                  ),
                ),
              ),
              AppSize.h10.ph,
              Divider(
                color: AppColors.kBlackColor,
              ),
              AppSize.h10.ph,

              ListTile(
                leading: Image.asset(Resources.return_order, height: 30.sp, color: AppColors.kMainColor,),
                title: Text('My Orders', style: AppStyles.kTextStyle16.copyWith(
                    color: AppColors.kBlackColor
                ),),
                onTap: () {
                  UI.pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => OrderPage()));
                },
              ),

              ListTile(
                leading: Image.asset(Resources.reviews, height: 30.sp, color: AppColors.kMainColor,),
                title: Text('My Feedback', style: AppStyles.kTextStyle16.copyWith(
                    color: AppColors.kBlackColor
                ),),
                onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(appBar: customAppBarWithoutBack(context, title: "My Feedback", isBack: true),
                     backgroundColor: AppColors.kWhiteColor,
                     body: Padding(
                       padding: EdgeInsets.all(15.0.sp),
                       child: ShowRatingsPage(salonId: PrefManager.currentUser?.id ?? "",isFromDrwaer: true,),
                     ))));
                },
              ),


              ListTile(
                leading: Image.asset(Resources.address, height: 30.sp, color: AppColors.kMainColor,),
                title: Text('My Addresses', style: AppStyles.kTextStyle16.copyWith(
                    color: AppColors.kBlackColor
                ),),
                onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => const ListAdressesWidget()));
                },
              ),

              /*ListTile(
                leading: Image.asset(Resources.user, height: 23.sp,width: 23.sp, color: AppColors.kBlackColor,),
                title: Text('Change Password', style: AppStyles.kTextStyle16.copyWith(
                    color: AppColors.kBlackColor
                ),),
                onTap: () {
                  UI.pop();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const ChangePasswordPage();
                    },
                  );
                },
              ),*/

              ListTile(
                leading: Image.asset(Resources.user, height: 30.sp, color: AppColors.kMainColor,),
                title: Text('Logout', style: AppStyles.kTextStyle16.copyWith(
                    color: AppColors.kRedColor
                ),),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Note'),
                        content: Text('Do you want to logout'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              UI.pop();
                            },
                            child: Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              PrefManager.clearUserData();
                              UI.pushWithRemove(AppRoutes.toggleBetweenUsers);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          );
        }
      ),
    );
  }
}
