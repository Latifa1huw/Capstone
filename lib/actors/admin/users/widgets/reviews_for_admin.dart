import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/features/customer/ratings/models/rating.dart';
import 'package:template/features/customer/ratings/rate_viewModel.dart';
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

class ReviewsForAdmin extends StatefulWidget {
  final User salon;
  const ReviewsForAdmin({Key? key, required this.salon}) : super(key: key);

  @override
  State<ReviewsForAdmin> createState() => _ReviewsForAdminState();
}

class _ReviewsForAdminState extends State<ReviewsForAdmin> {
  RateViewModel viewModel = RateViewModel();

  @override
  void initState() {
    viewModel.getAllRateForSalonById(widget.salon.id ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<List<Rating>>,
        GenericCubitState<List<Rating>>>(
        bloc: viewModel.ratings,
        builder: (context, state) {
          return state is GenericLoadingState ? const Loading() :
          state.data.isEmpty ?
          const EmptyData()
              :
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 70.0.sp),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.data.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                color: AppColors.kWhiteColor,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: Row(
                    children: [
                      // Service Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: FadeInImage.assetNetwork(
                          placeholder: Resources.slider, // Local image shown while loading
                          image: state.data[index].salonData?.profile_image ?? "",
                          height: 50.sp,
                          width: 50.sp,
                          fit: BoxFit.cover,
                          imageErrorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return Image.asset(
                              Resources.slider, // Fallback image if network image fails
                              height: 50.sp,
                              width: 50.sp,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      AppSize.h10.pw,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    state.data[index].salonData?.name ?? "",
                                    style: AppStyles.kTextStyleHeader16,
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
                            ),
                            PrefManager.currentUser?.type == 1?
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    state.data[index].comment ?? "",
                                    maxLines: 2,
                                    style: AppStyles.kTextStyle14,
                                  ),
                                ),
                                Row(
                                  children: List.generate(5, (i) {
                                    int? rate = state.data[index].rate;
                                    return i < (rate ?? 0)
                                        ? const Icon(Icons.star, color: AppColors.kYollowColor580) // Filled star
                                        : const Icon(Icons.star_border, color: AppColors.kYollowColor580); // Outlined star

                                  }),
                                )
                              ],
                            ):
                            Text(
                              state.data[index].comment ?? "",
                              style: AppStyles.kTextStyle14,
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
