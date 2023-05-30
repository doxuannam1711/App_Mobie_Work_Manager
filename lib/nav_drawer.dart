import 'package:flutter/material.dart';
import 'package:flutter_application/my_cards/my_cards_screen.dart';
import 'account/account_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'my_boards/my_boards_screen.dart';
import 'notifications/notification_screen.dart';
import 'search/search_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'dart:io';

final Uri _url = Uri.parse('https://flutter.dev');

// final Uri _url = Uri.parse('http://192.168.53.160/api/downloadfile');
class NavDrawer extends StatefulWidget {
  final int userID;
  const NavDrawer(this.userID);

  // const NavDrawer({super.key});
  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  // static const user = UserPreferences.myUser;
  int unReadNotify = 1;
  @override
  void initState() {
    super.initState();
    _fetchCountUnread();
  }

  Future<List<Map<String, dynamic>>> getUserList() async {
    final response = await http.get(
        Uri.parse('http://192.168.53.160/api/getAccount/${widget.userID}'));
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

  Future<void> _fetchCountUnread() async {
    final response =
        await http.get(Uri.parse('http://192.168.53.160/api/getCountUnread'));
    if (mounted) {
      // Kiểm tra widget có đang được hiển thị hay không
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final jsonData = jsonDecode(data['Data']);
        final List<Map<String, dynamic>> countList =
            List<Map<String, dynamic>>.from(jsonData);
        setState(() {
          unReadNotify = countList.isNotEmpty ? countList[0]['CountNotify'] : 0;
        });
      } else {
        throw Exception('Failed to load board list');
      }
    }
  }

  Future<String> getFileCSV(int userId) async {
    final response =
        await http.get(Uri.parse('http://192.168.53.160/api/writecsv/$userId'));
    return response.body;
  }

  void _importFile() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        final PlatformFile file = result.files.first;
        final filePath = file.path!; // Add the null-aware operator (!) here

        // Read the CSV file
        final File csvFile = File(filePath);
        final csvString = await csvFile.readAsString();

        // Parse the CSV data
        final csvData = CsvToListConverter().convert(csvString);

        // Extract the userID
        final userID = csvData[0]
            [0]; // Assuming userID is in the first row and first column

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyBoardsScreen(userID),
          ),
        );
      }
    } catch (e) {
      // Handle import errors
      print('Import error: $e');
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
                  // physics: const BouncingScrollPhysics(),
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MyBoardsScreen(widget.userID)),
            );
          },
          accountName: Text(fullName,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          accountEmail: Text(email),
          currentAccountPicture: CircleAvatar(
            child: ClipOval(
              child: Image.network(
                imagePath,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.blue[900],
            // image: DecorationImage(
            //   image: NetworkImage(imagePath),
            //   // AssetImage(imagePath),
            //   fit: BoxFit.cover,
            // )
          ),
        ),

        // createListView,
        Column(
          children: [
            ListTile(
              leading: const Icon(Icons.space_dashboard_rounded),
              title: const Text('Các bảng của tôi'),
              onTap: () {
                setState(() {
                  unReadNotify = 1;
                });
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => MyBoardsScreen(widget.userID),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Các thẻ của tôi'),
              onTap: () => {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => MyCardsScreen(widget.userID)),
                )
              },
            ),
            const Divider(
              thickness: 2,
            ),
            ListTile(
              onTap: () {
                setState(() {
                  unReadNotify = 0;
                });
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => NotificationScreen(widget.userID),
                  ),
                );
              },
              leading: unReadNotify != 0
                  ? Stack(
                      children: [
                        const Icon(Icons.notifications),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              unReadNotify.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Icon(Icons.notifications),
              title: const Text('Thông báo'),
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Tìm kiếm'),
              onTap: () => {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => SearchScreen(widget.userID)),
                )
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Tài khoản'),
              onTap: () => {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => AccountScreen(widget.userID)),
                )
              },
            ),
            const Divider(
              thickness: 2,
            ),
            ListTile(
              leading: const Icon(Icons.file_open),
              title: const Text('Tải lên dữ liệu'),
              onTap: () {
                _importFile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_download),
              title: const Text('Tải xuống dữ liệu'),
              onTap: () async {
                getFileCSV(widget.userID);
                final downloadUrl =
                    // Uri.parse('http://192.168.53.160/api/downloadfile');
                    Uri.parse('http://192.168.53.160/api/downloadfile');
                if (!await launchUrl(downloadUrl,
                    mode: LaunchMode.externalApplication)) {
                  throw Exception('Could not launch $downloadUrl');
                }
              },
            ),
            const Divider(
              thickness: 2,
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Cài đặt'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: const Icon(Icons.error_outline),
              title: const Text('Trợ giúp'),
              onTap: () => {Navigator.of(context).pop()},
            ),
          ],
        ),
      ],
    );
  }
}
