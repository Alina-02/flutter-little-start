import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tutorial1/pages/todoapp/habits_page.dart';
import 'package:tutorial1/pages/todoapp/stats_page.dart';
import 'package:tutorial1/theme/theme_provider.dart';
import 'firebase_options.dart';
import 'package:go_router/go_router.dart';

import 'package:tutorial1/pages/todoapp/home_page.dart';
import 'package:provider/provider.dart';

import 'data/app_state.dart';

void main() async {
  await Hive.initFlutter();
  // open a box
  var box = await Hive.openBox('mybox');

  // firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ApplicationState(),
          builder: ((context, child) => const MyApp()),
        ),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
    ),
  );
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'sign-in',
          builder: (context, state) {
            return SignInScreen(
              actions: [
                ForgotPasswordAction(((context, email) {
                  final uri = Uri(
                    path: '/sign-in/forgot-password',
                    queryParameters: <String, String?>{'email': email},
                  );
                  context.push(uri.toString());
                })),
                AuthStateChangeAction(((context, state) {
                  final user = switch (state) {
                    SignedIn state => state.user,
                    UserCreated state => state.credential.user,
                    _ => null,
                  };
                  if (user == null) {
                    return;
                  }
                  if (state is UserCreated) {
                    user.updateDisplayName(user.email!.split('@')[0]);
                  }
                  if (!user.emailVerified) {
                    user.sendEmailVerification();
                    const snackBar = SnackBar(
                      content: Text(
                        'Please check your email to verify your email address',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  context.pushReplacement('/');
                })),
              ],
            );
          },
          routes: [
            GoRoute(
              path: 'forgot-password',
              builder: (context, state) {
                final arguments = state.uri.queryParameters;
                return ForgotPasswordScreen(
                  email: arguments['email'],
                  headerMaxExtent: 200,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) {
            return ProfileScreen(
              providers: const [],
              actions: [
                SignedOutAction((context) {
                  context.pushReplacement('/');
                }),
              ],
            );
          },
        ),
        GoRoute(
          path: 'habits',
          builder: (context, state) => const HabitsPage(),
        ),
        GoRoute(path: 'stats', builder: (context, state) => const StatsPage()),
      ],
    ),
  ],
);
// end of GoRouter configuration

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "To Dufler",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.lightGreen),
      routerConfig: _router,
    );
  }
}
