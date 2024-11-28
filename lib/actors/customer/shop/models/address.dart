import 'package:template/shared/models/user_model.dart';

class Address {
  String? id;
  String? locationName;
  String? details;
  String? customerId;
  UserModel? customerData;

  Address(
      {this.id,
        this.locationName,
        this.details,
        this.customerId,
        this.customerData});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locationName = json['location_name'];
    details = json['details'];
    customerId = json['customer_id'];
    customerData = json['Customer_data'] != null
        ? new UserModel.fromJson(json['Customer_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['location_name'] = this.locationName;
    data['details'] = this.details;
    data['customer_id'] = this.customerId;
    if (this.customerData != null) {
      data['Customer_data'] = this.customerData!.toJson();
    }
    return data;
  }
}