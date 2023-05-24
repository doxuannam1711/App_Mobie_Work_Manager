import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'change_password_screen.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}
class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final TextEditingController emailController = TextEditingController();
  final emailFocusNode = FocusNode();

  Map<String, dynamic> userList = {};
  int userID = 0;

  @override
  void initState() {
    super.initState();
    getUserList();
  }

  Future<Map<String, dynamic>> getUserList() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.7/api/getAccountLogin'));
    if (response.statusCode == 200) {
      setState(() {
        userList = jsonDecode(response.body);
      });
      return userList;
    } else {
      throw Exception('Failed to load user list');
    }
  }

  bool validateUser(String email) {
    List<dynamic> users = jsonDecode(userList['Data']);
    for (var user in users) {
      if (email == user['Email']) {
        userID = user['UserID'];
        return true;
      }
    }
    return false;
  }

  void onPressedNext(BuildContext context) {
    String email = emailController.text;
    if (email.isNotEmpty &&
        validateUser(email)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangePasswordScreen(userID),
        ),
      );
    } else {
      // Show error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Tài khoản email không đúng'),
          content:
              const Text('Nhập tài khoản email hợp lệ.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                emailController.clear(); // clear password input
                emailFocusNode
                    .requestFocus(); // move focus back to password field
              },
              child: const Text('Nhập lại'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quên mật khẩu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Nhập tài khoản email để đổi mật khẩu',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: emailController,
              focusNode: emailFocusNode,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => onPressedNext(context),
              child: const Text('Tiếp theo'),
            ),
          ],
        ),
      ),
    );
  }
}
