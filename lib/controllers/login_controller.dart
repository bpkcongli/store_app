import '../models/user.dart';
import '../repositories/user_repository.dart';

class LoginController {
  final UserRepository _repository = UserRepository();
  final User _registeredUser = User(username: 'andrian', email: 'andrian8367@gmail.com', password: '0004');

  Future<bool> registration(String username, String email, String password) async {
    await _repository.registration({
      'username': username,
      'email': email,
      'password': password,
    });

    return true;
  }

  bool login(String username, String password) {
    return _registeredUser.checkCredential(username, password);
  }

  bool logout(String username) {
    return true;
  }
}
