import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String? title;
  final String? hint;
  final Color? fillColor;
  final TextEditingController controller;
  final int? maxLines;
  // final int? minLines;
  final String? Function(String?)? validator;
  final Widget? prefix;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextStyle? hintStyle;
  final bool readOnly;
  final bool obsecure;
  final InputBorder? enabledBorder;
  final Function(String?)? onChange;
  final Function()? onTap;
  final double? borderRaduis;
  final FocusNode? focusNode;

  const CustomField(
      {required this.controller,
      this.title,
      this.hint,
      this.fillColor,
      this.maxLines = 1,
      this.validator,
      this.prefix,
      // this.minLines = 1,
      this.suffix,
      this.keyboardType,
      this.hintStyle,
      this.readOnly = false,
      this.obsecure = false,
      this.enabledBorder,
      this.onChange,
      this.onTap,
      this.focusNode,
      this.borderRaduis = 30,
      Key? key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obsecure,
      readOnly: readOnly,
      controller: controller,
      maxLines: maxLines,
      // minLines: minLines,
      focusNode: focusNode,
      validator: validator,
      onChanged: onChange,
      keyboardType: keyboardType,
      textAlign: TextAlign.start,
      onTap: onTap,
      decoration: InputDecoration(
          hintText: hint ?? "",
          hintStyle: hintStyle ??
              AppStyles.kTextStyleHeader14.copyWith(
                color: AppColors.kGreyColor,
              ),
          fillColor: fillColor ?? AppColors.kWhiteColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRaduis!),
            borderSide: const BorderSide(color: AppColors.kGreyColor),
          ),
          enabledBorder: enabledBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRaduis!),
                borderSide: const BorderSide(color: AppColors.kGreyColor),
              ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRaduis!),
            borderSide: const BorderSide(color: AppColors.kGreyColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRaduis!),
            borderSide: const BorderSide(color: AppColors.kRedColor),
          ),
          errorStyle: AppStyles.kTextStyleHeader12.copyWith(
            color: AppColors.redColor757,
          ),
          prefixIcon: prefix,
          suffixIcon: suffix,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSize.w10,
            vertical: AppSize.h10,
          )),
    );
  }
}
