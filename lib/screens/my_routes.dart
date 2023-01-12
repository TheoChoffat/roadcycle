// ignore: file_names
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:latlong2/latlong.dart';
import '../main.dart';
import '../utility/AppColors.dart';
import '../utility/AdminDrawer.dart';
import 'map/display/map_overview.dart';
import 'map/services/api_manager.dart';
import 'map/setup/shared_prefs.dart';

class MyRoutes extends StatefulWidget {
  const MyRoutes({super.key});

  @override
  State<MyRoutes> createState() => _MyRoutesState();
}

class _MyRoutesState extends State<MyRoutes> {
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();

    super.dispose();
  }

  Future openEditDialog(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("New Route name"),
            content: TextField(
              autofocus: true,
              decoration: const InputDecoration(hintText: "Enter the new name"),
              controller: nameController,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      FirebaseFirestore.instance
                          .collection('route')
                          .doc(id)
                          .update({'routeName': nameController.text.trim()});
                      Navigator.of(context).pop();
                      nameController.text = "";
                    }
                  },
                  child: const Text("Save name"))
            ],
          ));

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
        title: Text(AppLocalizations.of(context)!.myRoutes),
        backgroundColor: AppColors.main.orange,
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
            onPressed: () {
              changeSort();
            },
          )
        ],
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
                title: Text(data['routeName']),
                subtitle:
                    Text(data['originName'] + " - " + data['destinationName']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          openEditDialog(document.reference.id);
                        },
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          showAlertDialog(context, document.reference.id);
                        },
                        icon: const Icon(Icons.delete)),
                  ],
                ),
                onTap: (() => searchData(data)),
                // onTap: searchData(data),
              );
            }).toList(),
          );
        },
      ),
      drawer: const Drawer(
        child: DrawerWidget(),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed("/createRoute"),
        backgroundColor: AppColors.main.orange,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Stream<QuerySnapshot> _routes = FirebaseFirestore.instance
      .collection('route')
      .where("idAdmin", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .snapshots();

  showAlertDialog(BuildContext context, String id) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(AppLocalizations.of(context)!.cancel),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(AppLocalizations.of(context)!.delete),
      onPressed: () {
        FirebaseFirestore.instance.collection("route").doc(id).delete();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(AppLocalizations.of(context)!.deleteRoute),
      content: Text(AppLocalizations.of(context)!.deleteRouteDescription),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  searchData(Map<String, dynamic> data) async {
    sharedPreferences.setBool('exist', true);
    sharedPreferences.setString('source', json.encode(data['sourceMeta']));
    sharedPreferences.setString(
        'destination', json.encode(data['destinationMeta']));
        print((sharedPreferences.getString('destination')));
                print(sharedPreferences.getString('source'));

    LatLng sourceLatLng = getRouteLatLngStored('source');
    LatLng destinationLatLng = getRouteLatLngStored('destination');
    Map modifiedResponse =
        await getDirectionsResponse(sourceLatLng, destinationLatLng);

    // ignore: use_build_context_synchronously
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MapOverview(modifiedResponse: modifiedResponse)));
  }
}
