import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utility/AppColors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utility/BottomNavigation.dart';
import '../utility/RouteList.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Routes"),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.main.orange,
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
                  title: Text(data['name']),
                  subtitle: Text(data['startPoint'] + " - " + data['endPoint']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FavoriteButton(
                        isFavorite: true,
                        // iconDisabledColor: Colors.white,
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
                );
              }).toList(),
            );
          }),
      bottomNavigationBar: const BottomNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed("/my_home"),
        backgroundColor: AppColors.main.orange,
        child: const Icon(Icons.directions_bike),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  final Stream<QuerySnapshot> routes =
      FirebaseFirestore.instance.collection('route').snapshots();
}
