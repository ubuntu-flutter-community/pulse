import 'package:flutter/material.dart';
import 'package:open_weather_client/models/weather_data.dart';
import 'view/city_search_field.dart';
import 'view/forecast_tile.dart';
import 'view/today_tile.dart';
import 'utils.dart';
import 'weather_model.dart';
import 'weather_data_x.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/widgets.dart';

class WeatherPage extends StatelessWidget with WatchItMixin {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = watchIt<WeatherModel>();
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
            selectedData: todayForecast,
            data: const [],
            fontSize: 15,
          ),
      if (model.notTodayForeCast.isNotEmpty == true)
        for (int i = 0; i < model.notTodayForeCast.length; i++)
          ForecastTile(
            width: mq.size.width - 40,
            height: 200,
            padding: const EdgeInsets.only(bottom: 20),
            day: model.notTodayForeCast[i].getDate(context),
            time: model.notTodayForeCast[i].getTime(context),
            selectedData: model.notTodayForeCast[i],
            data: const [],
            fontSize: 15,
            // borderRadius: getBorderRadius(i, model.notTodayForeCast),
          ),
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
                            position: model.cityFromPosition,
                            data: model.data!,
                            fontSize: 20,
                            cityName: model.cityName,
                          ),
                          ...foreCastTiles,
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
                              position: model.cityFromPosition,
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
                            ),
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

  BorderRadius getBorderRadius(int i, List<WeatherData> data) {
    const radius = Radius.circular(10);
    if (i < data.length - 1 && data.length > 1) {
      if (i == 0) {
        return const BorderRadius.only(topLeft: radius, topRight: radius);
      }
      if (i >= 1) {
        if (data[i].getWD() == data[i + 1].getWD() &&
            data[i].getWD() == data[i - 1].getWD()) {
          return BorderRadius.zero;
        } else if (data[i].getWD() == data[i + 1].getWD()) {
          return const BorderRadius.only(topLeft: radius, topRight: radius);
        } else if (data[i].getWD() == data[i - 1].getWD()) {
          return const BorderRadius.only(
            bottomLeft: radius,
            bottomRight: radius,
          );
        }
      }
    }

    return BorderRadius.circular(10);
  }

  EdgeInsets getPadding(int i, List<WeatherData> data) {
    const value = 20.0;

    if (i == data.length - 1) {
      return const EdgeInsets.only(bottom: value);
    } else if (i == 0) {
      return const EdgeInsets.only(top: 10);
    }

    if (i < data.length - 1 && i >= 1) {
      if (data[i].getWD() == data[i + 1].getWD() &&
          data[i].getWD() == data[i - 1].getWD()) {
        return EdgeInsets.zero;
      } else if (data[i].getWD() == data[i + 1].getWD()) {
        return const EdgeInsets.only(top: value);
      } else if (data[i].getWD() == data[i - 1].getWD()) {
        return const EdgeInsets.only(bottom: value);
      }
    }

    return EdgeInsets.zero;
  }
}
