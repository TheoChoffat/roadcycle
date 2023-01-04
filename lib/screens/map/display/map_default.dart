import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../../main.dart';
import '../../../utility/AppColors.dart';
import '../setup/shared_prefs.dart';
import 'route_preparation.dart';

// Class that displays a basic map
class MapDefault extends StatefulWidget {
  const MapDefault({Key? key}) : super(key: key);

  @override
  State<MapDefault> createState() => _MapDefaultState();
}

class _MapDefaultState extends State<MapDefault> {
  late String currentAddress;
  late var currentCoord;
  late double currentLatLng;
  late double currentLongLng;
  late bool allowed = false;

  StreamController<void> resetController = StreamController.broadcast();
  String layerRoute =
      'https://wmts20.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-farbe/default/current/3857/{z}/{x}/{y}.jpeg';
  String layerImage =
      'https://wmts20.geo.admin.ch/1.0.0/ch.swisstopo.swissimage/default/current/3857/{z}/{x}/{y}.jpeg';
  bool layerToogle = true;

  final _mapController = MapController();

  @override
  void initState() {
    super.initState();

    if (sharedPreferences.getDouble("allowed") == 1) {
      allowed = true;

      currentAddress = getCurrentAddressStored();
      currentCoord = getCurrentLatLngStored();

      currentLatLng = double.parse(currentCoord.toString().substring(
          currentCoord.toString().indexOf('longitude:') + 10,
          currentCoord.toString().length - 1));
      currentLongLng = double.parse(currentCoord
          .toString()
          .substring(16, currentCoord.toString().indexOf(',')));
    }
  }

  void _resetTiles() {
    setState(() {
      layerToogle = !layerToogle;
    });
    resetController.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo_roadcycle_orange.png',
          height: 20,
        ),
        backgroundColor: AppColors.main.orange,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: allowed
                  ? LatLng(currentLongLng, currentLatLng)
                  : LatLng(46.8, 8.5),
              maxBounds: LatLngBounds(
                LatLng(45.4, 5.8),
                LatLng(47.9, 10.7),
              ),
              zoom: 10,
              minZoom: 8,
              maxZoom: 18,
              interactiveFlags: InteractiveFlag.all,
            ),
            children: [
              TileLayer(
                reset: resetController.stream,
                urlTemplate: layerToogle ? layerRoute : layerImage,
                userAgentPackageName: layerToogle
                    ? 'ch.vbs.panzerverschiebungsrouten'
                    : 'ch.swisstopo.swissimage',
              ),
              allowed
                  ? MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(currentLongLng, currentLatLng),
                          builder: (context) => const FlutterLogo(),
                        )
                      ],
                    )
                  : const MarkerLayer(),
            ],
          ),
          Positioned(
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
                          const SizedBox(height: 20),
                          Text(
                            AppLocalizations.of(context)!.yourPosition,
                          ),
                          Text(
                              allowed
                                  ? currentAddress
                                  : AppLocalizations.of(context)!.unknown,
                              style: TextStyle(color: AppColors.main.orange)),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const PrepareRoute())),
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(20),
                                backgroundColor: AppColors.main.orange),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(AppLocalizations.of(context)!.newRoute),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 200,
                right: 0,
                child: IconButton(
                    onPressed: _resetTiles,
                    icon: const Icon(Icons.swap_horiz_rounded),
                    iconSize: 50,
                    color: AppColors.main.orange),
              ),
        ],
      ),
    );
  }
}
