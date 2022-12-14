// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roadcycle/screens/auth/utils.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(height: 25),
        ListTile(
          leading: const Icon(Icons.route),
          title: Text(AppLocalizations.of(context)!.myRoutes),
          onTap: () {
            Navigator.of(context).pushNamed("/my_routes");
          },
        ),
        /*ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {
            Navigator.of(context).pushNamed("/my_settings");
          },
        ),*/
        ListTile(
          leading: const Icon(Icons.logout),
          title: Text(AppLocalizations.of(context)!.logout),
          onTap: () {
            FirebaseAuth.instance.signOut();
            isAdmin = false;
            Navigator.of(context).pushNamed("");
          },
        ),
      ],
    );
  }
}
