import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/features/authentication/user_viewModel.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/custom_dropdown.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class AvailabilityPage extends StatefulWidget {
  final User? user;
  const AvailabilityPage({Key? key, this.user}) : super(key: key);

  @override
  State<AvailabilityPage> createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  UserViewModel viewModel = UserViewModel();
  bool isHidden = true;

  @override
  void initState() {
    if(widget.user != null){
      viewModel.fillSalonData(widget.user!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWithoutBack(context, title: "Availability"),
      backgroundColor: AppColors.kWhiteColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20.sp),
        alignment: Alignment.center,
        child: Form(
          key: viewModel.formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppSize.h20.ph,
                BlocBuilder<GenericCubit<String?>, GenericCubitState<String?>>(
                    bloc: viewModel.fromTime,
                    builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.kMainColor)
                        ),
                        child: CustomDropdown(
                            value: state.data,
                            hint: "From",
                            items: viewModel.timeSlots.map((e){
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e, style:  AppStyles.kTextStyleHeader14.copyWith(
                                  color: AppColors.kBlackColor,
                                ),),
                              );
                            }).toList(),
                            onChange: (e){
                              viewModel.fromTime.onUpdateData(e);
                            }
                        ),
                      );
                    }
                ),
                AppSize.h20.ph,
                BlocBuilder<GenericCubit<String?>, GenericCubitState<String?>>(
                    bloc: viewModel.toTime,
                    builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.kMainColor)
                        ),
                        child: CustomDropdown(
                            value: state.data,
                            hint: "To",
                            items: viewModel.timeSlots.map((e){
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e, style:  AppStyles.kTextStyleHeader14.copyWith(
                                  color: AppColors.kBlackColor,
                                ),),
                              );
                            }).toList(),
                            onChange: (e){
                              viewModel.toTime.onUpdateData(e);
                            }
                        ),
                      );
                    }
                ),
                AppSize.h100.ph,
                BlocBuilder<GenericCubit<bool>,
                    GenericCubitState<bool>>(
                    bloc: viewModel.loading,
                    builder: (context, state) {
                      return state.data
                          ? const Loading()
                          : CustomButton(
                          title: "Done",
                          btnColor: AppColors.kBlackColor,
                          width: 120.sp,
                          onClick: (){
                            viewModel.salonUpdateProfile(widget.user!.id!);
                          }
                      );
                    }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
