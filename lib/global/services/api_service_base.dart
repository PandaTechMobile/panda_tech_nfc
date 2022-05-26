import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:panda_tech_nfc/features/dashboard/models/weather_forecast_dto.dart';

class ApiServiceBase {
  const ApiServiceBase();

  static const String _baseApi = 'api.openweathermap.org';
  //static const String _path = 'data/2.5/weather';
  //static const String _apiKey = 'a17df150ea36ea4d7c2047fb2b53177e';

  Future<T> get<T, K>(String endpoint, Map<String, dynamic> parameters) async {
    dynamic responseJson;

    final headers = _createHeaders();

    try {
      Uri uri = Uri.https(_baseApi, endpoint, parameters);
      final response = await http.get(uri, headers: headers);

      responseJson = _handleResponse(response);
    } on SocketException {}

    return JsonHelper.fromJson<T, K>(responseJson);
  }

  Future<T> post<T, K>(String endpoint, dynamic object) async {
    dynamic responseJson;

    final headers = _createHeaders();

    try {
      Uri uri = Uri.https(_baseApi, endpoint);
      final body = json.encode(object);
      final response = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      responseJson = _handleResponse(response);
    } on SocketException {}

    return JsonHelper.fromJson<T, K>(responseJson);
  }

  Map<String, String>? _createHeaders() {
    return <String, String>{
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
    };
  }
}

dynamic _handleResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      final dynamic responseJson = json.decode(response.body);
      return responseJson;
    case 400:
    // Custom Exception
    case 401:
    // Custom Exception
    case 403:
    // Custom Exception
    case 500:
    // Custom Exception
    default:
      throw Exception(
        // ignore: lines_longer_than_80_chars
        'An error occured while communicating with the server with StatusCode : ${response.statusCode}',
      );
  }
}

class JsonHelper {
  /// If T is a List, K is the subtype of the list.
  static T fromJson<T, K>(dynamic json) {
    if (json is Iterable) {
      return _fromJsonList<K>(json) as T;
    }

    switch (T) {
      case WeatherForecastDTO:
        return WeatherForecastDTO.fromJson(json as Map<String, dynamic>) as T;
      default:
        throw Exception('Unknown class');
    }
  }

  static List<K>? _fromJsonList<K>(Iterable<dynamic> jsonList) {
    return jsonList.map<K>((dynamic json) => fromJson<K, void>(json)).toList();
  }
}
