import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:template/features/customer/ratings/models/rating.dart';
import 'package:template/features/customer/ratings/rate_viewModel.dart';
import 'package:template/features/customer/ratings/widgets/CardRate.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/ui.dart';

class ShowRatingsPage extends StatefulWidget {
  final String salonId;
  final bool isFromDrwaer;
  final bool isDelete;
  const ShowRatingsPage({Key? key, required this.salonId, this.isDelete = false, this.isFromDrwaer = false}) : super(key: key);

  @override
  State<ShowRatingsPage> createState() => _ShowRatingsPageState();
}

class _ShowRatingsPageState extends State<ShowRatingsPage> {
  RateViewModel viewModel = RateViewModel();

  @override
  void initState() {
    if(PrefManager.currentUser?.type == 1){
      viewModel.getAllRatings();
    }else if(PrefManager.currentUser?.type == 3){
      viewModel.getAllRateForEveryUserID();
    }else if(widget.isFromDrwaer){
      print(">>>>>>>");
      viewModel.getAllRateForEveryCustomerID();
    }else{
      viewModel.getAllRateForSalonById(widget.salonId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<List<Rating>>,
        GenericCubitState<List<Rating>>>(
        bloc: viewModel.ratings,
        builder: (context, state) {
          return state is GenericLoadingState ? const Loading() :
          state.data.isEmpty?
              EmptyData():
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 70.0.sp),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.data.length,
          itemBuilder: (context, index) {
            return Card(
              color: AppColors.kBackgroundColor,
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none
              ),
              child: Padding(
                padding: EdgeInsets.all(10.sp),
                child: Row(
                  children: [
                    // Service Image

                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(90),
                    //   child: FadeInImage.assetNetwork(
                    //     placeholder: Resources.slider, // Local image shown while loading
                    //     image: state.data[index].salonData?.profile_image ?? "",
                    //     height: 60.sp,
                    //     width: 60.sp,
                    //     fit: BoxFit.cover,
                    //     imageErrorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    //       return Image.asset(
                    //         Resources.slider, // Fallback image if network image fails
                    //         height: 60.sp,
                    //         width: 60.sp,
                    //         fit: BoxFit.cover,
                    //       );
                    //     },
                    //   ),
                    // ),


                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(90),
                    //   child: Image.network(
                    //     state.data[index].salonData?.profile_image ?? "",
                    //     height: 40.sp,
                    //     width: 40.sp,
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    AppSize.h10.pw,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  state.data[index].customerData?.name ?? "",
                                  style: AppStyles.kTextStyleHeader16,
                                ),
                              ),
                              Row(
                                children: List.generate(5, (i) {
                                  int? rate = state.data[index].rate;
                                  return i < (rate ?? 0)
                                      ? const Icon(Icons.star, color: AppColors.kAmberColor580) // Filled star
                                      : const Icon(Icons.star_border, color: AppColors.kAmberColor580); // Outlined star

                                }),
                              )
                            ],
                          ),
                          PrefManager.currentUser?.type == 1 || (PrefManager.currentUser?.type == 2 && !widget.isDelete)?
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  state.data[index].comment ?? "",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.kGreyColor
                                  ),
                                ),
                              ),
                              BlocBuilder<GenericCubit<bool>,
                                  GenericCubitState<bool>>(
                                  bloc: viewModel.loading,
                                  builder: (context, deleteState) {
                                    return deleteState.data
                                        ? const Loading()
                                        : IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Note'),
                                                content: Text('Do you want to delete rate'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      UI.pop();
                                                    },
                                                    child: Text('No'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      viewModel.deleteRate(state.data[index].rateId ?? "");
                                                    },
                                                    child: Text('Delete'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: Icon(Icons.delete_outline_outlined,
                                          size: 30.sp,
                                          color: AppColors.kRedColor,
                                        )
                                    );
                                  }
                              )
                            ],
                          ):
                          Text(
                            state.data[index].comment ?? "",
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.kGreyColor
                            ),
                          ),

                          Text(
                            DateFormat("d MMM y").format(state.data[index].createdAt ?? DateTime.now()),
                            style: AppStyles.kTextStyle13,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    );
  }
}