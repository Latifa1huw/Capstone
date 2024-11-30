import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/salon/coupons/coupon_viewModel.dart';
import 'package:template/features/salon/coupons/models/coupon.dart';
import 'package:template/features/salon/coupons/widgets/CouponWidget.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class CouponPage extends StatefulWidget {
  const CouponPage({Key? key}) : super(key: key);

  @override
  State<CouponPage> createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  CouponViewModel viewModel = CouponViewModel();

  @override
  void initState() {
    viewModel.getAllCouponsForEveryUserID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWithoutBack(context, title: "Coupons"),
      body: Padding(
        padding: EdgeInsets.only(bottom: 70.0.sp),
        child: BlocBuilder<GenericCubit<List<Coupon>>,
            GenericCubitState<List<Coupon>>>(
            bloc: viewModel.coupons,
            builder: (context, state) {
              return state is GenericLoadingState ? const Loading()
                  : Padding(
                padding: EdgeInsets.all(10.0.sp),
                child: state.data.isEmpty ? const EmptyData():
                ListView.builder(
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    final coupon = state.data[index];
                    return Card(
                      color: AppColors.kWhiteColor,
                      margin: EdgeInsets.symmetric(vertical: 5.sp),
                      elevation: 4,
                      child: CouponWidget(coupon: coupon, viewModel: viewModel,),
                    );
                  },
                ),
              );
            }
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 70.0.sp),
        child: InkWell(
          onTap: () => UI.push(AppRoutes.addCouponPage, arguments: [viewModel]),
          child: Icon(
            Icons.add_circle_rounded,
            color: AppColors.kBlackColor,
            size: 60.sp,
          ),
        ),
      ),
    );
  }
}
