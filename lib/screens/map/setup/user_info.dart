import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../display/map_default.dart';
import '../services/api_manager.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  void initState() {
    super.initState();
    initializeLocationAndSave();
  }

  void initializeLocationAndSave() async {
    // Ensure all permissions are collected for Locations
    Location _location = Location();
    PermissionStatus? _permissionStatus;

    //CHECK IF ANDROID NEEDD IT !!!
    //bool? _serviceEnabled;

    // _serviceEnabled = await _location.serviceEnabled();
    // if (!_serviceEnabled) {
    //         print("fuck2");

    //   _serviceEnabled = await _location.requestService();
    // }

    _permissionStatus = await _location.hasPermission();
    print(_permissionStatus);
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await _location.requestPermission();
    }

    if (_permissionStatus.toString() == "PermissionStatus.deniedForever") {
      sharedPreferences.setBool("allowed", false);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MapDefault()),
          (route) => false);
    } else {
      LocationData _locationData = await _location.getLocation();
      LatLng currentLocation =
          LatLng(_locationData.latitude!, _locationData.longitude!);

      String currentAddress =
          (await getParsedReverseGeocoding(currentLocation))['place'];

      // Store the user location in sharedPreferences
      sharedPreferences.setDouble('latitude', _locationData.latitude!);
      sharedPreferences.setDouble('longitude', _locationData.longitude!);
      sharedPreferences.setString('current-address', currentAddress);
      sharedPreferences.setBool("allowed", true);
    }

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MapDefault()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.orange,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'RoadCycle',
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
