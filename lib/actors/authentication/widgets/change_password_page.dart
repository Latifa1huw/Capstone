import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/features/authentication/user_viewModel.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/custom_field.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/ui.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  UserViewModel viewModel = UserViewModel();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.kBackgroundColor,
      elevation: 100,
      // shadowColor: AppColors.kBlueColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppColors.kWhiteColor)),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: viewModel.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomField(
                controller: viewModel.currentPassword,
                obsecure: true,
                hint: "Password",
              ),
              AppSize.h20.ph,
              CustomField(
                controller: viewModel.newPassword,
                obsecure: true,
                hint: "New Password",
              ),
              AppSize.h20.ph,
              CustomField(
                controller: viewModel.newPasswordConfirmation,
                obsecure: true,
                hint: "New Password Confirmation",
              ),
            ],
          ),
        ),
      ),
      title: Text(
        'Change Password',
        textAlign: TextAlign.center,
        style: AppStyles.kTextStyle20
            .copyWith(color: AppColors.kMainColor, fontWeight: FontWeight.bold),
      ),
      actions: [
        TextButton(
          onPressed: () => UI.pop(),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            backgroundColor: Colors.grey.shade200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
          ),
        ),
        BlocBuilder<GenericCubit<bool>,
                GenericCubitState<bool>>(
            bloc: viewModel.loading,
            builder: (context, state) {
              return TextButton(
                onPressed: () {
                  viewModel.updatePassword();
                },
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: AppColors.kMainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: state.data
                    ? const SizedBox(width: 40, height: 25, child: Loading())
                    : Text(
                        'Update',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              );
            }),
      ],
    );
  }
}
