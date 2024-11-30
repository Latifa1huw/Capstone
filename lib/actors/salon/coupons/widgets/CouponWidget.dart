import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:template/features/salon/coupons/coupon_viewModel.dart';
import 'package:template/features/salon/coupons/models/coupon.dart';
import 'package:template/features/salon/services/models/service.dart';
import 'package:template/features/salon/services/service_viewModel.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';

class CouponWidget extends StatelessWidget {
  const CouponWidget({Key? key, required this.coupon, required this.viewModel}) : super(key: key);
  final Coupon coupon;
  final CouponViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(6.0.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // coupon Name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              coupon.code ?? "",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    UI.push(AppRoutes.addCouponPage, arguments: [viewModel, coupon]);
                                  },
                                  icon: Icon(Icons.mode_edit_outline_outlined,
                                    size: 30.sp,
                                    color: AppColors.kMainColor,
                                  )
                              ),
                              BlocBuilder<GenericCubit<bool>,
                                  GenericCubitState<bool>>(
                                  bloc: viewModel.loading,
                                  builder: (context, state) {
                                    return state.data
                                        ? const Loading()
                                        :  IconButton(
                                      onPressed: () {
                                        viewModel.deleteCoupon(coupon.couponId ?? "");
                                      },
                                      icon: Icon(Icons.delete_outline_outlined,
                                        size: 30.sp,
                                        color: AppColors.kRedColor,
                                      )
                                  );
                                }
                              )
                            ],
                          )
                        ],
                      ),
                      // Coupon Description
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Usage Limt: ${coupon.usageLimt}",
                              style: AppStyles.kTextStyle18,
                            ),
                          ),
                          Text(
                            coupon.discountPrecentage.toString() + " %",
                            style: AppStyles.kTextStyleHeader20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Coupon from and until
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  "Valid From: ${DateFormat('yyyy-MM-dd').format(coupon.validFrom!)}",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  "Valid Until: ${DateFormat('yyyy-MM-dd').format(coupon.validUntil!)}",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        )
    );
  }
}
