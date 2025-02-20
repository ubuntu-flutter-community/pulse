import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:open_weather_client/open_weather.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

import 'app/app_model.dart';
import 'locations/locations_service.dart';
import 'settings/settings_service.dart';
import 'weather/weather_model.dart';

void registerDependencies() {
  di
    ..registerSingletonAsync<FlutterSecureStorage>(
      () async {
        const flutterSecureStorage = FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        );

        const apiKey = String.fromEnvironment('API_KEY', defaultValue: '');

        if (apiKey.trim().isNotEmpty) {
          flutterSecureStorage.write(key: SettingKeys.apiKey, value: apiKey);
        }
        return flutterSecureStorage;
      },
    )
    ..registerSingletonAsync<SharedPreferences>(
      () async => SharedPreferences.getInstance(),
    )
    ..registerSingletonWithDependencies<SettingsService>(
      () => SettingsService(
        sharedPreferences: di<SharedPreferences>(),
        flutterSecureStorage: di<FlutterSecureStorage>(),
      ),
      dependsOn: [FlutterSecureStorage, SharedPreferences],
      dispose: (s) => s.dispose(),
    )
    ..registerSingletonWithDependencies<LocationsService>(
      () => LocationsService(
        settingsService: di<SettingsService>(),
      ),
      dependsOn: [SettingsService],
    )
    ..registerSingletonAsync<OpenWeather>(
      () async => OpenWeather(
        apiKey:
            await di<FlutterSecureStorage>().read(key: SettingKeys.apiKey) ??
                '',
      ),
      dependsOn: [SettingsService],
    )
    ..registerSingletonWithDependencies(
      () => WeatherModel(
        settingsService: di<SettingsService>(),
        locationsService: di<LocationsService>(),
        openWeather: di<OpenWeather>(),
      ),
      dependsOn: [OpenWeather, SettingsService],
      dispose: (s) => s.dispose(),
    )
    ..registerLazySingleton(AppModel.new);
}
