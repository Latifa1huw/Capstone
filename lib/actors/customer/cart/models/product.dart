class Product {
  String? id;
  String? name;
  String? description;
  double? price;
  String? supplier_id;
  String? imageUrl;

  Product( {
    this.id,
    this.name,
    this.description,
    this.price,
    this.imageUrl,
    this.supplier_id,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    description = json['description'];
    supplier_id = json['supplier_id'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['description'] = this.description;
    data['supplier_id'] = this.supplier_id;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}