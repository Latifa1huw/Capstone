import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:template/features/customer/cart/models/CartItem.dart';
import 'package:template/features/customer/orders/models/order.dart';
import 'package:template/features/customer/orders/order_viewModel.dart';
import 'package:template/features/customer/orders/widgets/InvoiceWidget.dart';
import 'package:template/features/customer/ratings/widgets/add_rating_widget.dart';
import 'package:template/features/salon/services/models/service.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBar.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  OrderViewModel viewModel = OrderViewModel();

  int selectedStatusIndex = 0;

  @override
  void initState() {
    if(PrefManager.currentUser?.type == 2) {
      viewModel.getOrdersProductsForEveryUserID();
    }
    if(PrefManager.currentUser?.type == 1) {
      viewModel.getAllOrders();
    }

    if(PrefManager.currentUser?.type == 3) {
      viewModel.getOrdersProductsForEverySalonID();
    }
    super.initState();
  }

  GenericCubit<List<OrderItem>> returnTypeOfOrders(){
    switch (selectedStatusIndex){
      case 0:
        return viewModel.ordersRequesrSend;
        break;
      case 1:
          return viewModel.ordersAccepted;
          break;
      case 2:
          return viewModel.ordersOnTheWay;
          break;
      case 3:
          return viewModel.ordersCompleted;
          break;
      case 4:
          return viewModel.ordersReject;
          break;
      default:
       return GenericCubit([]);
       break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWithoutBack(context, title: "Bookings", isBack: PrefManager.currentUser?.type == 2? true: false),
      body: Padding(
        padding: EdgeInsets.only(bottom: 70.0.sp),
        child: Column(
          children: [
            // Switchable buttons for categories
            Container(
              height: 40.sp,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: viewModel.statuses.asMap().entries.map((entry) {
                  int index = entry.key;
                  String category = entry.value;

                  return InkWell(
                    onTap:  () {
                      setState(() {
                        selectedStatusIndex = index; // Update selected category
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: selectedStatusIndex == index ?
                          AppColors.kMainColor :
                          AppColors.kWhiteColor, width: 2)
                        )
                      ),
                      margin: EdgeInsets.all(5.sp),
                      padding: EdgeInsets.all(5.sp),
                      child: Text(category, style: AppStyles.kTextStyleHeader16.copyWith(
                        color: AppColors.kMainColor
                      ),
                      ),
                    ),
                  );

                  // return Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 5.sp),
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       setState(() {
                  //         selectedStatusIndex = index; // Update selected category
                  //       });
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: selectedStatusIndex == index ?
                  //       AppColors.kMainColor :
                  //       AppColors.kInputColor,
                  //     ),
                  //     child: Text(category, style: AppStyles.kTextStyle13,),
                  //   ),
                  // );
                }).toList(),
              ),
            ),
            AppSize.h10.ph,
            Expanded(
              child: BlocBuilder<GenericCubit<List<OrderItem>>,
                  GenericCubitState<List<OrderItem>>>(
                  bloc: returnTypeOfOrders(),
                  builder: (context, state) {
                    return state is GenericLoadingState ?
                    const Loading()
                        : state.data.isEmpty ?
                    const EmptyData()
                        : ListView.builder(
                      itemCount: state.data.length,
                      padding: EdgeInsets.only(bottom: 150.sp),
                      itemBuilder: (context, index) {
                        final order = state.data[index];
                        return OrderCard(order: order, viewModel: viewModel,);
                        // return _buildOrderCard(order);
                      },
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderItem order;
  final OrderViewModel viewModel;
  OrderCard({required this.order, required this.viewModel});

  String returnTypeOfStatus(){
    switch (order.status){
      case "Request sent":
        return "Accepted";
        break;
      case "Accepted":
        return "On the way";
        break;
      case "On the way":
        return "Completed";
        break;
      default:
        return "";
        break;
    }
  }

  returnTypeOfStatusActions(){
    switch (order.status){
      case "Request sent":
        viewModel.status.onUpdateData("Accepted");
        viewModel.updateOrderStatus(order);
        break;
      case "Accepted":
        viewModel.status.onUpdateData("On the way");
        viewModel.updateOrderStatus(order);
        break;
      case "On the way":
        viewModel.status.onUpdateData("Completed");
        viewModel.updateOrderStatus(order);
        break;
      default:
        return "";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: AppColors.kWhiteColor,
      margin: const EdgeInsets.all(10),
      shape: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(30)
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomerInfo(),
            const SizedBox(height: 10),
            _buildSalonInfo(context),
            const SizedBox(height: 10),
            _buildServiceList(),
            const SizedBox(height: 10),
            _buildAddress(),
            const SizedBox(height: 10),
            _buildAppointmentDetails(),
            const SizedBox(height: 10),
            if (order.couponData != null) _buildCouponInfo(),
            _buildStatus(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total", style: AppStyles.kTextStyle16.copyWith(
                    fontWeight: FontWeight.bold
                )),
                Text("${viewModel.calcTotalServicePrice(order.serviceData?? [], withcoupon: order.couponData)} SR", style: AppStyles.kTextStyle16.copyWith(
                    color: AppColors.kMainColor,
                    fontWeight: FontWeight.bold
                )),
              ],
            ),
            order.status == "Completed" || order.status == "Reject" || PrefManager.currentUser?.type != 3?
            const SizedBox():
            AppSize.h10.ph,
            order.status == "Completed" || order.status == "Reject" || PrefManager.currentUser?.type != 3?
                const SizedBox():
            BlocBuilder<GenericCubit<bool>, GenericCubitState<bool>>(
              bloc: viewModel.loading,
              builder: (context, state) {
                return state.data?
                const Loading():
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                        title: returnTypeOfStatus(),
                        width: 100.sp,
                        height: 30.sp,
                        btnColor: AppColors.kGreenColor,
                        textSize: 13.sp,
                        onClick: (){
                          returnTypeOfStatusActions();
                        }
                    ),

                    order.status == "Request sent"?
                    AppSize.h10.pw:
                    const SizedBox(),

                    order.status == "Request sent"?
                    CustomButton(
                        title: "Reject",
                        width: 100.sp,
                        height: 30.sp,
                        btnColor: AppColors.kRedColor,
                        textSize: 13.sp,
                        onClick: (){
                          viewModel.status.onUpdateData("Reject");
                          viewModel.updateOrderStatus(order);
                        }
                    ):
                    const SizedBox(),
                  ],
                );
              }
            ),



            // if completed doing review and rating
            order.status == "Completed" && PrefManager.currentUser?.type == 2?
            AppSize.h10.ph:
            const SizedBox(),
            order.status == "Completed" && order.rated == false && PrefManager.currentUser?.type == 2?
            BlocBuilder<GenericCubit<bool>, GenericCubitState<bool>>(
              bloc: viewModel.loading,
              builder: (context, state) {
                return state.data?
                const Loading():
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                        title: "Rate",
                        width: 100.sp,
                        height: 30.sp,
                        textSize: 13.sp,
                        onClick: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AddRatingWidget(viewModel: viewModel, orderItem: order,),
                          );
                        }
                    ),
                  ],
                );
              }
            ): const SizedBox(),

            // if completed doing review and rating
            order.status == "Request sent" && PrefManager.currentUser?.type == 2?
            AppSize.h10.ph:
            const SizedBox(),
            order.status == "Request sent" && PrefManager.currentUser?.type == 2?
            BlocBuilder<GenericCubit<bool>, GenericCubitState<bool>>(
              bloc: viewModel.loading,
              builder: (context, state) {
                return state.data?
                const Loading():
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                        title: "Cancel",
                        width: 100.sp,
                        height: 30.sp,
                        textSize: 13.sp,
                        onClick: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirmation', style: AppStyles.kTextStyleHeader20,),
                                content: Container(
                                  height: 150.sp,
                                  child: Column(
                                    children: [
                                      Text('Do you want to cancel this appointment', style: AppStyles.kTextStyle18,),
                                      Text("The refund will be processed within 3 business days, and you'll receive a confirmation once it’s issued",
                                          style: AppStyles.kTextStyle16.copyWith(
                                            color: AppColors.kRedColor
                                          )),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      UI.pop();
                                    },
                                    child: Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      viewModel.status.onUpdateData("Cancel");
                                      viewModel.updateOrderStatus(order);
                                      UI.pop();
                                      UI.showMessage("The refund will be processed within 3 business days, and you'll receive a confirmation once it’s issued");
                                    },
                                    child: Text('Yes'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                    ),
                  ],
                );
              }
            ): const SizedBox()
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Customer: ${order.customerData?.name ?? "N/A"}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('Phone: ${order.customerData?.phone ?? "N/A"}'),
      ],
    );
  }

  Widget _buildSalonInfo(BuildContext context  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Salon: ${order.salonData?.name ?? "N/A"}',
            style: const TextStyle(fontWeight: FontWeight.bold)),

        InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (contex)=> InvoiceWidget(order: order)));
            },
            child: Icon(Icons.download, size: 30.sp,))
      ],
    );
  }

  Widget _buildServiceList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Services:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        ...order.serviceData?.map((service) => _buildServiceItem(service)) ??
            [const Text('No services')],
      ],
    );
  }

  Widget _buildServiceItem(Service service) {
    return ListTile(
      leading: Image.network(service.imageUrl ?? '', width: 50, height: 50),
      title: Text(service.name ?? "Service"),
      subtitle: Text(service.description ?? "", maxLines: 2, overflow: TextOverflow.ellipsis,),
      trailing: Text("${service.price.toString()}SR"),
    );
  }

  Widget _buildAppointmentDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text('Appointment Date: ${DateFormat("yyyy-MM-dd (hh:mm)").format(order.appointmentDate!) ?? "N/A"}')),
        Expanded(child: Text('Time: ${order.appointmentTime ?? "N/A"}')),
      ],
    );
  }

  Widget _buildCouponInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Coupon: ${order.couponData?.code ?? "N/A"}',
            style: const TextStyle(color: Colors.green)),
        Text('Discount: ${order.couponData?.discountPrecentage?.toStringAsFixed(1) ?? "0"}%'),
      ],
    );
  }

  Widget _buildStatus() {
    return Text(
      'Status: ${order.status ?? "Pending"}',
      style: AppStyles.kTextStyleHeader14,
    );
  }

  Widget _buildAddress() {
    return InkWell(
      onTap: (){
        launchUrl(Uri.parse(viewModel.generateGoogleMapsLink(order.lat ?? 29.0895085, order.long ?? 31.0455265)));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(Resources.location, height: 20.sp, color: AppColors.kGreyColor,),
          AppSize.h10.pw,
          Expanded(
            child: Text(
              '${order.trackingLocation ?? ""}',
              style: AppStyles.kTextStyle12,
            ),
          ),
          AppSize.h10.pw,
          Icon(Icons.arrow_forward_ios, size: 20.sp,)
        ],
      ),
    );
  }
}