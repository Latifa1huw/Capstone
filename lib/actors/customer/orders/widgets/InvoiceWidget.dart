import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:template/features/customer/orders/models/order.dart';
import 'package:template/features/customer/orders/order_viewModel.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class InvoiceWidget extends StatelessWidget {
  final OrderItem order;
  InvoiceWidget({Key? key, required this.order}) : super(key: key);

  OrderViewModel viewModel = OrderViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWithoutBack(context, title: "Order Details"),
      body: Container(
        padding: EdgeInsets.only(top: 20.sp),
        child: Column(
          children: [
            Card(
              color: AppColors.kWhiteColor,
              margin: EdgeInsets.all(10.sp),
              child: Padding(
                padding: EdgeInsets.all(15.sp),
                child: Column(
                  children: [
                    Text("Thank you ${order.salonData?.name}", style: AppStyles.kTextStyleHeader18,),
                    Text("Order details", style: AppStyles.kTextStyle14,),
                    Row(
                      children: [
                        Text("General", style: AppStyles.kTextStyleHeader14,),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(child: Text("Order number: ", style: AppStyles.kTextStyle16,)),
                        Expanded(child: Text("#"+ (order.bookingId ?? ""), style: AppStyles.kTextStyleHeader16,)),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(child: Text("Salon: ", style: AppStyles.kTextStyle16,)),
                        Expanded(child: Text(order.salonData?.name ?? "", style: AppStyles.kTextStyle18,)),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(child: Text("Date and Time: ", style: AppStyles.kTextStyle16,)),
                        Expanded(child: Text(DateFormat("d MMM y").format(order.appointmentDate ?? DateTime.now()), style: AppStyles.kTextStyle18,)),
                      ],
                    ),

                    AppSize.h30.ph,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(child: Text("Reservation List ", style: AppStyles.kTextStyleHeader16,)),
                        Expanded(child: Text(order.serviceData?.map((e) => e.name).toString().split("(").last.split(")").first ?? "", style: AppStyles.kTextStyle18,)),
                      ],
                    ),
                    AppSize.h20.ph,

                    Divider(),
                    Row(
                      children: [
                        Text("Amount", style: AppStyles.kTextStyleHeader14,),
                      ],
                    ),
                    AppSize.h10.ph,
                    Row(
                      children: [
                        Expanded(child: Text("Booking Cost: ", style: AppStyles.kTextStyleHeader16,)),
                        Text("${viewModel.calcTotalServicePrice(order.serviceData?? [], withcoupon: order.couponData)} RS", style: AppStyles.kTextStyleHeader16),
                      ],
                    ),
                    AppSize.h10.ph,
                    Row(
                      children: [
                        Expanded(child: Text("Total Amount", style: AppStyles.kTextStyle16,)),
                        Text("(Prices include tax)${viewModel.calcTotalServicePrice(order.serviceData?? [], withcoupon: order.couponData)} RS", style: AppStyles.kTextStyle16),
                      ],
                    ),

                    AppSize.h10.ph,
                    Row(
                      children: [
                        Expanded(child: Text("Payment method: ", style: AppStyles.kTextStyle16,)),
                        Text("Credit Card", style: AppStyles.kTextStyle16),
                      ],
                    ),

                    AppSize.h100.ph,
                  ],
                ),
              ),
            ),
            AppSize.h30.ph,
            //
            // CustomButton(title: "Save as PDF",
            //     width: 150.sp,
            //     btnColor: AppColors.kBlackColor,
            //     onClick: (){
            //
            // })
          ],
        ),
      ),
    );
  }
}
