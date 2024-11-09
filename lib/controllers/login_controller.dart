import '../common/user_info.dart';
import '../repositories/user_repository.dart';

class LoginController {
  final UserRepository _repository = UserRepository();

  Future<bool> registration(String username, String email, String password) async {
    await _repository.registration({
      'username': username,
      'email': email,
      'password': password,
    });

    return true;
  }

  Future<bool> authenticate(String username, String password) async {
    final accessToken = await _repository.authenticate({
      'username': username,
      'password': password,
    });

    await UserInfo().setToken(accessToken);

    return true;
  }

  Future<bool> logout() async {
    return UserInfo().logout();
  }
}
