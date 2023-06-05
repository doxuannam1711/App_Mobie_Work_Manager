import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/login/login_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'change_password_screen.dart';
import 'otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  EmailOTP myauth = EmailOTP();

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
    if (email.isNotEmpty && validateUser(email)) {
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
          backgroundColor: Colors.blue[200],
          title: const Text('TÀI KHOẢN EMAIL KHÔNG ĐÚNG'),
          content: const Text('Nhập tài khoản email hợp lệ.'),
          actions: [
            ElevatedButton(
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
              onPressed: () {
                Navigator.pop(context);
                emailController.clear(); // clear password input
                emailFocusNode
                    .requestFocus(); // move focus back to password field
              },
              child: Text(
                'NHẬP LẠI',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        title: const Text('Quên mật khẩu'),
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const LoginScreen()),
              (route) => false, // Remove all previous routes
            );
          },
          icon: const Icon(
            Icons.keyboard_arrow_left,
            size: 32,
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Text(
                //   'Nhập tài khoản email để đổi mật khẩu',
                //   style: Theme.of(context).textTheme.titleLarge,
                // ),
                const SizedBox(height: 15),
                SvgPicture.asset(
                  "assets/images/signup.svg",
                  width: MediaQuery.of(context).size.width * 0.65,
                  height: MediaQuery.of(context).size.width * 0.65,
                ),
                const SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: emailController,
                    focusNode: emailFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Nhập email của bạn',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide.none, // Set the border side to none
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue.shade900),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 251, 234, 234),
                    ),
                  ),
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
                              10), // Adjust the value to your desired roundness
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
                    onPressed: () async {
                      String email = emailController.text;
                      if (email.isNotEmpty && validateUser(email)) {
                        myauth.setConfig(
                          appEmail: "contact@hdevcoder.com",
                          appName: "Email OTP",
                          userEmail: emailController.text,
                          otpLength: 4,
                          otpType: OTPType.digitsOnly);
                        if (await myauth.sendOTP() == true) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Mã OTP đã được gửi đi"),
                          ));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtpScreen(
                                myauth: myauth, userID: userID, emailUser: email,
                              )
                            )
                          );
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Oops, Mã OTP gửi thất bại!"),
                          ));
                        }
                      }
                      else {
                        // Show error message
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.blue[200],
                            title: const Text('TÀI KHOẢN EMAIL KHÔNG ĐÚNG'),
                            content: const Text('Nhập tài khoản email hợp lệ.'),
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
                                  emailController
                                      .clear(); // clear password input
                                  emailFocusNode
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
                    },
                    child: const Text(
                      'TIẾP THEO',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
