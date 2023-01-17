import 'dart:convert';
import 'dart:io';

import 'package:weather/app/weather_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

bool get showYaruWindowTitleBar =>
    !kIsWeb && !Platform.isAndroid && !Platform.isIOS;

Future<void> main() async {
  if (showYaruWindowTitleBar) {
    await YaruWindowTitleBar.ensureInitialized();
  }

  WidgetsFlutterBinding.ensureInitialized();

  final apiKey = await loadApiKey();

  if (apiKey != null) {
    runApp(
      MyApp(
        apiKey: apiKey,
      ),
    );
  }
}

Future<String?> loadApiKey() async {
  final source = await rootBundle.loadString('assets/apikey.json');
  final json = jsonDecode(source);
  return json['apiKey'] as String;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.apiKey});

  final String apiKey;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      theme: yaruLight,
      darkTheme: yaruDark,
      home: WeatherPage.create(context, apiKey),
    );
  }
}
