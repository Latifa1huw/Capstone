import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/admin/all_services/widgets/AdminServiceWidget.dart';
import 'package:template/features/admin/users/list_users_viewModel.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/features/authentication/user_viewModel.dart';
import 'package:template/features/customer/orders/models/order.dart';
import 'package:template/features/customer/orders/order_viewModel.dart';
import 'package:template/features/customer/ratings/models/rating.dart';
import 'package:template/features/customer/ratings/rate_viewModel.dart';
import 'package:template/features/salon/services/models/service.dart';
import 'package:template/features/salon/services/service_viewModel.dart';
import 'package:template/features/salon/services/widgets/ServiceWidget.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class SalonReportsPage extends StatefulWidget {
  const SalonReportsPage({Key? key}) : super(key: key);

  @override
  State<SalonReportsPage> createState() => _SalonReportsPageState();
}

class _SalonReportsPageState extends State<SalonReportsPage> {
  final List<Map<String, dynamic>> reports = [];

  final List<double> values = [];
  final List<String> labels = [];

  ServiceViewModel serviceViewModel = ServiceViewModel();
  RateViewModel rateViewModel = RateViewModel();
  OrderViewModel orderViewModel = OrderViewModel();
  ListUsersViewModel listUsersViewModel = ListUsersViewModel();

  @override
  void initState() {
    serviceViewModel.getAllServicesForEveryUserID();
    rateViewModel.getAllRateForEveryUserID();
    orderViewModel.getOrdersProductsForEverySalonID();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWithoutBack(context, title: "Reports"),
      body: BlocBuilder<GenericCubit<List<Rating>>,
          GenericCubitState<List<Rating>>>(
          bloc: rateViewModel.ratings,
          builder: (context, rate_state) {
            return BlocBuilder<GenericCubit<List<Service>>,
                GenericCubitState<List<Service>>>(
                bloc: serviceViewModel.services,
                builder: (context, services_state) {
                  return BlocBuilder<GenericCubit<List<OrderItem>>,
                      GenericCubitState<List<OrderItem>>>(
                      bloc: orderViewModel.orders,
                      builder: (context, orders_state) {
                        if (orders_state is GenericLoadingState) {
                        } else {
                          reports.add(
                            {
                              "id": 3,
                              "name": "My Rates",
                              "value": rate_state.data.length
                            },
                          );
                          values.add(rate_state.data.length.toDouble());
                          labels.add("My Rates");
                          reports.add(
                            {
                              "id": 4,
                              "name": "My Services",
                              "value": services_state.data.length
                            },
                          );
                          values
                              .add(services_state.data.length.toDouble());
                          labels.add("My Services");
                          reports.add(
                            {
                              "id": 5,
                              "name": "My Orders",
                              "value": orders_state.data.length
                            },
                          );
                          values.add(orders_state.data.length.toDouble());
                          labels.add("My Orders");
                        }
                        return orders_state is GenericLoadingState
                            ? const Loading()
                            : SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppSize.h100.ph,
                              Container(
                                height: 300,
                                padding: const EdgeInsets.all(16.0),
                                child: LineChart(
                                  LineChartData(
                                    gridData: FlGridData(
                                      show: true,
                                      drawVerticalLine: false,
                                      horizontalInterval: 10,
                                      getDrawingHorizontalLine: (value) {
                                        return FlLine(
                                          color: Colors.grey.withOpacity(0.3),
                                          strokeWidth: 1,
                                        );
                                      },
                                    ),
                                    titlesData: FlTitlesData(
                                      show: true,
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 40,
                                          getTitlesWidget: (value, meta) {
                                            return Text(
                                              value.toInt().toString(),
                                              style: const TextStyle(fontSize: 12),
                                            );
                                          },
                                        ),
                                      ),
                                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Hide right titles
                                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Hide top titles
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 40,
                                          getTitlesWidget: (value, meta) {
                                            if (value < 0 || value >= labels.length) return const SizedBox.shrink();
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 8.0), // Adjust the padding to ensure the text is clear
                                              child: Text(
                                                labels[value.toInt()],
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                            );
                                          },
                                          interval: 1,
                                        ),
                                      ),
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
                                    ),
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: List.generate(
                                          values.length,
                                              (index) => FlSpot(index.toDouble(), values[index]),
                                        ),
                                        isCurved: true,
                                        barWidth: 4,
                                        dotData: FlDotData(show: true),
                                        belowBarData: BarAreaData(
                                          show: true,
                                        ),
                                      ),
                                    ],
                                    minY: 0,
                                    maxY: (values.reduce((a, b) => a > b ? a : b) * 1.2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                });
          })
    );
  }
}
