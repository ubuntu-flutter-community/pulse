import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:open_weather_client/open_weather.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

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

  Future<WeatherData?> loadWeatherFromCityName(String cityName) async {
    try {
      WeatherData? weatherData = await _openWeather.currentWeatherByCityName(
        cityName: cityName,
        weatherUnits: WeatherUnits.METRIC,
      );
      return weatherData;
      // ignore: empty_catches
    } catch (e) {}
    return null;
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
  }) async {
    return (await _openWeather.fiveDaysWeatherForecastByCityName(
      cityName: cityName,
      weatherUnits: WeatherUnits.METRIC,
    ))
        .forecastData
        .toList();
  }

  Future<List<WeatherData>> loadForeCastByPosition({
    required double longitude,
    required double latitude,
  }) async {
    return (await _openWeather.fiveDaysWeatherForecastByLocation(
      longitude: longitude,
      latitude: latitude,
      weatherUnits: WeatherUnits.METRIC,
    ))
        .forecastData;
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

  String getDate(BuildContext context) => weatherData?.date == null
      ? ''
      : DateFormat.yMMMMEEEEd(
          Localizations.maybeLocaleOf(context)?.toLanguageTag(),
        )
          .format(DateTime.fromMillisecondsSinceEpoch(weatherData!.date * 1000))
          .toString();
  String getTime(BuildContext context) {
    return weatherData?.date == null
        ? ''
        : DateFormat.Hm(Localizations.maybeLocaleOf(context)?.toLanguageTag())
            .format(
              DateTime.fromMillisecondsSinceEpoch(weatherData!.date * 1000),
            )
            .toString();
  }
}
