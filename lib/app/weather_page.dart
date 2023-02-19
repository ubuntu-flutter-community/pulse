import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather/app/city_search_field.dart';
import 'package:weather/app/weather_model.dart';
import 'package:weather/app/weather_tile.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

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

    var foreCastTiles = model.forecast.isEmpty
        ? <Widget>[]
        : [
            for (int i = 0; i < model.forecast.length; i++)
              WeatherTile(
                height: 200,
                padding: const EdgeInsets.only(bottom: 20),
                day: DateFormat('EEEE').format(
                  DateTime.now().add(
                    Duration(days: i),
                  ),
                ),
                isForeCastTile: true,
                data: model.forecast.elementAt(i),
                fontSize: 15,
              )
          ];
    final scaffold = Scaffold(
      appBar: !Platform.isAndroid && !Platform.isIOS
          ? YaruWindowTitleBar(
              leading: locationButton,
              title: const CitySearchField(
                underline: false,
              ),
            )
          : AppBar(
              leading: locationButton,
              toolbarHeight: kToolbarHeight,
              title: const CitySearchField(
                underline: true,
              ),
            ),
      body: model.initializing == true
          ? const Center(
              child: YaruCircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
              child: SizedBox(
                // height: size.height,
                child: OrientationBuilder(
                  builder: (context, orientation) {
                    var column = ListView(
                      children: [
                        WeatherTile(
                          padding: const EdgeInsets.only(bottom: 20),
                          day: 'Now',
                          height: 300,
                          position: model.position,
                          data: model.data,
                          fontSize: 20,
                          cityName: model.cityName,
                        ),
                        ...foreCastTiles
                      ],
                    );

                    var row = Row(
                      children: [
                        WeatherTile(
                          padding: const EdgeInsets.only(
                            bottom: 20,
                          ),
                          day: 'Now',
                          width: 500,
                          position: model.position,
                          data: model.data,
                          fontSize: 20,
                          cityName: model.cityName,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: ListView(
                            children: foreCastTiles,
                          ),
                        )
                      ],
                    );
                    return orientation == Orientation.portrait ? column : row;
                  },
                ),
              ),
            ),
    );
    if (Platform.isAndroid || Platform.isIOS) {
      return SafeArea(child: scaffold);
    }
    return scaffold;
  }
}
