import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../my_cards/card_detail_screen.dart';
import 'package:flutter_application/my_boards/my_boards_screen.dart';
import 'package:flutter_application/my_boards/create_card_screen.dart';
import 'package:flutter_application/list/list_add.dart';

class ListScreen extends StatefulWidget {
  final String boardName;
  final int userID;
  final int boardID;
  final String labels;

  const ListScreen(
    this.boardName,
    this.boardID,
    this.labels,
    this.userID, 
  );

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final bool _filterByDate = true;
  final int _listID = 1;
  DateFormat dateFormat = DateFormat('MMMM dd');
  final List<String> _listAvatar = [
    'https://png.pngtree.com/png-vector/20191027/ourlarge/pngtree-cute-pug-avatar-with-a-yellow-background-png-image_1873432.jpg',
    'https://dogily.vn/wp-content/uploads/2022/12/Anh-avatar-cho-Shiba-4.jpg',
    'https://top10camau.vn/wp-content/uploads/2022/10/avatar-meo-cute-5.jpg',
  ];
  final _items = <Map<String, dynamic>>[];
  final _itemNameController = TextEditingController();
  final _itemNameFocusNode = FocusNode();
  final bool _isAddingNewList = false;
  final String _ListName = '';
  // int _BoardID = 0;
  final int _ListID = 0;
  final bool _isEditingName = false;

  Map<String, List<Map<String, dynamic>>> _cardLists = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<List<Map<String, dynamic>>> _fetchcardList() async {
    final response = await http
        .get(Uri.parse('http://192.168.53.160/api/getLists/${widget.boardID}'));
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

  Future<List<Map<String, dynamic>>> _fetchCard(int listID) async {
    final response = await http
        .get(Uri.parse('http://192.168.53.160/api/getCards/$listID'));
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

  Future<void> _fetchData() async {
    final cardLists = await _fetchcardList();
    Map<String, List<Map<String, dynamic>>> tempCardLists = {};
    for (var card in cardLists) {
      String listName = card['ListName'];
      if (!tempCardLists.containsKey(listName)) {
        tempCardLists[listName] = [];
      }
      tempCardLists[listName]!.add(card); // add a null check here
    }
    setState(() {
      _cardLists = tempCardLists;
    });
  }

  int _currentPage = 2;

  @override
  Widget build(BuildContext context) {
    List<String> listNames = _cardLists.keys.toList();
    bool sortByIncreasing =
        true; // Default option is to sort by increasing expiration date
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.boardName),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: true,
                  child: Text("Sort by increasing expiration date"),
                ),
                const PopupMenuItem(
                  value: false,
                  child: Text("Sort by decreasing expiration date"),
                ),
              ];
            },
            onSelected: (value) {
              setState(() {
                sortByIncreasing = value;
              });
            },
            icon: const Icon(Icons.filter_list),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ListsAdd(
                    userID: widget.userID,
                    boardID: widget.boardID,
                    labels: widget.labels,
                    boardName: widget.boardName,
                  ),
                ),
              );
              setState(() {});
            }, // Navigate to the form to add a new list.
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/background/background_${widget.labels}.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  String listName = listNames[index];
                  List<Map<String, dynamic>> cardList =
                      _cardLists.values.toList()[index];
                  // List<Map<String, dynamic>> cardList = _cardLists.values
                  //     .expand((x) => x)
                  //     .where((element) =>
                  //         element.containsKey("ListID") &&
                  //         element["ListID"] == 1)
                  //     .toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Theme.of(context).colorScheme.secondary,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              listName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildCardsList(listName, cardList),
                      ),
                    ],
                  );
                },
                itemCount: _cardLists.length,
                controller: PageController(initialPage: _currentPage),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCardScreen(
                      creatorID: widget.userID,
                      boardID: widget.boardID,
                      labels: widget.labels,
                      boardName: widget.boardName,
                    ),
                  ),
                );
              },
              child: const Text('Thêm thẻ mới'),
            ),
            SizedBox(
              height: 48,
              child: Center(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listNames.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.circle,
                              color: _currentPage == index
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.grey,
                              size: 12,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsList(String listName, List<Map<String, dynamic>> cardList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              String title = cardList[index]['CardName'];
              // int test = cardList[index]['ListID'];
              // debugPrint(cardList.toString());
              String label = cardList[index]['Label'];
              // String label = "Medium";
              DateTime? expirationDate =
                  DateTime.tryParse(cardList[index]['DueDate'] ?? '');
              int comments = cardList[index]['Comment'];
              int checkedItems = cardList[index]['IntCheckList'] ?? 2;
              ;
              int totalItems = cardList[index]['Checklist'] ?? 2;
              List<String> avatars = List.castFrom<dynamic, String>(
                  cardList[index]['Avatars'] ?? []);
              return _buildCard(
                title,
                label,
                expirationDate,
                comments,
                checkedItems,
                totalItems,
                avatars,
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(width: 16),
            itemCount: cardList.length,
          ),
        ),
      ],
    );
  }

  Color _getColorFromLabel(String label) {
    switch (label) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.yellow;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getFormattedExpirationDate(DateTime? expirationDate) {
    if (expirationDate == null) {
      return 'No date';
    } else {
      final formatter = DateFormat('MMM d, y');
      return formatter.format(expirationDate);
    }
  }

  Widget _buildCard(
    String title,
    String label,
    DateTime? expirationDate,
    int comments,
    int checkedItems,
    int totalItems,
    List<String> avatars,
  ) {
    return GestureDetector(
      onTap: () {
        // Handle item click
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CardsDetailScreen('Front End', 1, widget.userID),
          ),
        );
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _getColorFromLabel(label),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getFormattedExpirationDate(expirationDate),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.comment,
                    size: 12,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    comments.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    checkedItems == totalItems
                        ? Icons.check_circle_outline
                        : Icons.check_circle_outline_rounded,
                    size: 12,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$checkedItems/$totalItems',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(
                  avatars.length,
                  (index) => const CircleAvatar(
                    radius: 10,
                    backgroundImage:
                        AssetImage('assets/images/avatar_user1.jpg'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListModel {
  final int ListID;
  final String ListName;

  ListModel({
    required this.ListID,
    required this.ListName,
  });

  Map<String, dynamic> toJson() => {
        'ListID': ListID,
        'ListName': ListName,
      };
}
