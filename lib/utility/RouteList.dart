import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:latlong2/latlong.dart';

import '../main.dart';
import '../screens/map/display/map_overview.dart';
import '../screens/map/services/api_manager.dart';

//Add the favorite to user in Firebase
Future addFavorite(String routeId) async {
  FirebaseFirestore.instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .update({
    "favorites": FieldValue.arrayUnion([routeId])
  });
}

//Remove the favorite from user in Firebase
Future removeFavourite(String routeId) async {
  FirebaseFirestore.instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .update({
    "favorites": FieldValue.arrayRemove([routeId])
  });
}

//Class to show a list of all the Routes
class RouteList extends StatelessWidget {
  RouteList({super.key, required this.routes});

  final Stream<QuerySnapshot> routes;

  final DocumentReference _favorites = FirebaseFirestore.instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser?.uid);

  @override
  Widget build(BuildContext context) {
    //Function to open the selected Route on the map
    Future<void> searchRoute(Map<String, dynamic> data) async {
          sharedPreferences.setBool('exist', false);

      Map<String, dynamic> srcMeta = data['sourceMeta'];
      String sourceString = json.encode(srcMeta);
      Map<String, dynamic> dstMeta = data['destinationMeta'];
      String destinationString = json.encode(dstMeta);
      sharedPreferences.setString('source', sourceString);
      sharedPreferences.setString('destination', destinationString);

      LatLng source = LatLng(data['originLat'], data['originLng']);
      LatLng destination =
          LatLng(data['destinationLat'], data['destinationLng']);
      Map modifiedResponse = await getDirectionsResponse(source, destination);

      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => MapOverview(modifiedResponse: modifiedResponse)));
    }

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
                title: Text(data['routeName']),
                subtitle:
                    Text(data['originName'] + " - " + data['destinationName']),
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
                  searchRoute(data);
                });
          }).toList(),
        );
      },
    );
  }
}
