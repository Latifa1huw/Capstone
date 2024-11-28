import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/customer/cart/cart_viewModel.dart';
import 'package:template/features/salon/services/models/service.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:provider/provider.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final CartViewModel cartViewModel;
  const ServiceCard({Key? key, required this.service, required this.cartViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<List<Service>?>, GenericCubitState<List<Service>?>>(
      bloc: cartViewModel.selectServices,
      builder: (context, state) {
        Service isSelectedService = Service();
        if(state.data != null) {
          state.data?.forEach(
              (e){
                if( service.serviceId == e.serviceId ){
                  isSelectedService = e;
                  print("insideloop");
                  print(isSelectedService.toMap() ?? "");
                  return;
                }
              },
          );
          print("isSelectedService.toMap() ??");
          print(isSelectedService.toMap() ?? "");
          // print(state.data?.first.toMap() ?? "");
        }
          return InkWell(
          onTap: (){
            var selectedServices = state.data ?? [];

            // Check if the service is already selected
            if (!(selectedServices.any((s) => s.serviceId == service.serviceId))) {
              selectedServices.add(service);
              cartViewModel.selectServices.onUpdateData(selectedServices);
              print('${service.name} added');
            } else {
              selectedServices.removeWhere((s) => s.serviceId == service.serviceId);
              cartViewModel.selectServices.onUpdateData(selectedServices);
              print('${service.name} is already selected');
            }

            // Print selected services
            print("Selected services: ${selectedServices.length}");
            print("Selected services:  state.data  ${state.data?.length}");
            selectedServices.forEach((service) => print(service.name));
          },
          child: Card(
            color: AppColors.kMainColor.withOpacity(.4),
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              borderSide: (state.data?.any((s) => s.serviceId == service.serviceId) ?? false) ? const BorderSide(color: AppColors.kBlueColor580, width: 3):  BorderSide.none
            ),
            child: Padding(
              padding: EdgeInsets.all(10.sp),
              child: Row(
                children: [
                  // Service Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    child: Image.network(
                      service.imageUrl ?? "",
                      height: 40.sp,
                      width: 40.sp,
                      fit: BoxFit.cover,
                    ),
                  ),
                  AppSize.h10.pw,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name ?? "",
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          service.description ?? "",
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 10.sp
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSize.h10.pw,
                  Text(
                    "${service.price} SR",
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
