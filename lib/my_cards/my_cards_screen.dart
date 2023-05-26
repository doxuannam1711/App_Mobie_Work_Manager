import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../my_boards/create_card_screen.dart';
import '../my_boards/create_screen.dart';
import '../nav_drawer.dart';
import '../my_cards/card_detail_screen.dart';

class MyCardsScreen extends StatefulWidget {
  final int userID;
  const MyCardsScreen(this.userID);

  // const MyCardsScreen({super.key});

  @override
  State<MyCardsScreen> createState() => _MyCardsScreenState();
}

class _MyCardsScreenState extends State<MyCardsScreen> {
  @override
  void initState() {
    super.initState();
    _fetchCardList();
  }

  String _searchKeyword = "";
  bool _filterByDate = true;
  final int _cardID = 1;
  DateFormat dateFormat = DateFormat('MMMM dd');
  final List<String> _listAvatar = [
    'https://png.pngtree.com/png-vector/20191027/ourlarge/pngtree-cute-pug-avatar-with-a-yellow-background-png-image_1873432.jpg',
    'https://dogily.vn/wp-content/uploads/2022/12/Anh-avatar-cho-Shiba-4.jpg',
    'https://top10camau.vn/wp-content/uploads/2022/10/avatar-meo-cute-5.jpg',
  ];
  List<Map<String, dynamic>> _searchResult = [];
  bool _sortByDate = false;
  Future<List<Map<String, dynamic>>> _fetchCardList() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.7/api/getCards/${widget.userID}'));
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body)['Data'];
        final cardData = jsonDecode(data);
        List<dynamic> cardList = [];
        if (cardData is List) {
          cardList = cardData;
        } else if (cardData is Map) {
          cardList = [cardData];
        }
        final resultList = cardList
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

  Future<List<Map<String, dynamic>>> _fetchSortCardList() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.7/api/sortCard/${widget.userID}'));
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body)['Data'];
        final cardData = jsonDecode(data);
        List<dynamic> cardList = [];
        if (cardData is List) {
          cardList = cardData;
        } else if (cardData is Map) {
          cardList = [cardData];
        }
        final resultList = cardList
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

  Future<List<Map<String, dynamic>>> _fetchSortCardLabel() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.7/api/sortCardLabel/${widget.userID}'));
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body)['Data'];
        final cardData = jsonDecode(data);
        List<dynamic> cardList = [];
        if (cardData is List) {
          cardList = cardData;
        } else if (cardData is Map) {
          cardList = [cardData];
        }
        final resultList = cardList
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

  Future<List<Map<String, dynamic>>> _searchCards(String keyword) async {
    final encodedKeyword = Uri.encodeComponent(keyword);
    final url =
        Uri.parse('http://192.168.1.7/api/searchCards/$encodedKeyword');
    final response = await http.post(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<Map<String, dynamic>> cardList =
          (jsonData['Data'] as List).cast<Map<String, dynamic>>();
      return cardList;
    } else {
      // Xử lý khi tìm kiếm thất bại
      try {
        return await _fetchCardList();
      } catch (e) {
        throw Exception('Failed to load data');
      }
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
        title: const Text('Các thẻ của tôi'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCardScreen(
                      creatorID: widget.userID,
                      boardID: -1,
                      labels: "mycard",
                      boardName: "",
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
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
                DropdownButton<bool>(
                  value: _sortByDate,
                  onChanged: (value) {
                    setState(() {
                      _sortByDate = value!;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: false,
                      child: Text('Màu Nhãn'),
                    ),
                    DropdownMenuItem(
                      value: true,
                      child: Text('Ngày hết hạn'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              onChanged: (value) => _onSearch(value),
              decoration: InputDecoration(
                hintText: 'Nhập tên bảng',
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
              future: _searchResult.isEmpty
                  ? (_sortByDate ? _fetchSortCardList() : _fetchSortCardLabel())
                  : Future<List<Map<String, dynamic>>>.value(_searchResult),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Failed to load card list'),
                    );
                  } else {
                    final cardList = snapshot.data!;
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: cardList.length,
                      itemBuilder: (context, index) {
                        final card = cardList[index];
                        return _buildCard(
                          card['CardName'],
                          card['LabelColor'],
                          card['DueDate'] != null
                              ? DateTime.parse(card['DueDate'])
                              : null,
                          card['Comment'],
                          card['index_checked'] = card['index_checked'] ?? 2,
                          card['SUM'] = card['SUM'] ?? 2,
                          _listAvatar,
                          card['CardID'], // pass cardID to _buildCard
                        );
                      },
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

  Widget _buildCard(
    String title,
    String label,
    DateTime? expirationDate,
    int comments,
    int checkedItems,
    int totalItems,
    List<String> avatars,
    int cardID, // add cardID as a parameter
  ) {
    Color rectangleColor = Colors.blue;
    switch (label.trim()) {
      case 'green':
        rectangleColor = Colors.green;
        break;
      case 'red':
        rectangleColor = Colors.red;
        break;
      case 'yellow':
        rectangleColor = Colors.yellow;
        break;
      default:
        rectangleColor = Colors.blue;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CardsDetailScreen(title, cardID,
                widget.userID), // pass cardID to CardsDetailScreen
          ),
        );
      },
      child: Card(
        key: expirationDate == null
            ? const ValueKey('noExpiration')
            : ValueKey(expirationDate),
        child: ListTile(
          minLeadingWidth: 1,
          leading: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: rectangleColor,
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              title,
            ),
          ),
          subtitle: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.calendar_today_outlined, size: 16),
                const SizedBox(width: 4),
                Text(
                  expirationDate != null
                      ? DateFormat('MMM d').format(expirationDate)
                      : 'No expiration',
                ),
                const SizedBox(width: 8),
                const Icon(Icons.comment_outlined, size: 16),
                const SizedBox(width: 4),
                Text('$comments'),
                const SizedBox(width: 8),
                const Icon(Icons.check_box_outlined, size: 16),
                const SizedBox(width: 4),
                Text('$checkedItems/$totalItems'),
              ],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                  radius: 14, backgroundImage: NetworkImage(avatars[0])),
              const SizedBox(width: 2),
              CircleAvatar(
                  radius: 14, backgroundImage: NetworkImage(avatars[1])),
              const SizedBox(width: 2),
              CircleAvatar(
                  radius: 14, backgroundImage: NetworkImage(avatars[2])),
            ],
          ),
        ),
      ),
    );
  }
}
