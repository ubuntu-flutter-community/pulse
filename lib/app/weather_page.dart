import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse/app/city_search_field.dart';
import 'package:pulse/app/forecast_tile.dart';
import 'package:pulse/app/today_tile.dart';
import 'package:pulse/app/utils.dart';
import 'package:pulse/app/weather_model.dart';
import 'package:pulse/weather_data_x.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<WeatherModel>();
    final mq = MediaQuery.of(context);
    final theme = Theme.of(context);
    final light = theme.brightness == Brightness.light;

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

    var foreCastTiles = [
      if (model.todayForeCast().isNotEmpty == true)
        for (final todayForecast in model.todayForeCast())
          ForecastTile(
            width: mq.size.width - 40,
            height: 200,
            padding: const EdgeInsets.only(bottom: 20),
            day: todayForecast.getDate(context),
            time: todayForecast.getTime(context),
            data: todayForecast,
            fontSize: 15,
          ),
      if (model.notTodayForeCast().isNotEmpty == true)
        for (final todayForecast in model.notTodayForeCast())
          ForecastTile(
            width: mq.size.width - 40,
            height: 200,
            padding: const EdgeInsets.only(bottom: 20),
            day: todayForecast.getDate(context),
            time: todayForecast.getTime(context),
            data: todayForecast,
            fontSize: 15,
          )
    ];
    final scaffold = Scaffold(
      backgroundColor: model.data == null
          ? null
          : getColor(model.data!).withOpacity(light ? 0.1 : 0.05),
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
          : model.data == null
              ? Center(
                  child: model.error != null
                      ? Text(model.error!)
                      : const SizedBox.shrink(),
                )
              : SizedBox(
                  // height: size.height,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      var column = ListView(
                        padding:
                            const EdgeInsets.only(top: 10, right: 20, left: 20),
                        children: [
                          TodayTile(
                            width: mq.size.width - 40,
                            padding: const EdgeInsets.only(bottom: 20),
                            day: 'Now',
                            height: 300,
                            position: model.position,
                            data: model.data!,
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
                            TodayTile(
                              padding: const EdgeInsets.only(
                                bottom: 20,
                              ),
                              day: 'Now',
                              width: 500,
                              height: mq.size.height - 40,
                              position: model.position,
                              data: model.data!,
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
