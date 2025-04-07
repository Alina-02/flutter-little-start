import 'package:flutter/material.dart';
import 'package:tutorial1/pages/counter_page.dart';
import 'package:tutorial1/pages/first_page.dart';
import 'package:tutorial1/pages/home_page.dart';
import 'package:tutorial1/pages/profile_page.dart';
import 'package:tutorial1/pages/settings_page.dart';
import 'package:tutorial1/pages/todoapp/todo_page.dart';

void main() {
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
      home: ToDoPage(),
      routes: {
        '/firstpage': (context) => FirstPage(),
        '/homepage': (context) => HomePage(),
        '/settingspage': (context) => SettingsPage(),
        '/profilepage': (context) => ProfilePage(),
      },
    );
  }
}
