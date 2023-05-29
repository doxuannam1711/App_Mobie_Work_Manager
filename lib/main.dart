import 'package:flutter/material.dart';
import 'package:flutter_application/my_cards/my_cards_screen.dart';
import 'checklist/checklist_screen_show.dart';
import 'login/login_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logging/logging.dart';

import 'member/member_screen.dart';

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  Logger logger = Logger('myLogger');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "Do An",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.instance.subscribeToTopic('doan').then((value) {
    logger.info('Subscribed to topic doan');
  }).catchError((e) {
    logger.info('Failed to subscribe to topic doan: $e');
  });
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  logger.info('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    logger.info('Got a message whilst in the foreground!');
    logger.info('Message data: ${message.data}');

    if (message.notification != null) {
      logger.info(
          'Message also contained a notification: ${message.notification}');
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}
