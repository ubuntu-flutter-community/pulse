// ignore_for_file: unused_element

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:open_weather_client/models/temperature.dart';
import 'package:open_weather_client/open_weather.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';
import 'package:watch_it/watch_it.dart';

import '../locations/locations_service.dart';
import 'weather_data_x.dart';
import 'weekday.dart';

class WeatherModel extends SafeChangeNotifier {
  WeatherModel({
    required OpenWeather openWeather,
    required LocationsService locationsService,
  })  : _openWeather = openWeather,
        _locationsService = locationsService;

  OpenWeather _openWeather;
  void setApiKeyAndLoadWeather(String apiKey) {
    di
      ..unregister<OpenWeather>()
      ..registerSingleton<OpenWeather>(OpenWeather(apiKey: apiKey));
    _openWeather = di<OpenWeather>();
    loadWeather();
  }

  final LocationsService _locationsService;
  StreamSubscription<bool>? _propertiesChangedSub;

  String? get lastLocation => _locationsService.lastLocation;
  Set<String> get favLocations => _locationsService.favLocations;
  Future<void> removeFavLocation(String location) =>
      _locationsService.removeFavLocation(location);

  WeatherData? _weatherData;
  WeatherData? get data => _weatherData;
  // needed for smooth transition
  WeatherType _weatherType = WeatherType.sunny;
  WeatherType get weatherType => _weatherType;

  String? _error;
  String? get error => _error;
  set error(String? value) {
    if (value == _error) return;
    _error = value;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    if (value == _loading) return;
    _loading = value;
    notifyListeners();
  }

  Future<void> loadWeather({String? cityName}) async {
    _error = null;
    loading = true;

    cityName ??= lastLocation ?? '';

    _propertiesChangedSub =
        _locationsService.propertiesChanged.listen((_) => notifyListeners());

    _weatherData = await loadWeatherFromCityName(cityName);
    _locationsService.setLastLocation(cityName);
    _fiveDaysForCast = await loadForeCastByCityName(cityName: cityName);
    if (_weatherData != null) {
      _locationsService.setLastLocation(cityName);
      _locationsService.addFavLocation(cityName);
    }

    if (_weatherData?.weatherType != null) {
      _weatherType = _weatherData!.weatherType;
    }

    loading = false;
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _propertiesChangedSub?.cancel();
  }

  Future<WeatherData?> loadWeatherFromCityName(String cityName) async {
    try {
      WeatherData? weatherData = await _openWeather.currentWeatherByCityName(
        cityName: cityName,
        weatherUnits: WeatherUnits.METRIC,
      );
      return weatherData;
    } catch (e) {
      error = e.toString();
      return null;
    }
  }

  Future<List<WeatherData>?>? loadForeCastByCityName({
    required String cityName,
  }) async {
    try {
      final weatherForecastData =
          await _openWeather.fiveDaysWeatherForecastByCityName(
        cityName: cityName,
        weatherUnits: WeatherUnits.METRIC,
      );

      return weatherForecastData.forecastData.toList();
    } catch (e) {
      error = e.toString();
      return null;
    }
  }

  List<WeatherData>? _fiveDaysForCast;
  List<WeatherData>? get fiveDaysForCast => _fiveDaysForCast;
  List<WeatherData> get todayForeCast {
    if (_fiveDaysForCast == null) return [];

    final foreCast = _fiveDaysForCast!;
    final nowIndex = DateTime.now().weekday - 1;

    final fDf = foreCast
        .where(
          (e) => e.getWD() == WeekDay.values[nowIndex],
        )
        .toList();

    return fDf;
  }

  List<WeatherData> get notTodayFullForecast {
    if (_fiveDaysForCast == null) return [];

    final foreCast = _fiveDaysForCast!;
    final nowIndex = DateTime.now().weekday - 1;

    final fDf = foreCast
        .where(
          (e) => e.getWD() != WeekDay.values[nowIndex],
        )
        .toList();

    return fDf;
  }

