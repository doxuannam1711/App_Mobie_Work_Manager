import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../nav_drawer.dart';
import 'create_screen.dart';
import 'list_screen.dart';

class MyBoardsScreen extends StatefulWidget {
  final int userID;
  const MyBoardsScreen(this.userID);

  // const MyBoardsScreen({super.key});
  @override
  State<MyBoardsScreen> createState() => _MyBoardsScreenState();
}

class _MyBoardsScreenState extends State<MyBoardsScreen> {
  String _searchKeyword = "";
  late Future<List<Map<String, dynamic>>> _boardListFuture;
  List<Map<String, dynamic>> _searchResult = [];
  
  @override
  void initState() {
    super.initState();
    _boardListFuture = _fetchBoardList();
  }

  Future<List<Map<String, dynamic>>> _fetchBoardList() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.7/api/getboards'));
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body)['Data'];
        final boardData = jsonDecode(data);
        List<dynamic> boardList = [];
        if (boardData is List) {
          boardList = boardData;
        } else if (boardData is Map) {
          boardList = [boardData];
        }
        final resultList = boardList
            .map((board) =>
                Map<String, dynamic>.from(board as Map<String, dynamic>))
            .toList();
        return resultList;
      } catch (e) {
        throw Exception('Failed to decode board list');
      }
    } else {
      throw Exception('Failed to load board list');
    }
  }

  Future<List<Map<String, dynamic>>> _searchBoards(String keyword) async {
    final url = Uri.parse('http://192.168.1.7/api/searchBoards/$keyword');
    final response = await http.post(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<Map<String, dynamic>> boardList =
          (jsonData['Data'] as List).cast<Map<String, dynamic>>();
      return boardList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _deleteBoard(int boardId) async {
    final url = Uri.parse('http://192.168.1.7/api/deleteBoard/$boardId');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Board deleted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete board!')),
      );
      print('Failed to delete board. Error: ${response.reasonPhrase}');
    }
  }

  void _onSearch(String keyword) async {
    if (keyword.isNotEmpty) {
      final result = await _searchBoards(keyword);
      setState(() {
        _searchKeyword = keyword;
        _searchResult = result;
      });
    } else {
      setState(() {
        _searchKeyword = '';
        _searchResult = [];
      });
    }
  }

  Color _getLabelColor(String label) {
    switch (label.toLowerCase()) {
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'orange':
        return Colors.orange;
      case 'white':
        return Colors.white;
      default:
        return Colors.grey;
    }
  }

  AssetImage _getImageLabel(String imagePath) {
    return AssetImage(imagePath);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  NavDrawer(widget.userID),
      appBar: AppBar(
        title: const Text('My Boards'),
        actions:<Widget> [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child:GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateScreen(widget.userID),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),         
          ),

        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (value) => _onSearch(value),
              decoration: InputDecoration(
                hintText: 'Enter board name',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(24),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                suffixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _searchKeyword.isEmpty
                  ? _boardListFuture
                  : _searchBoards(_searchKeyword),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data'));
                } else {
                  List<Map<String, dynamic>> boardList = snapshot.data!;
                  List<Map<String, dynamic>> mapList = boardList;
                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      // Build the board item widget
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  ListScreen( userID: widget.userID,
                                BoardName: 'Công việc ở công ty',
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Add image to the label and bottom container
                              Container(
                                width: double.infinity,
                                height: 100,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: _getImageLabel(
                                      'assets/images/background/background_${mapList[index]['Labels']}.jpg',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Confirm'),
                                            content: const Text(
                                              'Are you sure you want to delete this board?',
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
                                                  // TODO: delete board
                                                  _deleteBoard(mapList[index]['BoardID']); 
                                                  // call _deleteBoard function
                                                  await Navigator.of(context).push(
                                                    MaterialPageRoute(builder: (context) => MyBoardsScreen(widget.userID)),
                                                  );
                                                  setState(() {});
                                                  
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 24,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          margin: EdgeInsets.only(right: 8),
                                          decoration: BoxDecoration(
                                            color: _getLabelColor(
                                              mapList[index]['LabelsColor'],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        Text(
                                          mapList[index]['BoardName']
                                              .replaceAll("_", "-"),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      mapList[index]['CreatedDate']
                                          .substring(0, 10),
                                      style:
                                          TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                  color: Colors.grey[200],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 16);
                    },
                    itemCount: mapList.length,
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

