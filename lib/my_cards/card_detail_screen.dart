import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../attachment/attachment_screen.dart';
import '../checklist/checklist_screen_show.dart';
import '../nav_drawer.dart';
import 'my_cards_screen.dart';

class CardsDetailScreen extends StatefulWidget {
  final int userID;
  final String cardName;
  final int cardID;

  CardsDetailScreen(this.cardName, this.cardID, this.userID);

  @override
  State<CardsDetailScreen> createState() => _CardsDetailScreenState();
}

class _CardsDetailScreenState extends State<CardsDetailScreen> {
  String _listName = 'In Process'; // List within which the card is contained
  String _description = ''; // Description of the card
  DateTime? _expirationDate; // Expiration date of the card
  String _label = 'Label Name'; // Label for the card
  String _member = 'John Doe'; // Member assigned to the card
  String _checklistName = 'test1';
  final List<Map<String, dynamic>> _items = [
    {"muc 1": "te"},
    {"muc 1": "te"},
    {"muc 1": "te"},
    {"muc 1": "te"},
    {"muc 1": "te"},
  ];

  final List<Color> _labelColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.yellow,
  ];

  String _comment = "test comment";
  String _editComment = "";

  Future<List<Map<String, dynamic>>> getComments() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.7/api/getComments/${widget.cardID}'));
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body)['Data'];
        // print(response.body);
        print(data);
        final commentsData = jsonDecode(data);
        List<dynamic> commentsList = [];
        if (commentsData is List) {
          commentsList = commentsData;
        } else if (commentsData is Map) {
          commentsList = [commentsData];
        }
        final resultList = commentsList
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

  Future<void> _addComment() async {
    final url = Uri.parse('http://192.168.1.7/api/addComment');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userID': widget.userID,
        'cardID': widget.cardID,
        'detail': _comment,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment added failed!')),
      );
    }
  }

  Future<void> _deleteComment(int commentID) async {
    final url = Uri.parse('http://192.168.1.7/api/deleteComment/$commentID');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment deleted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete comment!')),
      );
      print('Failed to delete board. Error: ${response.reasonPhrase}');
    }
  }

  Future<void> _updateComment(int commentID) async {
    final url = Uri.parse(
        'http://192.168.1.7/api/updateComment/${widget.userID}/$commentID');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'detail': _editComment,
        'userID': widget.userID,
        'commentID': commentID,
      }),
    );

    if (response.statusCode == 200) {
      // Handle success
    } else {
      // Handle error
    }
  }

  Future<void> _updateCard(int cardID) async {
    final url = Uri.parse('http://192.168.1.7/api/updateCard/$cardID');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'dueDate': _expirationDate?.toIso8601String(),
        'cardID': cardID,
      }),
    );

    if (response.statusCode == 200) {
      // Handle success
    } else {
      // Handle error
    }
  }

  String getColorName(Color color) {
    if (color == Colors.red) {
      return 'Red';
    } else if (color == Colors.green) {
      return 'Green';
    } else if (color == Colors.blue) {
      return 'Blue';
    } else if (color == Colors.orange) {
      return 'Orange';
    } else if (color == Colors.yellow) {
      return 'Yellow';
    } else {
      // Add more color cases as needed
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    Color? _label = _labelColors[0];
    return GestureDetector(
      // add this widget to detect taps outside TextField
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        drawer: NavDrawer(widget.userID),
        appBar: AppBar(
          title: Text(widget.cardName),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () async {
                _updateCard(widget.cardID);
                await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => MyCardsScreen(widget.userID)),
                );
                setState(() {});
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.only(bottom: 80.0),
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trong danh sách:',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      const Text(
                        'Website bán hàng',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const Divider(
                        thickness: 1.0,
                        height: 24.0,
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Quick Actions:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(
                                    Icons.format_list_numbered_sharp),
                                onPressed: () {
                                  _updateCard(widget.cardID);
                                  Navigator.of(context).pop();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChecklistScreenShow(
                                          cardID: widget.cardID,
                                          userID: widget.userID),
                                    ),
                                    (route) => false,
                                  );
                                },
                              ),
                              const Text('Checklist'),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AttachmentPage(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.attach_file),
                                tooltip: 'Add Attachment',
                              ),
                              const Text('Attachment'),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.person_add),
                                tooltip: 'Add Member',
                              ),
                              const Text('Member'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Description:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextField(
                            maxLines: null,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Chạm để thêm một mô tả',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _description = value;
                              });
                            },
                          ),
                          const Icon(Icons.description),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'DueDate :',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _expirationDate ?? DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate:
                                    DateTime.now().add(Duration(days: 365)),
                              );
                              if (picked != null) {
                                setState(() {
                                  _expirationDate = picked;
                                });
                              }
                            },
                            child: Text(
                              _expirationDate == null
                                  ? 'Select date'
                                  : 'Date: ${_expirationDate!.toString().split(' ')[0]}',
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _expirationDate = null;
                              });
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const Text(
                        'Label Color:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      DropdownButtonFormField<Color>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: const OutlineInputBorder(),
                        ),
                        value: _label,
                        items: _labelColors.map((color) {
                          return DropdownMenuItem<Color>(
                            value: color,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20.0,
                                  height: 20.0,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  getColorName(color),
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (Color? value) {
                          setState(() {
                            _label = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Assigned Member:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/images/avatar_user1.jpg',
                              // Here you can add image that will represent member
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(_member),
                          const Spacer(),
                          const CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/images/avatar_user2.jpg',
                              // Here you can add image that will represent the other member
                            ),
                          ),
                          const CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/images/avatar_user3.png',
                              // Here you can add image that will represent the other member
                            ),
                          ),
                          PopupMenuButton(
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem(
                                child: Text('Delete Member'),
                                value: 'delete',
                              ),
                            ],
                            onSelected: (String value) {
                              setState(() {
                                _member = '';
                              });
                            },
                            child: IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16.0),
                      // CommentSection(),
                      const Text(
                        'Comments:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 12.0),

                      FutureBuilder<List<Map<String, dynamic>>>(
                          future: getComments(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return const Center(
                                  child: Text('Failed to load card list'),
                                );
                              } else {
                                final commentsList = snapshot.data!;
                                return Column(
                                  children: [
                                    for (final commentsData in commentsList)
                                      _buildCardDetail(
                                        commentsData["UserID"],
                                        commentsData["Fullname"],
                                        commentsData["AvatarUrl"],
                                        _editComment = commentsData["Detail"],
                                        commentsData["CommentID"],
                                      ),
                                  ],
                                );
                              }
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        maxLines: null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Leave a comment...',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _comment = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 8.0),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () async {
                        _addComment();
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CardsDetailScreen(
                                widget.cardName, widget.cardID, widget.userID),
                          ),
                        );
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardDetail(
    int checkUserID,
    String fullName,
    String avatarUrl,
    String commentDetail,
    int commentID,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(
                  avatarUrl,
                ),
              ),
              const SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.check),
                              iconSize: 20,
                              onPressed: () async {
                                if (checkUserID == widget.userID) {
                                  _updateComment(commentID);
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => CardsDetailScreen(
                                            widget.cardName,
                                            widget.cardID,
                                            widget.userID)),
                                  );
                                  setState(() {});
                                }
                              },
                            ),
                            const SizedBox(width: 15),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              iconSize: 20,
                              icon: const Icon(Icons.delete_outline),
                              // alignment: Alignment(-1, -2.5),
                              // alignment: Alignment.topRight,
                              onPressed: () async {
                                if (checkUserID == widget.userID) {
                                  print("Deleted");
                                  _deleteComment(commentID);

                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => CardsDetailScreen(
                                            widget.cardName,
                                            widget.cardID,
                                            widget.userID)),
                                  );
                                  setState(() {});
                                }
                              },
                            ),
                          ],
                        ),

                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextField(
                      enabled: checkUserID == widget.userID,
                      controller: TextEditingController(text: commentDetail),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      )),
                      maxLines: null,
                      onChanged: (value) {
                        _editComment = value;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40.0),
        ],
      ),
      // Column(
      // children: [

      // const SizedBox(height: 40.0),
      // ],
      // ),
    );
  }
}
