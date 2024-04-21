import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding_resolver/geocoding_resolver.dart';
import 'package:open_weather_client/open_weather.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/theme.dart';
import 'package:yaru/yaru.dart';

import 'src/app/app.dart';
import 'src/weather/weather_model.dart';

Future<void> main() async {
  await YaruWindowTitleBar.ensureInitialized();
  final apiKey = await loadApiKey();
  if (apiKey != null && apiKey.isNotEmpty) {
    di.registerSingleton(OpenWeather(apiKey: apiKey));
    di.registerSingleton(GeoCoder());
    final weatherModel =
        WeatherModel(openWeather: di<OpenWeather>(), geoCoder: di<GeoCoder>());
    await weatherModel.init();
    di.registerSingleton(weatherModel);

    runApp(const App());
  } else {
    runApp(MaterialApp(
      theme: yaruLight,
      home: const Scaffold(
        body: Center(
          child: Text('NO VALI API KEY FOUND'),
        ),
      ),
    ));
  }
}

Future<String?> loadApiKey() async {
  final source = await rootBundle.loadString('assets/apikey.json');
  final json = jsonDecode(source);
  return json['apiKey'] as String;
}
