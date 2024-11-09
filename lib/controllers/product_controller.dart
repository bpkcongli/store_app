import '../models/product.dart';

class ProductController {
  final List<Product> _products = [
    Product.build('Produk A', 'Ini deskripsi produk A', 100000),
    Product.build('Produk B', 'Ini deskripsi produk B', 100000),
    Product.build('Produk C', 'Ini deskripsi produk C', 100000),
    Product.build('Produk D', 'Ini deskripsi produk D', 100000),
  ];

  List<Product> getAllProducts() {
    return _products;
  }

  bool deleteProduct(String id) {
    _products.removeWhere((product) => product.id == id);

    return true;
  }
}