  List<WeatherData>? get notTodayForecastDaily {
    if (_fiveDaysForCast == null) return null;

    List<WeatherData> value = [];

    for (var e in notTodayFullForecast) {
      if (value.none((v) => v.getWD() == e.getWD())) {
        value.add(
          WeatherData(
            details: e.details,
            temperature: Temperature(
              currentTemperature: e.temperature.currentTemperature,
              feelsLike: e.temperature.feelsLike,
              tempMin: notTodayFullForecast
                  .where(
                    (m) => m.getWD() == e.getWD(),
                  )
                  .map((e) => e.temperature.tempMin)
                  .min,
              tempMax: notTodayFullForecast
                  .where(
                    (m) => m.getWD() == e.getWD(),
                  )
                  .map((m) => m.temperature.tempMax)
                  .max,
              pressure: e.temperature.pressure,
              humidity: e.temperature.humidity,
            ),
            wind: e.wind,
            coordinates: e.coordinates,
            name: e.name,
            date: e.dailyDateTime,
          ),
        );
      }
    }

    return value;
  }
}

// TODO: Location services in Ubuntu are very unprecise, disabling for now
// if (cityName == null || _position == null) {
//   _position = await _getCurrentPosition();
//   if (position != null) {
//     _weatherData = await loadWeatherByPosition(
//       latitude: position!.latitude,
//       longitude: position!.longitude,
//     );
//     _fiveDaysForCast = await loadForeCastByPosition(
//       longitude: position!.longitude,
//       latitude: position!.latitude,
//     );
//     _cityFromPosition = await loadCityFromPosition();
//     if (_cityFromPosition != null) {
//       _locationsService.setLastLocation(_cityFromPosition);
//       _locationsService.addFavLocation(_cityFromPosition!);
//     }
//   }
// }

// Position? _position;
// Position? get position => _position;

// String? _cityFromPosition;
// String? get cityFromPosition => _cityFromPosition;

// Future<String> loadCityFromPosition() async {
//   if (position == null) {
//     return '';
//   }

//   Address address = await _geoCoder.getAddressFromLatLng(
//     latitude: _position!.latitude,
//     longitude: _position!.longitude,
//   );

//   return address.displayName;
// }

// Future<List<WeatherData>?> loadForeCastByPosition({
//   required double longitude,
//   required double latitude,
// }) async {
//   try {
//     final weatherForecastData =
//         (await _openWeather.fiveDaysWeatherForecastByLocation(
//       longitude: longitude,
//       latitude: latitude,
//       weatherUnits: WeatherUnits.METRIC,
//     ));

//     return weatherForecastData.forecastData;
//   } on Exception catch (e) {
//     error = e.toString();
//     return null;
//   }
// }

// Future<WeatherData?> loadWeatherByPosition({
//   required double latitude,
//   required double longitude,
// }) async {
//   try {
//     final weatherData = await _openWeather.currentWeatherByLocation(
//       latitude: latitude,
//       longitude: longitude,
//       weatherUnits: WeatherUnits.METRIC,
//     );
//     return weatherData;
//   } on Exception catch (e) {
//     error = e.toString();
//     return null;
//   }
// }

// Future<Position?> _getCurrentPosition() async {
//   final hasPermission = await _handlePermission();

//   if (!hasPermission) {
//     return null;
//   }

//   final position = await _geolocatorPlatform.getCurrentPosition();
//   return position;
// }

// Future<bool> _handlePermission() async {
//   bool serviceEnabled;
//   LocationPermission permission;

//   serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     return false;
//   }

//   permission = await _geolocatorPlatform.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await _geolocatorPlatform.requestPermission();
//     if (permission == LocationPermission.denied) {
//       return false;
//     }
//   }

//   if (permission == LocationPermission.deniedForever) {
//     return false;
//   }

//   return true;
// }
