import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tutorial1/data/app_state.dart';
import 'package:tutorial1/data/task_message.dart';
import 'package:tutorial1/pages/todoapp/authentication.dart';
import 'package:tutorial1/util/dialog_box.dart';
import 'package:tutorial1/util/todo_tile.dart';

import 'package:firebase_auth/firebase_auth.dart' // new
    hide EmailAuthProvider, PhoneAuthProvider;
import '../../data/app_state.dart'; // new
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');

  final _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index, ApplicationState state) {
    TaskMessage task = state.taskMessages[index];
    bool completed = value as bool;

    if (state.loggedIn) {
      setState(() {
        //update task state in firebase
        state.updateTask(task, completed);
      });
    }
  }

  void saveNewTask(ApplicationState state) {
    if (state.loggedIn) {
      String task = _controller.text;

      setState(() {
        state.addTask(task);
        _controller.clear();
      });
      Navigator.of(context).pop();
    }
  }

  void saveNewHabit(ApplicationState state) {
    if (state.loggedIn) {
      String task = _controller.text;

      setState(() {
        state.addHabit(task);
        _controller.clear();
      });
      Navigator.of(context).pop();
    }
  }

  void createNewTask(ApplicationState state) {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSaveTask: saveNewTask,
          onSaveHabit: saveNewHabit,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index, ApplicationState state) {
    TaskMessage task = state.taskMessages[index];

    if (state.loggedIn) {
      setState(() {
        // delete task from firebase
        state.deleteTask(task);
      });
    }
  }

  @override
  Widget build(BuildContext buildContext) {
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
              foregroundColor: Colors.lightGreen[900],
              elevation: 0,
              shape: CircleBorder(),
              child: Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              padding: EdgeInsets.all(0),
              color: Colors.lightGreen,
              notchMargin: 5.0,
              shape: CircularNotchedRectangle(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),

                    child: IconButton(
                      icon: Icon(Icons.home, color: Colors.lightGreen[900]),
                      onPressed: () {
                        context.go('/');
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0),

                    child: IconButton(
                      icon: Icon(Icons.sunny, color: Colors.lightGreen[900]),
                      onPressed: () {
                        context.go('/habits');
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),

                    child: IconButton(
                      icon: Icon(
                        Icons.start_sharp,
                        color: Colors.lightGreen[900],
                      ),
                      onPressed: () {
                        context.go('/stats');
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),

                    child: IconButton(
                      icon: Icon(Icons.person, color: Colors.lightGreen[900]),
                      onPressed: () {
                        context.go('/profile');
                      },
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    appState.habitMessages.isNotEmpty
                        ? 'Habits'
                        : 'Add some habits',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...buildTaskList(appState.habitMessages, appState),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    appState.taskMessages.isNotEmpty
                        ? 'Tasks'
                        : 'Add some tasks',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...buildTaskList(appState.taskMessages, appState),
              ],
            ),
          ),
    );
  }

  List<Widget> buildTaskList(List tasks, ApplicationState appState) {
    return List.generate(tasks.length, (index) {
      return ToDoTile(
        taskName: tasks[index].task,
        taskCompleted: tasks[index].completed,
        onChanged: (value) => checkBoxChanged(value, index, appState),
        deleteFunction: (context) => deleteTask(index, appState),
      );
    });
  }
}
