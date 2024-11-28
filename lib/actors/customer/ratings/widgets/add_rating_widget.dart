import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/customer/orders/models/order.dart';
import 'package:template/features/customer/orders/order_viewModel.dart';
import 'package:template/features/customer/ratings/rate_viewModel.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';

class AddRatingWidget extends StatefulWidget {
  final OrderViewModel viewModel;
  final OrderItem orderItem;
  const AddRatingWidget({Key? key, required this.viewModel, required this.orderItem}) : super(key: key);

  @override
  State<AddRatingWidget> createState() => _AddRatingWidgetState();
}

class _AddRatingWidgetState extends State<AddRatingWidget> {
  RateViewModel rateViewModel = RateViewModel();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.85,
        child: Form(
          key: rateViewModel.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button at the top-right corner
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close),
                ),
              ),

              // Logo at the top center
              // CircleAvatar(
              //   radius: 40,
              //   backgroundColor: Colors.transparent,
              //   backgroundImage: AssetImage(Resources.review), // Replace with your asset
              // ),
              SizedBox(height: 10.sp),

              // Rating Title
              Text(
                'Please Rate your Experience',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.sp),

              // Star Rating Bar
              RatingBar.builder(
                initialRating: 4, // Set your initial rating
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating); // Handle rating value
                  rateViewModel.rate.onUpdateData(rating.toInt());
                },
              ),
              SizedBox(height: 20.sp),

              // Additional Comments Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Additional Comments',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10.sp),

              // TextField for comments
              TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "You've improved a lot",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: rateViewModel.comment,
                validator: (value) => value!.isEmpty ? 'Please enter your comment' : null,
              ),
              SizedBox(height: 20.sp),

              BlocBuilder<GenericCubit<bool>, GenericCubitState<bool>>(
                  bloc: rateViewModel.loading,
                  builder: (context, state) {
                    return state.data?
                    const Loading():
                    CustomButton(
                      title: "Submit",
                      onClick: (){
                        rateViewModel.addRate(widget.orderItem.salonData!, widget.orderItem.bookingId!);
                        widget.viewModel.updateOrderRating(widget.orderItem);
                      }
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}