import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/features/customer/cart/cart_viewModel.dart';
import 'package:template/features/customer/shop/widgets/AppointmentConfirmation.dart';
import 'package:template/features/customer/shop/widgets/SelectLocation.dart';
import 'package:template/features/salon/coupons/coupon_viewModel.dart';
import 'package:template/features/salon/coupons/models/coupon.dart';
import 'package:template/features/salon/services/models/service.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/custom_field.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';
import 'package:provider/provider.dart';

class SelectPayment extends StatefulWidget {
  final User salon;
  final CartViewModel cartViewModel;
  const SelectPayment({Key? key, required this.salon, required this.cartViewModel}) : super(key: key);

  @override
  State<SelectPayment> createState() => _SelectPaymentState();
}

class _SelectPaymentState extends State<SelectPayment> {
  CouponViewModel couponViewModel = CouponViewModel();

  @override
  void initState() {
    couponViewModel.getAllCoupons();
    widget.cartViewModel.calcTotalServicePrice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWithoutBack(context, title: "Payment"),
      body: Container(
        padding: EdgeInsets.all(10.sp),
        child: SingleChildScrollView(
          child: Form(
            key: widget.cartViewModel.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Services", style: AppStyles.kTextStyleHeader20,textAlign: TextAlign.start,),
                  ],
                ),

                const Divider(
                  color: AppColors.kGreyColor,
                  thickness: 2,
                ),

                BlocBuilder<GenericCubit<List<Service>?>,
                    GenericCubitState<List<Service>?>>(
                    bloc: widget.cartViewModel.selectServices,
                    builder: (context, state) {
                      return state is GenericLoadingState ? const Loading() :
                      (state.data?.isEmpty ?? false) ? const EmptyData(color: AppColors.kWhiteColor,):
                      buildSelectedServices(state.data ?? []);
                    }
                ),
                AppSize.h20.ph,
                Row(
                  children: [
                    Text("Payment Methods", style: AppStyles.kTextStyleHeader20,textAlign: TextAlign.start,),
                  ],
                ),

                const Divider(
                  color: AppColors.kGreyColor,
                  thickness: 2,
                ),
                AppSize.h10.ph,
                BlocBuilder<GenericCubit<int>,
                    GenericCubitState<int>>(
                    bloc: widget.cartViewModel.selectedPayment,
                    builder: (context, state) {
                      return state is GenericLoadingState ?
                      const Loading() :
                      Column(
                      children: [
                        InkWell(
                          onTap: (){
                            widget.cartViewModel.selectedPayment.onUpdateData(0);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0.sp),
                            child: Card(
                              color: AppColors.kWhiteColor,
                              child: ListTile(
                                leading: Image.asset(Resources.credit_card, height: 20.sp,),
                                title: Text("Credit card", style: AppStyles.kTextStyleHeader20.copyWith(
                                  color: AppColors.kBlackColor
                                ),),
                                trailing: state.data == 0? Image.asset(Resources.done, height: 30.sp,) : Image.asset(Resources.undone, height: 30.sp,),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            widget.cartViewModel.selectedPayment.onUpdateData(1);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0.sp),
                            child: Card(
                              color: AppColors.kWhiteColor,
                              child: ListTile(
                                leading: Image.asset(Resources.apple_pay, height: 20.sp,),
                                title: Text("Apple pay", style: AppStyles.kTextStyleHeader20.copyWith(
                                  color: AppColors.kBlackColor
                                ),),
                                trailing: state.data == 1? Image.asset(Resources.done, height: 30.sp,) : Image.asset(Resources.undone, height: 30.sp,),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            widget.cartViewModel.selectedPayment.onUpdateData(2);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0.sp),
                            child: Card(
                              color: AppColors.kWhiteColor,
                              child: ListTile(
                                leading: Image.asset(Resources.STCPay, height: 20.sp,),
                                title: Text("STC Pay", style: AppStyles.kTextStyleHeader20.copyWith(
                                  color: AppColors.kBlackColor
                                ),),
                                trailing: state.data == 2? Image.asset(Resources.done, height: 30.sp,) : Image.asset(Resources.undone, height: 30.sp,),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                ),
                AppSize.h10.ph,

                CustomField(
                    controller: widget.cartViewModel.sa,
                  borderRaduis: 10,
                  hint: "Card number 4111 1111 1111 1111",
                  validator: widget.cartViewModel.validateCardNumber,
                  keyboardType: TextInputType.numberWithOptions(signed: false),
                ),

                AppSize.h10.ph,

                Row(
                  children: [
                    Expanded(
                      child: CustomField(
                        controller: widget.cartViewModel.cvc,
                        borderRaduis: 10,
                        hint: "CVC",
                        validator: widget.cartViewModel.validateCvc,
                        keyboardType: TextInputType.numberWithOptions(signed: false),
                      ),
                    ),
                    AppSize.h10.pw,
                    Expanded(
                      child: CustomField(
                        controller: widget.cartViewModel.years_month,
                        borderRaduis: 10,
                        hint: "Years/Month (24/6)",
                        validator: widget.cartViewModel.validateCombinedInput,
                        // keyboardType: TextInputType.numberWithOptions(signed: false),
                      ),
                    ),
                  ],
                ),

                AppSize.h20.ph,
                const Divider(
                  color: AppColors.kGreyColor,
                  thickness: 2,
                ),
                Text("Discount Code?", style: AppStyles.kTextStyleHeader20,),
                CustomField(
                  controller: widget.cartViewModel.discount,
                  borderRaduis: 10,
                  hint: "Discount",
                  suffix: Padding(
                    padding: EdgeInsets.all(5.0.sp),
                    child:  BlocBuilder<GenericCubit<List<Coupon>>,
                        GenericCubitState<List<Coupon>>>(
                        bloc: couponViewModel.allCoupons,
                        builder: (context, state) {
                          return state is GenericLoadingState ? const Loading()
                        : CustomButton(
                          title: "Search",
                          width: 20.sp,
                          onClick: (){
                            widget.cartViewModel.checkCoupon(state.data, widget.cartViewModel.discount.text);
                          },
                        );
                      }
                    ),
                  ),
                ),

                AppSize.h10.ph,

                Text("The Bill", style: AppStyles.kTextStyleHeader20,),
                BlocBuilder<GenericCubit<double>,
                    GenericCubitState<double>>(
                    bloc: widget.cartViewModel.totalServicePriceWithoutDiscount,
                    builder: (context, state) {
                      return state is GenericLoadingState ? const Loading() :
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Subtotal", style: AppStyles.kTextStyle16.copyWith(
                          color: AppColors.kMainColor,
                          fontWeight: FontWeight.bold
                        )),
                        Text("${state.data} SR", style: AppStyles.kTextStyle16.copyWith(
                          color: AppColors.kMainColor,
                          fontWeight: FontWeight.bold
                        )),
                      ],
                    );
                  }
                ),

                BlocBuilder<GenericCubit<Coupon?>,
                    GenericCubitState<Coupon?>>(
                    bloc: widget.cartViewModel.selectedCoupon,
                    builder: (context, state) {
                      return state is GenericLoadingState ? const Loading() :
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Discount", style: AppStyles.kTextStyle16.copyWith(
                          color: AppColors.kMainColor,
                          fontWeight: FontWeight.bold
                        )),
                        Text("${state.data?.discountPrecentage?? "0"} SR", style: AppStyles.kTextStyle16.copyWith(
                          color: AppColors.kMainColor,
                          fontWeight: FontWeight.bold
                        )),
                      ],
                    );
                  }
                ),

                BlocBuilder<GenericCubit<double>,
                    GenericCubitState<double>>(
                    bloc: widget.cartViewModel.totalServicePrice,
                    builder: (context, state) {
                      return state is GenericLoadingState ? const Loading() :
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total", style: AppStyles.kTextStyle16.copyWith(
                          fontWeight: FontWeight.bold
                        )),
                        Text("${state.data} SR", style: AppStyles.kTextStyle16.copyWith(
                          color: AppColors.kMainColor,
                          fontWeight: FontWeight.bold
                        )),
                      ],
                    );
                  }
                ),

                AppSize.h20.ph,
                CustomButton(
                  title: "Appointment Confirmation",
                  onClick: (){
                    if(!(widget.cartViewModel.formKey.currentState?.validate() ?? false)) {
                      return;
                    } else {
                      widget.cartViewModel.orderCheckOut(widget.salon);
                    }
                  },
                ),
                AppSize.h20.ph
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildSelectedServices(List<Service> services){
    return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(10.sp),
        itemBuilder: (context, index){
          var service = services.elementAt(index);
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.kMainColor)
            ),
            padding: EdgeInsets.all(10.sp),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service.name ?? "", style: AppStyles.kTextStyleHeader18,),
                    AppSize.h10.ph,
                    Row(
                      children: [
                        Icon(Icons.calendar_month),
                        Text(service.availability ?? "", style: AppStyles.kTextStyle16,),
                      ],
                    ),
                    AppSize.h5.ph,
                    Row(
                      children: [
                        Icon(Icons.timer_outlined),
                        Text(service.availability ?? "", style: AppStyles.kTextStyle14),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Text(service.price.toString() + " SR", style: AppStyles.kTextStyleHeader18)
              ],
            ),
          );
        },
        separatorBuilder: (context, index){
          return AppSize.h10.ph;
        },
        itemCount: services.length
    );
  }

}
