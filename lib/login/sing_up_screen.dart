import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late File _imageFile;
  String _addUsername = "";
  String _addFullname = "";
  String _addPassword = "";
  String _confirmPassword = "";
  String _addEmail = "";

  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    _imageFile = File(
        '/data/user/0/com.example.demo/cache/a18fddf6-d830-4edc-9fc9-8010c84e9130/images.jpeg');
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _addUser() async {
    final url = Uri.parse('http://192.168.1.7/api/addUser');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userName': _addUsername,
        'fullName': _addFullname,
        'passWord': _addPassword,
        'email': _addEmail,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User added failed!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _imageFile != null ? FileImage(_imageFile) : null,
                  child: _imageFile == null ? const Icon(Icons.person) : null,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(

                decoration: const InputDecoration(
                  labelText: 'User Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _addUsername = value;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _addFullname = value;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _addEmail = value;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                // controller: password,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _addPassword = value;
                },
                obscureText: true,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _confirmPassword = value;
                },
                
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Sign Up'),
                onPressed: () async {
                  _addUser();
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>  SignupScreen()),
                  );
                  
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
