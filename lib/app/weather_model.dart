import 'package:geolocator/geolocator.dart';
import 'package:open_weather_client/open_weather.dart';
import 'package:pulse/weather_data_x.dart';
import 'package:pulse/weekday.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

class WeatherModel extends SafeChangeNotifier {
  WeatherModel(String apiKey) : _openWeather = OpenWeather(apiKey: apiKey);

  final OpenWeather _openWeather;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  Position? _position;
  Position? get position => _position;

  WeatherData? _weatherData;
  WeatherData? get data => _weatherData;

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
    } catch (e) {
      error = e.toString();
      return null;
    }
  }

  List<WeatherData>? _fiveDaysForCast;
  List<WeatherData> todayForeCast() {
    if (_fiveDaysForCast == null) return [];

    final foreCast = _fiveDaysForCast!;

    final nowIndex = DateTime.now().weekday - 1;

    final fDf = foreCast
        .where(
          (e) => e.getWD(e.date) == WeekDay.values[nowIndex],
        )
        .toList();

    return fDf;
  }

  List<WeatherData> notTodayForeCast() {
    if (_fiveDaysForCast == null) return [];

    final foreCast = _fiveDaysForCast!;

    final nowIndex = DateTime.now().weekday - 1;

    final fDf = foreCast
        .where(
          (e) => e.getWD(e.date) != WeekDay.values[nowIndex],
        )
        .toList();

    return fDf;
  }

  List<WeatherData> get forecast =>
      _fiveDaysForCast == null ? [] : _fiveDaysForCast!;

  List<WeatherData>? get fiveDaysForCast => _fiveDaysForCast;
  set fiveDaysForCast(List<WeatherData>? value) {
    if (value == null || value.isEmpty) return;
    _fiveDaysForCast = value;
    notifyListeners();
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
    } on Exception catch (_) {
      return null;
    }
  }

  Future<List<WeatherData>?> loadForeCastByPosition({
    required double longitude,
    required double latitude,
  }) async {
    try {
      final weatherForecastData =
          (await _openWeather.fiveDaysWeatherForecastByLocation(
        longitude: longitude,
        latitude: latitude,
        weatherUnits: WeatherUnits.METRIC,
      ));

      return weatherForecastData.forecastData;
    } on Exception catch (e) {
      error = e.toString();
      return null;
    }
  }

  String? _error;
  String? get error => _error;
  set error(String? value) {
    _error = value;
    notifyListeners();
  }

  Future<WeatherData?> loadWeatherByPosition({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final weatherData = await _openWeather.currentWeatherByLocation(
        latitude: latitude,
        longitude: longitude,
        weatherUnits: WeatherUnits.METRIC,
      );
      return weatherData;
    } on Exception catch (e) {
      error = e.toString();
      return null;
    }
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
