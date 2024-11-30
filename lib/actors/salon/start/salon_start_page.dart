
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/authentication/profile_page.dart';
import 'package:template/features/customer/home/home_page.dart';
import 'package:template/features/customer/orders/order_page.dart';
import 'package:template/features/customer/ratings/show_ratings_page.dart';
import 'package:template/features/salon/coupons/coupon_page.dart';
import 'package:template/features/salon/profile/Salon_Profile.dart';
import 'package:template/features/salon/services/service_page.dart';
import 'package:template/features/salon/start/salon_start_viewModel.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';


GlobalKey<ScaffoldState> startScaffoldKey = GlobalKey();

class SalonStartPage extends StatefulWidget {
  const SalonStartPage({Key? key}) : super(key: key);

  @override
  State<SalonStartPage> createState() => _SalonStartPageState();
}

class _SalonStartPageState extends State<SalonStartPage> {
  SalonStartViewModel startViewModel = SalonStartViewModel();

  List<Widget> pages = [];

  @override
  void initState() {
    pages = [
      const ServicePage(),
      const OrderPage(),
      const CouponPage(),
      Scaffold(appBar: customAppBarWithoutBack(context, title: "My Reviews", isBack: false),
          backgroundColor: AppColors.kWhiteColor,
          body: Padding(
            padding: EdgeInsets.all(15.0.sp),
            child: ShowRatingsPage(salonId: PrefManager.currentUser?.id ?? "",),
          )),
      const SalonProfile()
    ];
    super.initState();
  }


  late NavigatorState _navigator;

  @override
  void didChangeDependencies() {
    _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  NavigatorState of(BuildContext context, {bool rootNavigator = false}) {
    NavigatorState? navigator;
    if (context is StatefulElement && context.state is NavigatorState) {
      navigator = context.state as NavigatorState;
    }
    if (rootNavigator) {
      navigator =
          context.findRootAncestorStateOfType<NavigatorState>() ?? navigator;
    } else {
      navigator =
          navigator ?? context.findAncestorStateOfType<NavigatorState>();
    }
    return navigator!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<int>, GenericCubitState<int>>(
      bloc: startViewModel.currentPageCubit,
      builder: (context, state) {
        return Scaffold(
          key: startScaffoldKey,
          body: pages[state.data],
          backgroundColor: AppColors.kWhiteColor,
          bottomSheet: Container(
            height: AppSize.navBarHeight,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.kBackgroundColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: Material(
              shadowColor: AppColors.kWhiteColor,
              elevation: 100,
              color: AppColors.kMainColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildBottomNavItem(Resources.settings, "Services", 0, state.data),
                    buildBottomNavItem(Resources.clock, "Orders", 1, state.data),
                    buildBottomNavItem(Resources.coupon, "Coupons", 2, state.data),
                    buildBottomNavItem(Resources.reviews, "Reviews", 3, state.data),
                    buildBottomNavItem(Resources.user, "Profile", 4, state.data)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildBottomNavItem(String icon, String label, int index, int currentState) {
    return InkWell(
      onTap: () {
        startViewModel.currentPageCubit.onUpdateData(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon, color: currentState == index ? AppColors.kWhiteColor : AppColors.kBlackColor, height: 25.sp,width: 25.sp,),
          AppSize.h5.ph,
          Text(
            label,
            style: AppStyles.kTextStyle12.copyWith(
              color: currentState == index ? AppColors.kWhiteColor : AppColors.kBlackColor,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}