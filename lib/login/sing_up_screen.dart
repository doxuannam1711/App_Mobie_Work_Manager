import 'package:flutter/material.dart';
import 'package:flutter_application/login/login_screen.dart';
import 'package:googleapis/appengine/v1.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';

import '../profile_and_display/profile_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // late File _imageFile;
  bool isPasswordVisible = false;

  String _addUsername = "";
  String _addFullname = "";
  String _addPassword = "";
  String _addAvatarUrl = "";
  String _addEmail = "";

  String _confirmPassword = "";
  final String _defaultAvatar =
      'https://drive.google.com/uc?export=view&id=1KRAnJasEh6mSrI_JzKmgitiTJE6W2BQL';

  late drive.DriveApi _driveApi;

  TextEditingController confirmPasswordController = TextEditingController();

  final userNameFocusNode = FocusNode();
  final fullNameFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeDriveApi();
  }
  // @override
  // void initState() {
  //   super.initState();
  //   _imageFile = File(
  //       '/data/user/0/com.example.flutter_application/cache/32bf3f59-834b-4ea8-b7dd-627dbcad9f4e/download.jpg');
  // }

  // Future<void> _pickImage() async {
  //   final pickedFile =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageFile = File(pickedFile.path);
  //       print('Image path:');
  //       debugPrint(_imageFile.toString());
  //     });
  //   }
  // }

  Future<void> _addUser() async {
    final url = Uri.parse('http://192.168.1.7/api/addUser');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userName': _addUsername,
        'fullName': _addFullname,
        'passWord': _addPassword,
        'email': _addEmail,
        'avatarUrl': _addAvatarUrl.isNotEmpty ? _addAvatarUrl : _defaultAvatar,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User added failed!')),
      );
    }
  }

  Future<void> _initializeDriveApi() async {
    final credentials = ServiceAccountCredentials.fromJson({
      //json file of your google drive api
    });
    final client = await clientViaServiceAccount(
        credentials, [drive.DriveApi.driveFileScope]);

    _driveApi = drive.DriveApi(client);
  }

  Future<String> _uploadFile(String filePath) async {
    final file = File(filePath);
    const folderId = "1R2cPPIQU1dhQIxFBj45zmrdDEeKXiiCZ";
    final fileMedia = drive.Media(
      file.openRead(),
      file.lengthSync(),
    );

    final fileUpload = drive.File()
      ..name = file.path.split('/').last
      ..parents = [folderId];

    final fileResource = await _driveApi.files.create(
      fileUpload,
      uploadMedia: fileMedia,
    );

    if (fileResource != null) {
      _addAvatarUrl =
          'https://drive.google.com/uc?export=view&id=${fileResource.id}';

      print('File link: $_addAvatarUrl');

      setState(() {});
      // setState(() {
      //   // _attachments.add(link);
      //   _addAttachment();
      // });
      return _addAvatarUrl;
    } else {
      print("File upload failed or not completed yet.");
      return '';
    }
  }

  Future<void> _openFilePicker() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      for (final file in result.files) {
        final filePath = file.path!;
        // _addAttachmentName = file.name;
        print('File name: ${file.name}');
        print('File path: $filePath');
        _addAvatarUrl = await _uploadFile(filePath);
        // print('File link: $_addAttachmentPath');
        // launchUrl(link as Uri);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        title: const Text('Đăng ký tài khoản'),
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.28,
                height: MediaQuery.of(context).size.width * 0.28,
                child: ProfileWidget(
                  imagePath:
                      _addAvatarUrl.isNotEmpty ? _addAvatarUrl : _defaultAvatar,
                  isEdit: true,
                  onClicked: () {
                    _openFilePicker();
                    setState(() {});
                  },
                ),
              ),

              // InkWell(
              //   onTap: _openFilePicker,
              //   child: CircleAvatar(
              //     radius: 50,
              //     backgroundImage: _addAvatarUrl.isNotEmpty
              //         ? _addAvatarUrl
              //         : NetworkImage(
              //             'https://drive.google.com/uc?export=view&id=1KRAnJasEh6mSrI_JzKmgitiTJE6W2BQL'),
              //     //     _imageFile != null ? FileImage(_imageFile) : null,
              //     // child: _imageFile == null ? const Icon(Icons.person) : null,
              //   ),
              // ),
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
                  decoration: InputDecoration(
                    hintText: 'Tên đăng nhập',
                    labelStyle: TextStyle(
                      color: Colors.black,
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
                  focusNode: userNameFocusNode,
                  onChanged: (value) {
                    _addUsername = value;
                  },
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
                  decoration: InputDecoration(
                    hintText: 'Tên đẩy đủ',
                    labelStyle: TextStyle(
                      color: Colors.black,
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
                  focusNode: fullNameFocusNode,
                  onChanged: (value) {
                    _addFullname = value;
                  },
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
                  decoration: InputDecoration(
                    hintText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.black,
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
                  focusNode: emailFocusNode,
                  onChanged: (value) {
                    _addEmail = value;
                  },
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
                  decoration: InputDecoration(
                    hintText: 'Mật khẩu',
                    labelStyle: TextStyle(
                      color: Colors.black,
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
                        color: Colors.grey,
                      ),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 251, 234, 234),
                  ),
                  focusNode: passwordFocusNode,
                  obscureText: !isPasswordVisible,
                  onChanged: (value) {
                    _addPassword = value;
                  },
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
                  decoration: InputDecoration(
                    hintText: 'Xác nhận lại mật khẩu',
                    labelStyle: TextStyle(
                      color: Colors.black,
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
                        color: Colors.grey,
                      ),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 251, 234, 234),
                  ),
                  focusNode: confirmPasswordFocusNode,
                  obscureText: !isPasswordVisible,
                  onChanged: (value) {
                    _confirmPassword = value;
                  },
                ),
              ),
              const SizedBox(height: 40),
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
                    final pattern = r'[!@^%&*!#\$()_+"?><:+_-`~/|;]';
                    final regex = RegExp(pattern);

                    if (_addUsername.isEmpty) {
                      userNameFocusNode.requestFocus();
                    } else if (_addFullname.isEmpty) {
                      fullNameFocusNode.requestFocus();
                    } else if (_addEmail.isEmpty) {
                      emailFocusNode.requestFocus();
                    } else if (_addPassword.isEmpty) {
                      passwordFocusNode.requestFocus();
                    } else if (_addPassword.length <= 7) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.blue[200],
                          title: const Text('MẬT KHẨU QUÁ NGẮN'),
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
                    } else if (regex.hasMatch(_addPassword)) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.blue[200],
                          title: const Text('MẬT KHẨU KHÔNG HỢP LỆ'),
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
                    } else if (_confirmPassword.isEmpty) {
                      confirmPasswordFocusNode.requestFocus();
                    } else if (_addPassword == _confirmPassword) {
                      _addUser();
                      await Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (route) => false, // Remove all previous routes
                      );
                    } else {
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
                                        10), // Adjust the value to your desired roundness
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
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'ĐĂNG KÝ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
