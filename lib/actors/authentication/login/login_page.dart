import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/authentication/user_viewModel.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/custom_field.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';

class LoginPage extends StatefulWidget {
  final int type;
  const LoginPage({Key? key, required this.type}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserViewModel viewModel = UserViewModel();
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppColors.kMainColor,
        child: Form(
          key: viewModel.formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset(
                      Resources.rectangle3,
                      height: MediaQuery.of(context).size.height*.5,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      right: 10,
                      child: Image.asset(
                        Resources.loginLogo,
                        height: 200.sp,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 10,
                      right: 10,
                      child: Image.asset(
                        Resources.beautiful_girl,
                        height: MediaQuery.of(context).size.height*.3,
                      ),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height*.1,
                      left: 10,
                      right: 10,
                      child: Image.asset(
                        Resources.image_at_91,
                      ),
                    ),
                  ],
                ),
                AppSize.h10.ph, // Space between the logo and the title
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.sp, horizontal: 40.sp),
                  child: Column(
                    children: [
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
                      AppSize.h40.ph,
                      CustomButton(
                          title: "Login",
                          onClick: (){
                            viewModel.login();
                          }
                      ),
                      AppSize.h40.ph,
                      widget.type == 1? SizedBox(): InkWell(
                        onTap: () => widget.type == 1? UI.push(AppRoutes.adminRegisterPage) : widget.type == 3?  UI.push(AppRoutes.salonRegisterPage): UI.push(AppRoutes.customerRegisterPage),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("A new member", style: AppStyles.kTextStyle16.copyWith(
                              color: AppColors.kBlackColor,
                            )),
                            Text(" Sign up", style: AppStyles.kTextStyle18.copyWith(
                                color: AppColors.kBlackColor,
                                fontWeight: FontWeight.bold
                            ),),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
