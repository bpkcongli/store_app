import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import '../screens/product_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ super.key });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginController _loginController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _loginController = LoginController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  void onPressedSubmitButtonHandler() {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final isLoginSucceed = _loginController.login(username, password);

    if (isLoginSucceed) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        return ProductListScreen(username: username);
      }));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Kredensial yang Anda masukkan salah."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  label: Text('Username'),
                  hintText: 'Masukkan username',
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text('Password'),
                  hintText: 'Masukkan password',
                ),
              ),
              ElevatedButton(
                onPressed: onPressedSubmitButtonHandler,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
