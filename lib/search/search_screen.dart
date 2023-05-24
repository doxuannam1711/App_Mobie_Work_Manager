import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application/nav_drawer.dart';
import '../checklist/checklist_screen_show.dart';
import '../my_cards/card_detail_screen.dart';
import '../list/list_screen.dart';

class SearchScreen extends StatefulWidget {
  final int userID;
  const SearchScreen(this.userID);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchKeyword = "";
  List<Map<String, dynamic>> _searchCardResult = [];
  List<Map<String, dynamic>> _searchBoardResult = [];
  List<Map<String, dynamic>> _searchCheckListResult = [];
  int _currentTabIndex = 0; // Thêm biến để theo dõi tab hiện tại

  Future<List<Map<String, dynamic>>> _searchCards(String keyword) async {
    final url = Uri.parse('http://192.168.1.7/api/searchCards/$keyword');
    final response = await http.post(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<Map<String, dynamic>> cardList =
          (jsonData['Data'] as List).cast<Map<String, dynamic>>();
      return cardList;
    } else {
      throw Exception('Failed to load card data');
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
      throw Exception('Failed to load board data');
    }
  }

  Future<List<Map<String, dynamic>>> _searchCheckList(String keyword) async {
    final url = Uri.parse('http://192.168.1.7/api/searchCheckList/$keyword');
    final response = await http.post(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<Map<String, dynamic>> checkList =
          (jsonData['Data'] as List).cast<Map<String, dynamic>>();
      return checkList;
    } else {
      throw Exception('Failed to load board data');
    }
  }

  void _onSearch(String keyword) async {
    if (keyword.isNotEmpty) {
      setState(() {
        _searchKeyword = keyword;
      });

      switch (_currentTabIndex) {
        case 0: // Tab Cards
          final cardResult = await _searchCards(keyword);
          setState(() {
            _searchCardResult = cardResult;
          });
          break;
        case 1: // Tab Boards
          final boardResult = await _searchBoards(keyword);
          setState(() {
            _searchBoardResult = boardResult;
          });
          break;
        case 2: // Tab Checklists
          final checkListResult = await _searchCheckList(keyword);
          setState(() {
            _searchCheckListResult = checkListResult;
          });
          break;
      }
    } else {
      setState(() {
        _searchKeyword = '';
        _searchCardResult = [];
        _searchBoardResult = [];
        _searchCheckListResult = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(widget.userID),
      appBar: AppBar(
        title: const Text('Tìm kiếm'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Nhập từ khóa',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(24),
                ),
                filled: true,
                // fillColor: Colors.grey[200],
                suffixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    tabs: const [
                      Tab(
                        child: Text(
                          'Thẻ của tôi',
                          style: TextStyle(
                            color: Colors.black, // Đặt màu văn bản là màu đen
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Bảng của tôi',
                          style: TextStyle(
                            color: Colors.black, // Đặt màu văn bản là màu đen
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Checklists',
                          style: TextStyle(
                            color: Colors.black, // Đặt màu văn bản là màu đen
                          ),
                        ),
                      ),
                    ],
                    onTap: (index) {
                      setState(() {
                        _currentTabIndex = index;
                      });
                    },
                  ),
                  Expanded(
                    child: IndexedStack(
                      index: _currentTabIndex,
                      children: [
                        _buildCardResultList(),
                        _buildBoardResultList(),
                        _buildChecklistResultList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardResultList() {
    if (_searchKeyword.isEmpty) {
      return const Center(
        child: Text('Chưa nhập từ khóa nào.'),
      );
    } else if (_searchCardResult.isEmpty) {
      return const Center(
        child: Text('Không tìm thấy thẻ.'),
      );
    } else {
      return ListView.builder(
        itemCount: _searchCardResult.length * 2 -
            1, // Đặt số lượng item để tính cả dấu gạch ngang
        itemBuilder: (context, index) {
          if (index.isOdd) {
            // Xác định vị trí dấu gạch ngang
            return Divider();
          } else {
            // Xác định vị trí item
            final cardIndex = index ~/ 2;
            final card = _searchCardResult[cardIndex];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CardsDetailScreen(
                      card['CardName'],
                      card['CardID'],
                      widget.userID,
                    ),
                  ),
                );
              },
              child: ListTile(
                title: Text(card['CardName']),
              ),
            );
          }
        },
      );
    }
  }

  Widget _buildBoardResultList() {
    if (_searchKeyword.isEmpty) {
      return const Center(
        child: Text('Chưa nhập từ khóa nào.'),
      );
    } else if (_searchBoardResult.isEmpty) {
      return const Center(
        child: Text('Không tìm thấy bảng.'),
      );
    } else {
      return ListView.builder(
        itemCount: _searchBoardResult.length * 2 -
            1, // Đặt số lượng item để tính cả dấu gạch ngang
        itemBuilder: (context, index) {
          if (index.isOdd) {
            // Xác định vị trí dấu gạch ngang
            return Divider();
          } else {
            // Xác định vị trí item
            final boardIndex = index ~/ 2;
            final board = _searchBoardResult[boardIndex];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListScreen(
                      board['BoardName'],
                      board['BoardID'],
                      board['Labels'],
                      widget.userID,
                    ),
                  ),
                );
              },
              child: ListTile(
                title: Text(board['BoardName']),
              ),
            );
          }
        },
      );
    }
  }

  Widget _buildChecklistResultList() {
    if (_searchKeyword.isEmpty) {
      return const Center(
        child: Text('Chưa nhập từ khóa nào.'),
      );
    } else if (_searchCheckListResult.isEmpty) {
      return const Center(
        child: Text('Không tìm thấy checklists.'),
      );
    } else {
      return ListView.builder(
        itemCount: _searchCheckListResult.length * 2 -
            1, // Đặt số lượng item để tính cả dấu gạch ngang
        itemBuilder: (context, index) {
          if (index.isOdd) {
            // Xác định vị trí dấu gạch ngang
            return Divider();
          } else {
            // Xác định vị trí item
            final checklistIndex = index ~/ 2;
            final checklist = _searchCheckListResult[checklistIndex];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChecklistScreenShow(
                      cardID: 1,
                      userID: widget.userID,
                    ),
                  ),
                );
              },
              child: ListTile(
                title: Text(checklist['Title']),
                // subtitle: Text(checklist['description']),
              ),
            );
          }
        },
      );
    }
  }
}
