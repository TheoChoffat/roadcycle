import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roadcycle/screens/introductionScreen.dart';
import 'package:roadcycle/screens/my_routes.dart';

import '../app_start.dart';
import '../my_home.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text) {
    if (text == null) return;

    final snackBar = SnackBar(content: Text(text), backgroundColor: Colors.red);

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

bool isAdmin = false;

class AuthUtils {
  //Check if the user is already logged in
  static checkLoginState(context, bool? firstTime) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("user")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final user = snapshot.data.data();
                    if (user['isAdmin'] == true) {
                      return MyRoutes();
                    } else {
                      return MyHome();
                    }
                  }
                  return const Material(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              );
            } else {
              //Check if it's the first time, the user opens the app
              if (firstTime == null) {
                return IntroScreen();
              }
              return AppStart();
            }
          }),
    );
  }
}
