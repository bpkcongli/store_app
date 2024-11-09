import '../api/api_service.dart';

class UserRepository {
  static const String userRegistrationEndpoint = '/users/registration';
  static const String userAuthenticationEndpoint = '/users/authenticate';

  final ApiService _apiService = ApiService();

  Future<String> registration(Map<String, String> payload) async {
    final response = await _apiService.post(userRegistrationEndpoint, payload);
    return response['data']['userId'];
  }

  Future<String> authenticate(Map<String, String> payload) async {
    final response = await _apiService.post(userAuthenticationEndpoint, payload);
    return response['data']['accessToken'];
  }
}
