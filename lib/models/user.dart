class User {
  final String username;
  final String email;
  final String password;

  User({ required this.username, required this.email, required this.password });

  bool checkCredential(String username, String password) {
    return this.username == username && this.password == password;
  }
}
