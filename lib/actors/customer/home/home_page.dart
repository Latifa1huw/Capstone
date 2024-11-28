import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/customer/cart/widgets/CartIconWidget.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ProductsViewModel viewModel = ProductsViewModel();

  @override
  void initState() {
    // viewModel.getAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: AppStyles.kTextStyle22.copyWith(
            color: AppColors.kWhiteColor,
            fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.kMainColor,
        actions: [
          CartIconWidget()
        ],
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: BlocBuilder<GenericCubit<List<Product>>,
      //       GenericCubitState<List<Product>>>(
      //       bloc: viewModel.allProducts,
      //       builder: (context, state) {
      //         var products = state.data;
      //         return state is GenericLoadingState ? const Loading()
      //             : Padding(
      //             padding: EdgeInsets.all(10.0.sp),
      //         child: state.data.isEmpty ? const EmptyData():
      //         ListView.builder(
      //         itemCount: products.length,
      //         padding: EdgeInsets.only(bottom: 150.sp),
      //         itemBuilder: (context, index) {
      //           final product = products[index];
      //           return Productwidget(product: product);
      //         },
      //       ));
      //     }
      //   ),
      // ),
    );
  }
}