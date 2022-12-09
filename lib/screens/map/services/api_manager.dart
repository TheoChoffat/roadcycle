import 'package:latlong2/latlong.dart';

import 'api_direction.dart';
import 'api_reverse.dart';
import 'api_search.dart';

//Call the method to get the direction and return map from api answer
Future<Map> getDirectionsResponse(
    LatLng sourceLatLng, LatLng destinationLatLng) async {
  final response = await getDirectionRoute(sourceLatLng, destinationLatLng);

  Map geometry = response['features'][0]['geometry'];
  List elevation = (response['features'][0]['geometry']['coordinates']);
  num duration =
      response['features'][0]['properties']['segments'][0]['duration'];
  num distance =
      response['features'][0]['properties']['segments'][0]['distance'];
  num descent = response['features'][0]['properties']['descent'];
  num ascent = response['features'][0]['properties']['ascent'];

  Map modifiedResponse = {
    "geometry": geometry,
    "duration": duration,
    "distance": distance,
    "ascent": ascent,
    "descent": descent,
    "elevation": elevation
  };
  return modifiedResponse;
}

// Call the method to get the reverse geocoding and return map from api answer
Future<Map> getParsedReverseGeocoding(LatLng latLng) async {
  Map response = Map.from(await getReverseGeocoding(latLng));
  Map feature = response['features'][0];
  Map properties = feature['properties'];

  Map revGeocode = {
    'name': properties['name'],
    'place': properties['label'],
    'postalcode': properties['postalcode'],
    'county': properties['county'],
    'location': LatLng(feature['geometry']['coordinates'][0],
        feature['geometry']['coordinates'][1]),
  };
  return revGeocode;
}

//Remove blanks
String getValidatedQuery(String query) {
  String validatedQuery = query.trim();
  return validatedQuery;
}

// Call the method to get the results from user's input, source and destination. return map from api answer
Future<List> getParsedResponse(String value) async {
  List parsedResponses = [];

  String query = getValidatedQuery(value);
  if (query == '') return parsedResponses;

  Map response = Map.from(await getSearchResults(query));
  List features = response['features'];

  for (var feature in features) {
    Map response = {
      'name': feature['properties']['name'],
      'address': feature['properties']['label'],
      'place': feature['properties']['label'],
      'postalcode': feature['properties']['postalcode'],
      'county': feature['properties']['county'],
      'location': LatLng(feature['geometry']['coordinates'][0],
          feature['geometry']['coordinates'][1]),
    };
    parsedResponses.add(response);
  }
  return parsedResponses;
}


