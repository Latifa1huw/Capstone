import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/features/customer/orders/models/order.dart';
import 'package:template/features/customer/orders/order_page.dart';
import 'package:template/features/customer/orders/order_viewModel.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';

class BookingsForAdmin extends StatefulWidget {
  final User salon;
  const BookingsForAdmin({Key? key, required this.salon}) : super(key: key);

  @override
  State<BookingsForAdmin> createState() => _BookingsForAdminState();
}

class _BookingsForAdminState extends State<BookingsForAdmin> {

  OrderViewModel viewModel = OrderViewModel();

  @override
  void initState() {
    viewModel.getOrdersProductsBySalonID(widget.salon.id ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<List<OrderItem>>,
        GenericCubitState<List<OrderItem>>>(
        bloc: viewModel.orders,
        builder: (context, state) {
          return state is GenericLoadingState ?
          const Loading()
              : state.data.isEmpty ?
          const EmptyData()
              : ListView.builder(
              itemCount: state.data.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 20.sp),
              itemBuilder: (context, index) {
              final order = state.data[index];
              return OrderCard(order: order, viewModel: viewModel,);
              },
          );
        }
    );
  }
}
