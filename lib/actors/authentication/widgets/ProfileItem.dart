import 'package:flutter/material.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';

class ProfileItem extends StatelessWidget {
  final TextStyle style;
  final String? value;
  final String? title;
  const ProfileItem(this.style, this.value, {Key? key, this.title, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(value == null){
      return AppSize.h1.ph;
    }else{
      return Row(
        children: [
          Text(
            title ?? "",
            style: AppStyles.kTextStyleHeader18.copyWith(
              color: AppColors.kButtonColor
            ),
          ),
          AppSize.h10.pw,
          Text(
            value ?? 'Not available',
            style: AppStyles.kTextStyle16.copyWith(
                color: AppColors.kButtonColor
            ),
          ),
        ],
      );
    }
  }
}
