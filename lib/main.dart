import 'package:flutter/material.dart';
import 'package:kitapp/const/app_text.dart';
import 'package:kitapp/screens/login/login_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppText.appName,
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
