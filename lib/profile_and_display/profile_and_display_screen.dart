// import 'dart:html';

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application/account/account_screen.dart';
// import 'package:flutter_application/profile_and_display/user_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:flutter_application/profile_and_display/user_preferences.dart';
import 'package:flutter_application/profile_and_display/profile_widget.dart';
// import 'package:flutter_application/profile_and_display/text_field_widget.dart';
import 'package:flutter_application/profile_and_display/button_widget.dart';

import 'package:image_picker/image_picker.dart';

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';

// import '../model/user.dart';

class ProfileAndDisplayScreen extends StatefulWidget {
  final int userID;
  // const ProfileAndDisplayScreen({super.key});
  const ProfileAndDisplayScreen(this.userID);

  @override
  State<ProfileAndDisplayScreen> createState() =>
      _ProfileAndDisplayScreenState();
}

class _ProfileAndDisplayScreenState extends State<ProfileAndDisplayScreen> {
  bool isPasswordVisible = false;

  String _updateUsername = "";
  String _updateFullname = "";
  String _updatePassword = "";
  String _updateEmail = "";
  String _updateAvatarUrl = "";
  String _oldAvatarUrl = "";
  String _oldPassword = "";
  String _confirmPassword = "";

  final oldPasswordFocusNode = FocusNode();
  final updatePasswordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController updatePasswordController = TextEditingController();

  late drive.DriveApi _driveApi;

  Map<String, dynamic> userList = {};

  @override
  void initState() {
    super.initState();
    _initializeDriveApi();
  }

  // Future<Map<String, dynamic>> getUserList() async {
  //   final response =
  //       await http.get(Uri.parse('http://192.168.1.2/api/getAccount'));
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     return data;
  //   } else {
  //     throw Exception('Failed to load user list');
  //   }
  // }

  // Future<User> _fetchUserList() async {
  //   final response =
  //       await http.get(Uri.parse('http://192.168.1.2/api/getAccount'));
  //   final jsonresponse = json.decode(response.body);
  //   return User.fromJson(jsonresponse);

  // }

