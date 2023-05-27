import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  final int userID;
  // const ProfileAndDisplayScreen({super.key});
  const ChangePasswordScreen(this.userID);
  // const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final confirmPasswordFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  String _updatePassword = "";
  String _confirmPassword = "";

  @override
  void initState() {
    super.initState();
  }

  Future<void> _changePassword() async {
    final url =
        Uri.parse('http://192.168.1.7/api/changePassword/${widget.userID}');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'passWord': _updatePassword,
        'userID': widget.userID,
      }),
    );

   if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đổi mật khẩu thành công')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đổi mật khẩu thất bại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        title: const Text('Đổi mật khẩu'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children:[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Mật khẩu mới',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                focusNode: passwordFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Nhập mật khẩu mới',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _updatePassword = value;
                },
              ),
              const SizedBox(height: 16.0),
              Text(
                'Nhập lại mật khẩu',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: confirmPasswordController,
                focusNode: confirmPasswordFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Nhập lại mật khẩu',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _confirmPassword = value;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                child: const Text('Đổi mật khẩu'),
                onPressed: () async {
                  if (_updatePassword.isEmpty) {
                    passwordFocusNode.requestFocus();
                  }
                  else if(_confirmPassword.isEmpty){
                    confirmPasswordFocusNode.requestFocus();
                  }
                  else if (_updatePassword == _confirmPassword) {
                    _changePassword();
                    await Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen()
                      ),
                      (route) => false, // Remove all previous routes
                    );
                  }
                  else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Mật khẩu nhập lại sai'),
                        content:
                            const Text('Mật khẩu nhập lại không trùng khớp.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              confirmPasswordController
                                  .clear(); // clear password input
                              confirmPasswordFocusNode
                                  .requestFocus(); // move focus back to password field
                            },
                            child: const Text('Nhập lại'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ], 
      ),
    );
  }
}
