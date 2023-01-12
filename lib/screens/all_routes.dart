// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roadcycle/utility/AppColors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roadcycle/utility/RouteList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utility/BottomNavigation.dart';

class AllRoutes extends StatefulWidget {
  const AllRoutes({super.key});

  @override
  State<AllRoutes> createState() => _AllRoutesState();
}

class _AllRoutesState extends State<AllRoutes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.allRoutes),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.main.orange,
      ),
      body: RouteList(
        routes: _routes,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: IconTheme(
          data: const IconThemeData(color: Colors.black),
          child: Row(
            children: <Widget>[
              const Spacer(),
              IconButton(
                tooltip: 'All Routes',
                icon: const Icon(Icons.route, color: Colors.orange),
                onPressed: () {},
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Favourites',
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  Navigator.of(context).pushNamed("/favorites");
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed("/my_home"),
        backgroundColor: AppColors.main.orange,
        child: const Icon(Icons.directions_bike),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  final Stream<QuerySnapshot> _routes =
      FirebaseFirestore.instance.collection('route').snapshots();
}
