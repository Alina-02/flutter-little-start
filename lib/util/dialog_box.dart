import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial1/data/app_state.dart';
import 'package:tutorial1/util/my_button.dart';

class DialogBox extends StatelessWidget {
  final controller;
  void Function(ApplicationState) onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.lightGreen[400],
      content: Container(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Add a new task",
              ),
            ),
            Consumer<ApplicationState>(
              builder:
                  (context, appState, _) => Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyButton(
                        text: "Save",
                        onPressed: () {
                          onSave(appState);
                        },
                      ),
                      const SizedBox(width: 10),
                      MyButton(text: "Cancel", onPressed: onCancel),
                    ],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
