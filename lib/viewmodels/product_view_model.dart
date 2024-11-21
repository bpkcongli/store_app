import 'package:flutter/material.dart';
import '../exceptions/app_exception.dart';
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
      notifyListeners();
    } on AppException catch (e) {
      _setApiErrorMessage(e.message);
    }
  }

  void clearError() {
    _apiErrorMessage = null;
    notifyListeners();
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
