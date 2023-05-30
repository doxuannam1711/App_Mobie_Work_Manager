import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../my_cards/card_detail_screen.dart';
import '../nav_drawer.dart';
import '../model/member.dart';

class MemberScreen extends StatefulWidget {
  final int userID;
  final int cardID;
  const MemberScreen(this.userID, this.cardID);

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  List<Map<String, dynamic>> _members = [];
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _searchResult = [];
  String _searchKeyword = '';

  Future<List<Map<String, dynamic>>> _getMembersCard() async {
    final response = await http.get(
        Uri.parse('http://192.168.53.160/api/getmembers/${widget.cardID}'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['Data'] is String) {
        final String data = jsonData['Data'];
        if (data.isNotEmpty) {
          try {
            final List<dynamic> membersList = json.decode(data);
            final List<Map<String, dynamic>> members = membersList
                .where((dynamic item) => item is Map<String, dynamic>)
                .map((dynamic item) => item as Map<String, dynamic>)
                .toList();
            return members;
          } catch (e) {
            throw FormatException('Failed to parse JSON data: $e');
          }
        } else {
          return [];
        }
      } else {
        throw FormatException('Invalid JSON data: ${jsonData['Data']}');
      }
    } else {
      throw Exception('Failed to load members');
    }
  }

  Future<List<Map<String, dynamic>>> _getAccount() async {
    final response =
        await http.get(Uri.parse('http://192.168.53.160/api/getAccountLogin'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['Data'] is String) {
        final String data = jsonData['Data'];
        if (data.isNotEmpty) {
          try {
            final List<dynamic> usersList = json.decode(data);
            final List<Map<String, dynamic>> users = usersList
                .where((dynamic item) => item is Map<String, dynamic>)
                .map((dynamic item) => item as Map<String, dynamic>)
                .toList();
            return users;
          } catch (e) {
            throw FormatException('Failed to parse JSON data: $e');
          }
        } else {
          return [];
        }
      } else {
        throw FormatException('Invalid JSON data: ${jsonData['Data']}');
      }
    } else {
      throw Exception('Failed to load members');
    }
  }

  Future<void> _deleteMember(int memberID) async {
    final url = Uri.parse('http://192.168.53.160/api/deleteMember/$memberID');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('member deleted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete member!')),
      );
      // print('Failed to delete member. Error: ${response.reasonPhrase}');
    }
  }

  Future<void> addMember(MemberModel newMember) async {
    final response = await http.post(
      Uri.parse('http://192.168.53.160/api/addMember/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newMember.toJson()),
    );
    if (response.statusCode == 200) {
      // show success message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding Member!')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getMembersCard().then((members) {
      setState(() {
        _members = members;
      });
    });
    _getAccount().then((users) {
      setState(() {
        _users = users;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Colors.blue[900],
        title: const Text('Thành viên'),
        actions: [
          IconButton(
            onPressed: () async {
              final email = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.blue[200],
                    title: Text('THÊM THÀNH VIÊN'),
                    content: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Chọn người dùng muốn thêm vào',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchKeyword = value;
                              });
                            },
                          ),
                          SizedBox(
                              height:
                                  16), // tạo khoảng cách giữa TextField và ListView
                          Expanded(
                            child: ListView.builder(
                              itemCount: _users.length,
                              itemBuilder: (BuildContext context, int index) {
                                final user = _users[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user['AvatarUrl']),
                                  ),
                                  title: Text(user['Fullname']),
                                  // subtitle: Text(user['Email']),
                                  onTap: () async {
                                    MemberModel newMember = MemberModel(
                                      fullname: user['Fullname'],
                                      Email: user['Email'],
                                      AvatarUrl: user['AvatarUrl'],
                                      assignedTo: 3,
                                    );
                                    await addMember(newMember);
                                    Navigator.of(context).pop(user['Email']);
                                    List<Map<String, dynamic>> members =
                                        await _getMembersCard();
                                    setState(() {
                                      _members = members;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  35), // Adjust the value to your desired roundness
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.black;
                              }
                              return Colors.blue.shade900;
                            },
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'THOÁT',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              );
              if (email != null && email.isNotEmpty) {
                // await _addMember(email);
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: NavDrawer(widget.userID),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Creator: Đỗ Xuân Nam',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 8.0),
                    Text(
                      'Danh sách thành viên trong thẻ:',
                      style:
                          TextStyle(fontSize: 16.0), // Đặt kích thước mong muốn
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 2,
          ),
          Expanded(
            child: FutureBuilder(
              future: Future.delayed(Duration(milliseconds: 200)).then((_) =>
                  _searchKeyword.isEmpty
                      ? _members
                      : _members
                          .where((member) => member['email']
                              .toLowerCase()
                              .contains(_searchKeyword.toLowerCase()))
                          .toList()),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Failed to load members'),
                    );
                  } else if (snapshot.hasData) {
                    _searchResult = snapshot.data;
                    return ListView.builder(
                      itemCount: _searchResult.length,
                      itemBuilder: (BuildContext context, int index) {
                        final member = _searchResult[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(member['AvatarUrl']),
                          ),
                          title: RichText(
                            text: TextSpan(
                              text: member['fullname'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: ' (${member['Email']})',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.blue[200],
                                    title: Text('XÓA THÀNH VIÊN'),
                                    content: Text(
                                        'Bạn có chắc muốn xóa thành viên này khỏi thẻ?'),
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
                                          backgroundColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              if (states.contains(
                                                  MaterialState.hovered)) {
                                                return Colors.black;
                                              }
                                              return Colors.blue.shade900;
                                            },
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'HỦY',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  35), // Adjust the value to your desired roundness
                                            ),
                                          ),
                                          backgroundColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              if (states.contains(
                                                  MaterialState.hovered)) {
                                                return Colors.black;
                                              }
                                              return Colors.blue.shade900;
                                            },
                                          ),
                                        ),
                                        onPressed: () {
                                          _deleteMember(member['id']);
                                          setState(() {
                                            _members.remove(member);
                                            _searchResult = _members;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'XÓA',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('No members found'),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
