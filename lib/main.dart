import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weather/app/weather_model.dart';
import 'package:weather/app/weather_page.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

Future<void> main() async {
  await YaruWindowTitleBar.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();

  final apiKey = await loadApiKey();

  if (apiKey != null) {
    runApp(
      MyApp.create(
        apiKey,
      ),
    );
  }
}

Future<String?> loadApiKey() async {
  final source = await rootBundle.loadString('assets/apikey.json');
  final json = jsonDecode(source);
  return json['apiKey'] as String;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.apiKey});

  final String apiKey;

  static Widget create(String apiKey) {
    return ChangeNotifierProvider<WeatherModel>(
      create: (context) => WeatherModel(apiKey)..init(),
      child: MyApp(apiKey: apiKey),
    );
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      theme: yaruLight,
      darkTheme: yaruDark,
      home: const WeatherPage(),
    );
  }
}
