// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utility/AppColors.dart';
import '../utility/AdminDrawer.dart';

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
