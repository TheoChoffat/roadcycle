import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(height: 25),
        ListTile(
          leading: const Icon(Icons.directions_bike),
          title: Text(AppLocalizations.of(context)!.allRoutes),
          onTap: () {
            Navigator.of(context).pushNamed("/all_routes");
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.myRoutes),
          onTap: () {
            Navigator.of(context).pushNamed("/my_routes");
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.settings),
          onTap: () {
            Navigator.of(context).pushNamed("/my_settings");
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.logout),
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamed("");
          },
        ),
      ],
    );
  }
}
