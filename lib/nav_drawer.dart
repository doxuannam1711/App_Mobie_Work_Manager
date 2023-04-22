import 'package:flutter/material.dart';
import 'package:flutter_application/my_cards/my_cards_screen.dart';
import 'package:flutter_application/profile_and_display/user_preferences.dart';
import 'account/account_screen.dart';
import 'main.dart';
import 'my_boards/my_boards_screen.dart';
import 'notifications/notification_screen.dart';
import 'profile_and_display/profile_and_display_screen.dart';


class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});
  static const user = UserPreferences.myUser;

  @override
  Widget build(BuildContext context) {

    Widget createListView = Column(
      children: [
        ListTile(
          leading: const Icon(Icons.space_dashboard_rounded),
          title: const Text('My boards'),
          onTap: () => {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MyBoardsScreen()),
            )
          },
        ),
        ListTile(
          leading: const Icon(Icons.credit_card),
          title: const Text('My cards'),
          onTap: () => {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MyCardsScreen()),
            )
          },
        ),
        const Divider(
          thickness: 2,
        ),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notification'),
          onTap: () => {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => NotificationScreen()),
            )
          },
        ),
        ListTile(
          leading: const Icon(Icons.account_circle),
          title: const Text('Account'),
          onTap: () => {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AccountScreen()),
            )
          },
        ),
        
        const Divider(
          thickness: 2,
        ),
        
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Setting'),
          onTap: () => {Navigator.of(context).pop()},
        ),
        
        ListTile(
          leading: const Icon(Icons.error_outline),
          title: const Text('Help'),
          onTap: () => {Navigator.of(context).pop()},
        ),
      ],
    );

    return Drawer(
      child: ListView(
        children:[
          UserAccountsDrawerHeader(
            onDetailsPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyBoardsScreen()
                ),
              );
            },
            accountName: Text(user.fullName),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  user.imagePath,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(user.imagePath),
                fit: BoxFit.cover,
              )
            ),
          ),
          createListView,
        ],
      ),    
    );
  }
}
