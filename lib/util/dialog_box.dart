import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial1/data/app_state.dart';
import 'package:tutorial1/util/my_button.dart';

class DialogBox extends StatefulWidget {
  final dynamic controller;
  void Function(ApplicationState) onSaveTask;
  void Function(ApplicationState) onSaveHabit;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.controller,
    required this.onSaveTask,
    required this.onSaveHabit,
    required this.onCancel,
  });

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  bool _checkCreateHabit = false;

  void changeCreatingHabit(bool? value) {
    setState(() {
      _checkCreateHabit = !_checkCreateHabit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(20),
      backgroundColor: Colors.lightGreen[400],
      content: SizedBox(
        height: 200,
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.lightGreen, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: widget.controller,
                autocorrect: true,
                autofocus: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add a new task...',
                ),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  focusColor: Colors.lightGreen,
                  value: _checkCreateHabit,
                  onChanged: (bool? value) {
                    changeCreatingHabit(value);
                  },
                ),
                Text("Set as habit"),
              ],
            ),
            Consumer<ApplicationState>(
              builder:
                  (context, appState, _) => Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyButton(text: "Cancel", onPressed: widget.onCancel),
                      const SizedBox(width: 10),
                      MyButton(
                        text: "Save",
                        onPressed: () {
                          //print(_checkCreateHabit);
                          _checkCreateHabit
                              ? widget.onSaveHabit(appState)
                              : widget.onSaveTask(appState);
                        },
                      ),
                    ],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
