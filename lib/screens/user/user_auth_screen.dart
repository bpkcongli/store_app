import 'package:flutter/material.dart';
import './user_registration_screen.dart';
import '../product/product_list_screen.dart';
import '../../controllers/login_controller.dart';
import '../../exceptions/app_exception.dart';

class UserAuthScreen extends StatefulWidget {
  const UserAuthScreen({super.key});

  @override
  State<UserAuthScreen> createState() => _UserAuthScreenState();
}

class _UserAuthScreenState extends State<UserAuthScreen> {
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

  void onPressedLoginButtonHandler() {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final bool isMounted = context.mounted;

    _loginController.authenticate(username, password)
      .then((isLoginSucceed) {
        if (isLoginSucceed) {
          if (isMounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) {
                return ProductListScreen(username: username);
              }),
            );
          }
        }
      }).onError((AppException e, _) {
        if (isMounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.message),
          ));
        }
      });
  }

  void onPressedRegisterButtonHandler() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return const UserRegistrationScreen();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan username',
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Masukkan password',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressedLoginButtonHandler,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  child: const Text('LOGIN'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressedRegisterButtonHandler,
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Colors.amber, width: 2),
                    backgroundColor: Colors.amber[50],
                  ),
                  child: const Text('REGISTER'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
