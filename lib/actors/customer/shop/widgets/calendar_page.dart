import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/features/customer/cart/cart_viewModel.dart';
import 'package:template/features/customer/shop/widgets/AppointmentDetails.dart';
import 'package:template/features/customer/shop/widgets/SelectLocation.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class CalendarPage extends StatefulWidget {
  final User salon;
  final CartViewModel cartViewModel;
  const CalendarPage({Key? key, required this.salon, required this.cartViewModel}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  @override
  void initState() {
    widget.cartViewModel.generateTimeSlots(widget.salon.fromTime! , widget.salon.toTime!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWithoutBack(context, title: "Appointments"),
      body: Container(
        padding: EdgeInsets.all(10.sp),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<GenericCubit<DateTime>, GenericCubitState<DateTime>>(
                bloc: widget.cartViewModel.selectedDate,
                builder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.kGreyColor)
                    ),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text("${ DateFormat('MMMM yyyy').format(state.data)}", style: AppStyles.kTextStyleHeader26.copyWith(
                            color: AppColors.kMainColor
                        ),),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.sp),
                          child: const Divider(
                              color: AppColors.kMainColor
                          ),
                        ),
                        AppSize.h20.ph,
                        TableCalendar(
                          firstDay: DateTime.utc(2000, 10, 16),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: state.data,
                          currentDay: state.data,
                          onDaySelected: (_, day){
                            print(day);
                            widget.cartViewModel.selectedDate.onUpdateData(day);
                            widget.cartViewModel.selectedTime.onUpdateData(null);
                          },
                        ),
                      ],
                    ),
                  );
                }
              ),
              AppSize.h20.ph,
              BlocBuilder<GenericCubit<List<String?>>, GenericCubitState<List<String?>>>(
                bloc: widget.cartViewModel.timeRanges,
                builder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.kGreyColor)
                    ),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text("Schedule Time", style: AppStyles.kTextStyleHeader26.copyWith(
                          color: AppColors.kMainColor
                        ),),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.sp),
                          child: const Divider(
                            color: AppColors.kMainColor
                          ),
                        ),
                        AppSize.h20.ph,
                        BlocBuilder<GenericCubit<String?>, GenericCubitState<String?>>(
                            bloc: widget.cartViewModel.selectedTime,
                            builder: (context, selectedTimeState) {
                              return Wrap(
                              children: List.generate(state.data.length, (index){
                               var time = state.data.elementAt(index);
                                return InkWell(
                                  onTap: (){
                                    widget.cartViewModel.selectedTime.onUpdateData(time);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0.sp),
                                    child: Container(
                                      width: (MediaQuery.of(context).size.width - 70.sp) /2,
                                      padding: EdgeInsets.all(10.sp),
                                      decoration: BoxDecoration(
                                        color: selectedTimeState.data == time? AppColors.kMainColor: null,
                                        border: Border.all(color: AppColors.kMainColor),
                                        borderRadius: selectedTimeState.data == time?
                                        BorderRadius.only(bottomRight: Radius.circular(20), topLeft: Radius.circular(20)) : BorderRadius.circular(20)
                                      ),
                                      child: Text(time!),
                                    ),
                                  ),
                                );
                              }),
                            );
                          }
                        )
                      ],
                    ),
                  );
                }
              ),

              AppSize.h20.ph,
              CustomButton(
                title: "Next",
                width: 150.sp,
                onClick: (){
                  if(widget.cartViewModel.selectedTime.state.data != null && (widget.cartViewModel.selectedDate.state.data != null)) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => AppointmentDetails(
                          salon: widget.salon,
                          cartViewModel: widget.cartViewModel,
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
      ),
    );
  }
}
