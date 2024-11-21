import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './user_auth_screen.dart';
import '../../viewmodels/user_view_model.dart';

class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({super.key});

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final viewModel = context.watch<UserViewModel>();
    if (viewModel.apiErrorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSnackBar(context, viewModel.apiErrorMessage!);
        viewModel.clearError();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> onPressedRegisterButtonHandler(VoidCallback callback) async {
    final viewModel = context.read<UserViewModel>();
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    final registrationResult = await viewModel.registration(username, email, password);
    if (registrationResult) {
      callback();
    }
  }

  void onPressedLoginButtonHandler() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return const UserAuthScreen();
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
                  onPressed: () {
                    onPressedRegisterButtonHandler(() {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Registrasi user berhasil.'),
                      ));

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return const UserAuthScreen();
                        }),
                      );
                    });
                  },
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

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
