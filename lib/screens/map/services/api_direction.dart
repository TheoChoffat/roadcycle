import 'package:latlong2/latlong.dart';
import 'package:dio/dio.dart';

String baseUrl =
    'https://api.openrouteservice.org/v2/directions/cycling-regular/geojson';
String apiKey = '5b3ce3597851110001cf6248ccc00d0f6e574355be1be99cfbe46788';
String pathParam = 'cycling-regular';

Dio _dio = Dio();

// Call api to get the direction between 2 points
Future getDirectionRoute(LatLng source, LatLng destination) async {
  var dat =
      '{"coordinates":[[${source.longitude},${source.latitude}],[${destination.longitude},${destination.latitude}]],"elevation":"true"}';
  try {
    final responseData = await _dio.post(
      baseUrl,
      data: dat,
      options: Options(headers: {
        'Accept':
            'application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8',
        'Authorization':
            '5b3ce3597851110001cf6248ccc00d0f6e574355be1be99cfbe46788',
        'Content-Type': 'application/json; charset=utf-8'
      }),
    );
    return responseData.data;
  } catch (e) {
    print(e);
  }
}
