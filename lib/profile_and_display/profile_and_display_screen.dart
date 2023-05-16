// import 'dart:html';

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

// import '../model/user.dart';

class ProfileAndDisplayScreen extends StatefulWidget {
  final int userID;
  // const ProfileAndDisplayScreen({super.key});
  const ProfileAndDisplayScreen(this.userID, {super.key});

  @override
  State<ProfileAndDisplayScreen> createState() =>
      _ProfileAndDisplayScreenState();
}

class _ProfileAndDisplayScreenState extends State<ProfileAndDisplayScreen> {
  bool _isObscure = true;
  String _updateUsername = "";
  String _updateFullname = "";
  String _updatePassword = "";
  String _updateEmail = "";

  Map<String, dynamic> userList = {};

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
                child: Text('Failed to load card list'),
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
                        userData["AvatarUrl"],
                        _updateUsername = userData["Username"],
                        _updateFullname = userData["Fullname"],
                        _updateEmail = userData["Email"],
                        _updatePassword = userData["Password"]);
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

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
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
          imagePath: imagePath,
          isEdit: true,
          onClicked: () async{
            final image = await ImagePicker().pickImage(source: ImageSource.gallery);
            // if (image == null) return;

            // final directory = await getApplicationDocumentsDirectory();
            // final name = p.basename(image.path);
            // final imageFile = File('${directory.path}/$name');
            
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
              'Password',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              obscureText: _isObscure,
              controller: TextEditingController(text: password),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // this button is used to toggle the password visibility
                  suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      })),
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
              'Confirm Password',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              obscureText: _isObscure,
              controller: TextEditingController(text: password),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // this button is used to toggle the password visibility
                  suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      })),
              onChanged: (name) {},
            ),
          ],
        ),
        const SizedBox(height: 24),
        ButtonWidget(
          text: 'Save',
          onClicked: () async {
            _updateUser(userID);
            getUserList();
            await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => AccountScreen(widget.userID)),
            );
            setState(() {});
          },
        ),
      ],
    );
  }
}
