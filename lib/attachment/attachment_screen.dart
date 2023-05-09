import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';


class AttachmentPage extends StatefulWidget {
  const AttachmentPage({Key? key}) : super(key: key);

  @override
  _AttachmentPageState createState() => _AttachmentPageState();
}

class _AttachmentPageState extends State<AttachmentPage> {
  List<String> _attachments = [];

  Future<void> _openFilePicker() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _attachments.add(result.files.first.path!);
      });
    }
  }

  Widget _buildAttachmentList() {
    return ListView.builder(
      itemCount: _attachments.length,
      itemBuilder: (BuildContext context, int index) {
        final attachment = _attachments[index];
        return ListTile(
          leading: const Icon(Icons.attachment),
          title: Text(attachment),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                _attachments.removeAt(index);
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attachments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _attachments.isEmpty
                ? const Center(
                    child: Text('No attachments yet.'),
                  )
                : _buildAttachmentList(),
          ),
        ],
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
