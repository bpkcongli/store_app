import '../api/api_service.dart';
import '../common/user_info.dart';
import '../models/product.dart';

class ProductRepository {
  final ApiService _apiService = ApiService();

  Future<List<Product>> getAllProducts() async {
    final authorizationHeader = await _getAuthorizationHeader();
    final response = await _apiService.get('/products', { ...authorizationHeader });

    return (response['data'] as List<dynamic>)
      .map<Product>((data) => Product.fromJson(data))
      .toList();
  }

  Future<Map<String, String>> _getAuthorizationHeader() async {
    final token = await UserInfo().getToken();

    return {
      'Authorization': 'Bearer $token',
    };
  }
}
