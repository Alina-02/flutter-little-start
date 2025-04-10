import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:tutorial1/pages/counter_page.dart';
import 'package:tutorial1/pages/first_page.dart';
import 'package:tutorial1/pages/todoapp/home_page.dart';
import 'package:tutorial1/pages/profile_page.dart';
import 'package:tutorial1/pages/settings_page.dart';
import 'package:tutorial1/pages/todoapp/todo_page.dart';

void main() async {
  await Hive.initFlutter();
  // open a box
  var box = await Hive.openBox('mybox');

  // firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /*
    List<int> numbers = [1,2,3];

    Set<String> uniqueNames = {"Mitch", "Sharon", "Vince"};

    Map user = {
      "name": "Mitch",
      "age": 26,
      "height": 180
    };
   */

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(primaryColor: Colors.lightGreen),
      /*routes: {
        '/firstpage': (context) => FirstPage(),
        '/homepage': (context) => HomePage(),
        '/settingspage': (context) => SettingsPage(),
        '/profilepage': (context) => ProfilePage(),
      },*/
    );
  }
}
