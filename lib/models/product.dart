import 'package:uuid/uuid.dart';

class Product {
  String id;
  String name;
  String description;
  double price;

  Product._(this.id, this.name, this.description, this.price);

  static Product build(String name, String description, double price) {
    const uuid = Uuid();
    
    return Product._(uuid.v4(), name, description, price);
  }
}
