import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../attachment/attachment_screen.dart';
import '../checklist/checklist_screen_show.dart';
import '../member/member_screen.dart';
import '../model/card_detail.dart';
import '../nav_drawer.dart';
import 'my_cards_screen.dart';

class CardsDetailScreen extends StatefulWidget {
  final int userID;
  final String cardName;
  final int cardID;

  const CardsDetailScreen(this.cardName, this.cardID, this.userID);

  @override
  State<CardsDetailScreen> createState() => _CardsDetailScreenState();
}

class _CardsDetailScreenState extends State<CardsDetailScreen> {
  late CardDetail _cardDetail;
  String _cardName = '';
  int permission = 2;
  // late String _cardName;
  String _listName = ''; // List within which the card is contained
  String _description = ''; // Description of the card
  DateTime? _expirationDate; // Expiration date of the card

  String _member = 'Đỗ Xuân Nam'; // Member assigned to the card

  final List<Color> _labelColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.yellow,
  ];

  final List<String> _labelList = [
    'High',
    'Medium',
    'Low',
  ];

  Color? label;
  String? labelName = "red";
  String? label2 = "High";

  String _comment = "";
  final commentFocusNode = FocusNode();

  String _editComment = "";

  var _cardNameController;

  @override
  void initState() {
    super.initState();
    _cardName = widget.cardName; // Khởi tạo giá trị của _cardName
    _cardNameController = TextEditingController(text: widget.cardName);
    fetchCardDetail(widget.cardID).then((cardDetail) {
      setState(() {
        _cardDetail = cardDetail;
        _listName = cardDetail.listName;
        _expirationDate = DateTime.parse(cardDetail.dueDate);
        permission = cardDetail.permission;
        // _expirationDate = cardDetail.expirationDate;
      });
    });
  }

  @override
  void dispose() {
    _cardNameController.dispose();
    super.dispose();
  }

  void _updateCardName(String value) {
    // Cập nhật giá trị của _cardName khi thay đổi
    setState(() {
      _cardName = value;
    });
  }

  void _saveCardName() {
    // Cập nhật tên thẻ trong CardDetail
    setState(() {
      _cardDetail.cardName = _cardName;
    });
  }

  Future<CardDetail> fetchCardDetail(int cardID) async {
    final response = await http
        .get(Uri.parse('http://192.168.53.160/api/getcarddetail/$cardID'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['Data'];
      final cardData = json.decode(data)[0];

      return CardDetail.fromJson(cardData);
    } else {
      throw Exception('Failed to load card detail');
    }
  }

  Future<List<DateTime>> fetchListDueDate() async {
    final response =
        await http.get(Uri.parse('http://192.168.53.160/api/getListDueDate/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['Data'];
      final List<dynamic> cardDataList = json.decode(data);

      List<DateTime> dueDates = cardDataList.map((item) {
        final String dueDateStr = item['DueDate'];
        return DateTime.parse(dueDateStr);
      }).toList();

      return dueDates;
    } else {
      throw Exception('Failed to load card detail');
    }
  }

  Future<List<Map<String, dynamic>>> getComments() async {
    final response = await http.get(
        Uri.parse('http://192.168.53.160/api/getComments/${widget.cardID}'));
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body)['Data'];
        // print(response.body);
        print(data);
        final commentsData = jsonDecode(data);
        List<dynamic> commentsList = [];
        if (commentsData is List) {
          commentsList = commentsData;
        } else if (commentsData is Map) {
          commentsList = [commentsData];
        }
        final resultList = commentsList
            .map((board) =>
                Map<String, dynamic>.from(board as Map<String, dynamic>))
            .toList();
        return resultList;
      } catch (e) {
        throw Exception('Failed to decode user list');
      }
    } else {
      throw Exception('Failed to load user list');
    }
  }

  Future<void> _addComment() async {
    final url = Uri.parse('http://192.168.53.160/api/addComment');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userID': widget.userID,
        'cardID': widget.cardID,
        'detail': _comment,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment added failed!')),
      );
    }
  }

  Future<void> _deleteCard() async {
    final url =
        Uri.parse('http://192.168.53.160/api/deleteCard/${widget.cardID}');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card deleted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete card!')),
      );
      print('Failed to delete board. Error: ${response.reasonPhrase}');
    }
  }

  Future<void> _deleteComment(int commentID) async {
    final url = Uri.parse('http://192.168.53.160/api/deleteComment/$commentID');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment deleted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete comment!')),
      );
      print('Failed to delete board. Error: ${response.reasonPhrase}');
    }
  }

  Future<void> _updateComment(int commentID) async {
    final url = Uri.parse(
        'http://192.168.53.160/api/updateComment/${widget.userID}/$commentID');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'detail': _editComment,
        'userID': widget.userID,
        'commentID': commentID,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('UPDATE successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('UPDATE failure')),
      );
    }
  }

  Future<void> _updateCard(int cardID) async {
    final url = Uri.parse('http://192.168.53.160/api/updateCard/$cardID');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'cardName': _cardNameController.text,
        'label': label2,
        'LabelColor': labelName,
        'dueDate': _expirationDate?.toIso8601String(),
      }),
    );
    if (mounted) {
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('UPDATE successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('UPDATE failure')),
        );
      }
    }
  }

  String getColorName(Color color) {
    if (color == Colors.red) {
      return 'red';
    } else if (color == Colors.green) {
      return 'green';
    } else if (color == Colors.blue) {
      return 'blue';
    } else if (color == Colors.orange) {
      return 'orange';
    } else if (color == Colors.yellow) {
      return 'yellow';
    } else {
      // Add more color cases as needed
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    label = _labelColors[0];
    return GestureDetector(
      // add this widget to detect taps outside TextField
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        // drawer: NavDrawer(widget.userID),
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: permission == 1
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                backgroundColor: Colors.blue[200],
                                title: const Text('NHẬP TÊN THẺ'),
                                content: TextField(
                                  controller: _cardNameController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Nhập tên thẻ',
                                  ),
                                  onChanged: _updateCardName,
                                ),
                                actions: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              35), // Adjust the value to your desired roundness
                                        ),
                                      ),
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.hovered)) {
                                            return Colors.black;
                                          }
                                          return Colors.blue.shade900;
                                        },
                                      ),
                                    ),
                                    onPressed: permission == 1
                                        ? null
                                        : () {
                                            Navigator.pop(context);
                                          },
                                    child: Text(
                                      'HỦY',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              35), // Adjust the value to your desired roundness
                                        ),
                                      ),
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.hovered)) {
                                            return Colors.black;
                                          }
                                          return Colors.blue.shade900;
                                        },
                                      ),
                                    ),
                                    onPressed: permission == 1
                                        ? null
                                        : () {
                                            _saveCardName();
                                            Navigator.pop(context);
                                          },
                                    child: Text(
                                      'LƯU',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    // backgroundColor: Colors.grey[100],
                    alignment: Alignment.centerLeft,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    // side: BorderSide(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    _cardName,
                    maxLines: null,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: permission == 1
                    ? null
                    : () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              backgroundColor: Colors.blue[200],
                              title: const Text('NHẬP TÊN THẺ'),
                              content: TextField(
                                controller: _cardNameController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Nhập tên thẻ',
                                ),
                                onChanged: _updateCardName,
                              ),
                              actions: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.hovered)) {
                                          return Colors.black;
                                        }
                                        return Colors.blue.shade900;
                                      },
                                    ),
                                  ),
                                  onPressed: permission == 1
                                      ? null
                                      : () {
                                          Navigator.pop(context);
                                        },
                                  child: Text(
                                    'HỦY',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.hovered)) {
                                          return Colors.black;
                                        }
                                        return Colors.blue.shade900;
                                      },
                                    ),
                                  ),
                                  onPressed: permission == 1
                                      ? null
                                      : () {
                                          _saveCardName();
                                          Navigator.pop(context);
                                        },
                                  child: Text(
                                    'LƯU',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                child: Icon(
                  Icons.edit,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: permission == 1
                  ? null
                  : () async {
                      _updateCard(widget.cardID);
                      await Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => MyCardsScreen(widget.userID),
                        ),
                        (route) => false, // Remove all previous routes
                      );
                      setState(() {});
                    },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: permission == 1
                  ? null
                  : () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.blue[200],
                            title: const Text('XÁC NHẬN'),
                            content: const Text(
                              'Bạn có chắc muốn xóa thẻ này?',
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          35), // Adjust the value to your desired roundness
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.hovered)) {
                                        return Colors.black;
                                      }
                                      return Colors.blue.shade900;
                                    },
                                  ),
                                ),
                                child: Text(
                                  'HỦY',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                                onPressed: permission == 1
                                    ? null
                                    : () {
                                        Navigator.of(context).pop();
                                      },
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          35), // Adjust the value to your desired roundness
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.hovered)) {
                                        return Colors.black;
                                      }
                                      return Colors.blue.shade900;
                                    },
                                  ),
                                ),
                                child: Text(
                                  'XÓA',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                                onPressed: permission == 1
                                    ? null
                                    : () async {
                                        _deleteCard();
                                        await Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MyCardsScreen(widget.userID),
                                          ),
                                          (route) =>
                                              false, // Remove all previous routes
                                        );
                                        setState(() {});
                                      },
                              ),
                            ],
                          );
                        },
                      );
                    },
            ),
          ],
        ),

        body: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.only(bottom: 80.0),
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trong danh sách:',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      _listName != null
                          ? Text(
                              _listName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            )
                          : CircularProgressIndicator(),
                      const Divider(
                        thickness: 1.0,
                        height: 24.0,
                      ),
                      const SizedBox(height: 30.0),
                      const Text(
                        'Các thao tác nhanh:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(
                                    Icons.format_list_numbered_sharp),
                                onPressed: permission == 1
                                    ? null
                                    : permission == 1
                                        ? null
                                        : () {
                                            // _updateCard(widget.cardID);
                                            // Navigator.of(context).pop();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChecklistScreenShow(
                                                        cardID: widget.cardID,
                                                        userID: widget.userID),
                                              ),
                                            );
                                          },
                              ),
                              const Text('Checklist'),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: permission == 1
                                    ? null
                                    : () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AttachmentPage(widget.cardID),
                                          ),
                                        );
                                      },
                                icon: const Icon(Icons.attach_file),
                                tooltip: 'Add Attachment',
                              ),
                              const Text('Thêm tệp đính kèm'),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: permission == 1
                                    ? null
                                    : () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MemberScreen(
                                              widget.userID,
                                              widget.cardID,
                                            ),
                                          ),
                                        );
                                      },
                                icon: const Icon(Icons.person),
                                tooltip: 'Add Member',
                              ),
                              const Text('Thành viên'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      const Text(
                        'Mô tả:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextField(
                            maxLines: null,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Chạm để thêm một mô tả',
                            ),
                            enabled: permission != 1,
                            onChanged: (value) {
                              setState(() {
                                _description = value;
                              });
                            },
                          ),
                          const Icon(Icons.description),
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      const Text(
                        'Ngày hết hạn :',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        padding: const EdgeInsets.all(
                            6.0), // Adjust the padding as needed
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: permission == 1
                                  ? null
                                  : () async {
                                      final DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate:
                                            _expirationDate ?? DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now()
                                            .add(const Duration(days: 365)),
                                      );
                                      if (pickedDate != null) {
                                        final TimeOfDay? pickedTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: _expirationDate != null
                                              ? TimeOfDay.fromDateTime(
                                                  _expirationDate!)
                                              : TimeOfDay.now(),
                                        );
                                        if (pickedTime != null) {
                                          final DateTime pickedDateTime =
                                              DateTime(
                                            pickedDate.year,
                                            pickedDate.month,
                                            pickedDate.day,
                                            pickedTime.hour,
                                            pickedTime.minute,
                                          );

                                          // Lấy danh sách dữ liệu DueDate từ API
                                          List<DateTime> existingDueDates =
                                              await fetchListDueDate();

                                          // Kiểm tra trùng lịch
                                          bool isDuplicate = existingDueDates
                                              .contains((date) =>
                                                  date.year ==
                                                      pickedDateTime.year &&
                                                  date.month ==
                                                      pickedDateTime.month &&
                                                  date.day ==
                                                      pickedDateTime.day &&
                                                  date.hour ==
                                                      pickedDateTime.hour &&
                                                  date.minute ==
                                                      pickedDateTime.minute);

                                          // Kiểm tra khoảng cách thời gian
                                          bool isWithin2Hours =
                                              existingDueDates.any((date) =>
                                                  pickedDateTime.isBefore(
                                                      date.add(const Duration(
                                                          hours: 2))) &&
                                                  pickedDateTime.isAfter(date
                                                      .subtract(const Duration(
                                                          hours: 2))));

                                          if (isDuplicate || isWithin2Hours) {
                                            // Hiển thị thông báo trùng lịch
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Lịch trình đã tồn tại, Bạn vui lòng đặt lịch lại'),
                                                  content: const Text(
                                                      'Thời gian đã bị trùng lặp hoặc nằm trong khoảng 2 giờ của lịch trình hiện có.'),
                                                  actions: <Widget>[
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            setState(() {
                                              _expirationDate = pickedDateTime;
                                            });

                                            // Hiển thị dialog thành công
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Đặt lịch thành công'),
                                                  content: Text('Bạn đã đặt lịch thành công cho thẻ công việc: "${widget.cardName}"'),
                                                  actions: <Widget>[
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        }
                                      }
                                    },
                              child: Text(
                                _expirationDate == null
                                    ? 'Select date and time'
                                    : _expirationDate.toString(),
                              ),
                            ),
                            IconButton(
                              onPressed: permission == 1
                                  ? null
                                  : () {
                                      setState(() {
                                        _expirationDate = null;
                                      });
                                    },
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30.0),
                      const Text(
                        'Mức độ ưu tiên:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: const OutlineInputBorder(),
                        ),
                        value: label2 ??
                            _labelList[
                                0], // Đặt giá trị mặc định cho DropdownButtonFormField
                        items: _labelList.map((label) {
                          return DropdownMenuItem<String>(
                            value: label,
                            child: Text(
                              label,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: permission != 1
                            ? (String? value) {
                                setState(() {
                                  label2 = value;
                                });
                              }
                            : null, // Disable DropdownButtonFormField khi permission = 1
                      ),
                      const SizedBox(height: 30.0),
                      const Text(
                        'Nhãn màu:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      DropdownButtonFormField<Color>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: const OutlineInputBorder(),
                        ),
                        value: label,
                        items: _labelColors.map((color) {
                          return DropdownMenuItem<Color>(
                            value: color,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20.0,
                                  height: 20.0,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  getColorName(color),
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: permission != 1
                            ? (Color? value) {
                                setState(() {
                                  label = value;
                                  labelName = getColorName(value!);
                                });
                              }
                            : null,
                      ),
                      const SizedBox(height: 30.0),
                      const Text(
                        'Phân công thành viên:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/images/avatar_user1.jpg',
                              // Here you can add image that will represent member
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(_member),
                          const Spacer(),
                          const CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/images/avatar_user2.jpg',
                              // Here you can add image that will represent the other member
                            ),
                          ),
                          const CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/images/avatar_user3.png',
                              // Here you can add image that will represent the other member
                            ),
                          ),
                          PopupMenuButton(
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete Member'),
                              ),
                            ],
                            onSelected: (String value) {
                              setState(() {
                                _member = '';
                              });
                            },
                            child: IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: permission == 1 ? null : () {},
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30.0),
                      // CommentSection(),
                      const Text(
                        'Bình luận:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 12.0),

                      FutureBuilder<List<Map<String, dynamic>>>(
                          future: getComments(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return const Center(
                                  child: Text('Failed to load card list'),
                                );
                              } else {
                                final commentsList = snapshot.data!;
                                return Column(
                                  children: [
                                    for (final commentsData in commentsList)
                                      _buildCardDetail(
                                        commentsData["UserID"],
                                        commentsData["Fullname"],
                                        commentsData["AvatarUrl"],
                                        _editComment = commentsData["Detail"],
                                        commentsData["CommentID"],
                                      ),
                                  ],
                                );
                              }
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Thêm nhận xét',
                        ),
                        focusNode: commentFocusNode,
                        onChanged: (value) {
                          setState(() {
                            _comment = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.blue[900], size: 30),
                      onPressed: () async {
                        if (_comment.isEmpty) {
                          commentFocusNode.requestFocus();
                        } else {
                          _addComment();
                          await Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => CardsDetailScreen(
                                  widget.cardName,
                                  widget.cardID,
                                  widget.userID),
                            ),
                          );
                          setState(() {});
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardDetail(
    int checkUserID,
    String fullName,
    String avatarUrl,
    String commentDetail,
    int commentID,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  avatarUrl,
                ),
              ),
              const SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: checkUserID == widget.userID
                                  ? const Icon(Icons.check)
                                  : const SizedBox(),
                              iconSize: 20,
                              onPressed: permission == 1
                                  ? null
                                  : () async {
                                      if (checkUserID == widget.userID) {
                                        _updateComment(commentID);
                                        await Navigator.of(context)
                                            .pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CardsDetailScreen(
                                                      widget.cardName,
                                                      widget.cardID,
                                                      widget.userID)),
                                        );
                                        setState(() {});
                                      }
                                    },
                            ),
                            const SizedBox(width: 15),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              iconSize: 20,
                              icon: checkUserID == widget.userID
                                  ? const Icon(Icons.delete_outline)
                                  : const SizedBox(),
                              // alignment: Alignment(-1, -2.5),
                              // alignment: Alignment.topRight,
                              onPressed: permission == 1
                                  ? null
                                  : () async {
                                      if (checkUserID == widget.userID) {
                                        print("Deleted");
                                        _deleteComment(commentID);

                                        await Navigator.of(context)
                                            .pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CardsDetailScreen(
                                                      widget.cardName,
                                                      widget.cardID,
                                                      widget.userID)),
                                        );
                                        setState(() {});
                                      }
                                    },
                            ),
                          ],
                        ),

                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextField(
                      enabled: checkUserID == widget.userID,
                      controller: TextEditingController(text: commentDetail),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      )),
                      maxLines: null,
                      style: TextStyle(
                        color:
                            checkUserID == widget.userID ? null : Colors.black,
                      ),
                      onChanged: (value) {
                        _editComment = value;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40.0),
        ],
      ),
      // Column(
      // children: [

      // const SizedBox(height: 40.0),
      // ],
      // ),
    );
  }
}
