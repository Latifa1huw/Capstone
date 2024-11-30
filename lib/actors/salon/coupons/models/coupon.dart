import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template/shared/models/user_model.dart';

class Coupon {
  String? couponId;
  String? code;
  double? discountPrecentage;
  DateTime? validFrom;
  DateTime? validUntil;
  String? usageLimt;
  String? salonId;
  UserModel? salonData;

  Coupon(
      {this.couponId,
        this.code,
        this.discountPrecentage,
        this.validFrom,
        this.validUntil,
        this.usageLimt,
        this.salonId,
        this.salonData});

  Coupon.fromJson(Map<String, dynamic> json) {
    couponId = json['coupon_id'];
    code = json['code'];
    discountPrecentage = json['discount_precentage'];
    validFrom = (json['valid_from'] as Timestamp).toDate();
    validUntil = (json['valid_until'] as Timestamp).toDate();
    usageLimt = json['usage_limt'];
    salonId = json['salon_id'];
    salonData = json['salon_data'] != null
        ? new UserModel.fromJson(json['salon_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coupon_id'] = this.couponId;
    data['code'] = this.code;
    data['discount_precentage'] = this.discountPrecentage;
    data['valid_from'] = this.validFrom;
    data['valid_until'] = this.validUntil;
    data['usage_limt'] = this.usageLimt;
    data['salon_id'] = this.salonId;
    if (this.salonData != null) {
      data['salon_data'] = this.salonData!.toJson();
    }
    return data;
  }
}
