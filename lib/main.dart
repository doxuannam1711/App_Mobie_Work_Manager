import 'package:flutter/material.dart';
import 'package:flutter_application/my_boards/my_boards_screen.dart';
import 'account/account_screen.dart';
import 'login/login_screen.dart';
import 'profile_and_display/profile_and_display_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}


