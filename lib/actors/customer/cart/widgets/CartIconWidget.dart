import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:template/features/customer/cart/cart_page.dart';
import 'package:template/features/customer/cart/cart_viewModel.dart';
import 'package:template/features/customer/cart/cart_viewModel.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/resources.dart';

class CartIconWidget extends StatefulWidget {
  const CartIconWidget({Key? key}) : super(key: key);

  @override
  State<CartIconWidget> createState() => _CartIconWidgetState();
}

class _CartIconWidgetState extends State<CartIconWidget> {
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartViewModel>(context); // If this fails, Provider is not in scope
    print(cart.totalItems); // Debugging purpose

    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CartPage()),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(3.0.sp),
        child: Stack(
          children: [
            IconButton(
              icon: Image.asset(Resources.cart, color: AppColors.kWhiteColor, height: 45.sp,width: 45.sp,),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
              },
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Consumer<CartViewModel>(
                builder: (context, cart, child) {
                  return cart.totalItems > 0
                      ? Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '${cart.totalItems}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                      : SizedBox();
                },
              ),
            ),
           /* Positioned(
              right: 8,
              top: 8,
              child: Consumer<CartViewModel>(
                builder: (context, cart, child) {
                  return cart.totalItems > 0
                      ? Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '${cart.totalItems}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                      : SizedBox();
                },
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
