import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../utility/AppColors.dart';
import '../main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utility/RouteList.dart';
import 'map/display/map_overview.dart';
import 'map/services/api_manager.dart';
import 'map/setup/shared_prefs.dart';

class FavoritesWidget extends StatefulWidget {
  const FavoritesWidget({super.key});

  @override
  State<FavoritesWidget> createState() => _FavoritesWidgetState();
}

class _FavoritesWidgetState extends State<FavoritesWidget> {
  dynamic favoritesList;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((DocumentSnapshot userData) {
      if (userData.exists) {
        try {
          favoritesList = userData.get('favorites');
        } on StateError {}
      }
      ;
    });
  }

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
                          routes = FirebaseFirestore.instance
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
                          routes = FirebaseFirestore.instance
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
                          routes = FirebaseFirestore.instance
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
                          routes = FirebaseFirestore.instance
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
        title: Text(AppLocalizations.of(context)!.favoriteRoute),
        automaticallyImplyLeading: false,
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
          stream: routes,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text(AppLocalizations.of(context)!.somethingWrong);
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              children: snapshot.data!.docs
                  .where((element) => favoritesList
                      .any((field) => field.toString() == element.id))
                  .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                return ListTile(
                  title: Text(data['routeName']),
                  subtitle: Text(
                      data['originName'] + " - " + data['destinationName']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FavoriteButton(
                        isFavorite: true,
                        valueChanged: (isFavorite) {
                          if (isFavorite == true) {
                            addFavorite(document.reference.id);
                          } else {
                            removeFavourite(document.reference.id);
                          }
                        },
                      )
                    ],
                  ),
                  onTap: () {
                    searchRoute(data);
                  },
                );
              }).toList(),
            );
          }),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: IconTheme(
          data: const IconThemeData(color: Colors.black),
          child: Row(
            children: <Widget>[
              const Spacer(),
              IconButton(
                tooltip: 'All Routes',
                icon: const Icon(Icons.route),
                onPressed: () {
                  Navigator.of(context).pushNamed("/all_routes");
                },
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Favourites',
                icon: const Icon(Icons.favorite, color: Colors.orange),
                onPressed: () {},
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
                  Navigator.of(context).pushNamed("/app_start");
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

  Stream<QuerySnapshot> routes =
      FirebaseFirestore.instance.collection('route').snapshots();

  //Get the data and get the route and open it on the map
  Future<void> searchRoute(Map<String, dynamic> data) async {
    sharedPreferences.setBool('exist', false);
    sharedPreferences.setString('source', json.encode(data['sourceMeta']));
    sharedPreferences.setString(
        'destination', json.encode(data['destinationMeta']));
    print((sharedPreferences.getString('destination')));
    print(sharedPreferences.getString('source'));

    LatLng sourceLatLng = getRouteLatLngStored('source');
    LatLng destinationLatLng = getRouteLatLngStored('destination');

    print(sourceLatLng);
    print(destinationLatLng);
    Map modifiedResponse =
        await getDirectionsResponse(sourceLatLng, destinationLatLng);

    // ignore: use_build_context_synchronously
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MapOverview(modifiedResponse: modifiedResponse)));
  }
}
