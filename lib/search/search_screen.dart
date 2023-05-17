import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application/nav_drawer.dart';
import 'dart:convert';





class SearchScreen extends StatefulWidget {
  final int userID;
  const SearchScreen(this.userID);
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchKeyword = "";
  List<Map<String, dynamic>> _searchResult = [];

  Map<String, dynamic> cardList = {};
  Map<String, dynamic> boardList = {};
  Map<String, dynamic> listData = {};

  Future<Map<String, dynamic>> getCardList() async {
    final response =
        await http.get(Uri.parse('http://192.168.53.160/api/getcardlist'));
    if (response.statusCode == 200) {
      setState(() {
        cardList = jsonDecode(response.body);
      });
      return cardList;
    } else {
      throw Exception('Failed to load list');
    }

  }

  Future<Map<String, dynamic>> getBoardList() async {
    
    final response =
        await http.get(Uri.parse('http://192.168.53.160/api/getboardlist'));
    if (response.statusCode == 200) {
      setState(() {
        boardList = jsonDecode(response.body);
      });
      return boardList;
    } else {
      throw Exception('Failed to load list');
    }

  }

  Future<Map<String, dynamic>> getListData() async {
    
    final response =
        await http.get(Uri.parse('http://192.168.53.160/api/getlistslist'));
    if (response.statusCode == 200) {
      setState(() {
        listData = jsonDecode(response.body);
      });
      return listData;
    } else {
      throw Exception('Failed to load list');
    }

  }

  Future<List<Map<String, dynamic>>> _searchCards(String keyword) async {
    final url = Uri.parse('http://192.168.53.160/api/searchCards/$keyword');
    final response = await http.post(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<Map<String, dynamic>> cardList =
          (jsonData['Data'] as List).cast<Map<String, dynamic>>();
      return cardList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Map<String, dynamic>>> _searchBoards(String keyword) async {
    final url = Uri.parse('http://192.168.53.160/api/searchBoards/$keyword');
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


  Future<List<Map<String, dynamic>>> _searchLists(String keyword) async {
    final url = Uri.parse('http://192.168.53.160/api/searchLists/$keyword');
    final response = await http.post(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<Map<String, dynamic>> listData =
          (jsonData['Data'] as List).cast<Map<String, dynamic>>();
      return listData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _onSearch(String keyword) async {
    if (keyword.isNotEmpty) {
      final result = await _searchCards(keyword);
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(widget.userID),
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.filter_alt_outlined),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _searchKeyword,
                  onChanged: (value) {
                    setState(() {
                      _searchKeyword = value!;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: '0',
                      child: Text('Board'),
                    ),
                    DropdownMenuItem(
                      value: '1',
                      child: Text('List'),
                    ),
                    DropdownMenuItem(
                      value: '2',
                      child: Text('Card'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter name',
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

          
        ],
      ),
    );
  }
}
