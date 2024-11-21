import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/admin/all_services/widgets/AdminServiceWidget.dart';
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

class AllServicePage extends StatefulWidget {
  final String id;
  const AllServicePage({Key? key, required this.id}) : super(key: key);

  @override
  State<AllServicePage> createState() => _AllServicePageState();
}

class _AllServicePageState extends State<AllServicePage> {
  ServiceViewModel viewModel = ServiceViewModel();

  @override
  void initState() {
    viewModel.getServicesByUserID(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<List<Service>>,
        GenericCubitState<List<Service>>>(
        bloc: viewModel.services,
        builder: (context, state) {
          return state is GenericLoadingState ? const Loading()
              : Padding(
            padding: EdgeInsets.all(10.0.sp),
            child: state.data.isEmpty ? const EmptyData():
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                final service = state.data[index];
                return Card(
                  color: AppColors.kWhiteColor,
                  margin: EdgeInsets.symmetric(vertical: 5.sp),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: AdminServiceWidget(service: service, viewModel: viewModel,),
                  ),
                );
              },
            ),
          );
        }
    );
  }
}
