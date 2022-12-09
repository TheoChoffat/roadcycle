import 'package:dio/dio.dart';

String searchUrl = 'https://api.openrouteservice.org/geocode/search';
String api_key = '5b3ce3597851110001cf6248ccc00d0f6e574355be1be99cfbe46788';
String boundary = 'ch';

Dio _dio = Dio();

// Call api to get results from user's input
Future getSearchResults(String query) async {
  String url =
      '$searchUrl?api_key=$api_key&text=$query&boundary.country=$boundary';
  url = Uri.parse(url).toString();
  print(url);
  try {
    _dio.options.contentType = Headers.jsonContentType;
    final responseData = await _dio.get(url);
    return responseData.data;
  } catch (e) {
    print(e);
  }
}
