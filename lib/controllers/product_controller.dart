import '../exceptions/product_invalid_state_exception.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

class ProductController {
  final ProductRepository _repository = ProductRepository();

  Future<bool> createProduct(String code, String name, double price) async {
    _checkNewProductValidity(code, name, price);

    await _repository.createProduct({
      'code': code,
      'name': name,
      'price': price,
    });

    return true;
  }

  Future<List<Product>> getAllProducts() async {
    return _repository.getAllProducts();
  }

  Future<Product> getSpecificProduct(String productId) {
    return _repository.getSpecificProduct(productId);
  }

  Future<bool> editProduct(String productId, String code, String name, double price) async {
    _checkNewProductValidity(code, name, price);

    await _repository.updateSpecificProduct(productId, {
      'code': code,
      'name': name,
      'price': price,
    });

    return true;
  }

  Future<bool> deleteProduct(String productId) async {
    await _repository.deleteSpecificProduct(productId);

    return true;
  }

  void _checkNewProductValidity(String code, String name, double price) {
    if (code.isEmpty) {
      throw ProductInvalidStateException('Product code is empty.');
    }

    if (name.isEmpty) {
      throw ProductInvalidStateException('Product description is empty.');
    }

    if (price <= 0) {
      throw ProductInvalidStateException('Product price less than or equal to 0.');
    }
  }
}
