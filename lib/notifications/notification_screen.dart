import 'package:flutter/material.dart';
import 'package:flutter_application/list/list_screen.dart';
import 'package:flutter_application/my_boards/my_boards_screen.dart';
import 'package:flutter_application/my_cards/card_detail_screen.dart';
import 'package:flutter_application/nav_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:async';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationScreen extends StatefulWidget {
  final int userID;
  const NotificationScreen(this.userID);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _selectedFilter = "All categories"; // initialize filter value
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchBoardList();
  }

  Future<void> _fetchBoardList() async {
    final response =
        await http.get(Uri.parse('http://192.168.53.160/api/getNotifications'));
    if (mounted) {
      // Check if the widget is still mounted
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _notifications =
              List<Map<String, dynamic>>.from(jsonDecode(data['Data']));
        });
      } else {
        throw Exception('Failed to load board list');
      }
    }
  }

  List<Map<String, dynamic>> get filteredNotifications {
    switch (_selectedFilter) {
      case 'All categories':
        return _notifications;
      case 'Unread':
        return _notifications
            .where((notification) => notification['NotificationType'] == 1)
            .toList();
      case 'Me':
        return _notifications
            .where((notification) =>
                notification['NotificationType'] == 5 ||
                notification['NotificationType'] == 6)
            .toList();

      case 'Comment':
        return _notifications
            .where((notification) => notification['NotificationType'] == 4)
            .toList();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(widget.userID),
      appBar: AppBar(
        title: const Text('Thông báo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    child: Wrap(
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.markunread),
                          title: const Text('Chưa đọc'),
                          onTap: () {
                            setState(() {
                              _selectedFilter = 'Unread';
                            });
                            Navigator.pop(context);
                          },
                          selected: _selectedFilter == 'Unread',
                        ),
                        ListTile(
                          leading: const Icon(Icons.category),
                          title: const Text('Tất cả'),
                          onTap: () {
                            setState(() {
                              _selectedFilter = 'All categories';
                            });
                            Navigator.pop(context);
                          },
                          selected: _selectedFilter == 'All categories',
                        ),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Của tôi'),
                          onTap: () {
                            setState(() {
                              _selectedFilter = 'Me';
                            });
                            Navigator.pop(context);
                          },
                          selected: _selectedFilter == 'Me',
                        ),
                        ListTile(
                          leading: const Icon(Icons.comment),
                          title: const Text('Bình luận'),
                          onTap: () {
                            setState(() {
                              _selectedFilter = 'Comment';
                            });
                            Navigator.pop(context);
                          },
                          selected: _selectedFilter == 'Comment',
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredNotifications.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final notification = filteredNotifications[index];
          IconData iconData;
          switch (notification['NotificationType']) {
            case 1:
              iconData = Icons.markunread;
              break;
            case 2:
              iconData = Icons.notifications;
              break;
            case 3:
              iconData = Icons.person;
              break;
            case 4:
              iconData = Icons.comment;
              break;
            case 5:
              iconData = Icons.attachment;
              break;
            case 6:
              iconData = Icons.check_circle;
              break;
            case 0:
              iconData = Icons.notification_important;
              break;
            default:
              iconData = Icons.notification_important;
          }

          return ListTile(
            leading: Icon(iconData),
            title: RichText(
              text: TextSpan(
                text: '${notification['Username']}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: ' ${notification['Content']} ',
                  ),
                  TextSpan(
                    text: '${notification['CardName']}',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color.fromARGB(255, 36, 24, 23),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: ' của bảng ',
                  ),
                  TextSpan(
                    text: '${notification['BoardName']}',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color.fromARGB(255, 46, 30, 28),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            subtitle: Text(
              DateFormat("'vào ngày' d 'thg' M',' y 'lúc' HH:mm")
                  .format(DateTime.parse(notification['CreatedDate'])),
            ),
            trailing: const Text(""),
            onTap: () {
              if (notification['CardName'] != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CardsDetailScreen(
                      notification['CardName'],
                      notification['CardID'],
                      widget.userID,
                    ),
                  ),
                );
              } else if (notification['BoardName'] != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListScreen(
                      notification['BoardName'],
                      notification['BoardID'],
                      notification['labels'],
                      widget.userID,
                    ),
                  ),
                );
              } else {
                // Xử lý cho các trường hợp khác
              }
            },
          );
        },
      ),
    );
  }
}
