import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:panda_tech_nfc/features/dashboard/models/weather_forecast_dto.dart';
import 'package:panda_tech_nfc/features/dashboard/services/weather_service.dart';

import '../../authentication/login/view/login_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key, required String this.email}) : super(key: key);

  final String email;

  @override
  State<DashboardPage> createState() => _DashboardPageState(email);
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  final WeatherService _weatherService = WeatherService();
  final _locationName = 'Newcastle';
  final _locationCountryCode = 'AU';
  final String email;
  var _welcomeText = "Welcome ";
  var _locationForecastText = '7 Day forecast for ';

  _DashboardPageState(this.email) {
    _welcomeText = "Welcome " + email;
    _locationForecastText = '7 Day forecast for ' + _locationName;
  }

  String _WeatherConditionToEmoji(String weatherCondition) {
    switch (weatherCondition) {
      case 'Clear':
        return '☀️';
      case 'Rain':
        return '🌧️';
      case 'Clouds':
        return '☁️';
      case 'Snow':
        return '🌨️';
      default:
        return '❓';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_welcomeText),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () async {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('TODO -> Show Settings page'),
                  ),
                );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              await Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _weatherService.getWeeklyWeatherForecast(
            _locationName, _locationCountryCode),
        builder: (builder, snapshot) {
          if (snapshot.hasData) {
            // return Text("Has data success - " +
            //     (snapshot.data as List<WeatherForecast>).toString());
            var weatherForecasts = snapshot.data as List<WeatherForecast>;
            weatherForecasts.removeAt(0); // don't need to show today's forecast
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _locationName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Text(
                    'Updated: ${DateFormat.jm().format(DateTime.now())}',
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _WeatherConditionToEmoji(
                          weatherForecasts[0].weather?[0].main ?? ''),
                      style: const TextStyle(fontSize: 100),
                    ),
                  ],
                ),
                ListView.separated(
                  itemBuilder: (BuildContext, index) {
                    return ListTile(
                      leading: Text(
                        _WeatherConditionToEmoji(
                            weatherForecasts[index].weather?[0].main ?? ''),
                        style: const TextStyle(fontSize: 20),
                      ),
                      title: Text(_getTitle(weatherForecasts[index])),
                      subtitle: Text(
                          weatherForecasts[index].weather?[0].description ??
                              'na'),
                      onTap: () {
                        _showDialog(context, weatherForecasts[index]);
                      },
                    );
                  },
                  separatorBuilder: (BuildContext, index) {
                    return Divider(height: 1);
                  },
                  itemCount: weatherForecasts.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(5),
                  scrollDirection: Axis.vertical,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  String _getTitle(WeatherForecast forecast) {
    DateTime currentDate = DateTime.fromMillisecondsSinceEpoch(
        forecast.dt != null ? forecast.dt! * 1000 : 0);
    return DateFormat.E().format(currentDate) +
        ' ' +
        DateFormat.yMMMd().format(currentDate) +
        ' - ' +
        (forecast.weather?[0].main ?? 'na');
  }

  String _getExtraData(WeatherForecast forecast) {
    return 'date: ' +
        forecast.dt.toString() +
        '\nsunrise: ' +
        forecast.sunrise.toString() +
        '\nsunset: ' +
        forecast.sunset.toString() +
        '\ntemp max: ' +
        (forecast.temp?.max?.toString() ?? 'na') +
        '\ntemp min: ' +
        (forecast.temp?.min?.toString() ?? 'na');
  }

  void _showDialog(BuildContext context, WeatherForecast forecast) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(_getTitle(forecast)),
          content: new Text(_getExtraData(forecast)),
          actions: <Widget>[
            FlatButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
