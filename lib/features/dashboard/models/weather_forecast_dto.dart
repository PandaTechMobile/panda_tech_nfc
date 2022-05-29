import 'package:json_annotation/json_annotation.dart';
part 'weather_forecast_dto.g.dart';

@JsonSerializable()
class WeatherForecastDTO {
  City? city;
  String? cod;
  double? message;
  int? cnt;
  @JsonKey(name: 'list')
  List<WeatherForecast>? weatherForecasts;

  WeatherForecastDTO(
      {this.city, this.cod, this.message, this.cnt, this.weatherForecasts});

  factory WeatherForecastDTO.fromJson(Map<String, dynamic> data) =>
      _$WeatherForecastDTOFromJson(data);

  Map<String, dynamic> toJson() => _$WeatherForecastDTOToJson(this);
}

@JsonSerializable()
class City {
  int? id;
  String? name;
  Coord? coord;
  String? country;
  int? population;
  int? timezone;

  City(
      {this.id,
      this.name,
      this.coord,
      this.country,
      this.population,
      this.timezone});

  factory City.fromJson(Map<String, dynamic> data) => _$CityFromJson(data);

  Map<String, dynamic> toJson() => _$CityToJson(this);
}

@JsonSerializable()
class Coord {
  double? lon;
  double? lat;

  Coord({this.lon, this.lat});

  factory Coord.fromJson(Map<String, dynamic> data) => _$CoordFromJson(data);

  Map<String, dynamic> toJson() => _$CoordToJson(this);
}

@JsonSerializable()
class WeatherForecast {
  int? dt;
  int? sunrise;
  int? sunset;
  Temp? temp;
  FeelsLike? feelsLike;
  double? pressure;
  double? humidity;
  List<Weather>? weather;
  double? speed;
  double? deg;
  double? gust;
  double? clouds;
  double? pop;
  double? rain;

  WeatherForecast(
      {this.dt,
      this.sunrise,
      this.sunset,
      this.temp,
      this.feelsLike,
      this.pressure,
      this.humidity,
      this.weather,
      this.speed,
      this.deg,
      this.gust,
      this.clouds,
      this.pop,
      this.rain});

  factory WeatherForecast.fromJson(Map<String, dynamic> data) =>
      _$WeatherForecastFromJson(data);

  Map<String, dynamic> toJson() => _$WeatherForecastToJson(this);
}

@JsonSerializable()
class Temp {
  double? day;
  double? min;
  double? max;
  double? night;
  double? eve;
  double? morn;

  Temp({this.day, this.min, this.max, this.night, this.eve, this.morn});

  factory Temp.fromJson(Map<String, dynamic> data) => _$TempFromJson(data);

  Map<String, dynamic> toJson() => _$TempToJson(this);
}

@JsonSerializable()
class FeelsLike {
  double? day;
  double? night;
  double? eve;
  double? morn;

  FeelsLike({this.day, this.night, this.eve, this.morn});

  factory FeelsLike.fromJson(Map<String, dynamic> data) =>
      _$FeelsLikeFromJson(data);

  Map<String, dynamic> toJson() => _$FeelsLikeToJson(this);
}

@JsonSerializable()
class Weather {
  int? id;
  String? main;
  String? description;
  String? icon;

  Weather({this.id, this.main, this.description, this.icon});

  factory Weather.fromJson(Map<String, dynamic> data) =>
      _$WeatherFromJson(data);

  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}
