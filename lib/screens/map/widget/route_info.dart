import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roadcycle/main.dart';

import '../../../utility/AppColors.dart';
import '../../auth/utils.dart';
import '../setup/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Display the information about the route
Widget routeInfo(BuildContext context, String distance,
    String durationFormatted, String ascent, String descent) {
  // Get source and destination addresses from sharedPreferences
  String sourceAddress = getPlacesStored('source');
  String destinationAddress = getPlacesStored('destination');
  bool isExist = sharedPreferences.getBool('exist')!;
  if (isExist == null){
    isExist == false;
  }

  return Positioned(
    bottom: 0,
    child: SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$sourceAddress -> $destinationAddress',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppColors.main.orange)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    tileColor: Colors.grey[200],
                    leading: const Icon(Icons.pedal_bike),
                    title: Text(AppLocalizations.of(context)!.information,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        '${AppLocalizations.of(context)!.distance}$distance km |${AppLocalizations.of(context)!.time}$durationFormatted |${AppLocalizations.of(context)!.elevation}$ascent m -$descent m'),
                  ),
                ),
                isAdmin
                    ? !isExist ? ElevatedButton(
                        onPressed: () async {
                          await saveData(distance, durationFormatted, ascent,
                              descent, sourceAddress, destinationAddress);
                              Navigator.of(context).pushNamed("/my_routes");
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(20),
                            backgroundColor: AppColors.main.orange),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(AppLocalizations.of(context)!.saveRoute),
                            ]))
                    : const Text("") : const Text(""),
              ]),
        ),
      ),
    ),
  );
}
//Save the route
Future<void> saveData(String distance, String durationFormatted, String ascent,
    String descent, String sourceAdd, String destinationAdd) async {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  String routeName = "$sourceAdd -> $destinationAdd";

  final routeToSave = {
    "destinationLat":
        (json.decode(sharedPreferences.getString('destination')!)['location']
            ['coordinates'][0]),
    "destinationLng":
        (json.decode(sharedPreferences.getString('destination')!)['location']
            ['coordinates'][1]),
    "destinationMeta":
        (json.decode(sharedPreferences.getString('destination')!)),
    "destinationName": destinationAdd,
    "distance": double.parse(distance),
    "duration": durationFormatted,
    "idAdmin": userId,
    "maxElevation": double.parse(ascent),
    "minElevation": double.parse(descent),
    "originLat":
        (json.decode(sharedPreferences.getString('source')!)['location']
            ['coordinates'][0]),
    "originLng":
        (json.decode(sharedPreferences.getString('source')!)['location']
            ['coordinates'][1]),
    "originName": sourceAdd,
    "routeName": routeName,
    "sourceMeta": (json.decode(sharedPreferences.getString('source')!)),
  };

  final databaseReference = FirebaseFirestore.instance.collection("route");
  await databaseReference.add(routeToSave);
}
