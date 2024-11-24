import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/features/authentication/register/admin_register_page.dart';
import 'package:template/features/authentication/register/customer_register_page.dart';
import 'package:template/features/authentication/register/salon_register_page.dart';
import 'package:template/features/authentication/user_viewModel.dart';
import 'package:template/features/authentication/widgets/ProfileItem.dart';
import 'package:template/features/authentication/widgets/change_password_page.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserViewModel viewModel = UserViewModel();
  @override
  void initState() {
    viewModel.getUserById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      appBar: customAppBarWithoutBack(context, title: "Profile", isBack: false),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: BlocBuilder<GenericCubit<User>,
            GenericCubitState<User>>(
          bloc: viewModel.userCubit,
          builder: (context, state) {
            var profile = state.data;
            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 70.0.sp, top: 10.sp),
              child: Column(
                children: [
                  profile.profile_image == null || PrefManager.currentUser!.type == 2?
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child:  Image.asset(Resources.user,
                          height: 100.sp,
                          width: 100.sp,
                          fit: BoxFit.fill,
                        )
                    ),
                  ):
                  ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: Image.network(
                          profile.profile_image ?? "",
                        height: 100.sp,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                  ),
                  AppSize.h10.ph,
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        ProfileItem(AppStyles.kTextStyle18.copyWith(fontWeight: FontWeight.bold), profile.name, title: "Name: ",),
                        ProfileItem(AppStyles.kTextStyle16, profile.phone, title: "Phone: ",),
                        ProfileItem(AppStyles.kTextStyle14, profile.account_type, title: "Account type: ",),
                        ProfileItem(AppStyles.kTextStyle14.copyWith(fontWeight: FontWeight.bold), profile.email, title: "Email: ",),
                        ProfileItem(AppStyles.kTextStyle16.copyWith(fontWeight: FontWeight.bold), profile.status, title: "Status: ",),
                        AppSize.h40.ph,

                        CustomButton(title: "Update Profile",
                            width: 210.sp,
                            onClick: (){
                          if(PrefManager.currentUser?.type == 1) {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) {
                                      return AdminRegisterPage(
                                        user: profile,
                                      );
                                    }));
                          }

                          if(PrefManager.currentUser?.type == 2) {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) {
                                      return CustomerRegisterPage(
                                        user: profile,
                                      );
                                    }));
                          }
                          if(PrefManager.currentUser?.type == 3) {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) {
                                      return SalonRegisterPage(
                                        user: profile,
                                      );
                                    }));
                          }
                        }),
                        AppSize.h20.ph,
                        CustomButton(title: "Logout",
                            btnColor: AppColors.kRedColor,
                            width: 210.sp,
                            onClick: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirmation', style: AppStyles.kTextStyleHeader20,),
                                content: Text('Do you want to logout', style: AppStyles.kTextStyle20,),
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
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
