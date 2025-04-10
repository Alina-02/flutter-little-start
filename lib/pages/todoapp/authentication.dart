import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets.dart';

class AuthFunc extends StatelessWidget {
  const AuthFunc({super.key, required this.loggedIn, required this.signOut});

  final bool loggedIn;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 5),
          child: IconButton(
            onPressed: () {
              !loggedIn ? context.push('/sign-in') : signOut();
            },
            icon:
                !loggedIn
                    ? const Text('Login')
                    : const Icon(Icons.logout, color: Colors.black),
          ),
        ),
        Visibility(
          visible: loggedIn,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8, right: 10),
            child: IconButton(
              onPressed: () {
                context.push('/profile');
              },
              icon: const Icon(Icons.person, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
