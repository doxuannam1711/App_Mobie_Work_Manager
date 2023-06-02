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

  bool isPasswordVisible = false;

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
        backgroundColor: Colors.blue[900],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children:[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Text(
              //   'Mật khẩu mới',
              //   style: Theme.of(context).textTheme.titleLarge,
              // ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                focusNode: passwordFocusNode,
                decoration: InputDecoration(
                  labelText: 'NHẬP MẬT KHẨU MỚI',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    child: Icon(
                      isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.black,
                    ),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 251, 234, 234),
                ),
                obscureText: !isPasswordVisible,
                onChanged: (value) {
                  _updatePassword = value;
                },
              ),
              // const SizedBox(height: 16.0),
              // Text(
              //   'Nhập lại mật khẩu',
              //   style: Theme.of(context).textTheme.titleLarge,
              // ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: confirmPasswordController,
                focusNode: confirmPasswordFocusNode,
                decoration: InputDecoration(
                  labelText: 'NHẬP LẠI MẬT KHẨU',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    child: Icon(
                      isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.black,
                    ),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 251, 234, 234),
                ),
                obscureText: !isPasswordVisible,
                onChanged: (value) {
                  _confirmPassword = value;
                },
              ),
              const SizedBox(height: 25.0),
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: 55,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            35), // Adjust the value to your desired roundness
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.black;
                        }
                        return Colors.blue.shade900;
                      },
                    ),
                  ),
                  child: const Text(
                    'ĐỔI MẬT KHẨU',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    final pattern = r'[!@^%&*!#\$()_+"?><:+_-`~/|;]';
                    final regex = RegExp(pattern);
                    if (_updatePassword.isEmpty) {
                      passwordFocusNode.requestFocus();
                    }
                    else if (_updatePassword.length <= 7) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.blue[200],
                          title: const Text('MẬT KHẨU MỚI QUÁ NGẮN'),
                          content: const Text(
                              'Mật khẩu phải có độ dài tối thiểu 8 ký tự.'),
                          actions: [
                            ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        35), // Adjust the value to your desired roundness
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.hovered)) {
                                      return Colors.black;
                                    }
                                    return Colors.blue.shade900;
                                  },
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                passwordFocusNode
                                    .requestFocus(); // move focus back to password field
                              },
                              child: Text(
                                'NHẬP LẠI',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    else if (regex.hasMatch(_updatePassword)) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.blue[200],
                          title: const Text('MẬT KHẨU MỚI KHÔNG HỢP LỆ'),
                          content: const Text(
                              'Mật khẩu không được chứa các ký tự đặc biệt.'),
                          actions: [
                            ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        35), // Adjust the value to your desired roundness
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.hovered)) {
                                      return Colors.black;
                                    }
                                    return Colors.blue.shade900;
                                  },
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                passwordFocusNode
                                    .requestFocus(); // move focus back to password field
                              },
                              child: Text(
                                'NHẬP LẠI',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    else if (_confirmPassword.isEmpty) {
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
                          backgroundColor: Colors.blue[200],
                          title: const Text('MẬT KHẨU NHẬP LẠI SAI'),
                          content:
                              const Text('Mật khẩu nhập lại không trùng khớp.'),
                          actions: [
                            ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        35), // Adjust the value to your desired roundness
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.hovered)) {
                                      return Colors.black;
                                    }
                                    return Colors.blue.shade900;
                                  },
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                confirmPasswordController
                                    .clear(); // clear password input
                                confirmPasswordFocusNode
                                    .requestFocus(); // move focus back to password field
                              },
                              child: Text(
                                'NHẬP LẠI',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ], 
      ),
    );
  }
}
