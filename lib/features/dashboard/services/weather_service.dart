import 'package:panda_tech_nfc/global/services/api_service_base.dart';

import '../../../constants/api_constants.dart';
import '../models/weather_forecast_dto.dart';

class WeatherService extends ApiServiceBase {
  static const String _baseEndpoint = ApiConstants.baseWeatherForecastEndpoint;
  static const String _apiKey = ApiConstants.apiWeatherKey;

  Future<List<WeatherForecast>> getWeeklyWeatherForecast(
      String location, String countryCode) async {
    Map<String, dynamic> parameters = {
      'q': location + ',' + countryCode,
      'cnt': '7',
      'appId': _apiKey
    };
    // Uri uri = Uri.https(_authority, _path, parameters);
    // http.Response result = await http.get(uri);
    // Map<String, dynamic> data = json.decode(result.body);
    // return Weather.fromJson(data);

    await Future.delayed(const Duration(milliseconds: 3000));

    var response =
        await get<WeatherForecastDTO, void>(_baseEndpoint, parameters);
    if (response.weatherForecasts != null) {
      return response.weatherForecasts!;
    }

    throw Exception('Error: No forecasts available');
  }
}
