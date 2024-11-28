import 'package:template/features/customer/cart/cart_viewModel.dart';
import 'package:template/features/customer/cart/models/product.dart';

class CartItem {
  Product? product;
  int quantity = 1;


  CartItem({this.product, this.quantity = 1});

  CartItem.fromJson(Map<String, dynamic> json) {
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['quantity'] = this.quantity;
    return data;
  }

  void increment() {
    quantity++;
  }

  void decrement() {
    if (quantity > 1) {
      quantity--;
    }
  }
}