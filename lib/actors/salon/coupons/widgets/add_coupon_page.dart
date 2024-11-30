import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:template/features/authentication/user_viewModel.dart';
import 'package:template/features/salon/coupons/coupon_viewModel.dart';
import 'package:template/features/salon/coupons/models/coupon.dart';
import 'package:template/features/salon/services/models/service.dart';
import 'package:template/features/salon/services/service_viewModel.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/custom_dropdown.dart';
import 'package:template/shared/ui/componants/custom_field.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/widgets/CustomAppBar.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class AddCouponPage extends StatefulWidget {
  final CouponViewModel viewModel;
  final Coupon? coupon;
  const AddCouponPage({Key? key, required this.viewModel, this.coupon}) : super(key: key);

  @override
  State<AddCouponPage> createState() => _AddCouponPageState();
}

class _AddCouponPageState extends State<AddCouponPage> {
  @override
  void initState() {
    if(widget.coupon != null){
      widget.viewModel.fillDate(widget.coupon!);
    }else{
      widget.viewModel.clearDate();
    }
    super.initState();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWithoutBack(context, title: widget.coupon != null ? "Update Coupon" : "Add Coupon"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: widget.viewModel.formKey,
          child: ListView(
            children: [
              CustomField(
                controller: widget.viewModel.code,
                hint: "Code",
                validator:  (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a code';
                  }
                  return null;
                },
              ),
              AppSize.h20.ph,
              CustomField(
                controller: widget.viewModel.usageLimt,
                hint: "Usage limit",
                validator:  (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a usage limit';
                  }
                  return null;
                },
              ),
              AppSize.h20.ph,
              CustomField(
                controller: widget.viewModel.discountPrecentage,
                hint: "Discount precentage",
                keyboardType: TextInputType.number,
                validator:  (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid discount precentage';
                  }
                  return null;
                },
              ),
              AppSize.h20.ph,
              BlocBuilder<GenericCubit<DateTime?>, GenericCubitState<DateTime?>>(
                  bloc: widget.viewModel.validFrom,
                  builder: (context, state) {
                    return  ElevatedButton(
                      onPressed: () => widget.viewModel.selectDate(context, true),
                      child: Text('${state.data != null ? "Valid From: ${DateFormat('yyyy-MM-dd').format(state.data!)}" : 'Select Valid From Date'}'),
                    );
                  }
              ),
              AppSize.h20.ph,
              BlocBuilder<GenericCubit<DateTime?>, GenericCubitState<DateTime?>>(
                  bloc: widget.viewModel.validUntil,
                  builder: (context, state) {
                    return  ElevatedButton(
                      onPressed: () => widget.viewModel.selectDate(context, false),
                      child: Text('${state.data != null ?"Valid Until: ${DateFormat('yyyy-MM-dd').format(state.data!)}" : 'Select Valid Until Date'}'),
                    );
                  }
              ),
              AppSize.h40.ph,
              BlocBuilder<GenericCubit<bool>,
                  GenericCubitState<bool>>(
                  bloc: widget.viewModel.loading,
                  builder: (context, state) {
                    return state is GenericLoadingState || state.data
                        ? const Loading()
                        :  CustomButton(title: widget.coupon != null ? "Update Coupon" : "Add Coupon", onClick: (){
                          if (widget.coupon != null){
                            widget.viewModel.updateCoupon(widget.coupon?.couponId ?? "");
                          }else{
                            widget.viewModel.addCoupon();
                          }
                        });
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}
