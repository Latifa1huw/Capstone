import 'package:template/features/authentication/models/user.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? password;
  String? profile_image;
  String? owner_name;
  String? status;
  String? account_type;
  String? token;
  int? type;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.password,
    this.profile_image,
    this.owner_name,
    this.status,
    this.account_type,
    this.type,
  });

  // Convert a Customer object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'password': password,
      'profile_image': profile_image,
      'type': type,
    };
  }

  // Convert a Customer object to a Map
  Map<String, dynamic> toMapLogin() {
    return {
      'email': email,
      'password': password,
    };
  }

  // Convert a Admin object to a Map
  Map<String, dynamic> toMapAdmin() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'phone': phone,
      'password': password,
      'type': type,
    };
  }

  // Convert a Salon object to a Map
  Map<String, dynamic> toMapSalon() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'password': password,
      'owner_name': owner_name,
      'status': status,
      'profile_image': profile_image,
      'account_type': account_type,
      'type': type,
    };
  }

  // Convert toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'password': password,
      'owner_name': owner_name,
      'status': status,
      'profile_image': profile_image,
      'account_type': account_type,
      'type': type,
    };
  }

  // Create a Customer object from a Map
  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      password: map['password'],
      account_type: map['account_type'],
      status: map['status'],
      owner_name: map['owner_name'],
      profile_image: map['profile_image'],
      type: map['type'],
    );
  }
}