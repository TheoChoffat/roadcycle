import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

String searchUrl = 'https://api.openrouteservice.org/geocode/reverse';
String api_key = '5b3ce3597851110001cf6248ccc00d0f6e574355be1be99cfbe46788';
String boundary = 'CH';

Dio _dio = Dio();

// Call api to get position details from lat/lng
Future getReverseGeocoding(LatLng latLng) async {
  String query = 'point.lon=${latLng.longitude}&point.lat=${latLng.latitude}';
  String url = '$searchUrl?api_key=$api_key&$query&boundary.country=$boundary';
  url = Uri.parse(url).toString();
  try {
    _dio.options.contentType = Headers.jsonContentType;
    final responseData = await _dio.get(url);
    return responseData.data;
  } catch (e) {
    print(e);
  }
}
