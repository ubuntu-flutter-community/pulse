import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/constants.dart';
import 'package:yaru/widgets.dart';

import '../../build_context_x.dart';
import 'view/forecast_tile.dart';
import 'view/today_tile.dart';
import 'weather_data_x.dart';
import 'weather_model.dart';
import 'weather_utils.dart';

class WeatherPage extends StatelessWidget with WatchItMixin {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = watchIt<WeatherModel>();
    final mq = context.mq;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          if (model.data != null)
            Opacity(
              opacity: context.light ? 0.4 : 0.3,
              child: WeatherBg(
                weatherType: getWeatherType(model.data!),
                width: mq.size.width,
                height: mq.size.height,
              ),
            ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: const YaruWindowTitleBar(
              backgroundColor: Colors.transparent,
              border: BorderSide.none,
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
                    : Column(
                        children: [
                          Expanded(
                            child: TodayTile(
                              width: mq.size.width,
                              padding: EdgeInsets.zero,
                              day: 'Now',
                              height: mq.size.height,
                              position: model.cityFromPosition,
                              data: model.data!,
                              fontSize: 20,
                              cityName: model.cityName,
                            ),
                          ),
                          SizedBox(
                            height: 300,
                            width: mq.size.width,
                            child: ListView(
                              padding: const EdgeInsetsDirectional.all(
                                kYaruPagePadding,
                              ),
                              scrollDirection: Axis.horizontal,
                              children: [
                                if (model.todayForeCast().isNotEmpty == true)
                                  for (final todayForecast
                                      in model.todayForeCast())
                                    ForecastTile(
                                      width: 300,
                                      height: 400,
                                      padding: const EdgeInsets.only(right: 20),
                                      day: todayForecast.getDate(context),
                                      time: todayForecast.getTime(context),
                                      selectedData: todayForecast,
                                      data: const [],
                                      fontSize: 15,
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}

/* var foreCastTiles = [
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
] */