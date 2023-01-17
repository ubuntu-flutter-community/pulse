import 'dart:io';

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

    var scaffold = Scaffold(
      appBar: !showYaruWindowTitleBar
          ? AppBar(
              leading: const YaruIconButton(icon: Icon(Icons.location_on)),
              titleSpacing: 0,
              toolbarHeight: 44,
              title: const CitySearchField(
                underline: true,
              ),
            )
          : YaruWindowTitleBar(
              leading: Center(
                child: YaruIconButton(
                  icon: const Icon(Icons.location_on),
                  style: IconButton.styleFrom(fixedSize: const Size(40, 40)),
                  onPressed: () => model.init(cityName: null),
                ),
              ),
              title: const CitySearchField(
                underline: false,
              ),
            ),
      body: model.initializing == true
          ? const Center(
              child: YaruCircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: WeatherTile(
                    position: model.position,
                    data: model.data,
                    fontSize: 15,
                    cityName: model.cityName,
                  ),
                ),
                Center(
                  child: Text(
                    'Five days forecast',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: model.fiveDaysForCast
                              ?.map(
                                (e) => Expanded(
                                  child: WeatherTile(
                                    count: 5,
                                    data: FormattedWeatherData(e),
                                    fontSize: 15,
                                  ),
                                ),
                              )
                              .toList() ??
                          <Icon>[],
                    ),
                  ),
                )
              ],
            ),
    );

    return Platform.isLinux
        ? scaffold
        : SafeArea(
            child: scaffold,
          );
  }
}