  Future<List<Map<String, dynamic>>> getUserList() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.2/api/getAccount/${widget.userID}'));
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body)['Data'];
        // print(response.body);
        print(data);

        final userData = jsonDecode(data);
        List<dynamic> userList = [];
        if (userData is List) {
          userList = userData;
        } else if (userData is Map) {
          userList = [userData];
        }
        final resultList = userList
            .map((board) =>
                Map<String, dynamic>.from(board as Map<String, dynamic>))
            .toList();
        return resultList;
      } catch (e) {
        throw Exception('Failed to decode user list');
      }
    } else {
      throw Exception('Failed to load user list');
    }
  }

  Future<void> _updateUser(int userID) async {
    final url = Uri.parse('http://192.168.1.2/api/updateUser/$userID');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userName': _updateUsername,
        'fullName': _updateFullname,
        'passWord': _updatePassword,
        'email': _updateEmail,
        'avatarUrl': _updateAvatarUrl.isEmpty?_oldAvatarUrl: _updateAvatarUrl,
        'userID': userID,
      }),
    );

    if (response.statusCode == 200) {
      // Handle success
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    AppBar buildAppBar(BuildContext context) {
      const icon = CupertinoIcons.moon_stars;

      return AppBar(
        leading: const BackButton(),
        title: const Text('My Profile'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(icon),
            onPressed: () {},
          )
        ],
      );
    }

    return Scaffold(
      appBar: buildAppBar(context),
      // body: FutureBuilder(
      //   future: getUserList(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       if (snapshot.hasError) {
      //         return const Center(
      //           child: Text('Failed to load card list'),
      //         );
      //       }
      //       else {
      //         final userData = snapshot.data!;
      //         final avatarUrl = userData.imagePath;
      //         final userName = userData.userName;
      //         final fullName = userData.fullName;
      //         final password = userData.password;
      //         final email = userData.email;

      //         return ListView(
      //           padding:
      //               const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      //           physics: const BouncingScrollPhysics(),
      //           children: [
      //             ProfileWidget(
      //               imagePath: avatarUrl,
      //               onClicked: () async {},
      //             ),
      //             const SizedBox(height: 24),
      //             TextFieldWidget(
      //               label: 'User Name',
      //               text: userName,
      //               onChanged: (name) {},
      //             ),
      //             const SizedBox(height: 24),
      //             TextFieldWidget(
      //               label: 'Full Name',
      //               text: '$fullName',
      //               onChanged: (name) {},
      //             ),
      //             const SizedBox(height: 24),
      //             TextFieldWidget(
      //               label: 'Email',
      //               text: '$email',
      //               onChanged: (name) {},
      //             ),

      //             const SizedBox(height: 24),
      //             Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 const Text(
      //                   'Password',
      //                   style: TextStyle(
      //                       fontWeight: FontWeight.bold, fontSize: 16),
      //                 ),
      //                 const SizedBox(height: 8),
      //                 TextField(
      //                   obscureText: _isObscure,
      //                   controller: TextEditingController(text: '$password'),
      //                   decoration: InputDecoration(
      //                       border: OutlineInputBorder(
      //                         borderRadius: BorderRadius.circular(12),
      //                       ),
      //                       // this button is used to toggle the password visibility
      //                       suffixIcon: IconButton(
      //                           icon: Icon(_isObscure
      //                               ? Icons.visibility
      //                               : Icons.visibility_off),
      //                           onPressed: () {
      //                             setState(() {
      //                               _isObscure = !_isObscure;
      //                             });
      //                           })),
      //                   onChanged: (name) {},
      //                 ),
      //               ],
      //             ),

      //             const SizedBox(height: 24),
      //             Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 const Text(
      //                   'Confirm Password',
      //                   style: TextStyle(
      //                       fontWeight: FontWeight.bold, fontSize: 16),
      //                 ),
      //                 const SizedBox(height: 8),
      //                 TextField(
      //                   obscureText: _isObscure,
      //                   controller: TextEditingController(text: '$password'),
      //                   decoration: InputDecoration(
      //                       border: OutlineInputBorder(
      //                         borderRadius: BorderRadius.circular(12),
      //                       ),
      //                       // this button is used to toggle the password visibility
      //                       suffixIcon: IconButton(
      //                           icon: Icon(_isObscure
      //                               ? Icons.visibility
      //                               : Icons.visibility_off),
      //                           onPressed: () {
      //                             setState(() {
      //                               _isObscure = !_isObscure;
      //                             });
      //                           })),
      //                   onChanged: (name) {},
      //                 ),
      //               ],
      //             ),
      //             // const SizedBox(height: 24),
      //             // TextFieldWidget(
      //             //   label: 'About',
      //             //   text: user.about,
      //             //   maxLines: 5,
      //             //   onChanged: (name) {},
      //             // ),
      //             const SizedBox(height: 24),
      //             ButtonWidget(
      //               text: 'Save',
      //               onClicked: () {
      //                 // UserPreferences.setUser(user);
      //                 Navigator.of(context).pop();
      //               },
      //             ),
      //           ],
      //         );
      //       }
      //     } else {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //   },
      // )

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getUserList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Failed to load user list'),
              );
            } else {
              final userList = snapshot.data!;
              return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  physics: const BouncingScrollPhysics(),
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    final userData = userList[index];

                    return _buildProfile(
                        userData["UserID"],
                        _oldAvatarUrl=userData["AvatarUrl"],
                        _updateUsername = userData["Username"],
                        _updateFullname = userData["Fullname"],
                        _updateEmail = userData["Email"],
                        userData["Password"]);
                  });
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
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
      _updateAvatarUrl =
          'https://drive.google.com/uc?export=view&id=${fileResource.id}';

      print('File link: $_updateAvatarUrl');

      setState(() {});
      // setState(() {
      //   // _attachments.add(link);
      //   _addAttachment();
      // });
      return _updateAvatarUrl;
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
        _updateAvatarUrl = await _uploadFile(filePath);
        // print('File link: $_addAttachmentPath');
        // launchUrl(link as Uri);
      }
    }
  }

  Widget _buildProfile(
    int userID,
    String imagePath,
    String userName,
    String fullName,
    String email,
    String password,
  ) {
    return Column(
      children: [
        ProfileWidget(
          imagePath: _updateAvatarUrl.isNotEmpty ? _updateAvatarUrl : imagePath,
          isEdit: true,
          onClicked: () {
            _openFilePicker();
            setState(() {});
          },
        ),
        // Center(
        //   child: Stack(
        //     children: [
        //       ClipOval(
        //         child: Material(
        //           color: Colors.transparent,
        //           child: Ink.image(
        //             image: AssetImage(imagePath),
        //             fit: BoxFit.cover,
        //             width: 120,
        //             height: 120,
        //           ),
        //         ),
        //       ),
        //       Positioned(
        //         bottom: 0,
        //         right: 4,
        //         child: ClipOval(

        //           child: Container(
        //             color: Theme.of(context).colorScheme.primary,
        //             padding: EdgeInsets.all(8),
        //             child: const Icon(
        //               Icons.add_a_photo,
        //               color: Colors.white,
        //               size: 20,
        //             ),
        //           )),
        //       ),
        //     ]
        //   ),
        // ),
        const SizedBox(height: 24),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Name',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: userName),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              )),
              maxLines: 1,
              onChanged: (value) {
                _updateUsername = value;
              },
            ),
          ],
        ),

        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Full Name',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: fullName),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              )),
              maxLines: 1,
              onChanged: (value) {
                _updateFullname = value;
              },
            ),
          ],
        ),
        // TextFieldWidget(
        //   label: 'Full Name',
        //   text: fullName,
        //   onChanged: (name) {},
        // ),

        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Email',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: email),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              )),
              maxLines: 1,
              onChanged: (value) {
                _updateEmail = value;
              },
            ),
          ],
        ),
        // TextFieldWidget(
        //   label: 'Email',
        //   text: email,
        //   onChanged: (name) {},
        // ),

        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mật khẩu cũ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: oldPasswordController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // this button is used to toggle the password visibility
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
                  )),
              obscureText: !isPasswordVisible,
              focusNode: oldPasswordFocusNode,
              onChanged: (value) {
                _oldPassword = value;
              },
            ),
          ],
        ),

        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mật khẩu mới',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: updatePasswordController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // this button is used to toggle the password visibility
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
                  )),
              obscureText: !isPasswordVisible,
              focusNode: updatePasswordFocusNode,
              onChanged: (value) {
                _updatePassword = value;
              },
            ),
          ],
        ),

        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nhập lại mật khẩu mới',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // this button is used to toggle the password visibility
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
                  )),
              obscureText: !isPasswordVisible,
              focusNode: confirmPasswordFocusNode,
              onChanged: (value) {
                _confirmPassword = value;
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
        ButtonWidget(
          text: 'Save',
          onClicked: () async {
            if (_oldPassword != password) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Mật khẩu cũ sai'),
                  content: const Text('Nhập lại mật khẩu cũ.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        oldPasswordController.clear();
                        oldPasswordFocusNode
                            .requestFocus(); // move focus back to password field
                      },
                      child: const Text('Nhập lại'),
                    ),
                  ],
                ),
              );
            } else if (_oldPassword.isEmpty) {
              oldPasswordFocusNode.requestFocus();
            } else if (_updatePassword.isEmpty) {
              updatePasswordFocusNode.requestFocus();
            } else if (_confirmPassword.isEmpty) {
              confirmPasswordFocusNode.requestFocus();
            } else if (_updatePassword == _confirmPassword) {
              _updateUser(userID);
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => AccountScreen(widget.userID)),
              );
              setState(() {});
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Mật khẩu nhập lại sai'),
                  content: const Text('Mật khẩu nhập lại không trùng khớp.'),
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
    );
  }
}
