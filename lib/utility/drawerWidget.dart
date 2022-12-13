import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roadcycle/screens/auth/utils.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    var tileMyRoutes = ListTile(
      title: Text(AppLocalizations.of(context)!.myRoutes),
      onTap: () {
        Navigator.of(context).pushNamed("/my_routes");
      },
    );

    if (isAdmin) {
      return ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(height: 25),
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
              isAdmin = false;
              Navigator.of(context).pushNamed("");
            },
          ),
        ],
      );
    }

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
          title: Text(AppLocalizations.of(context)!.settings),
          onTap: () {
            Navigator.of(context).pushNamed("/my_settings");
          },
        ),
        ListTile(
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
