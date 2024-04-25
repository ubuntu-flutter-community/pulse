import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding_resolver/geocoding_resolver.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_weather_client/open_weather.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import 'src/app/app.dart';
import 'src/app/app_model.dart';
import 'src/locations/locations_service.dart';
import 'src/weather/weather_model.dart';

Future<void> main() async {
  await YaruWindowTitleBar.ensureInitialized();
  final apiKey = await loadApiKey();
  if (apiKey != null && apiKey.isNotEmpty) {
    di.registerSingleton<OpenWeather>(OpenWeather(apiKey: apiKey));
    di.registerSingleton<GeoCoder>(GeoCoder());
    di.registerSingleton<GeolocatorPlatform>(GeolocatorPlatform.instance);
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
        locationsService: di<LocationsService>(),
        openWeather: di<OpenWeather>(),
        geoCoder: di<GeoCoder>(),
        geolocatorPlatform: di<GeolocatorPlatform>(),
      ),
      dispose: (s) => s.dispose(),
    );

    runApp(const App());
  } else {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: yaruLight,
        home: const Scaffold(
          appBar: YaruWindowTitleBar(),
          body: Center(
            child: Text('NO VALID API KEY FOUND'),
          ),
        ),
      ),
    );
  }
}

Future<String?> loadApiKey() async {
  final source = await rootBundle.loadString('assets/apikey.json');
  final json = jsonDecode(source);
  return json['apiKey'] as String;
}
