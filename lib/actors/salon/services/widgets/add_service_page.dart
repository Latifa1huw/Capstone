import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/features/authentication/user_viewModel.dart';
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

class AddServicePage extends StatefulWidget {
  final ServiceViewModel viewModel;
  final Service? service;
  const AddServicePage({Key? key, required this.viewModel, required this.service}) : super(key: key);

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  UserViewModel userViewModel = UserViewModel();

  @override
  void initState() {
    if(widget.service != null){
      widget.viewModel.fillDate(widget.service!);
    }else{
      widget.viewModel.clearDate();
    }
    super.initState();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWithoutBack(context, title: widget.service != null ? "Update Service" : "Add Service"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: widget.viewModel.formKey,
          child: ListView(
            children: [
              BlocBuilder<GenericCubit<String?>, GenericCubitState<String?>>(
                  bloc: widget.viewModel.selectedCategory,
                  builder: (context, state) {
                    return CustomDropdown(
                        value: state.data,
                        hint: "Category",
                        items: widget.viewModel.categories.map((e){
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e, style:  AppStyles.kTextStyleHeader14.copyWith(
                              color: AppColors.kBlackColor,
                            ),),
                          );
                        }).toList(),
                        onChange: (e){
                          widget.viewModel.selectedCategory.onUpdateData(e);
                        }
                    );
                  }
              ),
              AppSize.h20.ph,
              CustomField(
                controller: widget.viewModel.name,
                hint: "Name",
                validator:  (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              AppSize.h20.ph,
              CustomField(
                controller: widget.viewModel.description,
                hint: "Description",
                maxLines: 4,
                validator:  (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              AppSize.h20.ph,
              CustomField(
                controller: widget.viewModel.price,
                hint: "Price",
                keyboardType: TextInputType.number,
                validator:  (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              AppSize.h20.ph,
              CustomField(
                controller: widget.viewModel.number_of_employees,
                hint: "Number of employees",
                keyboardType: TextInputType.number,
                validator:  (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null) {
                    return 'Please enter a valid number of employees';
                  }
                  return null;
                },
              ),
              AppSize.h20.ph,
              CustomField(
                controller: widget.viewModel.duration,
                hint: "Duration",
                keyboardType: TextInputType.number,
                validator:  (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid duration';
                  }
                  return null;
                },
              ),
              AppSize.h20.ph,

              /*Text("Availability", style: AppStyles.kTextStyleHeader18,),
              AppSize.h10.ph,
              BlocBuilder<GenericCubit<String?>, GenericCubitState<String?>>(
                  bloc: widget.viewModel.fromTime,
                  builder: (context, state) {
                    return CustomDropdown(
                        value: state.data,
                        hint: "Start To",
                        items: userViewModel.timeSlots.map((e){
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e, style:  AppStyles.kTextStyleHeader14.copyWith(
                              color: AppColors.kBlackColor,
                            ),),
                          );
                        }).toList(),
                        onChange: (e){
                          widget.viewModel.fromTime.onUpdateData(e);
                        }
                    );
                  }
              ),
              AppSize.h20.ph,
              BlocBuilder<GenericCubit<String?>, GenericCubitState<String?>>(
                  bloc: widget.viewModel.toTime,
                  builder: (context, state) {
                    return CustomDropdown(
                        value: state.data,
                        hint: "Start To",
                        items: userViewModel.timeSlots.map((e){
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e, style:  AppStyles.kTextStyleHeader14.copyWith(
                              color: AppColors.kBlackColor,
                            ),),
                          );
                        }).toList(),
                        onChange: (e){
                          widget.viewModel.toTime.onUpdateData(e);
                        }
                    );
                  }
              ),
              AppSize.h20.ph,*/

              TextButton.icon(
                onPressed:  widget.viewModel.pickImage,
                icon: const Icon(Icons.image),
                label: Text('Select Service Image', style: AppStyles.kTextStyle18,),
              ),
              BlocBuilder<GenericCubit<File?>, GenericCubitState<File?>>(
                  bloc:  widget.viewModel.imageFile,
                  builder: (s, state){
                    return state.data != null ?
                    Image.file(state.data!, height: 150):
                    Container(height: 150, color: Colors.grey[300], child: Icon(Icons.image));
                  }
              ),
              AppSize.h40.ph,
              BlocBuilder<GenericCubit<bool>,
                  GenericCubitState<bool>>(
                  bloc: widget.viewModel.loading,
                  builder: (context, state) {
                    return state is GenericLoadingState || state.data
                        ? const Loading()
                        :  CustomButton(title: widget.service != null ? "Update Service" : "Add Service", onClick: (){
                          if (widget.service != null){
                            widget.viewModel.updateService(widget.service?.serviceId ?? "");
                          }else{
                            widget.viewModel.addService();
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
