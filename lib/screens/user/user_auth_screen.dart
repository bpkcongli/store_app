import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './user_registration_screen.dart';
import '../product/product_list_screen.dart';
import '../../common/user_info.dart';
import '../../viewmodels/user_view_model.dart';

class UserAuthScreen extends StatefulWidget {
  const UserAuthScreen({super.key});

  @override
  State<UserAuthScreen> createState() => _UserAuthScreenState();
}

class _UserAuthScreenState extends State<UserAuthScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
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
    _passwordController.dispose();
  }

  Future<void> onPressedLoginButtonHandler(VoidCallback callback) async {
    final viewModel = context.read<UserViewModel>();
    final username = _usernameController.text;
    final password = _passwordController.text;
    final authenticateResult = await viewModel.authenticate(username, password);

    if (authenticateResult) {
      callback();
    }
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
                  onPressed: () {
                    onPressedLoginButtonHandler(() {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          UserInfo().setUsername(_usernameController.text);
                          return const ProductListScreen();
                        }),
                      );
                    });
                  },
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

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
