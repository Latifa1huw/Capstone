import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/Customer/cart/cart_viewModel.dart';
import 'package:template/features/Customer/home/widgets/ProductDetailPage.dart';
import 'package:template/features/customer/cart/models/product.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';

class Productwidget extends StatefulWidget {
  final Product product;
  const Productwidget({Key? key, required this.product}) : super(key: key);

  @override
  State<Productwidget> createState() => _ProductwidgetState();
}

class _ProductwidgetState extends State<Productwidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: widget.product),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        color: AppColors.kWhiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.network(
                widget.product.imageUrl ??"",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name ?? "",
                    style: AppStyles.kTextStyle20.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.product.description ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.kTextStyle14.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  AppSize.h10.ph,
                  Text(
                    '${widget.product.price?.toStringAsFixed(2)}SR',
                    style: AppStyles.kTextStyle16.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
