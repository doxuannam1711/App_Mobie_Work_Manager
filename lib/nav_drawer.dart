import 'package:flutter/material.dart';
import 'package:flutter_application/my_cards/my_cards_screen.dart';
import 'package:flutter_application/profile_and_display/user_preferences.dart';
import 'account/account_screen.dart';
import 'main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'my_boards/my_boards_screen.dart';
import 'notifications/notification_screen.dart';
import 'profile_and_display/profile_and_display_screen.dart';
import 'search/search_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

final Uri _url = Uri.parse('https://flutter.dev');

class NavDrawer extends StatefulWidget {
  final int userID;
  const NavDrawer(this.userID);

  // const NavDrawer({super.key});
  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  // static const user = UserPreferences.myUser;

  Future<void> _downloadFile() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
    // final directory = await getApplicationDocumentsDirectory();
    // final file = File('${directory.path}/test.csv');

    // try {
    //   final response = await http.get(_url);

    //   if (response.statusCode == 200) {
    //     await file.writeAsBytes(response.bodyBytes);
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('File downloaded successfully')),
    //     );
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Failed to download file')),
    //     );
    //   }
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Failed to download file: $e')),
    //   );
    // }
  }

  Future<List<Map<String, dynamic>>> getUserList() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.2/api/getAccount/${widget.userID}'));
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body)['Data'];
        // print(response.body);
        // print(data);

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

  @override
  Widget build(BuildContext context) {
    // Widget createListView = Column(
    //   children: [
    //     ListTile(
    //       leading: const Icon(Icons.space_dashboard_rounded),
    //       title: const Text('My boards'),
    //       onTap: () => {
    //         Navigator.of(context).push(
    //           MaterialPageRoute(builder: (context) => const MyBoardsScreen()),
    //         )
    //       },
    //     ),
    //     ListTile(
    //       leading: const Icon(Icons.credit_card),
    //       title: const Text('My cards'),
    //       onTap: () => {
    //         Navigator.of(context).push(
    //           MaterialPageRoute(builder: (context) => const MyCardsScreen()),
    //         )
    //       },
    //     ),
    //     const Divider(
    //       thickness: 2,
    //     ),
    //     ListTile(
    //       leading: const Icon(Icons.notifications),
    //       title: const Text('Notification'),
    //       onTap: () => {
    //         Navigator.of(context).push(
    //           MaterialPageRoute(builder: (context) => NotificationScreen()),
    //         )
    //       },
    //     ),
    //     ListTile(
    //       leading: const Icon(Icons.account_circle),
    //       title: const Text('Account'),
    //       onTap: () => {
    //         Navigator.of(context).push(
    //           MaterialPageRoute(builder: (context) => const AccountScreen()),
    //         )
    //       },
    //     ),
    //     const Divider(
    //       thickness: 2,
    //     ),
    //     ListTile(
    //       leading: const Icon(Icons.settings),
    //       title: const Text('Setting'),
    //       onTap: () => {Navigator.of(context).pop()},
    //     ),
    //     ListTile(
    //       leading: const Icon(Icons.error_outline),
    //       title: const Text('Help'),
    //       onTap: () => {Navigator.of(context).pop()},
    //     ),
    //   ],
    // );

    return Drawer(
      child: FutureBuilder<List<Map<String, dynamic>>>(
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
                  physics: const BouncingScrollPhysics(),
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    final userData = userList[index];
                    return _buildUserAccountsDrawerHeader(
                      userData["Fullname"],
                      userData["Email"],
                      userData["AvatarUrl"],
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
      //  ListView(
      //   children: [
      //     UserAccountsDrawerHeader(
      //       onDetailsPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => const MyBoardsScreen()),
      //         );
      //       },
      //       accountName: Text(user.fullName),
      //       accountEmail: Text(user.email),
      //       currentAccountPicture: CircleAvatar(
      //         child: ClipOval(
      //           child: Image.asset(
      //             user.imagePath,
      //             width: 90,
      //             height: 90,
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //       ),
      //       decoration: BoxDecoration(
      //           image: DecorationImage(
      //         image: AssetImage(user.imagePath),
      //         fit: BoxFit.cover,
      //       )),
      //     ),
      //     createListView,
      //   ],
      // ),
    );
  }

  Widget _buildUserAccountsDrawerHeader(
    String fullName,
    String email,
    String imagePath,
  ) {
    return Column(
      children: [
        UserAccountsDrawerHeader(
          onDetailsPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyBoardsScreen(widget.userID)),
            );
          },
          accountName: Text(fullName),
          accountEmail: Text(email),
          currentAccountPicture: CircleAvatar(
            child: ClipOval(
              child: Image.asset(
                imagePath,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          )),
        ),

        // createListView,
        Column(
          children: [
            ListTile(
              leading: const Icon(Icons.space_dashboard_rounded),
              title: const Text('My boards'),
              onTap: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => MyBoardsScreen(widget.userID)),
                )
              },
            ),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('My cards'),
              onTap: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => MyCardsScreen(widget.userID)),
                )
              },
            ),

            
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search'),
              onTap: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const SearchScreen()),
                )
              },
            ),

            const Divider(
              thickness: 2,
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notification'),
              onTap: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => NotificationScreen(widget.userID)),
                )
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Account'),
              onTap: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => AccountScreen(widget.userID)),
                )
              },
            ),
            const Divider(
              thickness: 2,
            ),
            ListTile(
              leading: const Icon(Icons.file_download),
              title: const Text('Export Data'),
              onTap: () {
                _downloadFile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Setting'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: const Icon(Icons.error_outline),
              title: const Text('Help'),
              onTap: () => {Navigator.of(context).pop()},
            ),
          ],
        ),
      ],
    );
  }
}
