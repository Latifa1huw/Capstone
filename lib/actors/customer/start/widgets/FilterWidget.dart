import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/customer/start/customer_start_viewModel.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/util/ui.dart';

class FilterWidget extends StatefulWidget {
  final CustomerStartViewModel viewModel;
  const FilterWidget({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  bool low_to_high = false;
  bool high_to_low = false;
  bool from_rate = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.h350,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.kWhiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSize.r30),
          topRight: Radius.circular(AppSize.r30),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 20.sp),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Sort", style: AppStyles.kTextStyle18,),
              InkWell(
                  onTap: () => UI.pop(),
                  child: Icon(Icons.clear, size: 30.sp,))
            ],
          ),
          AppSize.h30.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  RotatedBox(
                      quarterTurns: 3,
                      child: Icon(Icons.arrow_forward, size: 30.sp,)),
                  AppSize.h5.pw,
                  Text("Price - Low to High", style: AppStyles.kTextStyle18,),
                ],
              ),
              InkWell(
                  onTap: (){
                   setState(() {
                     low_to_high = true;
                     high_to_low = false;
                     from_rate = false;
                   });

                   widget.viewModel.getAllSalonIsFilterLowToHigh(low_to_high);
                  },
                  child: Icon(low_to_high ? Icons.radio_button_on: Icons.radio_button_off, size: 30.sp,))
            ],
          ),
          AppSize.h20.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  RotatedBox(
                      quarterTurns: 1,
                      child: Icon(Icons.arrow_forward, size: 30.sp,)),
                  AppSize.h5.pw,
                  Text("Price - High to Low", style: AppStyles.kTextStyle18,),
                ],
              ),
              InkWell(
                  onTap: (){
                   setState(() {
                     low_to_high = false;
                     high_to_low = true;
                     from_rate = false;
                   });
                   widget.viewModel.getAllSalonIsFilterLowToHigh(low_to_high);
                  },
                  child: Icon(high_to_low ? Icons.radio_button_on: Icons.radio_button_off, size: 30.sp,))
            ],
          ),
          AppSize.h20.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.star_rate_outlined, size: 30.sp,),
                  AppSize.h5.pw,
                  Text("Ratings", style: AppStyles.kTextStyle18,),
                ],
              ),
              InkWell(
                  onTap: (){
                   setState(() {
                     low_to_high = false;
                     high_to_low = false;
                     from_rate = true;
                   });
                   widget.viewModel.getAllSalonIsFilterRate();
                  },
                  child: Icon(from_rate ? Icons.radio_button_on: Icons.radio_button_off, size: 30.sp,))
            ],
          ),

        ],
      ),
    );
  }
}
