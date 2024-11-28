import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:template/features/customer/cart/cart_viewModel.dart';
import 'package:template/features/customer/cart/models/CartItem.dart';
import 'package:template/features/customer/cart/models/product.dart';
import 'package:template/features/customer/orders/models/order.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/widgets/CustomAppBar.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      body: Padding(
        padding: EdgeInsets.only(top: 10.0.sp, left: 10.sp, right: 10.sp, bottom: 20.sp,),
        child: Column(
          children: [
            customAppBar(context),
            Expanded(
              child: Provider.of<CartViewModel>(context, listen: false).items.isEmpty? EmptyData(): ListView.builder(
                itemCount:  Provider.of<CartViewModel>(context, listen: false).items.length,
                itemBuilder: (context, index) {
                  final item =  Provider.of<CartViewModel>(context, listen: false).items[index];
                  return _buildCartItem(item);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total: ${Provider.of<CartViewModel>(context, listen: false).totalPrice.toStringAsFixed(2)}SR',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            BlocBuilder<GenericCubit<bool>, GenericCubitState<bool>>(
              bloc: Provider.of<CartViewModel>(context, listen: false).loading,
              builder: (context, state) {
                return state.data? const Loading():
                CustomButton(
                    title: "Checkout",
                    btnColor: AppColors.greenColor580,
                    onClick: (){
                      // OrderItem order = OrderItem();
                      // order.s = Provider.of<CartViewModel>(context, listen: false).items;
                      // Provider.of<CartViewModel>(context, listen: false).orderCheckOut(order);
                });
              }
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.network(item.product?.imageUrl ?? "", width: 50, height: 50),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product?.name ?? "", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('${item.product?.price?.toStringAsFixed(2)}SR'),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      item.decrement();
                      if (item.quantity == 0) {
                        Provider.of<CartViewModel>(context, listen: false).removeFromCart(item.product ?? Product());
                      }
                    });
                  },
                ),
                Text('${item.quantity}', style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      item.increment();
                    });
                  },
                ),
              ],
            ),
            SizedBox(width: 10),
            Text('${(item.product!.price! * item.quantity).toStringAsFixed(2)}SR', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
