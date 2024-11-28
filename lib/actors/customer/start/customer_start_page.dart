
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/features/authentication/profile_page.dart';
import 'package:template/features/customer/home/home_page.dart';
import 'package:template/features/customer/start/widgets/AvailableSalons.dart';
import 'package:template/features/customer/offers/widgets/OfferIndicatorWidget.dart';
import 'package:template/features/customer/orders/order_page.dart';
import 'package:template/features/customer/start/customer_start_viewModel.dart';
import 'package:template/features/customer/start/widgets/CustomerEndDrawerWidget.dart';
import 'package:template/features/customer/start/widgets/FilterWidget.dart';
import 'package:template/features/salon/coupons/coupon_viewModel.dart';
import 'package:template/features/salon/coupons/models/coupon.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_field.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBar.dart';


GlobalKey<ScaffoldState> startScaffoldKey = GlobalKey();

class CustomerStartPage extends StatefulWidget {
  const CustomerStartPage({Key? key}) : super(key: key);

  @override
  State<CustomerStartPage> createState() => _CustomerStartPageState();
}

class _CustomerStartPageState extends State<CustomerStartPage> {
  CustomerStartViewModel viewModel = CustomerStartViewModel();
  CouponViewModel couponViewModel = CouponViewModel();

  final List<String> offerImages = [
    Resources.slider_bg,
    Resources.slider_bg,
    Resources.slider_bg
  ];

  int _index = 0;

  @override
  void initState() {
    viewModel.getAllSalonIsUnblocked();
    couponViewModel.getAllCoupons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomerEndDrawerWidget(),
      body: Container(
        padding: EdgeInsets.only(
          top: 20.sp
        ),
        child: Column(
          children: [
            Builder(
              builder: (context) {
                return customAppBar(context, ontTap: (){
                  Scaffold.of(context).openDrawer();
                });
              }
            ),
            AppSize.h20.ph,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomField(
                                  controller: viewModel.search,
                                  hint: "Search...",
                                  onChange: (input) {
                                    print(input);
                                    viewModel.serchOnSalons(input ?? "");
                                  },
                                  prefix: Padding(
                                    padding: EdgeInsets.all(8.0.sp),
                                    child: Image.asset(Resources.search, height: 20.sp,),
                                  ),
                                ),
                              ),
                              AppSize.h5.pw,
                              InkWell(
                                  onTap: (){
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(AppSize.r30),
                                          topRight: Radius.circular(AppSize.r30),
                                        ),
                                      ),
                                      builder: (_) => Container(
                                        height: AppSize.h350,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: AppColors.kWhiteColor,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(AppSize.r30),
                                            topRight: Radius.circular(AppSize.r30),
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                                        child: FilterWidget(viewModel: viewModel,)
                                      ),
                                    );
                                  },
                                  child: Image.asset(Resources.filter, height: 25,)),
                            ],
                          ),

                          AppSize.h20.ph,
                          // Available Offers Section
                          Text(
                            'Available Offers',
                            style: AppStyles.kTextStyleHeader18.copyWith(
                              color: AppColors.kWhiteColor
                            ),
                          ),
                          const Divider(
                            color: AppColors.kWhiteColor,
                            height: 2,
                          ),
                          AppSize.h10.ph,
                          // Special Offers Section (Slider)
                          BlocBuilder<GenericCubit<List<Coupon>>,
                              GenericCubitState<List<Coupon>>>(
                              bloc: couponViewModel.allCoupons,
                              builder: (context, state) {
                                return state is GenericLoadingState ? const SizedBox() :
                                CarouselSlider(
                                options: CarouselOptions(
                                    height: 150.sp,
                                    enlargeFactor: .2,
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    onPageChanged: (i,CarouselPageChangedReason? onPageChanged){
                                      setState(() {
                                        _index = i;
                                      });
                                    }
                                ),
                                items: state.data.map((coup) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: FadeInImage.assetNetwork(
                                              placeholder: Resources.slider_bg, // Local image shown while loading
                                              image: coup.salonData?.profile_image ?? "",
                                              width: MediaQuery.of(context).size.width,
                                              height: 150.sp,
                                              fit: BoxFit.fill,
                                              imageErrorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                return Image.asset(
                                                  Resources.slider_bg, // Fallback image if network image fails
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 150.sp,
                                                  fit: BoxFit.fill,
                                                );
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 20.sp,
                                            right: 40.sp,
                                            child: Column(
                                              children: [
                                                Text(
                                                  coup.salonData?.name?? "",
                                                  style: AppStyles.kTextStyleHeader22,
                                                ),
                                                AppSize.h10.ph,
                                                Text(
                                                  coup.code?? "",
                                                  style: AppStyles.kTextStyleHeader14,
                                                ),
                                                AppSize.h10.ph,
                                                Text(
                                                  "${coup.discountPrecentage}%",
                                                  style: AppStyles.kTextStyleHeader22,
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                }).toList(),
                              );
                            }
                          ),
                          AppSize.h10.ph,
                          BlocBuilder<GenericCubit<List<Coupon>>,
                              GenericCubitState<List<Coupon>>>(
                              bloc: couponViewModel.allCoupons,
                              builder: (context, state) {
                                return state is GenericLoadingState ? const SizedBox() :
                                OfferIndicatorWidget(offerImages: state.data.length, currentIndex: _index,);
                            }
                          ),

                          AppSize.h10.ph,
                          // Available Salons Section
                          Text(
                            'Available Salons',
                            style: AppStyles.kTextStyleHeader18.copyWith(
                                color: AppColors.kWhiteColor
                            ),
                          ),
                          const Divider(
                            color: AppColors.kWhiteColor,
                            height: 2,
                          ),
                        ],
                      ),
                    ),
                    // Salons List
                   BlocBuilder<GenericCubit<List<User>>, GenericCubitState<List<User>>>(
                        bloc: viewModel.searchSalonsResults,
                        builder:  (context, searchState) {
                          return searchState is GenericLoadingState ?
                          const Loading()
                              :
                          BlocBuilder<GenericCubit<List<User>>, GenericCubitState<List<User>>>(
                              bloc: viewModel.salons,
                              builder:  (context, state) {
                           return state is GenericLoadingState ? const Loading()
                               : AvailableSalons(viewModel: viewModel, salons: searchState.data.isEmpty ? state.data : searchState.data,);
                         }
                       );
                     }
                   ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      backgroundColor: AppColors.kMainColor,
    );
  }
}