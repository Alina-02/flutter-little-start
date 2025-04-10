import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tutorial1/data/app_state.dart';
import 'package:tutorial1/data/database.dart';
import 'package:tutorial1/pages/todoapp/authentication.dart';
import 'package:tutorial1/util/dialog_box.dart';
import 'package:tutorial1/util/todo_tile.dart';

import 'package:firebase_auth/firebase_auth.dart' // new
    hide EmailAuthProvider, PhoneAuthProvider;
import '../../data/app_state.dart'; // new

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    super.initState();
  }

  final _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index, ApplicationState state) {
    if (state.loggedIn) {
      setState(() {
        db.toDoList[index][1] = !db.toDoList[index][1];
      });
      db.updateData();
    }
  }

  void saveNewTask(ApplicationState state) {
    if (state.loggedIn) {
      String task = _controller.text;

      setState(() {
        db.toDoList.add([task, false]);
        _controller.clear();
      });
      Navigator.of(context).pop();

      state.addTask(task, false);
      //db.updateData();
    }
  }

  void createNewTask(ApplicationState state) {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index, ApplicationState state) {
    if (state.loggedIn) {
      setState(() {
        db.toDoList.removeAt(index);
      });
      db.updateData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder:
          (context, appState, _) => Scaffold(
            backgroundColor: Colors.lightGreen[200],
            appBar: AppBar(
              backgroundColor: Colors.lightGreen,
              title: Center(child: Text("TO DUFLER")),
              elevation: 1,
              actions: [
                AuthFunc(
                  loggedIn: appState.loggedIn,
                  signOut: () {
                    FirebaseAuth.instance.signOut();
                  },
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                createNewTask(appState);
              },
              backgroundColor: Colors.lightGreen,
              elevation: 0,
              child: Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(color: Colors.lightGreen),
            body: ListView.builder(
              itemCount: appState.taskMessages.length,
              itemBuilder: (context, index) {
                return ToDoTile(
                  taskName: appState.taskMessages[index].task,
                  taskCompleted: appState.taskMessages[index].completed,
                  onChanged: (value) => checkBoxChanged(value, index, appState),
                  deleteFunction: (context) => deleteTask(index, appState),
                );
              },
            ),
          ),
    );
  }
}
