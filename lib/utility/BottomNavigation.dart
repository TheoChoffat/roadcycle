// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: IconTheme(
        data: const IconThemeData(color: Colors.black),
        child: Row(
          children: <Widget>[
            const Spacer(),
            IconButton(
              tooltip: 'All Routes',
              icon: const Icon(Icons.route),
              onPressed: () {
                Navigator.of(context).pushNamed("/all_routes");
              },
            ),
            const Spacer(),
            IconButton(
              tooltip: 'Favourites',
              icon: const Icon(Icons.favorite),
              onPressed: () {
                Navigator.of(context).pushNamed("/all_routes");
              },
            ),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            IconButton(
              tooltip: 'Settings',
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).pushNamed("/my_settings");
              },
            ),
            const Spacer(),
            IconButton(
              tooltip: 'Logout',
              icon: const Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamed("");
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
