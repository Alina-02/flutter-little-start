import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'package:flutter/material.dart';
import '../firebase_options.dart';
import 'task_message.dart';

import '../firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  StreamSubscription<QuerySnapshot>? _taskMessagesSubscription;
  List<TaskMessage> _taskMessages = [];
  List<TaskMessage> get taskMessages => _taskMessages;

  StreamSubscription<QuerySnapshot>? _habitMessagesSubscription;
  List<TaskMessage> _habitMessages = [];
  List<TaskMessage> get habitMessages => _habitMessages;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _taskMessages =
            FirebaseFirestore.instance
                    .collection('tasks')
                    .orderBy('timestamp', descending: true)
                    .snapshots()
                    .listen((snapshot) {
                      _taskMessages = [];
                      for (final document in snapshot.docs) {
                        _taskMessages.add(
                          TaskMessage(
                            id: document.id,
                            task: document.data()['text'] as String,
                            completed: document.data()['boolean'] as bool,
                            timestamp: document.data()['timestamp'] as int,
                          ),
                        );
                      }
                      notifyListeners();
                    })
                as List<TaskMessage>;
        _habitMessages =
            FirebaseFirestore.instance
                    .collection('habits')
                    .orderBy('timestamp', descending: true)
                    .snapshots()
                    .listen((snapshot) {
                      _habitMessages = [];
                      for (final document in snapshot.docs) {
                        _habitMessages.add(
                          TaskMessage(
                            id: document.id,
                            task: document.data()['text'] as String,
                            completed: document.data()['boolean'] as bool,
                            timestamp: document.data()['timestamp'] as int,
                          ),
                        );
                      }
                      notifyListeners();
                    })
                as List<TaskMessage>;
      } else {
        _loggedIn = false;
        _taskMessages = [];
        _taskMessagesSubscription?.cancel();
        _habitMessages = [];
        _habitMessagesSubscription?.cancel();
      }

      notifyListeners();
    });
  }

  Future<DocumentReference> addDayliTask(String task, bool completed) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance
        .collection('dailytasks')
        .add(<String, dynamic>{
          'text': task,
          'boolean': completed,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'name': FirebaseAuth.instance.currentUser!.displayName,
          'userId': FirebaseAuth.instance.currentUser!.uid,
        });
  }

  Future<DocumentReference> addTask(String task) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance.collection('tasks').add(<String, dynamic>{
      'text': task,
      'boolean': false,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<void> updateTask(TaskMessage task, bool completed) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    var collection = FirebaseFirestore.instance.collection('tasks');

    return collection.doc(task.id).update({
      'text': task.task,
      'boolean': completed,
      'timestamp': task.timestamp,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<void> deleteTask(TaskMessage task) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    var collection = FirebaseFirestore.instance.collection('tasks');
    return collection.doc(task.id).delete();
  }
}
