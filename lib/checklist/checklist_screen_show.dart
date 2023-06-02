import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../my_cards/my_cards_screen.dart';

class ChecklistScreenShow extends StatefulWidget {
  final int userID;
  final int cardID;

  const ChecklistScreenShow(
      {super.key, required this.cardID, required this.userID});

  @override
  State<ChecklistScreenShow> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreenShow> {
  final _items = <Map<String, dynamic>>[];
  final _itemNameController = TextEditingController();
  final _itemNameFocusNode = FocusNode();
  bool _isAddingNewItem = false;
  String? _checklistName;
  int? _checklistID; // Update the type to int?
  bool _isEditingName = false;
  bool? _isCheckedFilter;

  @override
  void initState() {
    super.initState();
    _fetchChecklistItems();
    _isAddingNewItem = false;
  }

  Future<void> _fetchChecklistItems() async {
    final response = await http.get(
        Uri.parse('http://192.168.53.160/api/getChecklists/${widget.cardID}'));
    final String jsonData = json.decode(response.body)['Data'];
    final List<dynamic> data = json.decode(jsonData);

    if (data.isEmpty) {
      setState(() {
        _checklistID = null;
        _checklistName = null;
        _items.clear();
      });
      return;
    }

    final List<Map<String, dynamic>> items =
        List<Map<String, dynamic>>.from(data);

    setState(() {
      _checklistID = items[0]['ChecklistID'];
      _checklistName = items[0]['CardName'];

      _items.clear();
      _items.addAll(items.map((item) => {
            'checklistitemID': item['ChecklistitemID'],
            'title': item['Title'],
            'completed': item['Completed'] ?? false,
          }));
    });
  }

  Future<void> _deleteChecklistitem(String itemName) async {
    final url =
        Uri.parse('http://192.168.53.160/api/deleteChecklistitem/$itemName');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
    } else {
      // Error
      print('Failed to delete item. Error: ${response.reasonPhrase}');
    }
  }

