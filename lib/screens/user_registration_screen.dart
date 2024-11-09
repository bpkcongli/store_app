import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import '../exceptions/app_exception.dart';
import '../screens/login_screen.dart';

class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({super.key});

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  late LoginController _loginController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _loginController = LoginController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void onPressedRegisterButtonHandler() {
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final bool isMounted = context.mounted;

    _loginController.registration(username, email, password)
      .then((isRegistrationSucceed) {
        if (isRegistrationSucceed) {
          if (isMounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Registrasi user berhasil.'),
            ));

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) {
                return const LoginScreen();
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

  void onPressedLoginButtonHandler() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return const LoginScreen();
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
                'Register',
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
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan email',
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
                  onPressed: onPressedRegisterButtonHandler,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  child: const Text('REGISTER'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressedLoginButtonHandler,
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Colors.amber, width: 2),
                    backgroundColor: Colors.amber[50],
                  ),
                  child: const Text('LOGIN'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
