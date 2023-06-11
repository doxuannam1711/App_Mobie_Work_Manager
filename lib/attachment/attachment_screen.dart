import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class AttachmentPage extends StatefulWidget {
  final int cardID;

  // const AttachmentPage({Key? key}) : super(key: key);
  const AttachmentPage(this.cardID);

  @override
  _AttachmentPageState createState() => _AttachmentPageState();
}

// class _AttachmentPageState extends State<AttachmentPage> {
//   List<String> _attachments = [];

//   Future<void> _openFilePicker() async {
//     final result = await FilePicker.platform.pickFiles();
//     if (result != null && result.files.isNotEmpty) {
//       for (final file in result.files) {
//         final fileName = file.name;
//         final filePath = file.path;
//         print('File name: ');
//         print(fileName);
//         print('File path: ');
//         print(filePath);
//       }
//       setState(() {
//         // _attachments.add(result.files.first.path!);
//         _attachments.add(result.files.first.name);
//       });
//     }
//   }

//   Widget _buildAttachmentList() {
//     return ListView.builder(
//       itemCount: _attachments.length,
//       itemBuilder: (BuildContext context, int index) {
//         final attachment = _attachments[index];
//         return ListTile(
//           leading: const Icon(Icons.attachment),
//           title: Text(attachment),
//           trailing: IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: () {
//               setState(() {
//                 _attachments.removeAt(index);
//               });
//             },
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Attachments'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: _attachments.isEmpty
//                 ? const Center(
//                     child: Text('No attachments yet.'),
//                   )
//                 : _buildAttachmentList(),
//           ),
//         ],
//       ),
//       bottomNavigationBar: const BottomAppBar(
//         color: Colors.white,
//         height: 50.0,
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//       floatingActionButton: FloatingActionButton(
//         onPressed: _openFilePicker,
//         tooltip: 'Add Attach File',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

class _AttachmentPageState extends State<AttachmentPage> {
  final _attachments = <String>[
    'https://drive.google.com/uc?id=1IFsLihg2jGUF9vmjk5ox2G25atpNYqlQ&export=download'
  ];
  String _addAttachmentPath = "";
  String _addAttachmentName = "";
  late drive.DriveApi _driveApi;

  @override
  void initState() {
    super.initState();
    _initializeDriveApi();
  }

