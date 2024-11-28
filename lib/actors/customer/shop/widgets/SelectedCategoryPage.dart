import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/features/customer/cart/cart_viewModel.dart';
import 'package:template/features/salon/services/models/service.dart';
import 'package:template/features/salon/services/service_viewModel.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';

class SelectedCategoryPage extends StatefulWidget {
  final CartViewModel cartViewModel;
  final ServiceViewModel viewModel;
  final User salon;
  const SelectedCategoryPage({Key? key, required this.cartViewModel, required this.viewModel, required this.salon}) : super(key: key);

  @override
  State<SelectedCategoryPage> createState() => _SelectedCategoryPageState();
}

class _SelectedCategoryPageState extends State<SelectedCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two elements per row
        crossAxisSpacing: 10.sp, // Spacing between items horizontally
        mainAxisSpacing: 10.sp, // Spacing between items vertically
        childAspectRatio: 2.8, // Adjust aspect ratio for a good layout
      ),
      padding: EdgeInsets.all(10),
      itemCount: widget.viewModel.categories.length,
      itemBuilder: (context, index) {
        final service = widget.viewModel.categories[index];
        return CategoryCard(category: service, cartViewModel: widget.cartViewModel, viewModel: widget.viewModel, index: index, salon: widget.salon,);
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  final User salon;
  final String category;
  final CartViewModel cartViewModel;
  final ServiceViewModel viewModel;
  final int index;
  const CategoryCard({Key? key, required this.category, required this.cartViewModel, required this.viewModel, required this.index, required this.salon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return BlocBuilder<GenericCubit<String?>, GenericCubitState<String?>>(
        bloc: cartViewModel.selectCategoryServices,
        builder: (context, state) {
          return InkWell(
            onTap: (){
              cartViewModel.selectCategoryServices.onUpdateData(category);
              // viewModel.getServicesByCategory(category);
              viewModel.getServicesByCategoryAndSalonId(category, salon.id ?? "");
            },
            child: Card(
              elevation: 4,
              color: AppColors.kWhiteColor,
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: ( category == state.data ) ? const BorderSide(color: AppColors.kBlueColor580, width: 3):  BorderSide.none
              ),
              child: Container(
                padding: EdgeInsets.all(10.sp),
                alignment: Alignment.center,
                child: Text(
                  category ?? "",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}

