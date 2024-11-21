import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/admin/all_services/all_service_page.dart';
import 'package:template/features/admin/users/list_users_viewModel.dart';
import 'package:template/features/admin/users/widgets/bookings_for_admin.dart';
import 'package:template/features/admin/users/widgets/reviews_for_admin.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/features/authentication/widgets/ProfileItem.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/custom_dropdown.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class UserDetailsPage extends StatefulWidget {
  final ListUsersViewModel viewModel;
  final User profile;
  const UserDetailsPage({Key? key, required this.profile, required this.viewModel}) : super(key: key);

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {

  List<String> titles = ["Profile", "Services", "Bookings", "Reviews"];
  List<bool> titlesAppear = [true, false, false, false];

  @override
  void initState() {
    widget.viewModel.status.onUpdateData(widget.profile.status ?? "Unblocked");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.profile.type == 2 ? Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kMainColor,
        centerTitle: true,
        title: Text(
          widget.profile.name ?? "",
          style: AppStyles.kTextStyleHeader20,
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 100.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.profile.profile_image != null ?
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  child: Image.network(
                    widget.profile.profile_image ?? "",
                    height: 300.sp,
                    width: double.infinity,
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
                padding: EdgeInsets.all(10.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileItem(AppStyles.kTextStyle18.copyWith(fontWeight: FontWeight.bold), widget.profile.name, title: "Full Name: ",),
                    ProfileItem(AppStyles.kTextStyle18.copyWith(fontWeight: FontWeight.bold), widget.profile.owner_name, title: "Owner name: ",),
                    ProfileItem(AppStyles.kTextStyle16, widget.profile.phone, title: "Phone: ",),
                    ProfileItem(AppStyles.kTextStyle14, widget.profile.account_type, title: "Account type: ",),
                    ProfileItem(AppStyles.kTextStyle14.copyWith(fontWeight: FontWeight.bold), widget.profile.email, title: "Email: ",),
                    ProfileItem(AppStyles.kTextStyle18, widget.profile.address, title: "Address",),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ):
    Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kMainColor,
        centerTitle: true,
        title: Text(
          widget.profile.name ?? "",
          style: AppStyles.kTextStyleHeader20,
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 100.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: List.generate(titles.length, (index){
                    return  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.sp),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            for(int i = 0; i< titlesAppear.length; i++){
                              titlesAppear[i] = false;
                              if(i == index){
                                titlesAppear[index] = true;
                              }
                            }
                            print(titlesAppear);
                          });
                        },
                        child: Container(
                          height: 40.sp,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: titlesAppear[index] ?
                                  BorderSide(color: AppColors.kBlackColor, width: 2): BorderSide.none
                              )
                          ),
                          alignment: Alignment.center,  // Center the text
                          child: Text(
                            titles[index],
                            style: AppStyles.kTextStyleHeader16.copyWith(
                                color: AppColors.kButtonColor
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              titlesAppear[0] ? buildProfile(): SizedBox(),
              titlesAppear[1] ? buildServices(): SizedBox(),
              titlesAppear[2] ? BookingsForAdmin(salon: widget.profile,): SizedBox(),
              titlesAppear[3] ? ReviewsForAdmin(salon: widget.profile,): SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  buildProfile(){
    return Column(
      children: [
        widget.profile.profile_image != null ?
        ClipRRect(
            borderRadius: BorderRadius.circular(90),
            child: Image.network(
              widget.profile.profile_image ?? "",
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
          padding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileItem(AppStyles.kTextStyle18.copyWith(fontWeight: FontWeight.bold), widget.profile.name, title: "Salon Name: ",),
              // ProfileItem(AppStyles.kTextStyle18.copyWith(fontWeight: FontWeight.bold), widget.profile.owner_name, title: "Owner name: ",),
              ProfileItem(AppStyles.kTextStyle16, widget.profile.phone, title: "Phone: ",),
              ProfileItem(AppStyles.kTextStyle14, widget.profile.account_type, title: "Account type: ",),
              ProfileItem(AppStyles.kTextStyle14.copyWith(fontWeight: FontWeight.bold), widget.profile.email, title: "Email: ",),
              // ProfileItem(AppStyles.kTextStyle18, widget.profile.address, title: "Address",),

              AppSize.h100.ph,
            ],
          ),
        ),
        BlocBuilder<GenericCubit<bool>, GenericCubitState<bool>>(
            bloc: widget.viewModel.loading,
            builder: (context, state) {
              return state.data ?
              Loading():
              CustomButton(
                  title: widget.profile.status == "Blocked" ? "Unblocked": "Blocked",
                  width: 150.sp,
                  btnColor: AppColors.kBlackColor,
                  onClick: (){
                    widget.viewModel.status.onUpdateData(widget.profile.status == "Blocked" ? "Unblocked": "Blocked");
                    widget.viewModel.blockSalon(widget.profile);
                  });
            }
        ),

      ],
    );
  }

  buildServices(){
    return AllServicePage(id: widget.profile.id ?? "",);
  }

}