  Future<void> _addAttachment() async {
    final url = Uri.parse('http://192.168.1.7/api/addAttachment');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'cardID': widget.cardID,
        'attachmentPath': _addAttachmentPath,
        'attachmentName': _addAttachmentName,
      }),
    );

    if (response.statusCode == 200) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Attachment added successfully!')),
      // );
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Attachment added failed!')),
      // );
    }
  }

  Future<List<Map<String, dynamic>>> getAttachments() async {
    final response = await http.get(
        Uri.parse('http://192.168.1.7/api/getAttachments/${widget.cardID}'));
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body)['Data'];
        // print(response.body);
        // print(data);
        final attachmentData = jsonDecode(data);
        List<dynamic> attachmentList = [];
        if (attachmentData is List) {
          attachmentList = attachmentData;
        } else if (attachmentData is Map) {
          attachmentList = [attachmentData];
        }
        final resultList = attachmentList
            .map((board) =>
                Map<String, dynamic>.from(board as Map<String, dynamic>))
            .toList();
        return resultList;
      } catch (e) {
        throw Exception('Failed to decode attachment list');
      }
    } else {
      throw Exception('Failed to load attachment list');
    }
  }

  Future<void> _deleteAttachment(int attachmentID) async {
    final url =
        Uri.parse('http://192.168.1.7/api/deleteAttachment/$attachmentID');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Attachment deleted successfully!')),
      // );
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Failed to delete Attachment!')),
      // );
      // print('Failed to delete board. Error: ${response.reasonPhrase}');
    }
  }

  Future<void> _initializeDriveApi() async {
    final credentials = ServiceAccountCredentials.fromJson({
      //file Json of your Drive Api
    });
    final client = await clientViaServiceAccount(
        credentials, [drive.DriveApi.driveFileScope]);

    _driveApi = drive.DriveApi(client);
  }

  Future<String> _uploadFile(String filePath) async {
    final file = File(filePath);
    const folderId = "1oCrGnhOhakw5-WLFC1cLqqSXSzY3iS73";
    final fileMedia = drive.Media(
      file.openRead(),
      file.lengthSync(),
    );

    final fileUpload = drive.File()
      ..name = file.path.split('/').last
      ..parents = [folderId];

    final fileResource = await _driveApi.files.create(
      fileUpload,
      uploadMedia: fileMedia,
    );

    if (fileResource != null) {
      _addAttachmentPath =
          // 'https://drive.google.com/viewerng/viewer?embedded=true&url=https://drive.google.com/uc?id=${fileResource.id}&export=download';
      'https://drive.google.com/uc?id=${fileResource.id}&export=download';
      final link =
          'https://drive.google.com/uc?id=${fileResource.id}&export=download';
      print(link);
      setState(() {
        // _attachments.add(link);
        _addAttachment();
      });
      return link;
    } else {
      print("File upload failed or not completed yet.");
      return '';
    }
  }

  Future<void> _openFilePicker() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      for (final file in result.files) {
        final filePath = file.path!;
        _addAttachmentName = file.name;
        print('File name: ${file.name}');
        print('File path: $filePath');
        _addAttachmentPath = await _uploadFile(filePath);
        setState(() {
          
        });
        print('File link: $_addAttachmentPath');
        // launchUrl(link as Uri);
      }
    }
  }

  // Widget _buildAttachmentList() {
  //   return ListView.builder(
  //     itemCount: _attachments.length,
  //     itemBuilder: (BuildContext context, int index) {
  //       final attachment = _attachments[index];
  //       return ListTile(
  //         leading: const Icon(Icons.attachment),
  //         title: Text(attachment),
  //         trailing: IconButton(
  //           icon: const Icon(Icons.delete),
  //           onPressed: () {
  //             setState(() {
  //               _attachments.removeAt(index);
  //             });
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildAttachmentList() {
  //   return ListView.builder(
  //     itemCount: _attachments.length,
  //     itemBuilder: (BuildContext context, int index) {
  //       final attachment = _attachments[index];
  //       return ListTile(
  //         leading: const Icon(Icons.attachment),
  //         title: GestureDetector(
  //           child: Text(attachment),
  //           onTap: () async {
  //             final url = Uri.parse(attachment);
  //             if (await canLaunchUrl(url)) {
  //               await launchUrl(url);
  //             }else {
  //               throw 'Could not launch $url';
  //             }
  //           },
  //         ),
  //         trailing: IconButton(
  //           icon: const Icon(Icons.delete),
  //           onPressed: () {
  //             setState(() {
  //               _attachments.removeAt(index);
  //             });
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildAttachmentList(
    int attachmentID,
    int cardID,
    String attachmentPath,
    String attachmentName,
  ) {
    return Column(
      children: [
        ListTile(
          leading: attachmentName.contains('.png') || attachmentName.contains('.jpg') || attachmentName.contains('.jpg') ? Image.asset('assets/images/imageIcon.png',width: 35,height: 35) : attachmentName.contains('.docx') ? Image.asset('assets/images/Word-icon.png',width: 30,height: 30) : attachmentName.contains('.pdf') ? Image.asset('assets/images/pdf.png', width: 35, height: 35) : const Icon(Icons.attachment),
          title: GestureDetector(
            child: Text(attachmentName),
            onTap: () async {
              final url =
              //  Uri.parse(
                  // "https://drive.google.com/uc?id=1kFGCC0oSxUYd8u8O1sM_OlCnyNR-Rmfj&export=download");
              Uri.parse(attachmentPath);

              // if (await canLaunchUrl(url)) {
              //   await launchUrl(url);
              // }
              // final url =
              //     "https://drive.google.com/uc?id=1rG5p-eJ4LOeeE_IeflkQ_4oJF_T94CBi&export=download";
              // final url = Uri.parse(
              //     'https://drive.google.com/viewerng/viewer?embedded=true&url=https://drive.google.com/uc?id=1oKxzb-yicVb57AEPkxtc7d8bR8PAGlgm&export=download');

              try {
                if (await canLaunchUrl(url)) {
                  await launchUrl(url,mode: LaunchMode.externalApplication);
                } else {
                  throw 'Could not launch $url';
                }
              } catch (e) {
                print("Error launching URL: $e");
              }
            },
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _deleteAttachment(attachmentID);
              setState(() {});
              // setState(() {
              //   _attachments.removeAt(index);
              // });
            },
          ),
        ),
        const Divider(
          thickness: 2,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Các tệp đính kèm'),
        backgroundColor: Colors.blue[900],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getAttachments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Failed to load attachment list'),
              );
            } else {
              final attachmentList = snapshot.data!;
              return ListView.builder(
                  // padding: const EdgeInsets.symmetric(
                  //     horizontal: 32, vertical: 12),
                  physics: const BouncingScrollPhysics(),
                  itemCount: attachmentList.length,
                  itemBuilder: (context, index) {
                    final attachmentData = attachmentList[index];

                    return _buildAttachmentList(
                      attachmentData["AttachmentID"],
                      attachmentData["CardID"],
                      attachmentData["AttachmentPath"],
                      attachmentData["AttachmentName"],
                    );
                  });
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Colors.white,
        height: 50.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[900],
        onPressed: _openFilePicker,
        tooltip: 'Add Attach File',
        child: const Icon(Icons.add),
      ),
    );
  }
}
