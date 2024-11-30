class Service {
  String? serviceId;
  String? name;
  String? imageUrl;
  String? description;
  double? price;
  String? duration;
  int? number_of_employees;
  String? availability;
  String? category;
  String? salonId;

  Service({
    this.serviceId,
    this.name,
    this.imageUrl,
    this.description,
    this.price,
    this.duration,
    this.category,
    this.number_of_employees,
    this.availability,
    this.salonId,
  });

  // Convert Service object to a map to upload to Firestore
  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'price': price,
      'category': category,
      'duration': duration,
      'number_of_employees': number_of_employees,
      'availability': availability,
      'salonId': salonId,
    };
  }

  // Convert Firestore document to Service object
  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      serviceId: map['serviceId'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      duration: map['duration'] ?? '',
      availability: map['availability'] ?? false,
      salonId: map['salonId'] ?? '',
      category: map['category'] ?? '',
      number_of_employees: map['number_of_employees'] ?? 0,
    );
  }
}
