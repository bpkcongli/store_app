import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  Future<bool> setToken(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString('token', value);
  }

  Future<String?> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('token');
  }

  Future<bool> logout() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.clear();
  }
}
