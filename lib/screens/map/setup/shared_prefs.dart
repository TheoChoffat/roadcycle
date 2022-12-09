import 'dart:convert';
import 'package:latlong2/latlong.dart';

import '../../../main.dart';

//Get the current position from the sharedPreferences
LatLng getCurrentLatLngStored() {
  return LatLng(sharedPreferences.getDouble('latitude')!,
      sharedPreferences.getDouble('longitude')!);
}

//Get the current address from the sharedPreferences
String getCurrentAddressStored() {
  return sharedPreferences.getString('current-address')!;
}

//Get the info about the route from the sharedPreferences
LatLng getRouteLatLngStored(String type) {
  print(json.decode(sharedPreferences.getString('source')!)['location']
      ['coordinates']);
  print(json.decode(sharedPreferences.getString('destination')!)['location']
      ['coordinates']);

  List sourceLocationList =
      json.decode(sharedPreferences.getString('source')!)['location']
          ['coordinates'];
  List destinationLocationList =
      json.decode(sharedPreferences.getString('destination')!)['location']
          ['coordinates'];
  LatLng source = LatLng(sourceLocationList[0], sourceLocationList[1]);
  LatLng destination =
      LatLng(destinationLocationList[0], destinationLocationList[1]);

  if (type == 'source') {
    return source;
  } else {
    return destination;
  }
}

//Get the info about the source and the destination from the shared preferences
String getPlacesStored(String type) {
  String sourceAddress =
      json.decode(sharedPreferences.getString('source')!)['name'];
  String destinationAddress =
      json.decode(sharedPreferences.getString('destination')!)['name'];

  if (type == 'source') {
    return sourceAddress;
  } else {
    return destinationAddress;
  }
}
