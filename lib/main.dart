import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:open_weather_client/open_weather.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import 'src/app/app.dart';
import 'src/app/app_model.dart';
import 'src/locations/locations_service.dart';
import 'src/weather/weather_model.dart';

Future<void> main() async {
  await YaruWindowTitleBar.ensureInitialized();

  final locationsService = LocationsService();
  await locationsService.init();
  di.registerSingleton<LocationsService>(
    locationsService,
    dispose: (s) => s.dispose(),
  );
  final appModel = AppModel(connectivity: Connectivity());
  await appModel.init();
  di.registerSingleton(appModel);

  di.registerLazySingleton(
    () => WeatherModel(
      locationsService: locationsService,
      openWeather: OpenWeather(apiKey: locationsService.apiKey ?? ''),
    ),
    dispose: (s) => s.dispose(),
  );

  runApp(const App());
}
