import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/shared/models/user_model.dart';

class Rating {
  String? rateId;
  int? rate;
  String? comment;
  UserModel? customerData;
  String? customerId;
  User? salonData;
  String? salonId;
  String? bookingId;
  DateTime? createdAt;

  Rating(
      {this.rateId,
        this.rate,
        this.comment,
        this.customerData,
        this.customerId,
        this.salonData,
        this.salonId,
        this.createdAt,
        this.bookingId});

  Rating.fromJson(Map<String, dynamic> json) {
    rateId = json['rate_id'];
    rate = json['rate'];
    comment = json['comment'];
    customerData = json['customer_data'] != null
        ? new UserModel.fromJson(json['customer_data'])
        : null;
    customerId = json['customer_id'];
    createdAt = (json['createdAt'] as Timestamp).toDate();
    salonData = json['salon_data'] != null
        ? new User.fromJson(json['salon_data'])
        : null;
    salonId = json['salon_id'];
    bookingId = json['booking_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rate_id'] = this.rateId;
    data['rate'] = this.rate;
    data['createdAt'] = DateTime.now();
    data['comment'] = this.comment;
    if (this.customerData != null) {
      data['customer_data'] = this.customerData!.toJson();
    }
    data['customer_id'] = this.customerId;
    if (this.salonData != null) {
      data['salon_data'] = this.salonData!.toJson();
    }
    data['salon_id'] = this.salonId;
    data['booking_id'] = this.bookingId;
    return data;
  }
}