import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_weather_client/open_weather.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';
import 'package:yaru_colors/yaru_colors.dart';
import 'package:yaru_icons/yaru_icons.dart';

class WeatherModel extends SafeChangeNotifier {
  WeatherModel(String apiKey) : _openWeather = OpenWeather(apiKey: apiKey);

  final OpenWeather _openWeather;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  Position? _position;
  Position? get position => _position;

  WeatherData? _weatherData;
  FormattedWeatherData get data => FormattedWeatherData(_weatherData);

  String? _cityName;
  String? get cityName => _cityName;

  bool? _initializing;
  bool? get initializing => _initializing;
  set initializing(bool? value) {
    if (value == null || value == _initializing) return;
    _initializing = value;
    notifyListeners();
  }

  Future<void> init({String? cityName}) async {
    initializing = true;
    _cityName = cityName;

    _position = await _getCurrentPosition();

    if (_position != null && (cityName == null || cityName.isEmpty)) {
      _weatherData = await loadWeatherByPosition(
        latitude: position!.latitude,
        longitude: position!.longitude,
      );
      _fiveDaysForCast = await loadForeCastByPosition(
        longitude: position!.longitude,
        latitude: position!.latitude,
      );
    } else {
      _weatherData = await loadWeatherFromCityName(cityName!);
      _cityName = cityName;
      _fiveDaysForCast = await loadForeCastByCityName(cityName: cityName);
    }

    initializing = false;
  }

  Future<WeatherData> loadWeatherFromCityName(String cityName) async {
    WeatherData weatherData = await _openWeather.currentWeatherByCityName(
      cityName: cityName,
      weatherUnits: WeatherUnits.METRIC,
    );

    return weatherData;
  }

  List<WeatherData>? _fiveDaysForCast;
  List<FormattedWeatherData> get forecast => _fiveDaysForCast != null
      ? _fiveDaysForCast!.map((e) => FormattedWeatherData(e)).toList()
      : <FormattedWeatherData>[];
  List<WeatherData>? get fiveDaysForCast => _fiveDaysForCast;
  set fiveDaysForCast(List<WeatherData>? value) {
    if (value == null || value.isEmpty) return;
    _fiveDaysForCast = value;
    notifyListeners();
  }

  Future<List<WeatherData>> loadForeCastByCityName({
    required String cityName,
    int take = 5,
  }) async {
    return (await _openWeather.fiveDaysWeatherForecastByCityName(
      cityName: cityName,
      weatherUnits: WeatherUnits.METRIC,
    ))
        .forecastData
        .take(take)
        .toList();
  }

  Future<List<WeatherData>> loadForeCastByPosition({
    required double longitude,
    required double latitude,
    int take = 5,
  }) async {
    return (await _openWeather.fiveDaysWeatherForecastByLocation(
      longitude: longitude,
      latitude: latitude,
      weatherUnits: WeatherUnits.METRIC,
    ))
        .forecastData
        .take(take)
        .toList();
  }

  String? _error;
  String? get error => _error;
  Future<WeatherData> loadWeatherByPosition({
    required double latitude,
    required double longitude,
  }) async {
    return await _openWeather
        .currentWeatherByLocation(
          latitude: latitude,
          longitude: longitude,
          weatherUnits: WeatherUnits.METRIC,
        )
        .catchError((err) => _error = err);
  }

  Future<Position?> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return null;
    }

    final position = await _geolocatorPlatform.getCurrentPosition();
    return position;
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    return true;
  }
}

class FormattedWeatherData {
  FormattedWeatherData(this.weatherData);

  final WeatherData? weatherData;

  String get currentTemperature =>
      '${weatherData?.temperature.currentTemperature ?? ''} °C';
  String get feelsLike => '${weatherData?.temperature.feelsLike ?? ''} °C';

  String get windSpeed => '${weatherData?.wind.speed ?? ''} km/h';

  String get shortDescription =>
      weatherData?.details.firstOrNull?.weatherShortDescription ?? '';
  String get longDescription =>
      weatherData?.details.firstOrNull?.weatherLongDescription ?? '';

  Color get color {
    final time = DateTime.now();

    final night = time.hour > 19 || time.hour < 8;

    switch (shortDescription) {
      case 'Clouds':
        return night ? YaruColors.blue : YaruColors.blue;
      case 'Drizzle':
        return YaruColors.warmGrey;
      case 'Rain':
        return YaruColors.sage;
      case 'Snow':
        return YaruColors.porcelain;
      case 'Clear':
        return night ? YaruColors.blue[900]! : YaruColors.blue[300]!;
      case 'Sunny':
        return night ? YaruColors.warning : YaruColors.warning;
      default:
        return Colors.transparent;
    }
  }

  IconData get icon {
    final time = DateTime.now();

    final night = time.hour > 19 || time.hour < 8;

    switch (shortDescription) {
      case 'Clouds':
        return night ? YaruIcons.few_clouds_night : YaruIcons.few_clouds;
      case 'Drizzle':
        return YaruIcons.rain;
      case 'Rain':
        return YaruIcons.rain;
      case 'Snow':
        return YaruIcons.snow;
      case 'Clear':
        return night ? YaruIcons.clear_night : YaruIcons.sun;
      case 'Sunny':
        return night ? YaruIcons.clear_night : YaruIcons.sun;
      default:
        return night ? YaruIcons.storm : YaruIcons.storm;
    }
  }
}
