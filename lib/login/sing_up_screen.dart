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
      "type": "service_account",
      "project_id": "appworkmanager",
      "private_key_id": "51c1bc83a5942a5af73dd21bee9d350cac497637",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDsEg4VyFcOaqXD\nOOaSIF3+8ltQmCmDV37sTrRZEadn97UXdTgawKEN51bVkDCzvN279FAubExCF+7x\n5aSuey1MQ3QA6d1wQ3tJYfPRJ1fxG+xpkkfnP+z5/e7a6I7/5fo7DTzD27Z2mJmh\nSASHvBnARna8+9nkWkZAUv6LiGSnr3KJ0yIw6d6f32PjMixPVUkmVcFuFCP7tvZ5\n3fm849FcNzsFaA9P7pV0G/iV+wGXAsFrgNTOHQSjXW+kWr2aIVyvYsv3cMHsSl3V\ntHn3zjFN3eIgG1/PC5MEDSxdL10BFYE2zJMAP/YX+mmrGKy62hXB1MYTkDUIPrdr\nVsVi+EKHAgMBAAECggEAa3ug/Bv2PzMhe+xZVqj0AxM3rk9Jf2qD+HWxOWiHTxgC\nVMbjH5MbASiWabA37G4Oivgm1awrYGBjQ7HqNCMTMcj4dT4Fu4qOBJBboZwHN1ke\nX8bhhBGgBQawDO2bxjlgoChbxVUxE3hRYpRWs7JaCyhKAautvoG3wKvJB6C3K30f\nYqxU75RWfKDS4YfWXd/ilG48fvRcLPEui0R8eDRTWGV/Yad2lYqtg0t4CL2HgmFY\n3dlSHAVN0lQ8WjS9B3mpUVfUz/I7QDcu+K6VtiZaxCYdRfHBLWmRo5bfIyrm2tJ2\nYSj2ootiG01kJwLn1uvYdoCPiycDHrYWNsut1RKdoQKBgQD/nf6er8LZg7CSOt7Y\nc79mRrlEQHfVm0vrjxbhZRDrNCH/wK9/zMP7AfQDZ5AZXZYQMmPdpLXFmmCHKQKt\nV8fpa/TjPivGaRJ+T95IkG1GE21+Lnlrpw3kZpoXm2bw0HbYTLV4r4lJJJi3QAAR\nAaPv9nwemgFrfLCHW0zJjGdLlwKBgQDsbJDrjlHFOnTzdQyKPrE5jFdokaFS8DJj\ni/mwnv3TVfd/T2dSCFMdWauzJxPQ1EH/ypVcNxwO1KufDBGXKwQjgm0pTXXtFjjd\n4qKRR9cZuWOaf+d4q/ygWtFWIag3J5MKp2ZaLQGNAPnFZHjr8S+h8YhsfEoxXdWL\nBa9CkZNekQKBgCRx4lu9s4pPvF0dB6jU1/U9IC0bA/rwqWJshFaekkr2o+JTFrKh\n/09KeAAERAdZ0It+o752PXRvDlQ3BKqyWU5ulfvQYW1ojbp0qLyv2uSi4HmdJrKy\nnshx2IaFIag0EL3GMhmC7ZAAJ8X42gmSsk0EV64FRy6MGJ8z5T7XReMBAoGBAIuh\nqw2T5nNnjP7kmF1lnWHxowYdTHwhZIEqgHNx01NnqF7GVK08QWpKNX//ilKBqeEa\nko/99FJGBH5QsGrpeu5F75a/KvC1eSyC16SaG04UEeGDvP+mA/Po703BXwoEE3Ht\nYCPOBOZ0Nw//wPMIZStt7Ta1SVRSqPYMi2/zbmghAoGBANdWLdTQonO5bm0GBhQ/\njxb9pvRsm5jmzqqOFkDOxkVh6M9XbnPlkzuztsGYmBY3Z5rgv/yi8uVOS2MKgfn0\nwX0ABthxc2cGLETvo/qKSPcJTCQhglwOuRKdkm9DC0sa7l1XbS7JDh1D4Bp6q0i8\nwGMvoOpjZPEf86003zPDZAVb\n-----END PRIVATE KEY-----\n",
      "client_email": "appworkmanager@appworkmanager.iam.gserviceaccount.com",
      "client_id": "115180400866275325068",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/appworkmanager%40appworkmanager.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
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
              const SizedBox(height: 10,),
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
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tên đăng nhập',
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  filled: true,
                  fillColor: Colors.blue[200],
                ),
                focusNode: userNameFocusNode,
                onChanged: (value) {
                  _addUsername = value;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tên đầy đủ',
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  filled: true,
                  fillColor: Colors.blue[200],
                ),
                focusNode: fullNameFocusNode,
                onChanged: (value) {
                  _addFullname = value;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color:Colors.black,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  filled: true,
                  fillColor: Colors.blue[200],
                ),
                focusNode: emailFocusNode,
                onChanged: (value) {
                  _addEmail = value;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  filled: true,
                  fillColor: Colors.blue[200],
                ),
                focusNode: passwordFocusNode,
                onChanged: (value) {
                  _addPassword = value;
                },
                obscureText: true,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Xác nhận lại mật khẩu',
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  filled: true,
                  fillColor: Colors.blue[200],
                ),
                focusNode: confirmPasswordFocusNode,
                onChanged: (value) {
                  _confirmPassword = value;
                },
                obscureText: true,
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
                  onPressed: () async {
                    if (_addUsername.isEmpty) {
                      userNameFocusNode.requestFocus();
                    } else if (_addFullname.isEmpty) {
                      fullNameFocusNode.requestFocus();
                    } else if (_addEmail.isEmpty) {
                      emailFocusNode.requestFocus();
                    } else if (_addPassword.isEmpty) {
                      passwordFocusNode.requestFocus();
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
                            TextButton(
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
                                  color: Colors.blue[900]
                                ),
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
