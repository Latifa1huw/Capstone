import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDropdown extends StatelessWidget {
  final Widget? icon;
  final Widget? hintObject;
  final String? hint;
  final List<DropdownMenuItem> items;
  final Function(dynamic) onChange;
  final dynamic value;
  final TextStyle? textStyle;

  const CustomDropdown(
      {required this.items,
      required this.onChange,
      this.icon,
      this.hintObject,
      this.hint,
      this.value,
      this.textStyle,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.h45,
      decoration: BoxDecoration(
        color: AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.w15,
        vertical: AppSize.h10,
      ),
      child: Center(
        child: DropdownButton(
          isExpanded: true,
          underline: Container(),
          dropdownColor: Colors.white,
          icon: icon ?? SvgPicture.asset(Resources.dropdown),
          style: textStyle ??
              AppStyles.kTextStyleHeader14.copyWith(
                color: AppColors.kGreyColor,
              ),
          hint: hintObject ??
              Text(
                hint ?? "",
                style: AppStyles.kTextStyle14.copyWith(
                  color: AppColors.kGreyColor,
                ),
              ),
          value: value,
          items: items,
          onChanged: onChange,
        ),
      ),
    );
  }
}
