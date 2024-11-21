import 'package:flutter/material.dart';
import '../common/user_info.dart';
import '../repositories/user_repository.dart';
import '../../exceptions/app_exception.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _repository;

  UserViewModel(this._repository);

  String? _apiErrorMessage;
  String? get apiErrorMessage => _apiErrorMessage;

  Future<bool> registration(String username, String email, String password) async {
    try {
      await _repository.registration({
        'username': username,
        'email': email,
        'password': password,
      });

      return true;
    } on AppException catch (e) {
      _setApiErrorMessage(e.message);
    }

    return false;
  }

  Future<bool> authenticate(String username, String password) async {
    try {
      final accessToken = await _repository.authenticate({
        'username': username,
        'password': password,
      });

      await UserInfo().setToken(accessToken);

      return true;
    } on AppException catch (e) {
      _setApiErrorMessage(e.message);
    }

    return false;
  }

  Future<bool> logout() async {
    return UserInfo().logout();
  }

  void clearError() {
    _apiErrorMessage = null;
    notifyListeners();
  }

  void _setApiErrorMessage(String apiErrorMessage) {
    _apiErrorMessage = apiErrorMessage;
    notifyListeners();
  }
}
