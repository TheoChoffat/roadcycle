import 'package:flutter/material.dart';
import 'package:roadcycle/screens/my_login.dart';
import 'package:roadcycle/screens/all_routes.dart';
import 'package:roadcycle/screens/my_settings.dart';
import 'package:roadcycle/screens/my_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/all_routes":
            return MaterialPageRoute(builder: (context) => const AllRoutes());
          case "/my_login":
            return MaterialPageRoute(builder: (context) => const MyLogin());
          case "/my_settings":
            return MaterialPageRoute(builder: (context) => const MySettings());
          case "/my_routes":
            return MaterialPageRoute(builder: (context) => const MyRoutes());
          default:
            return MaterialPageRoute(builder: (context) => const AllRoutes());
        }
      },
    );
  }
}
