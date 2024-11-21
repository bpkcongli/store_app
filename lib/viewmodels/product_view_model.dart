import 'package:flutter/material.dart';
import '../exceptions/app_exception.dart';
import '../exceptions/product_invalid_state_exception.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepository _repository;

  ProductViewModel(this._repository);

  List<Product> _products = [];
  List<Product> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _apiErrorMessage;
  String? get apiErrorMessage => _apiErrorMessage;

  Future<void> getAllProducts() async {
    _setIsLoading(true);

    try {
      _products = await _repository.getAllProducts();
      _setIsLoading(false);
    } on AppException catch (e) {
      _setApiErrorMessage(e.message);
    }
  }

  Future<Product?> getSpecificProduct(String productId) async {
    try {
      return _repository.getSpecificProduct(productId);
    } on AppException catch (e) {
      _setApiErrorMessage(e.message);
    }

    return null;
  }

  Future<bool> createProduct(String code, String name, double price) async {
    _checkNewProductValidity(code, name, price);

    try {
      await _repository.createProduct({
        'code': code,
        'name': name,
        'price': price,
      });

      return true;
    } on AppException catch (e) {
      _setApiErrorMessage(e.message);
    }

    return false;
  }

  Future<bool> editProduct(String productId, String code, String name, double price) async {
    _checkNewProductValidity(code, name, price);

    try {
      await _repository.updateSpecificProduct(productId, {
        'code': code,
        'name': name,
        'price': price,
      });

      return true;
    } on AppException catch (e) {
      _setApiErrorMessage(e.message);
    }

    return false;
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      await _repository.deleteSpecificProduct(productId);

      return true;
    } on AppException catch (e) {
      _setApiErrorMessage(e.message);
    }

    return false;
  }

  void clearError() {
    _apiErrorMessage = null;
    notifyListeners();
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

  void _setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void _setApiErrorMessage(String apiErrorMessage) {
    _apiErrorMessage = apiErrorMessage;
    notifyListeners();
  }
}
