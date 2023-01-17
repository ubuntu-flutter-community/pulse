import 'dart:io';

import 'package:open_weather_client/models/weather_data.dart';
import 'package:weather/app/city_search_field.dart';
import 'package:weather/app/weather_model.dart';
import 'package:weather/app/weather_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

bool get showYaruWindowTitleBar =>
    !kIsWeb && !Platform.isAndroid && !Platform.isIOS;

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  static Widget create(BuildContext context, String apiKey) {
    return ChangeNotifierProvider<WeatherModel>(
      create: (context) => WeatherModel(apiKey)..init(),
      child: const WeatherPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<WeatherModel>();

    final locationButton = Center(
      child: YaruIconButton(
        icon: const Icon(Icons.location_on),
        style: IconButton.styleFrom(fixedSize: const Size(40, 40)),
        onPressed: () => model.init(cityName: null),
      ),
    );

    final scaffold = Scaffold(
      appBar: !showYaruWindowTitleBar
          ? AppBar(
              leading: locationButton,
              toolbarHeight: 44,
              title: const CitySearchField(
                underline: true,
              ),
            )
          : YaruWindowTitleBar(
              leading: locationButton,
              title: const CitySearchField(
                underline: false,
              ),
            ),
      body: model.initializing == true
          ? const Center(
              child: YaruCircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: SizedBox(
                height: 1000,
                child: Column(
                  children: [
                    WeatherTile(
                      height: 250,
                      position: model.position,
                      data: model.data,
                      fontSize: 20,
                      cityName: model.cityName,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          for (final day
                              in model.fiveDaysForCast ?? <WeatherData>[])
                            Expanded(
                              child: WeatherTile(
                                foreCast: true,
                                count: 1,
                                data: FormattedWeatherData(day),
                                fontSize: 15,
                              ),
                            )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );

    return Platform.isLinux
        ? scaffold
        : SafeArea(
            child: scaffold,
          );
  }
}
