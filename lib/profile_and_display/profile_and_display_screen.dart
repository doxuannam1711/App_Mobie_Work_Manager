import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application/profile_and_display/user_preferences.dart';
import 'package:flutter_application/profile_and_display/profile_widget.dart';
import 'package:flutter_application/profile_and_display/text_field_widget.dart';
import 'package:flutter_application/profile_and_display/button_widget.dart';


class ProfileAndDisplayScreen extends StatefulWidget {
  const ProfileAndDisplayScreen({super.key});
  @override
  State<ProfileAndDisplayScreen> createState() =>
      _ProfileAndDisplayScreenState();
}

class _ProfileAndDisplayScreenState extends State<ProfileAndDisplayScreen> {

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    const user = UserPreferences.myUser;

    AppBar buildAppBar(BuildContext context) {
      const icon = CupertinoIcons.moon_stars;

      return AppBar(
        leading: const BackButton(),
        title: const Text('My Profile'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(icon),
            onPressed: () {},
          )
        ],
      );
    }
    
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user.imagePath,
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'User Name',
            text: user.userName,
            onChanged: (name) {},
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Full Name',
            text: user.fullName,
            onChanged: (name){},
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Email',
            text: user.email,
            onChanged: (name) {},
          ),

          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Password',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                obscureText: _isObscure,
                controller: TextEditingController(text: user.password),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // this button is used to toggle the password visibility
                  suffixIcon: IconButton(
                    icon: Icon(_isObscure
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    }
                  )
                ),
                onChanged: (name) {},
              ),
            ],
          ),

          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Confirm Password',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                obscureText: _isObscure,
                controller: TextEditingController(text: user.password),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    // this button is used to toggle the password visibility
                    suffixIcon: IconButton(
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        })),
                onChanged: (name) {},
              ),
            ],
          ),
          // const SizedBox(height: 24),
          // TextFieldWidget(
          //   label: 'About',
          //   text: user.about,
          //   maxLines: 5,
          //   onChanged: (name) {},
          // ),
          const SizedBox(height: 24),
          ButtonWidget(
            text: 'Save',
            onClicked: () {
              // UserPreferences.setUser(user);
              Navigator.of(context).pop();
            },
          ),
        ],
      ) ,
    );
    
  }
}
