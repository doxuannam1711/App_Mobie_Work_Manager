import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/account/account_screen.dart';
import 'package:flutter_application/login/sing_up_screen.dart';
import 'package:flutter_application/my_boards/create_screen.dart';
import 'package:flutter_application/my_cards/my_cards_screen.dart';
import 'package:flutter_application/notifications/notification_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../my_boards/my_boards_screen.dart';
import '../nav_drawer.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // late User userModal = User(userID: userID);
  int userID = 0;
  final passwordFocusNode = FocusNode();
  Map<String, dynamic> userList = {};

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    getUserList();
    _loadSavedLoginInfo();
  }

  void _loadSavedLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('email') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';          
      _rememberMe = prefs.getBool('rememberMe') ?? false;     
    });
  }

  void _saveLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_rememberMe) {
      await prefs.setString('email', _emailController.text);
      await prefs.setString('password', _passwordController.text);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
    }

    await prefs.setBool('rememberMe', _rememberMe);
  }

  Future<Map<String, dynamic>> getUserList() async {
    // Change this line
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

    // Add a return statement here to avoid the warning
    return {};
  }

  bool validateUser(String email, String password) {
    List<dynamic> users = jsonDecode(userList['Data']);

    for (var user in users) {
      if (email == user['Username'] && password == user['Password']) {
        userID = user['UserID'];
        // userModal = userModal.copy(userID: userID);
        // var data = User(userID: userID);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccountScreen(userID),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NavDrawer(userID),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyBoardsScreen(userID),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateScreen(userID),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyCardsScreen(userID),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationScreen(userID),
          ),
        );
        // print(userModal.userID);

        return true;
      }
    }

    return false;
  }

  void handleLogin() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    if (email.isNotEmpty &&
        password.isNotEmpty &&
        validateUser(email, password)) {
      _saveLoginInfo();
      // if(_rememberMe){
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   prefs.setString('email', email);
      //   prefs.setString('password', password);
      //   prefs.setBool('rememberMe', true);

      // }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MyBoardsScreen(userID),
        ),
        (route) => false,
      );
    } else {
      // Show error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Credentials'),
          content:
              const Text('The username or password you entered is incorrect.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _passwordController.clear(); // clear password input
                passwordFocusNode
                    .requestFocus(); // move focus back to password field
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.jpg',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 50),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                focusNode: passwordFocusNode,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    child: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                  ),
                ),
                obscureText: !isPasswordVisible,
              ),
              // const SizedBox(height: 1.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                  ),
                  const Text('Remember me'),
                ],
              ),
              // const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: handleLogin,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.black;
                        }
                        return Colors.blue;
                      },
                    ),
                  ),
                  child: const Text('Log In'),
                ),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.black.withOpacity(0.04);
                          }
                          return Colors.redAccent; // default value
                        },
                      ),
                    ),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen()),
                      );
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.black.withOpacity(0.04);
                          }
                          return Colors.redAccent; // default value
                        },
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
