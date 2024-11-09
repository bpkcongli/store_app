class Product {
  String id;
  String code;
  String name;
  double price;

  Product(this.id, this.code, this.name, this.price);

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(json['id'], json['code'], json['name'], double.parse(json['price']));
  }
}
