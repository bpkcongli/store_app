import '../exceptions/product_invalid_state_exception.dart';
import '../models/product.dart';

class ProductController {
  List<Product> _products = [
    Product.build('Produk A', 'Ini deskripsi produk A', 100000),
    Product.build('Produk B', 'Ini deskripsi produk B', 100000),
    Product.build('Produk C', 'Ini deskripsi produk C', 100000),
    Product.build('Produk D', 'Ini deskripsi produk D', 100000),
  ];

  void addNewProduct(String name, String description, double price) {
    _checkNewProductValidity(name, description, price);

    _products.add(Product.build(name, description, price));
  }

  List<Product> getAllProducts() {
    return _products;
  }

  Product getSpecificProduct(String id) {
    return _products.first;
    // return products.firstWhere((product) => product.id == id);
  }

  bool editProduct(String id, String name, String description, double price) {
    _products = _products.map((product) {
      return product.id == id ? product.edit(name, description, price) : product;
    }).toList();

    return true;
  }

  bool deleteProduct(String id) {
    _products.removeWhere((product) => product.id == id);

    return true;
  }

  void _checkNewProductValidity(String name, String description, double price) {
    if (name.isEmpty) {
      throw ProductInvalidStateException('Product name is empty.');
    }

    if (description.isEmpty) {
      throw ProductInvalidStateException('Product description is empty.');
    }

    if (price <= 0) {
      throw ProductInvalidStateException('Product price less than or equal to 0.');
    }
  }
}
