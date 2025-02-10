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
    ..registerSingleton<FlutterSecureStorage>(
      const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      ),
    )
    ..registerSingletonAsync<SharedPreferences>(
      () async => SharedPreferences.getInstance(),
    )
    ..registerSingletonWithDependencies<SettingsService>(
      () => SettingsService(
        sharedPreferences: di<SharedPreferences>(),
        flutterSecureStorage: di<FlutterSecureStorage>(),
      ),
      dependsOn: [SharedPreferences],
      dispose: (s) => s.dispose(),
    )
    ..registerSingletonAsync<LocationsService>(
      () async {
        final locationsService = LocationsService(
          settingsService: di<SettingsService>(),
        );
        await locationsService.init();
        return locationsService;
      },
      dependsOn: [SettingsService],
    )
    ..registerSingletonAsync<OpenWeather>(
      () async {
        final apiKey = (await di<SettingsService>()
                .getStringSecure(key: SettingKeys.apiKey)) ??
            '';
        return OpenWeather(apiKey: apiKey);
      },
      dependsOn: [SettingsService],
    )
    ..registerSingletonWithDependencies(
      () => WeatherModel(
        locationsService: di<LocationsService>(),
        openWeather: di<OpenWeather>(),
      ),
      dependsOn: [OpenWeather],
      dispose: (s) => s.dispose(),
    )
    ..registerLazySingleton(AppModel.new);
}
