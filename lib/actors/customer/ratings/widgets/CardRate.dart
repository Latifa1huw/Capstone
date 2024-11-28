import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/resources.dart';

class CardRate extends StatelessWidget {
  const CardRate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: AppColors.kWhiteColor,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none
      ),
      child: Padding(
        padding: EdgeInsets.all(10.sp),
        child: Row(
          children: [
            // Service Image
            ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Image.asset(
               Resources.slider,
                height: 40.sp,
                width: 40.sp,
                fit: BoxFit.cover,
              ),
            ),
            AppSize.h10.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Ahmed Fathy",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: List.generate(5, (_){
                          return Icon(Icons.star_border_purple500, color: AppColors.kYollowColor580,);
                        }),
                      )
                    ],
                  ),
                  Text(
                    "Good  Makup artist showing",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.kGreyColor
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
