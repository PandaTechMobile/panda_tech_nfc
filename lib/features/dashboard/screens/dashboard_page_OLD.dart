import 'dart:math' as math;

import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:panda_tech_nfc/features/dashboard/models/weather_forecast_dto.dart';
import 'package:panda_tech_nfc/features/dashboard/services/weather_service.dart';

import '../../authentication/login/view/login_page.dart';

class DashboardPageOLD extends StatefulWidget {
  const DashboardPageOLD({Key? key, required String this.email})
      : super(key: key);

  final String email;

  @override
  State<DashboardPageOLD> createState() => _DashboardPageOLDState(email);
}

class _DashboardPageOLDState extends State<DashboardPageOLD>
    with TickerProviderStateMixin {
  final WeatherService _weatherService = WeatherService();
  final _locationName = 'Newcastle';
  final _locationCountryCode = 'AU';
  final String email;
  var _welcomeText = "Welcome ";
  var _locationForecastText = '7 Day forecast for ';
  // TODO -> Make it change based on forecast
  var _showRainAnimation = false;

  _DashboardPageOLDState(this.email) {
    _welcomeText = "Welcome " + email;
    _locationForecastText = '7 Day forecast for ' + _locationName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
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
      body: AnimatedBackground(
        behaviour: RainParticleBehaviour(
          options: ParticleOptions(
            baseColor: Theme.of(context).primaryColor,
            spawnOpacity: 0.0,
            opacityChangeRate: 0.25,
            minOpacity: 0.1,
            maxOpacity: 1,
            particleCount: _showRainAnimation ? 70 : 0,
            spawnMaxRadius: 3.0,
            spawnMinRadius: 1.0,
            spawnMaxSpeed: 100.0,
            spawnMinSpeed: 30,
          ),
        ),
        vsync: this,
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                child: Text(
                  _welcomeText,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.start,
                ),
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
              FutureBuilder(
                future: _weatherService.getWeeklyWeatherForecast(
                    _locationName, _locationCountryCode),
                builder: (builder, snapshot) {
                  if (snapshot.hasData) {
                    // return Text("Has data success - " +
                    //     (snapshot.data as List<WeatherForecast>).toString());
                    var weatherForecasts =
                        snapshot.data as List<WeatherForecast>;
                    return ListView.separated(
                      itemBuilder: (BuildContext, index) {
                        return ListTile(
                          leading: Icon(
                            Icons.cloud_circle_sharp,
                            color: Colors.blue,
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
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error");
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTitle(WeatherForecast forecast) {
    return forecast.dt.toString() + ' - ' + (forecast.weather?[0].main ?? 'na');
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
            new FlatButton(
              child: new Text("OK"),
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

class RainParticleBehaviour extends RandomParticleBehaviour {
  static math.Random random = math.Random();

  bool enabled;

  RainParticleBehaviour({
    ParticleOptions options = const ParticleOptions(),
    Paint? paint,
    this.enabled = true,
  }) : super(options: options, paint: paint);

  @override
  void initPosition(Particle p) {
    p.cx = random.nextDouble() * size!.width;
    if (p.cy == 0.0)
      p.cy = random.nextDouble() * size!.height;
    else
      p.cy = random.nextDouble() * size!.width * 0.2;
  }

  @override
  void initDirection(Particle p, double speed) {
    double dirX = (random.nextDouble() - 0.5);
    double dirY = random.nextDouble() * 0.5 + 0.5;
    double magSq = dirX * dirX + dirY * dirY;
    double mag = magSq <= 0 ? 1 : math.sqrt(magSq);

    p.dx = dirX / mag * speed;
    p.dy = dirY / mag * speed;
  }

  @override
  Widget builder(
      BuildContext context, BoxConstraints constraints, Widget child) {
    return GestureDetector(
      onPanUpdate: enabled
          ? (details) => _updateParticles(context, details.globalPosition)
          : null,
      onTapDown: enabled
          ? (details) => _updateParticles(context, details.globalPosition)
          : null,
      child: ConstrainedBox(
        // necessary to force gesture detector to cover screen
        constraints: BoxConstraints(
            minHeight: double.infinity, minWidth: double.infinity),
        child: super.builder(context, constraints, child),
      ),
    );
  }

  void _updateParticles(BuildContext context, Offset offsetGlobal) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var offset = renderBox.globalToLocal(offsetGlobal);
    particles!.forEach((particle) {
      var delta = (Offset(particle.cx, particle.cy) - offset);
      if (delta.distanceSquared < 70 * 70) {
        var speed = particle.speed;
        var mag = delta.distance;
        speed *= (70 - mag) / 70.0 * 2.0 + 0.5;
        speed = math.max(
            options.spawnMinSpeed, math.min(options.spawnMaxSpeed, speed));
        particle.dx = delta.dx / mag * speed;
        particle.dy = delta.dy / mag * speed;
      }
    });
  }
}
