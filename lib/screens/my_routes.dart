// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utility/AppColors.dart';
import '../utility/drawerWidget.dart';

class MyRoutes extends StatefulWidget {
  const MyRoutes({super.key});

  @override
  State<MyRoutes> createState() => _MyRoutesState();
}

class _MyRoutesState extends State<MyRoutes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myRoutes),
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
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          showAlertDialog(context, document.reference.id);
                        },
                        icon: const Icon(Icons.delete)),
                  ],
                ),
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

  final Stream<QuerySnapshot> _routes = FirebaseFirestore.instance
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
}
