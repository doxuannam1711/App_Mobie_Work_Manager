import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application/model/list.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application/list/list_screen.dart';
import 'package:flutter_application/my_boards/my_boards_screen.dart';
import '../profile_and_display/button_widget.dart';

class ListsAdd extends StatefulWidget{
 final String boardName;
  final int userID;
  final int boardID;
  // const ListScreen (this.boardName,this.boardID);
  const ListsAdd( this.boardName,  this.userID,  this.boardID) ;

  @override
  State<ListsAdd> createState() => _ListsAdd();
}

class _ListsAdd extends State<ListsAdd> 
with TickerProviderStateMixin{
 late String _ListName = "test_list_name";
  late int _ListId = 1;

  Future<void> addList() async {
    // create a new CheckListItemModel object with data from form
     ListModel newList = ListModel(
      listID: _ListId,
      listName: _ListName,
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
  void initState() {
    super.initState();
    // initialize default values
  }

  @override
  Widget build(BuildContext){
    return DefaultTabController(
      length: 2, 
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Create a new list'),

      ),
      body:
      TabBarView(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
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
                        _ListName = value;
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
                    onPressed: () async{
                    addList();
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>  ListScreen(widget.boardName, widget.boardID, widget.userID)),
                    );
                    setState(() {});
                  }, 
                )
              ],
            ),
          )
        ],
      )
    )
    );
  }
}

class ListModel {
  final int listID;
  final String listName;

  ListModel({
    required this.listID,
    required this.listName,
  });

  Map<String, dynamic> toJson() => {
        'ListID': listID,
        'ListName': listName,
      };
}