  Future<void> addCheckListItem(String itemName) async {
    // create a new CheckListItemModel object with data from form
    CheckListItemModel newItem = CheckListItemModel(
      cardID: widget.cardID,
      title: itemName,
    );

    // call the API to add the new checklist item
    final response = await http.post(
      Uri.parse('http://192.168.53.160/api/addChecklistitem'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newItem.toJson()),
    );

    // check if the request was successful
    if (response.statusCode == 200) {
      // show success message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thêm đầu việc thành công!')),
      );
    } else {
      // show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding checklist item!')),
      );
    }
  }

  Future<void> _updateChecklistItem(
      int checklistitemID, String title, bool completed) async {
    final url = Uri.parse(
        'http://192.168.53.160/api/updatechecklistitem/$checklistitemID');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'Title': title,
        'Completed': completed,
      }),
    );

    if (mounted) {
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật đầu việc thành công!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật đầu việc không thành công!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
// Define a variable to store the filtered items
    List<Map<String, dynamic>> filteredItems = [];
    if (_isCheckedFilter == true) {
      filteredItems = _items
          .where((item) => item['isChecked'])
          .toList(); // displays checked items only
    } else if (_isCheckedFilter == false) {
      filteredItems = _items
          .where((item) => !item['isChecked'])
          .toList(); // displays unchecked items only
    } else {
      filteredItems = List.from(_items); // displays all items
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        // Display the checklist name as text or as an editable text field
        title: _isEditingName
            ? TextFormField(
                initialValue: _checklistName ?? '',
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    _checklistName = value;
                  });
                },
              )
            : Text(_checklistName ?? ''),

        actions: [
          IconButton(
            icon: const Icon(Icons.check_box_outline_blank),
            onPressed: () {
              setState(() {
                _isCheckedFilter = false;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.check_box),
            onPressed: () {
              setState(() {
                _isCheckedFilter = true;
              });
            },
          ),
          // Toggle between filtering and displaying only checked items, only unchecked items, or all items
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              setState(() {
                _isCheckedFilter = null;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            // Display the checklist name as text
            if (!_isEditingName)
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  _checklistName ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),

            // Text(
            //   _checklistName,
            //   style: const TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 18.0,
            //   ),
            // ),
            const SizedBox(height: 8.0),
            // Display the items based on the selected filter option
            for (final item in filteredItems)
              _buildChecklistItem(_items.indexOf(item), item),
            const SizedBox(height: 20.0),
            _buildAddNewItemRow(),
            if (_isAddingNewItem) _buildNewItemRow(),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.pop(
                //       context,
                //       {
                //         'checklistName': _checklistName,
                //         'items': _items,
                //       },
                //     );
                //   },
                //   child: Text('Save'),
                // ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyCardsScreen(widget.userID)),
                        (route) =>
                            false, // Xoá tất cả các screen còn lại trên stack
                      );
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Adjust the value to your desired roundness
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.black;
                          }
                          return Colors.blue.shade900;
                        },
                      ),
                    ),
                    child: const Text('LƯU'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(int index, Map<String, dynamic> item) {
    bool isCompleted = item['completed'] ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            item['isEditable'] = true;
          });
        },
        child: Row(
          children: [
            Checkbox(
              value: isCompleted,
              onChanged: (value) {
                setState(() {
                  item['completed'] = value!;
                  _updateChecklistItem(
                      item['checklistitemID'], item['title'], value!);
                });
              },
            ),
            Expanded(
              child: item['isEditable'] == true
                  ? Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: item['title'],
                            autofocus: true,
                            onChanged: (value) {
                              setState(() {
                                item['title'] = value;
                              });
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.done),
                          onPressed: () {
                            setState(() {
                              item['isEditable'] = false;
                              _updateChecklistItem(item['checklistitemID'],
                                  item['title'], item['completed']!);
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            setState(() {
                              _items.removeAt(index);
                            });
                            await _deleteChecklistitem(item['checklistitemID']);
                          },
                        ),
                      ],
                    )
                  : Text(
                      '${item['title']}',
                      style: isCompleted
                          ? const TextStyle(
                              decoration: TextDecoration.lineThrough,
                            )
                          : const TextStyle(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewItemRow() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isAddingNewItem = true;
          _itemNameFocusNode.requestFocus();
        });
      },
      child: Row(
        children: [
          Icon(Icons.add),
          SizedBox(width: 8.0),
          Text(
            'THÊM ĐẦU MỤC CÔNG VIỆC',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildNewItemRow() {
    return Column(
      children: [
        const SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: const OutlineInputBorder(),
                  hintText: 'Nhập tên đầu mục',
                ),
                controller: _itemNameController,
                focusNode: _itemNameFocusNode,
                autofocus: true,
                onSubmitted: (value) {
                  _addItem(value);
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.done),
              onPressed: () {
                _addItem(_itemNameController.text);
              },
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isAddingNewItem = false;
                  _itemNameController.clear();
                  _itemNameFocusNode.unfocus();
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  void _addItem(String itemName) async {
    if (itemName.isNotEmpty) {
      // add new item to the API
      await addCheckListItem(itemName);

      // fetch updated list from the API
      await _fetchChecklistItems();

      // add new item to the local list
      setState(() {
        // _items.add({'name': itemName, 'isChecked': false});
        _itemNameController.clear();
        _isAddingNewItem = false;
        _itemNameFocusNode.unfocus();
      });

      // Scroll to the added item
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final double distance =
            box.size.height - box.localToGlobal(Offset.zero).dy;
        if (distance > 0) {
          Scrollable.ensureVisible(context,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn);
        }
      });
    }
  }
}

class CheckListItemModel {
  final int cardID;
  final String title;

  CheckListItemModel({
    required this.cardID,
    required this.title,
  });

  Map<String, dynamic> toJson() => {
        'CardID': cardID,
        'Title': title,
      };
}
