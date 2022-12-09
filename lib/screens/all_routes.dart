// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roadcycle/utility/AppColors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roadcycle/utility/drawerWidget.dart';

class AllRoutes extends StatefulWidget {
  const AllRoutes({super.key});

  @override
  State<AllRoutes> createState() => _AllRoutesState();
}

class _AllRoutesState extends State<AllRoutes> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.allRoutes),
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
                          onPressed: () {},
                          icon: const Icon(Icons.favorite_border)),
                    ],
                  ),
                  onTap: () {
                    debugPrint("ID: " + document.reference.id);
                  });
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
        tooltip: 'Increment Counter',
        backgroundColor: AppColors.main.orange,
        child: const Icon(Icons.directions_bike),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  final Stream<QuerySnapshot> _routes =
      FirebaseFirestore.instance.collection('route').snapshots();
}
