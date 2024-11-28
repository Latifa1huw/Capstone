import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/customer/cart/cart_viewModel.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/features/customer/ratings/show_ratings_page.dart';
import 'package:template/features/customer/shop/widgets/SelectedCategoryPage.dart';
import 'package:template/features/customer/shop/widgets/calendar_page.dart';
import 'package:template/features/customer/shop/widgets/selected_service_page.dart';
import 'package:template/features/salon/services/models/service.dart';
import 'package:template/features/salon/services/service_viewModel.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class ShopInterface extends StatefulWidget {
  final User salon;
  const ShopInterface({Key? key, required this.salon}) : super(key: key);

  @override
  State<ShopInterface> createState() => _ShopInterfaceState();
}

class _ShopInterfaceState extends State<ShopInterface> {
  ServiceViewModel viewModel = ServiceViewModel();
  CartViewModel cartViewModel = CartViewModel();

  @override
  void initState() {
    // viewModel.getServicesByUserID(widget.salon.id ?? "");

    viewModel.getServicesByCategoryAndSalonId(viewModel.categories.first, widget.salon.id ?? "");
    super.initState();
  }

  bool isService = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWithoutBack(context, title: widget.salon.name),
      body: Container(
        padding: EdgeInsets.all(10.sp),
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap:  () {
                    setState(() {
                      isService = true; // Update selected category
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: isService?
                            AppColors.kMainColor :
                            AppColors.kWhiteColor, width: 2)
                        )
                    ),
                    margin: EdgeInsets.all(5.sp),
                    padding: EdgeInsets.all(5.sp),
                    child: Text("Services", style: AppStyles.kTextStyleHeader16.copyWith(
                        color: AppColors.kMainColor
                    ),
                    ),
                  ),
                ),

                InkWell(
                  onTap:  () {
                    setState(() {
                      isService = false; // Update selected category
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: !isService?
                            AppColors.kMainColor :
                            AppColors.kWhiteColor, width: 2)
                        )
                    ),
                    margin: EdgeInsets.all(5.sp),
                    padding: EdgeInsets.all(5.sp),
                    child: Text("Reviews", style: AppStyles.kTextStyleHeader16.copyWith(
                        color: AppColors.kMainColor
                    ),
                    ),
                  ),
                ),
              ],
            ),


            isService ?
                // for services
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select service',
                          style: AppStyles.kTextStyleHeader18,
                        ),
                        const Divider(
                          color: AppColors.kBlackColor,
                          height: 2,
                        ),
                      ],
                    ),
                  ),
                  AppSize.h10.ph,
                  Container(
                      height: 200.sp,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: AppColors.kMainColor,
                          borderRadius: BorderRadius.circular(30)
                      ),
                      padding: EdgeInsets.all(10.0.sp),
                      child: SelectedCategoryPage(cartViewModel: cartViewModel, viewModel: viewModel, salon: widget.salon,)),
              
                  AppSize.h20.ph,
              
                  BlocBuilder<GenericCubit<String?>, GenericCubitState<String?>>(
                      bloc: cartViewModel.selectCategoryServices,
                      builder: (context, state) {
                        return Row(
                          children: [
                            Text(
                              state.data ?? "",
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      }
                  ),
                  Divider(),
              
                  AppSize.h10.ph,
                  BlocBuilder<GenericCubit<List<Service>>,
                      GenericCubitState<List<Service>>>(
                      bloc: viewModel.services,
                      builder: (context, state) {
                        return state is GenericLoadingState ? const Loading() :
                        state.data.isEmpty ? const EmptyData(color: AppColors.kGreyColor,):
                        SelectedServicePage(services: state.data, cartViewModel: cartViewModel,);
                    }
                  ),
                  Divider(),
                  AppSize.h20.ph,
                ],
              ),
            )
            // for reviews
            : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Salon Ratings',
                        style: AppStyles.kTextStyleHeader18,
                      ),
                      const Divider(
                        color: AppColors.kBlackColor,
                        height: 2,
                      ),
                    ],
                  ),
                ),
                AppSize.h10.ph,
                ShowRatingsPage(salonId: widget.salon.id ?? "", isDelete: true)
              ],
            ),
            AppSize.h20.ph,
            isService ? CustomButton(
              title: "Next",
              width: 150.sp,
              onClick: (){
                if(cartViewModel.selectServices.state.data != null && (cartViewModel.selectServices.state.data?.isNotEmpty ?? false)) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => CalendarPage(
                            salon: widget.salon,
                            cartViewModel: cartViewModel,
                          )));
                }else{
                  UI.showMessage("Should select at least one service to complete");
                }
              },
            ): SizedBox(),
            AppSize.h20.ph
          ],
        ),
      ),
    );
  }
}
