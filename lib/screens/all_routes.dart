// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roadcycle/utility/AppColors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utility/BottomNavigation.dart';

class AllRoutes extends StatefulWidget {
  const AllRoutes({super.key});

  @override
  State<AllRoutes> createState() => _AllRoutesState();
}

class _AllRoutesState extends State<AllRoutes> {
  Future addFavorite(String routeId) async {
    final docUser = FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("favourites");
    final json = {"routeId": routeId};

    await docUser.add(json);
  }

  Future removeFavourite(String routeId) async {
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('favourites')
        .where('routeId', isEqualTo: routeId)
        .get()
        .then((snapshot) {
      snapshot.docs[0].reference.delete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.allRoutes),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.main.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _routes,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(AppLocalizations.of(context)!.somethingWrong);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                  title: Text(data['name']),
                  subtitle: Text(data['startPoint'] + " - " + data['endPoint']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () =>
                              removeFavourite(document.reference.id),
                          icon: const Icon(Icons.favorite_border)),
                    ],
                  ),
                  onTap: () {
                    //debugPrint("ID: ${document.reference.id}");
                  });
            }).toList(),
          );
        },
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

  final Stream<QuerySnapshot> _routes =
      FirebaseFirestore.instance.collection('route').snapshots();
}
