import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/list/list_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../model/card.dart';

class AddCardScreen extends StatefulWidget {
  final int creatorID;
  final int boardID;
  final String labels;
  final String boardName;

  const AddCardScreen(
      {Key? key,
      required this.creatorID,
      required this.boardID,
      required this.labels,
      required this.boardName})
      : super(key: key);

  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  late String _cardName;
  late String _label;
  late String _labelColor;
  late String _selectedLabelOption = 'Low';
  late String _selectedColorOption = 'default';
  DateTime? _dueDate;
  final List<String> _labelOptions = ['High', 'Medium', 'Low'];
  final List<String> _colorOptions = ['red', 'blue', 'green', 'yellow', 'default'];
  List<String> listNames = [];
  late String selectedListID = '';
  late List<dynamic> list;

  @override
  void initState() {
    super.initState();
    getLists();
  }

  Future<void> getLists() async {
    final response = await http.get(
        Uri.parse('http://192.168.53.160/api/getListOption/${widget.boardID}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final jsonString = data['Data'] as String;
      list = jsonDecode(jsonString) as List<dynamic>;
      listNames = list.map((e) => e['ListName'] as String).toList();
      selectedListID = list.first['ID'].toString();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching lists!')),
      );
    }
  }

  Future<void> addCard() async {
    CardModel newCard = CardModel(
      listID: int.parse(selectedListID),
      creatorID: widget.creatorID,
      cardName: _cardName,
      label: _selectedLabelOption,
      comment: 3,
      createdDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      dueDateString: _dueDate?.toIso8601String() ?? '',
      labelColor: _selectedColorOption,
    );

    final response = await http.post(
      Uri.parse('http://192.168.53.160/api/addCard'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newCard.toJson()),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding card!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new card'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          children: [
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
              'List Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: listNames.isNotEmpty ? listNames[0] : null,
              items: listNames.map((name) {
                return DropdownMenuItem<String>(
                  value: name,
                  child: Text(name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedListID = list
                      .firstWhere(
                        (element) => element['ListName'] == value,
                      )['ListID']
                      .toString();
                });
              },
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Label',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: _selectedLabelOption,
              items: _labelOptions.map((label) {
                return DropdownMenuItem<String>(
                  value: label,
                  child: Text(label),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLabelOption = value!;
                });
              },
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Due Date',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
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
                      initialDate: _dueDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() {
                        _dueDate = picked;
                      });
                    }
                  },
                  child: Text(
                    _dueDate == null
                        ? 'Select date'
                        : 'Date: ${_dueDate!.toString().split(' ')[0]}',
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _dueDate = null;
                    });
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Label Color',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: _selectedColorOption,
              items: _colorOptions.map((color) {
                return DropdownMenuItem<String>(
                  value: color,
                  child: Text(color),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedColorOption = value!;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () async {
                addCard();
                await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => ListScreen(widget.boardName,
                          widget.boardID, widget.labels, widget.creatorID)),
                );
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
