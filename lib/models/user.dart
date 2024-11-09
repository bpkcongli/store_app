class User {
  final String username;
  final String password;

  User({ required this.username, required this.password });

  bool checkCredential(String username, String password) {
    return this.username == username && this.password == password;
  }
}
