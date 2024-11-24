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
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/custom_dropdown.dart';
import 'package:template/shared/ui/componants/custom_field.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';

class CustomerRegisterPage extends StatefulWidget {
  final User? user;
  const CustomerRegisterPage({Key? key, this.user}) : super(key: key);

  @override
  State<CustomerRegisterPage> createState() => _CustomerRegisterPageState();
}

class _CustomerRegisterPageState extends State<CustomerRegisterPage> {
  UserViewModel viewModel = UserViewModel();
  bool isHidden = true;

  @override
  void initState() {
    if(widget.user != null){
      viewModel.fillCustomerData(widget.user!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kMainColor,
      ),
      backgroundColor: AppColors.kMainColor,
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
                widget.user != null ? SizedBox():
                 Image.asset(
                  Resources.logoHome,
                  height: 150.sp, // Adjust the size of the logo as needed
                ),
                AppSize.h10.ph, // Space between the logo and the title
                Text(
                  widget.user != null ? "Update": "Registration",
                  style: AppStyles.kTextStyleHeader36.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.kBlackColor,
                  ),
                ),
                AppSize.h40.ph,
                CustomField(
                    controller: viewModel.name,
                  hint: "Name",
                  validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                ),
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
                widget.user == null? CustomField(
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
                ): const SizedBox(),
                widget.user == null? AppSize.h20.ph : const SizedBox(),
                CustomField(
                  controller: viewModel.phone,
                  hint: "Phone",
                  validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
                ),
                // AppSize.h20.ph,
                // CustomField(
                //   controller: viewModel.address,
                //   hint: "Address",
                //   validator: (value) =>
                //   value!.isEmpty ? 'Please enter your address' : null,
                // ),
               /* widget.user == null? AppSize.h1.ph : AppSize.h20.ph,
                widget.user == null? AppSize.h1.ph : TextButton.icon(
                  onPressed:  viewModel.pickImage,
                  icon: const Icon(Icons.image),
                  label: Text('Select Your Photo', style: AppStyles.kTextStyle18,),
                ),
                widget.user == null? AppSize.h1.ph :
                BlocBuilder<GenericCubit<File?>, GenericCubitState<File?>>(
                    bloc: viewModel.profile_image,
                    builder: (s, state){
                      return state.data != null ?
                      Container(height: 150,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey[300],
                          padding: EdgeInsets.all(10.sp),
                          child: Image.file(state.data!, height: 150, width: MediaQuery.of(context).size.width,)):
                      Container(height: 150,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey[300], child: Icon(Icons.image));
                    }
                ),*/
                AppSize.h40.ph,
                BlocBuilder<GenericCubit<bool>,
                    GenericCubitState<bool>>(
                    bloc: viewModel.loading,
                    builder: (context, state) {
                      return state.data
                          ? const Loading()
                          : CustomButton(
                        title: widget.user != null ? "Update": "Register",
                        btnColor: AppColors.kToggleBottomColor,
                        width: 220.sp,
                        onClick: (){
                          if (widget.user != null){
                            viewModel.customerUpdateProfile(widget.user!.id!);
                          }else{
                            viewModel.customerRegister();
                          }
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
