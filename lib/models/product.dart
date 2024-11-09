import 'package:uuid/uuid.dart';

class Product {
  String id;
  String code;
  String name;
  double price;

  Product(this.id, this.code, this.name, this.price);

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(json['id'], json['code'], json['name'], double.parse(json['price']));
  }

  factory Product.build(String name, String description, double price) {
    const uuid = Uuid();
    
    return Product(uuid.v4(), name, description, price);
  }

  Product edit(String name, String description, double price) {
    name = name;
    description = description;
    price = price;

    return this;
  }
}
