import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roadcycle/utility/AppColors.dart';
import 'package:roadcycle/utility/BottomNavigation.dart';
import 'package:roadcycle/utility/RouteList.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

final DocumentReference _favorites = FirebaseFirestore.instance
    .collection('user')
    .doc(FirebaseAuth.instance.currentUser?.uid);

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo_roadcycle_orange.png',
          height: 20,
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.main.orange,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: 125,
            decoration: const BoxDecoration(
              color: Color(0xffef4f19),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(25, 20),
                bottomRight: Radius.elliptical(25, 20),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(top: 10.0),
            height: 80,
            child: Row(
              children: <Widget>[
                Container(
                  width: 10,
                ),
                Image.asset('assets/app_logo.png'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 22), //apply padding to some sides only
                        child: Row()),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("user")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          final user = snapshot.data.data();
                          return Column(
                            children: [
                              Text(
                                user['firstname'] + " " + user['lastname'],
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 25, color: Colors.white),
                              ),
                            ],
                          );
                        }
                        return const Material(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 200,
                margin:
                    const EdgeInsets.only(top: 100, left: 20.0, right: 20.0),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(18, 18),
                    topRight: Radius.elliptical(18, 18),
                    bottomLeft: Radius.elliptical(18, 18),
                    bottomRight: Radius.elliptical(18, 18),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection("route")
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var routeCount = snapshot.data?.docs.length;
                            return Column(
                              children: <Widget>[
                                StreamBuilder(
                                  stream: _favorites.snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data.data() != null) {
                                      var favorites = snapshot.data
                                          .data()['favorites'] as List;
                                      return Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                    .homePageInformationTextOne +
                                                " ${routeCount}" +
                                                AppLocalizations.of(context)!
                                                    .homePageInformationTextTwo +
                                                "${favorites.length}" +
                                                AppLocalizations.of(context)!
                                                    .homePageInformationTextThree,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white)),
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                              ],
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    AppLocalizations.of(context)!.startNewRoute,
                    style:
                        TextStyle(fontSize: 24, color: AppColors.main.orange),
                  ),
                ),
              ),
              Expanded(
                child: RouteList(
                  routes: _routes,
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        backgroundColor: AppColors.main.orange,
        child: const Icon(Icons.directions_bike),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  final Stream<QuerySnapshot> _routes =
      FirebaseFirestore.instance.collection('route').limit(4).snapshots();
}
