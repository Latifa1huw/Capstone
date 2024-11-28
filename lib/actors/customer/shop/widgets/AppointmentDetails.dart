import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/features/customer/cart/cart_viewModel.dart';
import 'package:template/features/customer/shop/widgets/SelectLocation.dart';
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

class AppointmentDetails extends StatefulWidget {
  final User salon;
  final CartViewModel cartViewModel;
  const AppointmentDetails({Key? key, required this.salon, required this.cartViewModel}) : super(key: key);

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  ServiceViewModel viewModel = ServiceViewModel();

  @override
  void initState() {
    viewModel.getServicesByUserID(widget.salon.id ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWithoutBack(context, title: "Appointments \n Details"),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: InkWell(
                  onTap: (){
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppSize.r30),
                          topRight: Radius.circular(AppSize.r30),
                        ),
                      ),
                      builder: (_) => Container(
                        height: AppSize.h450,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppColors.kWhiteColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(AppSize.r30),
                            topRight: Radius.circular(AppSize.r30),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        child: BlocBuilder<GenericCubit<List<Service>>,
                            GenericCubitState<List<Service>>>(
                            bloc: viewModel.services,
                            builder: (context, state) {
                              return state is GenericLoadingState ? const Loading() :
                              Container(
                                  height: state.data.isEmpty ? 200.sp: null,
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10.0.sp),
                                  child: state.data.isEmpty ? const EmptyData(color: AppColors.kWhiteColor,):
                                  SelectedServicesForAppointmentDetails(services: state.data, cartViewModel: widget.cartViewModel,)
                              );
                            }
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.kBlackColor)
                      )
                    ),
                      padding: EdgeInsets.only(bottom: 10.sp),
                      child: Text("+ Add new service", style: AppStyles.kTextStyle16,textAlign: TextAlign.start,))),
            ),
            AppSize.h100.ph,
            AppSize.h100.ph,
            CustomButton(
              title: "Next",
              width: 150.sp,
              onClick: (){
                if(widget.cartViewModel.selectServices.state.data != null && (widget.cartViewModel.selectServices.state.data?.isNotEmpty ?? false)) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => SelectLocation(
                        salon: widget.salon,
                        viewModel: widget.cartViewModel,
                      )));
                }else{
                  UI.showMessage("Should select at least one service to complete");
                }
              },
            ),
            AppSize.h20.ph
          ],
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
                      // Row(
                      //   children: [
                      //     Icon(Icons.calendar_month),
                      //     Text(service.availability ?? "", style: AppStyles.kTextStyle16,),
                      //   ],
                      // ),
                      // AppSize.h5.ph,
                      // Row(
                      //   children: [
                      //     Icon(Icons.timer_outlined),
                      //     Text(service.availability ?? "", style: AppStyles.kTextStyle14),
                      //   ],
                      // ),
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
