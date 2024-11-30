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
import 'package:template/features/salon/profile/AvailabilityPage.dart';
import 'package:template/features/salon/profile/ReportPage.dart';
import 'package:template/features/salon/profile/UpdateSalonWidget.dart';
import 'package:template/features/salon/salon_reports/salon_reports_page.dart';
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

class SalonProfile extends StatefulWidget {
  const SalonProfile({Key? key}) : super(key: key);

  @override
  State<SalonProfile> createState() => _SalonProfileState();
}

class _SalonProfileState extends State<SalonProfile> {
  UserViewModel viewModel = UserViewModel();
  @override
  void initState() {
    viewModel.getUserById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<GenericCubit<User>,
        GenericCubitState<User>>(
        bloc: viewModel.userCubit,
        builder: (context, state) {
          var profile = state.data;
          return Scaffold(
          // appBar: AppBar(),
          appBar: AppBar(
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
            automaticallyImplyLeading: false,
            leading: InkWell(
              onTap: (){

                final overlay = Overlay.of(context).context.findRenderObject();
                final overlayBox = overlay?.paintBounds;

                showMenu(
                  context: context,
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none
                  ),
                  position: RelativeRect.fromLTRB(
                    overlayBox!.left.toDouble(),
                    overlayBox.top.toDouble(),
                    overlayBox.right.toDouble(),
                    overlayBox.bottom.toDouble(),
                  ),
                  items: [
                    PopupMenuItem(
                      value: 0,
                      child: Text("Update Profile"),
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) {
                                  return UpdateSalonWidget(
                                    user: profile,
                                  );
                                }));
                    },),
                    PopupMenuItem(
                      value: 1,
                      child: const Text("Availability"),
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) {
                                  return AvailabilityPage(
                                    user: profile,
                                  );
                                }));
                    },),
                    PopupMenuItem(
                      value: 2,
                      child: const Text("Report"),
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) {
                                  return const SalonReportsPage();
                                }));
                    },),
                    PopupMenuItem(
                      value: 3,
                      child: const Text("Logout"),
                      onTap: (){
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
                    },),

                  ],
                ).then((value) {
                  // Handle menu selection
                });

              },
              child: Padding(
                padding: EdgeInsets.all(10.sp),
                child: Image.asset(Resources.list, height: 30.sp,),
              ),
            ),
            title: Text(
               'Profile',
              textAlign: TextAlign.center,
              style: AppStyles.kTextStyle22.copyWith(
                // color: AppColors.kWhiteColor,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 70.0.sp, top: 20.sp),
              child: Column(
                children: [
                  profile.profile_image != null ?
                  ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: Image.network(
                        profile.profile_image ?? "",
                        height: 100.sp,
                        width: 100.sp,
                        fit: BoxFit.fill,
                      )
                  ): Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child:  Image.asset(Resources.user,
                          height: 100.sp,
                          width: 100.sp,
                          fit: BoxFit.fill,
                        )
                    ),
                  ),
                  AppSize.h10.ph,
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        ProfileItem(AppStyles.kTextStyle18.copyWith(fontWeight: FontWeight.bold), profile.name, title: "Salon Name: ",),
                        // ProfileItem(AppStyles.kTextStyle18.copyWith(fontWeight: FontWeight.bold), profile.owner_name, title: "Owner name: ",),
                        ProfileItem(AppStyles.kTextStyle16, profile.phone, title: "Phone: ",),
                        ProfileItem(AppStyles.kTextStyle14, profile.account_type, title: "Account type: ",),
                        ProfileItem(AppStyles.kTextStyle14.copyWith(fontWeight: FontWeight.bold), profile.email, title: "Email: ",),
                        // ProfileItem(AppStyles.kTextStyle18, profile.address, title: "Address",),
                        ProfileItem(AppStyles.kTextStyle16.copyWith(fontWeight: FontWeight.bold), profile.status, title: "Status: ",),
                        AppSize.h20.ph,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
