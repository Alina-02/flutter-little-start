import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List toDoList = [];
  // reference box
  final _myBox = Hive.box("mybox");

  void createInitialData() {
    toDoList = [
      ["Make Tutorial", false],
      ["Read", false],
    ];
  }

  void loadData() {
    toDoList = _myBox.get("TODOLIST");
  }

  void updateData() {
    _myBox.put("TODOLIST", toDoList);
  }
}
