import 'package:flutter/material.dart';
import '../login/login_screen.dart';
import '../nav_drawer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../profile_and_display/profile_and_display_screen.dart';

class AccountScreen extends StatefulWidget {
  final int userID;
  // const AccountScreen({super.key});
  const AccountScreen(this.userID, {super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {


  Future<List<Map<String, dynamic>>> getUserList() async {

    final response =
        await http.get(Uri.parse('http://192.168.53.160/api/getAccount/${widget.userID}'));

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

  Future<void> _deleteUser() async {
    final url = Uri.parse('http://192.168.53.160/api/deleteUser/${widget.userID}');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete account!')),
      );
      print('Failed to delete board. Error: ${response.reasonPhrase}');
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(widget.userID),
      appBar: AppBar(
        title: const Text('Account Management'),
      ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  physics: const BouncingScrollPhysics(),
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    final userData = userList[index];

                    return buildAccount(
                      userData["AvatarUrl"],
                      userData["Fullname"],
                      userData["Email"],
                    );
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

  Widget buildAccount(
    String imagePath,
    String fullName,
    String email,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipOval(
          child: Material(
            color: Colors.transparent,
            child: Ink.image(
              image: NetworkImage(imagePath),
              fit: BoxFit.cover,
              width: 120,
              height: 120,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Column(
          children: [
            Text(
              fullName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: const TextStyle(color: Colors.grey),
            )
          ],
        ),
        // ClipOval(
        //   child: Material(
        //     color: Colors.transparent,
        //     child: Ink.image(
        //       image: AssetImage(user.imagePath),
        //       fit: BoxFit.cover,
        //       width: 120,
        //       height: 120,
        //     ),
        //   ),
        // ),
        // const SizedBox(height: 24),
        // buildName(user),

        const SizedBox(height: 24),
        _buildGroupBox(
          onTap: () {},
          'Your Boards',
          const Icon(Icons.dashboard),
          [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.transparent,
                border: Border.all(color: Colors.black),
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                child: const Text(
                  'Board 1',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.transparent,
                border: Border.all(color: Colors.black),
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                child: const Text(
                  'Board 2',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.transparent,
                border: Border.all(color: Colors.black),
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                child: const Text(
                  'Board 3',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildGroupBox(
          onTap: () {},
          'Account',
          const Icon(Icons.account_box),
          [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.transparent,
                border: Border.all(color: Colors.black),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfileAndDisplayScreen(widget.userID)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                child: const Text(
                  'Profile and display',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.transparent,
                border: Border.all(color: Colors.black),
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                child: const Text(
                  'switch accounts',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.transparent,
                border: Border.all(color: Colors.black),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                child: const Text(
                  'log out',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildGroupBox(
          onTap: () {},
          'Appearance',
          const Icon(Icons.palette),
          [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Theme'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Language'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildGroupBox(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm'),
                  content: const Text(
                    'Are you sure you want to delete this account?',
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Delete'),
                      onPressed: () async {
                        _deleteUser();
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>  const LoginScreen()
                          ),
                        );
                        setState(() {});
                      },
                    ),
                  ],
                );
              },
            );
          },
          'Delete Your Account',
          const Icon(Icons.delete_forever),
          [],
        ),
        const SizedBox(height: 16),
        _buildGroupBox(
          onTap:(){},
          'About Us',
          const Icon(Icons.info),
          [],
        ),
      ],
    );
  }

  Widget _buildGroupBox(String title, Widget icon, List<Widget> children, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: icon,
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}
