import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/salon/services/models/service.dart';
import 'package:template/features/salon/services/service_viewModel.dart';
import 'package:template/features/salon/services/widgets/ServiceWidget.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({Key? key}) : super(key: key);

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  ServiceViewModel viewModel = ServiceViewModel();

  @override
  void initState() {
    viewModel.getAllServicesForEveryUserID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWithoutBack(context, title: "Services"),
      body: Padding(
        padding: EdgeInsets.only(bottom: 70.0.sp),
        child: BlocBuilder<GenericCubit<List<Service>>,
            GenericCubitState<List<Service>>>(
            bloc: viewModel.services,
            builder: (context, state) {
              return state is GenericLoadingState ? const Loading()
                  : Padding(
                padding: EdgeInsets.all(10.0.sp),
                child: state.data.isEmpty ? const EmptyData():
                ListView.builder(
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    final service = state.data[index];
                    return Card(
                      color: AppColors.kWhiteColor,
                      margin: EdgeInsets.symmetric(vertical: 5.sp),
                      elevation: 4,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.kBlackColor)
                      ),
                      child: ServiceWidget(service: service, viewModel: viewModel,),
                    );
                  },
                ),
              );
            }
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 70.0.sp),
        child: InkWell(
          onTap: () => UI.push(AppRoutes.addServicePage, arguments: [viewModel]),
          child: Icon(
            Icons.add_circle_rounded,
            color: AppColors.kBlackColor,
            size: 60.sp,
          ),
        ),
      ),
    );
  }
}
