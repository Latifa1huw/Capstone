import 'dart:io';

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
import 'package:template/shared/models/user_model.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/custom_dropdown.dart';
import 'package:template/shared/ui/componants/custom_field.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class UpdateSalonWidget extends StatefulWidget {
  final User? user;
  const UpdateSalonWidget({Key? key, this.user}) : super(key: key);

  @override
  State<UpdateSalonWidget> createState() => _UpdateSalonWidgetState();
}

class _UpdateSalonWidgetState extends State<UpdateSalonWidget> {
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
      appBar: customAppBarWithoutBack(context, title: "Profile"),
      backgroundColor: AppColors.kWhiteColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20.sp),
        child: Form(
          key: viewModel.formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10.sp),
            child: Column(
              children: [
                TextButton.icon(
                  onPressed:  viewModel.pickImage,
                  icon: const Icon(Icons.image),
                  label: Text('Select Salon Image', style: AppStyles.kTextStyle18,),
                ),
                BlocBuilder<GenericCubit<File?>, GenericCubitState<File?>>(
                    bloc: viewModel.profile_image,
                    builder: (s, state){
                      return state.data != null ?

                      ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: Image.file(
                            state.data!,
                            height: 100.sp,
                            width: 100.sp,
                            fit: BoxFit.fill,
                          )
                      ) :
                      ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: Image.asset(
                            Resources.user,
                            height: 100.sp,
                            width: 100.sp,
                            fit: BoxFit.fill,
                          )
                      );
                    }
                ),
                AppSize.h40.ph,
                CustomField(
                  controller: viewModel.name,
                  hint: "Name",
                  validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                ),
                // AppSize.h20.ph,
                // CustomField(
                //   controller: viewModel.owner_name,
                //   hint: "Owner name",
                //   validator: (value) => value!.isEmpty ? 'Please enter your owner name' : null,
                // ),
                AppSize.h20.ph,
                CustomField(
                  controller: viewModel.email,
                  hint: "Email",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!viewModel.isValidEmail(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                AppSize.h20.ph,
                CustomField(
                  controller: viewModel.password,
                  hint: "Password",
                  obsecure: isHidden,
                  suffix: IconButton(
                    icon: isHidden? Icon(Icons.visibility_off_outlined):
                    Icon(Icons.visibility_outlined),
                    onPressed: (){
                      setState(() {
                        isHidden =! isHidden;
                      });
                    },
                  ),
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter your password' : null,
                ),

                AppSize.h20.ph,
                CustomField(
                  controller: viewModel.confirm_password,
                  hint: "Confirm Password",
                  obsecure: isHidden,
                  suffix: IconButton(
                    icon: isHidden? Icon(Icons.visibility_off_outlined):
                    Icon(Icons.visibility_outlined),
                    onPressed: (){
                      setState(() {
                        isHidden =! isHidden;
                      });
                    },
                  ),
                  validator: (value) =>
                  value!.isEmpty || value != viewModel.password.text ?
                  'Please enter your Confirm password' : null,
                ),

                AppSize.h20.ph,
                CustomField(
                  controller: viewModel.phone,
                  hint: "Phone",
                  isPhone: true,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    } else if (!(viewModel.isValidPhoneNumberWithCountryCode(value))) {
                      return 'Enter a valid 10-digit phone number';
                    }
                    return null; // Valid
                  },
                  // validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
                ),
                AppSize.h20.ph,
                BlocBuilder<GenericCubit<String>, GenericCubitState<String>>(
                    bloc: viewModel.account_type,
                    builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.kMainColor)
                        ),
                        child: CustomDropdown(
                            value: state.data,
                            items: ["Salon", "Individual"].map((e){
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e, style:  AppStyles.kTextStyleHeader14.copyWith(
                                  color: AppColors.kBlackColor,
                                ),),
                              );
                            }).toList(),
                            onChange: (e){
                              viewModel.account_type.onUpdateData(e);
                            }
                        ),
                      );
                    }
                ),
                AppSize.h20.ph,
                /*BlocBuilder<GenericCubit<String>, GenericCubitState<String>>(
                    bloc: viewModel.status,
                    builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.kMainColor)
                        ),
                        child: CustomDropdown(
                            value: state.data,
                            items: ["Blocked", "Unblocked"].map((e){
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e, style:  AppStyles.kTextStyleHeader14.copyWith(
                                  color: AppColors.kBlackColor,
                                ),),
                              );
                            }).toList(),
                            onChange: (e){
                              viewModel.status.onUpdateData(e);
                            }
                        ),
                      );
                    }
                ),
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
                            hint: "Start From",
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
                            hint: "Start To",
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
              */ AppSize.h40.ph,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BlocBuilder<GenericCubit<bool>,
                        GenericCubitState<bool>>(
                        bloc: viewModel.loading,
                        builder: (context, state) {
                          return state.data
                              ? const Loading()
                              : CustomButton(
                              title: widget.user != null ? "Update": "Register",
                              btnColor: AppColors.kBlackColor,
                              width: 120.sp,
                              onClick: (){
                                if (widget.user != null){
                                  viewModel.salonUpdateProfile(widget.user!.id!);
                                }else{
                                  viewModel.salonRegister();
                                }
                              }
                          );
                        }
                    ),
                    CustomButton(
                        title: "Delete Account",
                        btnColor: AppColors.kRedColor,
                        width: 120.sp,
                        onClick: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Note'),
                                content: Text('Do you want to delete account'),
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
                        }
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
