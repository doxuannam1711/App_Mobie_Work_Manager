import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../my_cards/card_detail_screen.dart';
import 'package:flutter_application/my_boards/my_boards_screen.dart';
import 'package:flutter_application/list/list_add.dart';

class ListScreen extends StatefulWidget {
  final String boardName;
  final int userID;
  final int boardID;


  // ListScreen(required this.userID, required this.BoardName);

      const ListScreen( this.boardName,  this.userID,  this.boardID) ;
  // const ListScreen({Key? key,required this.userID, required this.BoardName,
  //     required this.boardID}) : super(key: key);

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
  bool _isAddingNewList = false;
  String _ListName = '';
  // int _BoardID = 0;
  int _ListID = 0;
  bool _isEditingName = false;

  @override
  void initState() {
    super.initState();
     _fetchList();
    _isAddingNewList = false;
  }

  Future<List<Map<String, dynamic>>> _fetchList() async {
    final response =
        await http.get(Uri.parse('http://192.168.53.160/api/getLists/${widget.boardID}'));
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body)['Data'];
        final listData = jsonDecode(data);
        List<dynamic> listList = [];
        if (listData is List) {
          listList = listData;
        } else if (listData is Map) {
          listList = [listData];
        }
        final resultList = listList
            .map((board) =>
                Map<String, dynamic>.from(board as Map<String, dynamic>))
            .toList();
        return resultList;
      } catch (e) {
        throw Exception('Failed to decode list');
      }
    } else {
      throw Exception('Failed to load list');
    }
  }

  Future<List<Map<String, dynamic>>> _fetchCardList() async {
    final response =
        await http.get(Uri.parse('http://192.168.53.160/api/getcards/'));
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
      throw Exception('Failed to load  list');
    }
  }

  // Future<void> _addList() async {
  //   final url = Uri.parse('http://192.168.53.160/api/addList');
  //   final response = await http.post(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, dynamic>{
  //       'userID': widget.userID,
  //       'boardID': widget.boardID,
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Comment added successfully!')),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Comment added failed!')),
  //     );
  //   }
  // }
  
//   final Map<String, List<Map<String, dynamic>>> _cardLists = {
//     'Website bán hàng': [
//       {
//         'CardName': 'FrontEnd',
//         'Label': 'Medium',
//         'ExpirationDate': '2023-12-31',
//         'Comments': 4,
//         'CheckedItems': 3,
//         'TotalItems': 5,
//       },
//       {
//         'CardName': 'Create Database',
//         'Label': 'Low',
//         'ExpirationDate': '2024-06-30',
//         'Comments': 3,
//         'CheckedItems': 2,
//         'TotalItems': 5,
//       },
//       {
//         'CardName': 'Create WebAPI',
//         'Label': 'High',
//         'ExpirationDate': '2024-06-30',
//         'Comments': 5,
//         'CheckedItems': 2,
//         'TotalItems': 4,
//       },
//       {
//         'CardName': 'BackEnd',
//         'Label': 'High',
//         'ExpirationDate': '2024-06-30',
//         'Comments': 11,
//         'CheckedItems': 3,
//         'TotalItems': 4,
//       },
// // ... more cards
//     ],
//     'Phần mềm quản lý công nhân': [
//       {
//         'CardName': 'FrontEnd',
//         'Label': 'Medium',
//         'ExpirationDate': '2023-12-31',
//         'Comments': 4,
//         'CheckedItems': 3,
//         'TotalItems': 5,
//       },
//       {
//         'CardName': 'Create Database',
//         'Label': 'Low',
//         'ExpirationDate': '2024-06-30',
//         'Comments': 3,
//         'CheckedItems': 2,
//         'TotalItems': 5,
//       },
//       {
//         'CardName': 'Create WebAPI',
//         'Label': 'High',
//         'ExpirationDate': '2024-06-30',
//         'Comments': 5,
//         'CheckedItems': 2,
//         'TotalItems': 4,
//       },
// // ... more cards
//     ],
//     'App mobile quản lý công việc cá nhân': [
//       {
//         'CardName': 'FrontEnd',
//         'Label': 'Medium',
//         'ExpirationDate': '2023-12-31',
//         'Comments': 4,
//         'CheckedItems': 3,
//         'TotalItems': 5,
//       },
//       {
//         'CardName': 'Create Database',
//         'Label': 'Low',
//         'ExpirationDate': '2024-06-30',
//         'Comments': 3,
//         'CheckedItems': 2,
//         'TotalItems': 5,
//       },
//       {
//         'CardName': 'Create WebAPI',
//         'Label': 'High',
//         'ExpirationDate': '2024-06-30',
//         'Comments': 5,
//         'CheckedItems': 2,
//         'TotalItems': 4,
//       },
//       {
//         'CardName': 'BackEnd',
//         'Label': 'High',
//         'ExpirationDate': '2024-06-30',
//         'Comments': 11,
//         'CheckedItems': 3,
//         'TotalItems': 4,
//       },
//       {
//         'CardName': 'BackEnd2',
//         'Label': 'High',
//         'ExpirationDate': '2024-06-30',
//         'Comments': 11,
//         'CheckedItems': 3,
//         'TotalItems': 4,
//       },
// // ... more cards
//     ],
//     '': [], // empty list to add new list
//   };

  int _currentPage = 0;
  // void _addNewList(String listName) async{
  //   if(listName.isNotEmpty){

  //     await addList
  //   }
  // }
  Widget build(BuildContext context) {
    // List<String> listNames = _cardLists.keys.toList();
    bool sortByIncreasing =
        true; // Default option is to sort by increasing expiration date
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.boardName),
        actions:<Widget> [
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
          
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child:GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListsAdd(widget.boardName, widget.boardID, widget.userID),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),         
          ),
          
           
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background/background_2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child : FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Failed to load list'),
                    );
                  } else {
                    final cardList = snapshot.data!;
                    return PageView.builder(
                itemCount: cardList.length,
                itemBuilder: (context, index) {
         
                  final list = cardList[index];
                  return _buildList(
                    list['ListName'],
                    list['ListID'],
                  );
                  
                },
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },             
                controller: PageController(initialPage: _currentPage),
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

            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchCardList(),
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
                          card['index_checked'],
                          card['SUM'],
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
      ),
    );
  }
Widget _buildList(
    String name,
    int listID,
  ){
   return PageView(
     children: 
        [Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Theme.of(context).accentColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    name,                            
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            
            
                SizedBox(
                  height: 48,
                  child: Center(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: listID,
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
                                      ? Theme.of(context).accentColor
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
      ],
   );

    
}
  Color _getColorFromLabel(String label) {
    switch (label) {
      case 'red':
        return Colors.red;
      case 'yellow':
        return Colors.yellow;
      case 'green':
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
    int cardID,
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
      // onTap: () {
      //   // Handle item click
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => CardsDetailScreen(title, cardID, widget.userID),
      //       // builder: (context) => CardsDetailScreen(title, cardID)
      //     ),
      //   );
      // },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: _getColorFromLabel(label),
              blurRadius: 4,
              offset: Offset(0, 2),
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
                      color: rectangleColor,
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
                mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(radius: 14,backgroundImage: NetworkImage(avatars[0])),
              const SizedBox(width: 2),
              CircleAvatar(radius: 14,backgroundImage: NetworkImage(avatars[1])),
              const SizedBox(width: 2),
              CircleAvatar(radius: 14,backgroundImage: NetworkImage(avatars[2])),
            ],
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