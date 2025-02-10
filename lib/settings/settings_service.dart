import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  SettingsService({
    required SharedPreferences sharedPreferences,
    required FlutterSecureStorage flutterSecureStorage,
  })  : _preferences = sharedPreferences,
        _flutterSecureStorage = flutterSecureStorage;

  final SharedPreferences _preferences;
  final FlutterSecureStorage _flutterSecureStorage;
  final _propertiesChangedController = StreamController<bool>.broadcast();
  Stream<bool> get propertiesChanged => _propertiesChangedController.stream;
  void notify(bool saved) {
    if (saved) _propertiesChangedController.add(true);
  }

  String? getString({required String key}) => _preferences.getString(key);
  Future<String?> getStringSecure({required String key}) =>
      _flutterSecureStorage.read(key: key);
  void setString({
    required String key,
    required String value,
    bool secure = false,
  }) =>
      secure
          ? _flutterSecureStorage
              .write(key: key, value: value)
              .then((_) => _propertiesChangedController.add(true))
          : _preferences.setString(key, value).then(notify);

  List<String>? getStrings({required String key}) =>
      _preferences.getStringList(key);
  void setStrings({required String key, required List<String> value}) =>
      _preferences.setStringList(key, value).then(notify);

  Future<void> dispose() async => _propertiesChangedController.close();
}

class SettingKeys {
  static const String apiKey = 'apiKey';
  static const favoriteLocations = 'favoriteLocations';
  static const lastLocation = 'lastLocation';
}
