import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../my_boards/create_card_screen.dart';

class ListsAdd extends StatefulWidget {
  final int userID;
  final int boardID;
  final String labels;
  final String boardName;

  const ListsAdd(
      {Key? key,
      required this.userID,
      required this.boardID,
      required this.labels,
      required this.boardName})
      : super(key: key);

  @override
  State<ListsAdd> createState() => _ListsAdd();
}

class _ListsAdd extends State<ListsAdd> with TickerProviderStateMixin {
  late String _listName = "";

  Future<void> addList() async {
    ListModel newList = ListModel(
      listName: _listName,
      boardID: widget.boardID,
    );


    final response = await http.post(
      Uri.parse('http://192.168.53.160/api/addList/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newList.toJson()),
    );


    if (response.statusCode == 200) {
      // show success message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('List added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding list item!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create a new list'),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Column(
                children: [
                  const SizedBox(height: 16.0),
                  const Text(
                    'List Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _listName = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter list name',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    child: const Text('Add'),
                    onPressed: () {
                      addList();
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ListModel {
  final String listName;
  final int boardID;

  ListModel({
    required this.listName,
    required this.boardID,
  });

  Map<String, dynamic> toJson() => {
        'ListName': listName,
        'BoardID': boardID,
      };
}
