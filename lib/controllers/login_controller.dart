import '../models/user.dart';

class LoginController {
  final User _registeredUser = User(username: 'andrian', password: '0004');

  bool login(String username, String password) {
    return _registeredUser.checkCredential(username, password);
  }

  bool logout(String username) {
    return true;
  }
}
