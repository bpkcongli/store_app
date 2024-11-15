import 'package:flutter/material.dart';
import './common/theme.dart';
import './screens/user/user_auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: appTheme,
      home: const UserAuthScreen(),
    );
  }
}
