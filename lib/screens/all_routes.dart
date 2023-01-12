// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roadcycle/utility/AppColors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roadcycle/utility/RouteList.dart';
import '../utility/BottomNavigation.dart';

class AllRoutes extends StatefulWidget {
  const AllRoutes({super.key});

  @override
  State<AllRoutes> createState() => _AllRoutesState();
}

class _AllRoutesState extends State<AllRoutes> {
  Stream<QuerySnapshot> _routes = FirebaseFirestore.instance
      .collection('route')
      .orderBy("distance", descending: false)
      .snapshots();

  //Show the different sorting options for the routes
  void changeSort() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.sort),
              content: SizedBox(
                height: 220,
                width: double.minPositive,
                child: ListView(
                  children: [
                    ListTile(
                      title: Row(
                        children: [
                          Text(AppLocalizations.of(context)!.sortName),
                          Icon(Icons.arrow_downward_outlined)
                        ],
                      ),
                      onTap: () => {
                        setState(() {
                          _routes = FirebaseFirestore.instance
                              .collection('route')
                              .orderBy("routeName", descending: false)
                              .snapshots();
                        }),
                        Navigator.of(context).pop()
                      },
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Text(AppLocalizations.of(context)!.sortName),
                          Icon(Icons.arrow_upward_outlined)
                        ],
                      ),
                      onTap: () => {
                        setState(() {
                          _routes = FirebaseFirestore.instance
                              .collection('route')
                              .orderBy("routeName", descending: true)
                              .snapshots();
                        }),
                        Navigator.of(context).pop()
                      },
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Text(AppLocalizations.of(context)!.sortDistance),
                          Icon(Icons.arrow_downward_outlined)
                        ],
                      ),
                      onTap: () => {
                        setState(() {
                          _routes = FirebaseFirestore.instance
                              .collection('route')
                              .orderBy("distance", descending: false)
                              .snapshots();
                        }),
                        Navigator.of(context).pop()
                      },
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Text(AppLocalizations.of(context)!.sortDistance),
                          Icon(Icons.arrow_upward_outlined)
                        ],
                      ),
                      onTap: () => {
                        setState(() {
                          _routes = FirebaseFirestore.instance
                              .collection('route')
                              .orderBy("distance", descending: true)
                              .snapshots();
                        }),
                        Navigator.of(context).pop()
                      },
                    ),
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.allRoutes),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.main.orange,
        actions: [
          IconButton(
              icon: Icon(
                Icons.filter_list,
                color: Colors.white,
              ),
              onPressed: () => changeSort())
        ],
      ),
      body: RouteList(
        routes: _routes,
      ),
      bottomNavigationBar: const BottomNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed("/my_home"),
        backgroundColor: AppColors.main.orange,
        child: const Icon(Icons.directions_bike),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
