import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/features/customer/cart/models/CartItem.dart';
import 'package:template/features/salon/coupons/models/coupon.dart';
import 'package:template/features/salon/services/models/service.dart';
import 'package:template/shared/models/user_model.dart';

class OrderItem {
  String? bookingId;
  String? customerId;
  UserModel? customerData;
  String? salonId;
  User? salonData;
  // String? serviceId;
  List<Service>? serviceData;
  String? couponId;
  Coupon? couponData;
  DateTime? appointmentDate;
  String? appointmentTime;
  String? status;
  bool? rated;
  double? lat;
  double? long;
  String? trackingLocation;

  OrderItem(
      {this.bookingId,
        this.customerId,
        this.customerData,
        this.salonId,
        this.salonData,
        // this.serviceId,
        this.serviceData,
        this.couponId,
        this.couponData,
        this.appointmentDate,
        this.appointmentTime,
        this.status,
        this.rated,
        this.lat,
        this.long,
        this.trackingLocation});

  OrderItem.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    customerId = json['customer_id'];
    customerData = json['customer_data'] != null
        ? new UserModel.fromJson(json['customer_data'])
        : null;
    salonId = json['salon_id'];
    salonData = json['salon_data'] != null
        ? new User.fromJson(json['salon_data'])
        : null;
    // serviceId = json['service_id'];
    if (json['service_data'] != null) {
      serviceData = <Service>[];
      json['service_data'].forEach((v) {
        serviceData!.add(new Service.fromMap(v));
      });
    }
    couponId = json['coupon_id'];
    couponData = json['coupon_data'] != null
        ? new Coupon.fromJson(json['coupon_data'])
        : null;
    appointmentDate = (json['appointment_date'] as Timestamp).toDate();
    appointmentTime = json['appointmentTime'];
    status = json['status'];
    rated = json['rated'] ?? false;
    lat = json['lat'];
    long = json['long'];
    trackingLocation = json['tracking_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['customer_id'] = this.customerId;
    if (this.customerData != null) {
      data['customer_data'] = this.customerData!.toJson();
    }
    data['salon_id'] = this.salonId;
    if (this.salonData != null) {
      data['salon_data'] = this.salonData!.toJson();
    }
    // data['service_id'] = this.serviceId;
    if (this.serviceData != null) {
      data['service_data'] = this.serviceData!.map((v) => v.toMap()).toList();
    }
    data['coupon_id'] = this.couponId;
    if (this.couponData != null) {
      data['coupon_data'] = this.couponData!.toJson();
    }
    data['appointment_date'] = this.appointmentDate;
    data['appointmentTime'] = this.appointmentTime;
    data['status'] = this.status;
    data['rated'] = this.rated ?? false;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['tracking_location'] = this.trackingLocation;
    return data;
  }
}





// class OrderItem {
//   String? id;
//   String? userId;
//   List<CartItem>? cartItem;
//
//   OrderItem({this.id, this.userId, this.cartItem});
//
//   OrderItem.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['userId'];
//     if (json['cartItem'] != null) {
//       cartItem = <CartItem>[];
//       json['cartItem'].forEach((v) {
//         cartItem!.add(new CartItem.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['userId'] = this.userId;
//     if (this.cartItem != null) {
//       data['cartItem'] = this.cartItem!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }