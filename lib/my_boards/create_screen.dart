import 'dart:convert';
import 'package:flutter_application/my_boards/my_boards_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application/model/board.dart';

import '../profile_and_display/button_widget.dart';
import 'background_item.dart';

class CreateScreen extends StatefulWidget {

  final int userID;
  const CreateScreen(this.userID);

  // CreateScreen({Key? key}) : super(key: key);

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen>
    with TickerProviderStateMixin {
  late String _boardName = "test";
  late int userID = 1;
  late String _boardColor;
  late String _cardName;
  late String _cardDescription;
  late DateTime _startDate;
  late DateTime _expirationDate;
  late List<String> _members;
  late List<String> _attachments;
  List<String> myStringList = ['string1', 'string2', 'string3'];
  String _backgroundImage = "0";
  // TabController controller = TabController(length: 2, vsync: this);

  Future<void> addBoard() async {
    // get the current user ID or use a default value
    // int userID = currentUser?.id ?? 1;

    // create a new board object with data from form
    BoardModel newBoard = BoardModel(
      boardName: _boardName,
      createdDate: DateTime.now(),
      UserID: 1,
      labels: _backgroundImage,
      labelsColor: _boardColor,
    );

    // call the API to add the new board
    final response = await http.post(
      Uri.parse('http://192.168.1.7/api/addBoard'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newBoard.toJson()),
    );

    // check if the request was successful
    if (response.statusCode == 200) {
      // show success message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Board added successfully!')),
      );
    } else {
      // show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding board!')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // initialize default values
    _boardColor = 'Blue';
    _members = [];
    _attachments = [];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create'),
          // controller: controller,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Board'),
              Tab(text: 'Card'),
            ],
          ),
        ),
        body:
        TabBarView(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  const Text(
                    'Board Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _boardName = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter board name',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Board Color',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  DropdownButtonFormField<String>(
                    value: _boardColor,
                    items: <String>[
                      'Blue',
                      'Green',
                      'Red',
                      'Yellow',
                      'Custom',
                    ].map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        _boardColor = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Background Image',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  DropdownButton<String>(
                    key: UniqueKey(),
                    value: _backgroundImage,
                    onChanged: (value) {
                      setState(() {
                        _backgroundImage = value!;
                      });
                    },
                    items: const [
                      DropdownMenuItem<String>(
                        value: '0',
                        child: BackgroundItem(
                          value: 'background_0.jpg',
                          text: 'Background 1',
                          image: 'background_0.jpg',
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: '1',
                        child: BackgroundItem(
                          value: 'background_1.jpg',
                          text: 'Background 2',
                          image: 'background_1.jpg',
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: '2',
                        child: BackgroundItem(
                          value: 'background_2.jpg',
                          text: 'Background 3',
                          image: 'background_2.jpg',
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: '3',
                        child: BackgroundItem(
                          value: 'background_3.jpg',
                          text: 'Background 4',
                          image: 'background_3.jpg',
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: '4',
                        child: BackgroundItem(
                          value: 'background_4.jpg',
                          text: 'Background 5',
                          image: 'background_4.jpg',
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: '9',
                        child: BackgroundItem(
                          value: 'background_9.jpg',
                          text: 'Background 6',
                          image: 'background_9.jpg',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  
                  ElevatedButton(
                    child: const Text('Add'),
                    onPressed: () async{
                      addBoard();
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MyBoardsScreen(widget.userID)),
                      );
                      setState(() {});
                    },    
                  ),
                ],
              ),
            ),
            // Board section

            // Card section
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  const Text(
                    'Card List',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  DropdownButtonFormField<String>(
                    value: null,
                    items: <String>['List 1', 'List 2', 'List 3']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select a list',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Card Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _cardName = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter card name',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Card Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _cardDescription = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter card description',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Start Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _startDate = DateTime.parse(value);
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter start date',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Expiration Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _expirationDate = DateTime.parse(value);
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter expiration date',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Members',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        myStringList.add(value);
                        _members = myStringList;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter members',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Attachments',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        myStringList.add(value);
                        _attachments = myStringList;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter attachments',
                    ),
                  ),
                ]
              )
            )
          ],
        ) 
      )
    );
  }
}
