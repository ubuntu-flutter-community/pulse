import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather/app/city_search_field.dart';
import 'package:weather/app/weather_model.dart';
import 'package:weather/app/weather_tile.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

bool get showYaruWindowTitleBar =>
    !kIsWeb && !Platform.isAndroid && !Platform.isIOS;

bool get isDesktop =>
    Platform.isLinux || Platform.isMacOS || Platform.isWindows;

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
    final size = MediaQuery.of(context).size;
    final model = context.watch<WeatherModel>();

    final locationButton = Center(
      child: YaruIconButton(
        icon: const Icon(Icons.location_on),
        style: IconButton.styleFrom(fixedSize: const Size(40, 40)),
        onPressed: () => model.init(cityName: null),
      ),
    );

    var foreCastTiles = Expanded(
      child: Column(
        children: model.forecast.isEmpty
            ? []
            : [
                for (int i = 0; i < model.forecast.length; i++)
                  Expanded(
                    child: WeatherTile(
                      padding: EdgeInsets.only(bottom: isDesktop ? 20 : 8),
                      widthFactor: 1,
                      day: DateFormat('EEEE').format(
                        DateTime.now().add(
                          Duration(days: i),
                        ),
                      ),
                      foreCast: true,
                      count: 5,
                      data: model.forecast.elementAt(i),
                      fontSize: isDesktop ? 15 : 10,
                    ),
                  )
              ],
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
          : Padding(
              padding: isDesktop
                  ? const EdgeInsets.only(top: 20, right: 20, left: 20)
                  : const EdgeInsets.only(top: 5, right: 5, left: 5),
              child: SizedBox(
                height: size.height,
                child: OrientationBuilder(
                  builder: (context, orientation) {
                    return orientation == Orientation.portrait
                        ? Column(
                            children: [
                              WeatherTile(
                                padding:
                                    EdgeInsets.only(bottom: isDesktop ? 20 : 8),
                                widthFactor: 1,
                                day: 'Now',
                                height: 250,
                                position: model.position,
                                data: model.data,
                                fontSize: 20,
                                cityName: model.cityName,
                              ),
                              foreCastTiles
                            ],
                          )
                        : Row(
                            children: [
                              WeatherTile(
                                padding:
                                    EdgeInsets.only(bottom: isDesktop ? 20 : 8),
                                widthFactor: 1,
                                day: 'Now',
                                width: size.width / 2,
                                position: model.position,
                                data: model.data,
                                fontSize: 20,
                                cityName: model.cityName,
                              ),
                              SizedBox(
                                width: isDesktop ? 20 : 8,
                              ),
                              foreCastTiles
                            ],
                          );
                  },
                ),
              ),
            ),
    );

    return isDesktop
        ? scaffold
        : SafeArea(
            child: scaffold,
          );
  }
}
