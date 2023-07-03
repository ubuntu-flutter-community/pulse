import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/app/city_search_field.dart';
import 'package:weather/app/weather_model.dart';
import 'package:weather/app/weather_tile.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<WeatherModel>();

    final locationButton = Center(
      child: SizedBox(
        height: 35,
        width: 35,
        child: YaruIconButton(
          icon: const Icon(
            Icons.location_on,
            size: 16,
          ),
          onPressed: () => model.init(cityName: null),
        ),
      ),
    );

    var foreCastTiles = model.forecast.isEmpty
        ? <Widget>[]
        : [
            for (int i = 0; i < model.forecast.length; i++)
              WeatherTile(
                height: 200,
                padding: const EdgeInsets.only(bottom: 20),
                day: model.forecast[i].getDate(context),
                time: model.forecast[i].getTime(context),
                isForeCastTile: true,
                data: model.forecast.elementAt(i),
                fontSize: 15,
              )
          ];
    final scaffold = Scaffold(
      backgroundColor: model.data.color.withOpacity(0.1),
      appBar: YaruWindowTitleBar(
        backgroundColor: Colors.transparent,
        border: BorderSide.none,
        leading: locationButton,
        title: const SizedBox(
          width: 300,
          child: CitySearchField(),
        ),
      ),
      body: model.initializing == true
          ? const Center(
              child: YaruCircularProgressIndicator(),
            )
          : SizedBox(
              // height: size.height,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  var column = ListView(
                    padding:
                        const EdgeInsets.only(top: 10, right: 20, left: 20),
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

                  var row = Padding(
                    padding:
                        const EdgeInsets.only(top: 20, right: 20, left: 20),
                    child: Row(
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
                    ),
                  );
                  return constraints.maxWidth < 1000 ? column : row;
                },
              ),
            ),
    );

    return scaffold;
  }
}
