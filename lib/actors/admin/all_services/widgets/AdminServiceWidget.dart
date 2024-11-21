import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/salon/services/models/service.dart';
import 'package:template/features/salon/services/service_viewModel.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';

class AdminServiceWidget extends StatelessWidget {
  final Service service;
  final ServiceViewModel viewModel;
  const AdminServiceWidget({Key? key, required this.service, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(6.0.sp),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: Image.network(
                    service.imageUrl ?? "",
                    height: 70.sp,
                    width: 70.sp,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10.sp),

                // Service Name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              service.name ?? "",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          BlocBuilder<GenericCubit<bool>, GenericCubitState<bool>>(
                              bloc: viewModel.loading,
                              builder: (context, state) {
                                return state.data?
                                const Loading():
                                IconButton(
                                    onPressed: () {
                                      viewModel.deleteService(service.serviceId ?? "");
                                    },
                                    icon: Icon(Icons.delete_outline_outlined,
                                      size: 30.sp,
                                      color: AppColors.kRedColor,
                                    )
                                );
                              }
                          ),
                        ],
                      ),
                      // Service Description
                      Text(
                        service.description ?? "",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.sp),

            // Service Price and Duration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Price: ${service.price}SR",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Duration: ${service.duration} mins",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.sp),

            // Service Availability
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  "Available: ${service.availability}",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        )
    );
  }
}