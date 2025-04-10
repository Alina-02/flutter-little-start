import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tutorial1/data/task_message.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key, required this.addTask, required this.messages});

  final FutureOr<void> Function(String task) addTask;
  final List<TaskMessage> messages;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_TaskListState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
