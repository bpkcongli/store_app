import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './common/theme.dart';
import './repositories/product_repository.dart';
import './repositories/user_repository.dart';
import './screens/user/user_auth_screen.dart';
import './viewmodels/product_view_model.dart';
import './viewmodels/user_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel(UserRepository())),
        ChangeNotifierProvider(create: (_) => ProductViewModel(ProductRepository())),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: appTheme,
        home: const UserAuthScreen(),
      ),
    );
  }
}
