import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/account/account_screen.dart';
import 'package:flutter_application/login/sing_up_screen.dart';
import 'package:flutter_application/my_boards/create_screen.dart';
import 'package:flutter_application/my_cards/my_cards_screen.dart';
import 'package:flutter_application/notifications/notification_screen.dart';
import 'package:flutter_svg/svg.dart';
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
        await http.get(Uri.parse('http://192.168.53.160/api/getAccountLogin'));
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
          backgroundColor: Colors.blue[200],
          title: const Text('ĐĂNG NHẬP THẤT BẠI'),
          content: const Text('Tên người dùng hoặc mật khẩu không đúng'),
          actions: [
            ElevatedButton(
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
              onPressed: () {
                Navigator.pop(context);
                _passwordController.clear(); // clear password input
                passwordFocusNode
                    .requestFocus(); // move focus back to password field
              },
              child: Text(
                'THỬ LẠI',
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
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              SvgPicture.asset(
                "assets/images/login.svg",
                width: MediaQuery.of(context).size.width * 0.65,
                height: MediaQuery.of(context).size.width * 0.65,
              ),
              // const SizedBox(height: 20),
              // Text(
              //   "Xin chào😀Mừng bạn trở lại",
              //   style: TextStyle(color: Colors.black, fontSize: 16),
              // ),
              const SizedBox(height: 30),
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
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'TÊN NGƯỜI DÙNG',
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
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(1),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.blue.shade900,
                          BlendMode.srcIn,
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                  controller: _passwordController,
                  focusNode: passwordFocusNode,
                  decoration: InputDecoration(
                    // labelText: 'MẬT KHẨU',
                    hintText: 'MẬT KHẨU',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 3, 102, 250)!),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 251, 234, 234),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(1),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            Colors.blue.shade900, BlendMode.srcIn),
                        child: Icon(
                          Icons.lock,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
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
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                  obscureText: !isPasswordVisible,
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.only(left: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.zero,
                      child: Row(
                        children: [
                          Transform.scale(
                            scale: 1,
                            child: Checkbox(
                              visualDensity: VisualDensity.compact,
                              activeColor: Colors.blue[900],
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                          ),
                          Text(
                            'Nhớ tài khoản',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.black.withOpacity(0.04);
                            }
                            return Colors.redAccent; // default value
                          },
                        ),
                      ),
                      child: Text(
                        'Quên mật khẩu?',
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10.0),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: handleLogin,
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
                    child: const Text(
                      'ĐĂNG NHẬP',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                          return Colors.black; // default value
                        },
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: 'Chưa có tài khoản? ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: 'Đăng ký',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ],
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
