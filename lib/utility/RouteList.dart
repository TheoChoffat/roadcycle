// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future addFavorite(String routeId) async {
  FirebaseFirestore.instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .update({
    "favorites": FieldValue.arrayUnion([routeId])
  });
}

Future removeFavourite(String routeId) async {
  FirebaseFirestore.instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .update({
    "favorites": FieldValue.arrayRemove([routeId])
  });
}

final DocumentReference _favorites = FirebaseFirestore.instance
    .collection('user')
    .doc(FirebaseAuth.instance.currentUser?.uid);

class RouteList extends StatelessWidget {
  const RouteList({super.key, required this.routes});

  final Stream<QuerySnapshot> routes;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: routes,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            bool isFavRoute = false;
            _favorites.get().then((value) {
              try {
                if (value.get('favorites').contains(document.reference.id)) {
                  isFavRoute = true;
                }
              } catch (e) {
                isFavRoute = false;
              }
            });
            return ListTile(
                title: Text(data['name']),
                subtitle: Text(data['startPoint'] + " - " + data['endPoint']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder(
                        future: _favorites.get(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return FavoriteButton(
                              isFavorite: isFavRoute,
                              // iconDisabledColor: Colors.white,
                              valueChanged: (isFavorite) {
                                if (isFavorite == true) {
                                  addFavorite(document.reference.id);
                                } else {
                                  removeFavourite(document.reference.id);
                                }
                              },
                            );
                          }
                          return const Text("");
                        })
                  ],
                ),
                onTap: () {
                  //debugPrint("ID: ${document.reference.id}");
                });
          }).toList(),
        );
      },
    );
  }
}
