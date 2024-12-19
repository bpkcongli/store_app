import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './common/theme.dart';
import './common/user_info.dart';
import './repositories/product_repository.dart';
import './repositories/user_repository.dart';
import './screens/product/product_list_screen.dart';
import './screens/user/user_auth_screen.dart';
import './viewmodels/product_view_model.dart';
import './viewmodels/user_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = const CircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    checkIsLogin();
  }

  void checkIsLogin() async {
    final token = await UserInfo().getToken();

    if (token != null) {
      setState(() {
        page = const ProductListScreen();
      });
    } else {
      setState(() {
        page = const UserAuthScreen();
      });
    }
  }

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
        home: page,
      ),
    );
  }
}
