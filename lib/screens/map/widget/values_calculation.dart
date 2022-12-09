import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'map_elevation.dart';

// Transform seconds into hours
String getDuration(num duration) {
  int hour = duration ~/ 3600;
  int minute = ((duration - hour * 3600)) ~/ 60;

  var hours = hour.toString();
  var minutes = minute.toString();

  if (hour < 10) hours = '0$hour';

  if (minute < 10) minutes = '0$minute';

  String result = "$hours h $minutes min";

  return result;
}

// Calculation elevation
String getElevation(num start, num end) {
  String elevation = (end - start).round().toString();
  return elevation;
}

// Get the elevation points
List<ElevationPoint> getPoints(List point) {
  List<List<double>> list = [];

  for (int i = 0; i < point.length; i++) {
    list.add([point[i][0], point[i][1], point[i][2]]);
  }
  return list.map((e) => ElevationPoint(e[1], e[0], e[2])).toList();
}

// Calculate center of route
LatLng getCenterRoute(double long, double lat, double long1, double lat1) {
  double finalLat = (lat + lat1) / 2;
  double finalLng = (long + long1) / 2;
  return LatLng(finalLng, finalLat);
}
