import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:roadcycle/screens/auth/AuthPage.dart';
import 'package:roadcycle/screens/all_routes.dart';
import 'package:roadcycle/screens/my_settings.dart';
import 'package:roadcycle/screens/my_routes.dart';
import 'package:roadcycle/screens/my_map.dart';
import 'package:roadcycle/screens/app_start.dart';
import 'package:roadcycle/screens/my_home.dart';

import 'firebase_options.dart';
import 'screens/auth/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/all_routes":
            return MaterialPageRoute(builder: (context) => const AllRoutes());
          case "/my_settings":
            return MaterialPageRoute(builder: (context) => const MySettings());
          case "/my_routes":
            return MaterialPageRoute(builder: (context) => const MyRoutes());
          case "/app_start":
            return MaterialPageRoute(builder: (context) => const AppStart());
          case "/my_map":
            return MaterialPageRoute(builder: (context) => const MyMap());
          case "/my_home":
            return MaterialPageRoute(builder: (context) => const MyHome());
          default:
            return MaterialPageRoute(builder: (context) => const AppStart());
        }
      },
    );
  }
}
