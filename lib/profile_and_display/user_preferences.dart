import 'package:flutter_application/model/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Map<String, dynamic> userList = {};

Future<List<Map<String, dynamic>>> _fetchUserList() async {
  final response = await http.get(Uri.parse('http://192.168.1.4/api/getAccount'));
  if (response.statusCode == 200) {
    try {
      final data = jsonDecode(response.body)['Data'];
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
class UserPreferences {
  static const myUser = User(
    imagePath:
        'assets/images/batman_robot_suit.jpg',
    userName:'doxuannam',
    fullName: 'Đỗ Xuân Nam',
    email: 'doxuannam@gmail.com',
    password: '123456',
  );
}

