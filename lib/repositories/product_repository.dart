import '../api/api_service.dart';
import '../common/user_info.dart';
import '../models/product.dart';

class ProductRepository {
  final ApiService _apiService = ApiService();

  Future<String> createProduct(Map<String, dynamic> payload) async {
    final authorizationHeader = await _getAuthorizationHeader();
    final response = await _apiService.post('/products', payload, { ...authorizationHeader });

    return response['data']['productId'];
  }

  Future<List<Product>> getAllProducts() async {
    final authorizationHeader = await _getAuthorizationHeader();
    final response = await _apiService.get('/products', { ...authorizationHeader });

    return (response['data'] as List<dynamic>)
      .map<Product>((data) => Product.fromJson(data))
      .toList();
  }

  Future<Product> getSpecificProduct(String productId) async {
    final authorizationHeader = await _getAuthorizationHeader();
    final response = await _apiService.get('/products/$productId', { ...authorizationHeader });

    return Product.fromJson(response['data']);
  }

  Future<Null> updateSpecificProduct(String productId, Map<String, dynamic> payload) async {
    final authorizationHeader = await _getAuthorizationHeader();
    final response = await _apiService.put('/products/$productId', payload, { ...authorizationHeader });

    return response['data'];
  }

  Future<Map<String, String>> _getAuthorizationHeader() async {
    final token = await UserInfo().getToken();

    return {
      'Authorization': 'Bearer $token',
    };
  }
}
