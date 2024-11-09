import '../api/api_service.dart';

class UserRepository {
  static const String userRegistrationEndpoint = '/users/registration';

  final ApiService _apiService = ApiService();

  Future<String> registration(Map<String, String> payload) async {
    final response = await _apiService.post(userRegistrationEndpoint, payload);
    return response['data']['userId'];
  }
}
