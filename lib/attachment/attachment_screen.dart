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
      "type": "service_account",
      "project_id": "appworkmanager",
      "private_key_id": "51c1bc83a5942a5af73dd21bee9d350cac497637",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDsEg4VyFcOaqXD\nOOaSIF3+8ltQmCmDV37sTrRZEadn97UXdTgawKEN51bVkDCzvN279FAubExCF+7x\n5aSuey1MQ3QA6d1wQ3tJYfPRJ1fxG+xpkkfnP+z5/e7a6I7/5fo7DTzD27Z2mJmh\nSASHvBnARna8+9nkWkZAUv6LiGSnr3KJ0yIw6d6f32PjMixPVUkmVcFuFCP7tvZ5\n3fm849FcNzsFaA9P7pV0G/iV+wGXAsFrgNTOHQSjXW+kWr2aIVyvYsv3cMHsSl3V\ntHn3zjFN3eIgG1/PC5MEDSxdL10BFYE2zJMAP/YX+mmrGKy62hXB1MYTkDUIPrdr\nVsVi+EKHAgMBAAECggEAa3ug/Bv2PzMhe+xZVqj0AxM3rk9Jf2qD+HWxOWiHTxgC\nVMbjH5MbASiWabA37G4Oivgm1awrYGBjQ7HqNCMTMcj4dT4Fu4qOBJBboZwHN1ke\nX8bhhBGgBQawDO2bxjlgoChbxVUxE3hRYpRWs7JaCyhKAautvoG3wKvJB6C3K30f\nYqxU75RWfKDS4YfWXd/ilG48fvRcLPEui0R8eDRTWGV/Yad2lYqtg0t4CL2HgmFY\n3dlSHAVN0lQ8WjS9B3mpUVfUz/I7QDcu+K6VtiZaxCYdRfHBLWmRo5bfIyrm2tJ2\nYSj2ootiG01kJwLn1uvYdoCPiycDHrYWNsut1RKdoQKBgQD/nf6er8LZg7CSOt7Y\nc79mRrlEQHfVm0vrjxbhZRDrNCH/wK9/zMP7AfQDZ5AZXZYQMmPdpLXFmmCHKQKt\nV8fpa/TjPivGaRJ+T95IkG1GE21+Lnlrpw3kZpoXm2bw0HbYTLV4r4lJJJi3QAAR\nAaPv9nwemgFrfLCHW0zJjGdLlwKBgQDsbJDrjlHFOnTzdQyKPrE5jFdokaFS8DJj\ni/mwnv3TVfd/T2dSCFMdWauzJxPQ1EH/ypVcNxwO1KufDBGXKwQjgm0pTXXtFjjd\n4qKRR9cZuWOaf+d4q/ygWtFWIag3J5MKp2ZaLQGNAPnFZHjr8S+h8YhsfEoxXdWL\nBa9CkZNekQKBgCRx4lu9s4pPvF0dB6jU1/U9IC0bA/rwqWJshFaekkr2o+JTFrKh\n/09KeAAERAdZ0It+o752PXRvDlQ3BKqyWU5ulfvQYW1ojbp0qLyv2uSi4HmdJrKy\nnshx2IaFIag0EL3GMhmC7ZAAJ8X42gmSsk0EV64FRy6MGJ8z5T7XReMBAoGBAIuh\nqw2T5nNnjP7kmF1lnWHxowYdTHwhZIEqgHNx01NnqF7GVK08QWpKNX//ilKBqeEa\nko/99FJGBH5QsGrpeu5F75a/KvC1eSyC16SaG04UEeGDvP+mA/Po703BXwoEE3Ht\nYCPOBOZ0Nw//wPMIZStt7Ta1SVRSqPYMi2/zbmghAoGBANdWLdTQonO5bm0GBhQ/\njxb9pvRsm5jmzqqOFkDOxkVh6M9XbnPlkzuztsGYmBY3Z5rgv/yi8uVOS2MKgfn0\nwX0ABthxc2cGLETvo/qKSPcJTCQhglwOuRKdkm9DC0sa7l1XbS7JDh1D4Bp6q0i8\nwGMvoOpjZPEf86003zPDZAVb\n-----END PRIVATE KEY-----\n",
      "client_email": "appworkmanager@appworkmanager.iam.gserviceaccount.com",
      "client_id": "115180400866275325068",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/appworkmanager%40appworkmanager.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    });
    final client = await clientViaServiceAccount(
        credentials, [drive.DriveApi.driveFileScope]);

    _driveApi = drive.DriveApi(client);
  }

  // Future<String?> _uploadFile(String filePath) async {
  //   final file = File(filePath);
  //   const folderId = "1oCrGnhOhakw5-WLFC1cLqqSXSzY3iS73";
  //   final fileMedia = drive.Media(
  //     file.openRead(),
  //     file.lengthSync(),
  //   );

  //   // final fileUpload = drive.File()..name = file.path.split('/').last;
  //   final fileUpload = drive.File()
  //     ..name = file.path.split('/').last
  //     ..parents = [folderId];

  //   final fileResource = await _driveApi.files.create(
  //     fileUpload,
  //     uploadMedia: fileMedia,
  //   );

  //   if (fileResource != null) {
  //     final link = fileResource.webViewLink;
  //     print(link);
  //     setState(() {
  //       _attachments.add(link!);
  //     });
  //     return link;
  //   } else {
  //     print("File upload failed or not completed yet.");
  //     return null;
  //   }

  //   // final link = fileResource.webViewLink!;
  //   // // print('File link: $link');
  //   // if (fileResource != null) {
  //   //   final link = fileResource.webViewLink;
  //   //   print(link);
  //   // } else {
  //   //   print("File upload failed or not completed yet.");
  //   // }

  //   // setState(() {
  //   //   _attachments.add(link);
  //   // });

  //   // return link;

  // }
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
        onPressed: _openFilePicker,
        tooltip: 'Add Attach File',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Future<void> _initializeDriveApi() async {
//   final credentials = ServiceAccountCredentials.fromJson({
//     "client_id": "506655516388-0a8qr6cfoua5aobooqs29tfa3ngsa7ph.apps.googleusercontent.com",
//     "client_secret": "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",
//     "project_id": "app-work-manager",
//     "private_key_id": "506655516388-0a8qr6cfoua5aobooqs29tfa3ngsa7ph.apps.googleusercontent.com",
//     "private_key": "AIzaSyAlTPnvPahSHLwjE-oqIgUsq16QqF6E4g0",
//     "type": "service_account",
//     "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//     "token_uri": "https://accounts.google.com/o/oauth2/token",
//     "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//     "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/YOUR_CLIENT_EMAIL"
//   });

//   final client = await clientViaServiceAccount(credentials, [drive.DriveApi.driveFileScope]);

//   _driveApi = drive.DriveApi(client);
// }

// Future<void> _uploadFile(String filePath) async {
//   final file = File(filePath);

//   final credentials = ServiceAccountCredentials.fromJson({
//     "type": "service_account",
//     "project_id": "app-work-manager",
//     "private_key_id": "c221d87c96cd0d6fc523fd56e8c390a0aa93b5b9",
//     "private_key":
//         "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC5ibRxHKyua6Tr\nQNAY8yJ3b/s1QRAgvQjWoysDdwiK8OSJWtIIMRsuq15VYlx+GSXHmF2z9vqiKQGF\nC4rU/pXH94Rf4MHkdMTroMYaKDXaADh4R6t/IX0YLlsQ8NOJHPdmyWHTZ78DPURw\nQUWG7DuKYRNE1mnSsS6O2o/7VtJAhERgvElseHxak9edPgzXvxuGF99/hy5JiDcJ\nXbDr/6qZTBhsqmSQ6ZDcHsIflj8QRLnH5C3iEnSGMwGmns9QhGh2N4ipSQ36O14c\nbyAme2H+IfLiZKShNpFLtXbbt5OG6tfp64BYRGf/RfYJBaMqzv9yD2vQnkLpz5F7\nuTU62dIHAgMBAAECggEACv2WGO3haXL1RyhE4M16Q7Ki91xzd5+rB903iDzYs95M\nM2S+tKnarzDgkCnuSlvz/yGj9Kv93HWVt6C06Hls5vZfEDeQqhdOrkSM/PICf/eW\nYML3bOWkyDYVbT35fJGg3XpdbKKkeoJ6bN848/fyGPg3e32WBts5uPrydNQySoxR\nMVGtqFD4NCuLSRWaLExVrn+Mt0UMHk92mLTGuA1Nntkp39N1Hc3hh6MNOSlch7ux\nzfjsBl/Z5OmtLWTcyHk8hUJwmvHR7tTQ+fgTIzHF47QpIRHc6EQ75mC6zk8K2jE2\nX3KPA951/DU3F2TOJFWs4dyseT6x9eL3GzyJ64oOYQKBgQD5J+C436rjA7OndRDf\n8dZTSLV8x1LgwlcKGOc/RkbmcZLUtw/QRI1QmVRcRx50hKylyTV5r80YwVlxFei+\nTuGEIK7TpSNCBz5j2RKizS8WqOkq0KCnJ2X7pKomCyz3BRHeRP3aZC9kfSjH8BfY\nnhptddT4mKmmZMW0YnKIkod/4QKBgQC+onOCQ0ef1iO3WkoKjz/RE3wLji55bBhl\n9Rvo5ND6TlYYHG4rt9X97rgvV0q3waQh0h+QlC6L7v5VLepm84uXtYm6JTY2pS54\nG08NZMGGC5f4OalOkM71QDhgE+lqRsfeqceUc1Hgl27laRbAC2dvphIX09rFNjsn\n/DUzSPsu5wKBgQCUNDNI5MqaZI5NsqXJ/+lT+vDxewMCbLcna27KRXxRAQes/gMr\nCEviwIHcrfUgq/aiWtAzRO5DpmcUjEq4QOWGGYbEn/scAIENFYcvTcuPuAOSEy0s\noJPaHrWTEZy6hsp9Ix649FT4ejZyz47vrAPeTnPTN8PaFSFAzjqAoGB3IQKBgFVw\nv+6JMwfbVSSvbfHvpD2TywvuzLuVDBZeVgT60QLuqz2hOGuVuG5YWOq26AEV4/dY\nktcc4wPKuOj6bE16KH11WuY4GWVCgWJJcxPgra/jcFhLl6tj0a4v+1RseDguwxPz\n6kSJrw/HL2fYwt6N/e0XdJKDXFD5bmgMbNewhQvPAoGARZskMK3t/YvCK3gFgUGX\nLA5mBF5r0sAIpqo8NR13urvwHDsRe3Yivhd4TRpH9gufmdM4oJILCVQIs7Vi1zqT\nKZ1u1BTzaqavt9ROq47go1ll2kq8mV0+uJ+TvYZR8afJHcyjfbXWI3xs81+pcrAG\nQbzG7I6hj0nm5UyzJNl4yHs=\n-----END PRIVATE KEY-----\n",
//     "client_email": "appworkmanager@app-work-manager.iam.gserviceaccount.com",
//     "client_id": "104631853184844821400",
//     "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//     "token_uri": "https://oauth2.googleapis.com/token",
//     "auth_provider_x509_cert_url":
//         "https://www.googleapis.com/oauth2/v1/certs",
//     "client_x509_cert_url":
//         "https://www.googleapis.com/robot/v1/metadata/x509/appworkmanager%40app-work-manager.iam.gserviceaccount.com",
//     "universe_domain": "googleapis.com"
//   });

//   final client = await clientViaServiceAccount(
//       credentials, [drive.DriveApi.driveFileScope]);

//   _driveApi = drive.DriveApi(client);

//   final fileMedia = drive.Media(
//     file.openRead(),
//     file.lengthSync(),
//   );

//   final fileUpload = drive.File()
//     ..name = file.path.split('/').last;

//   await _driveApi.files.create(
//     fileUpload,
//     uploadMedia: fileMedia,
//   );

//   setState(() {
//     _attachments.add(fileUpload.name!);
//   });
// }

// Future<String> _uploadFile(String filePath) async {
//   final file = File(filePath);

//   final fileMedia = drive.Media(
//     file.openRead(),
//     file.lengthSync(),
//   );

//   final fileUpload = drive.File()..name = file.path.split('/').last;

//   final fileResource = await _driveApi.files.create(
//     fileUpload,
//     uploadMedia: fileMedia,
//   );

//   setState(() {
//     _attachments.add(fileResource.name!);
//   });

//   return fileResource.webViewLink!;
// }

// Future<void> _openFilePicker() async {
//   final result = await FilePicker.platform.pickFiles();
//   if (result != null && result.files.isNotEmpty) {
//     for (final file in result.files) {
//       final filePath = file.path!;
//       print('File name: ${file.name}');
//       print('File path: $filePath');
//       final link = await _uploadFile(filePath);
//       print('File link: $link');
//     }
//   }
// }

// Future<void> _openFilePicker() async {
//   final result = await FilePicker.platform.pickFiles();
//   if (result != null && result.files.isNotEmpty) {
//     for (final file in result.files) {
//       final filePath = file.path!;
//       print('File name: ${file.name}');
//       print('File path: $filePath');
//       await _uploadFile(filePath);
//     }
//   }
// }



// final url = Uri.parse("https://drive.google.com/uc?id=1kFGCC0oSxUYd8u8O1sM_OlCnyNR-Rmfj&export=download");
// try {
//   if (await canLaunchUrl(url)) {
//     await launchUrl(url);
//   } else {
//     throw 'Could not launch $url';
//   }
// } catch (e) {
//   print("Error launching URL: $e");
// }
