import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import '../../../main.dart';
import '../../../utility/AppColors.dart';
import '../widget/map_elevation.dart';
import '../widget/route_info.dart';
import '../widget/values_calculation.dart';

// Class that displays the route
class MapOverview extends StatefulWidget {
  const MapOverview({Key? key, required this.modifiedResponse})
      : super(key: key);
  final Map modifiedResponse;

  @override
  State<MapOverview> createState() => _MapOverviewState();
}

class _MapOverviewState extends State<MapOverview> {
  late ElevationPoint? hoverPoint;

  LocationData? _currentLocation;
  late List<LatLng> _polylinePoints;
  final List<LatLng> polyPoints = [];
  final Set<Polyline> polyLines = {};
  late List<Marker> _markers = [];
  final List<LatLng> polyLi = [];
  late List<ElevationPoint> elevationPoints;
  late LatLng mid;
  final _mapController = MapController();

  List sourceLocationList =
      json.decode(sharedPreferences.getString('source')!)['location']
          ['coordinates'];
  List destinationLocationList =
      json.decode(sharedPreferences.getString('destination')!)['location']
          ['coordinates'];

  late String distance;
  late String durationFormatted;
  late Map geometry;
  late String ascent;
  late String descent;

  // Set markers
  setMarkers() {
    _markers.add(
      Marker(
        point: LatLng(sourceLocationList[0], sourceLocationList[1]),
        builder: (context) => Icon(
          Icons.location_pin,
          color: AppColors.main.orange,
        ),
      ),
    );
    _markers.add(
      Marker(
        point: LatLng(destinationLocationList[0], destinationLocationList[1]),
        builder: (context) => Icon(
          Icons.location_pin,
          color: AppColors.main.orange,
        ),
      ),
    );
    mid = LatLng((sourceLocationList[0] + destinationLocationList[0]) / 2,
        (sourceLocationList[1] + destinationLocationList[1]) / 2);
    setState(() {});
  }

  //Prepare data to draw the segments
  void drawLines() {
    LineString ls =
        LineString(widget.modifiedResponse['geometry']['coordinates']);

    for (int i = 0; i < ls.lineString.length; i++) {
      polyPoints.add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
      polyLi.add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
    }

    if (polyPoints.length == ls.lineString.length) {
      setPolyLines();
    }
  }

  // Draw segments to create a complete route
  setPolyLines() {
    Polyline polyline = Polyline(
      color: AppColors.main.orange,
      points: polyPoints,
    );
    polyLines.add(polyline);

    setState(() {});
  }

  // Handle the 2 layers available
  StreamController<void> resetController = StreamController.broadcast();
  String layerRoute =
      'https://wmts20.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-farbe/default/current/3857/{z}/{x}/{y}.jpeg';
  String layerImage =
      'https://wmts20.geo.admin.ch/1.0.0/ch.swisstopo.swissimage/default/current/3857/{z}/{x}/{y}.jpeg';
  bool layerToogle = true;

  @override
  void initState() {
    super.initState();

    _calculateValues();
    setMarkers();
    drawLines();
  }

  // Change layer
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
      body: SafeArea(
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                center: (mid),
                maxBounds: LatLngBounds(
                  LatLng(45.4, 5.8),
                  LatLng(47.9, 10.7),
                ),
                zoom: 8,
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
                MarkerLayer(markers: _markers),
                PolylineLayer(
                  polylineCulling: false,
                  polylines: [
                    Polyline(
                        points: polyLi, color: Colors.green, strokeWidth: 5.0),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 120,
              child: Container(
                color: Colors.white.withOpacity(0.8),
                child: NotificationListener<ElevationHoverNotification>(
                    onNotification: (ElevationHoverNotification notification) {
                      setState(() {
                        hoverPoint = notification.position;
                      });
                      return true;
                    },
                    child: Elevation(
                      getPoints(widget.modifiedResponse['elevation']),
                      color: Colors.grey,
                      elevationGradientColors: ElevationGradientColors(
                          gt10: Colors.green,
                          gt20: Colors.orangeAccent,
                          gt30: Colors.redAccent),
                    )),
              ),
            ),
            Positioned(
              bottom: 200,
              right: 10,
              child: IconButton(
                  onPressed: _resetTiles,
                  icon: Icon(
                    Icons.swap_horiz_rounded,
                    size: 50,
                    color: AppColors.main.orange,
                  )),
            ),
            routeInfo(context, distance, durationFormatted, ascent, descent),
          ],
        ),
      ),
    );
  }

  // Get the values to display as route's information
  _calculateValues() {
    distance = (widget.modifiedResponse['distance'] / 1000).toStringAsFixed(1);
    durationFormatted = getDuration(widget.modifiedResponse['duration']);

    ascent = (widget.modifiedResponse['ascent']).toString();
    descent = (widget.modifiedResponse['descent']).toString();
    mid = getCenterRoute(sourceLocationList[0], sourceLocationList[1],
        destinationLocationList[0], destinationLocationList[1]);
  }
}

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}
