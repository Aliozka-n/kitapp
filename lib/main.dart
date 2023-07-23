import 'package:flutter/material.dart';
import 'package:kitapp/const/app_colors.dart';
import 'package:kitapp/const/app_text.dart';
import 'package:kitapp/screens/login/login_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: AppColors.white,
          appBarTheme: const AppBarTheme(
              centerTitle: true, backgroundColor: AppColors.primary)),
      title: AppText.appName,
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
