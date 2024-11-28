import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:template/features/Customer/cart/cart_viewModel.dart';
import 'package:template/features/Customer/cart/widgets/CartIconWidget.dart';
import 'package:template/features/customer/cart/models/product.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/widgets/CustomAppBar.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      appBar: AppBar(
        title: Text(widget.product.name ?? "", style: AppStyles.kTextStyle22.copyWith(
            color: AppColors.kWhiteColor,
            fontWeight: FontWeight.bold
        ),),
        backgroundColor: AppColors.kMainColor.withOpacity(.5),
        centerTitle: true, // Center the title
        elevation: 0,
        actions: [
          CartIconWidget()
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Image.network(
              widget.product.imageUrl ?? "",
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name ?? "",
                  style: AppStyles.kTextStyle22.copyWith( fontWeight: FontWeight.bold),
                ),
                AppSize.h10.ph,
                Text(
                  widget.product.description ?? "",
                  style: AppStyles.kTextStyle16.copyWith( color: Colors.grey[600]),
                ),
                AppSize.h20.ph,
                Text(
                  '${widget.product.price?.toStringAsFixed(2)}SR',
                  style: AppStyles.kTextStyle20.copyWith( fontWeight: FontWeight.bold, color: Colors.green),
                ),
                AppSize.h40.ph,

                CustomButton(title: "Add to cart", onClick: (){
                  Provider.of<CartViewModel>(context, listen: false).addToCart(widget.product);
                }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
