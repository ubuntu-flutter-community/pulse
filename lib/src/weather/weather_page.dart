import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/constants.dart';
import 'package:yaru/widgets.dart';

import '../build_context_x.dart';
import '../../constants.dart';
import '../app/app_model.dart';
import 'view/forecast_chart.dart';
import 'view/forecast_tile.dart';
import 'view/today_tile.dart';
import 'weather_data_x.dart';
import 'weather_model.dart';

class WeatherPage extends StatelessWidget with WatchItMixin {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = context.mq;
    final theme = context.theme;
    final data = watchPropertyValue((WeatherModel m) => m.data);
    final initializing = watchPropertyValue((WeatherModel m) => m.initializing);
    final error = watchPropertyValue((WeatherModel m) => m.error);
    final cityFromPosition =
        watchPropertyValue((WeatherModel m) => m.cityFromPosition);
    final cityName = watchPropertyValue((WeatherModel m) => m.cityName);
    final todayForeCast =
        watchPropertyValue((WeatherModel m) => m.todayForeCast);
    final notTodayForeCast =
        watchPropertyValue((WeatherModel m) => m.notTodayForecastDaily);
    final appModel = watchIt<AppModel>();
    final showToday = appModel.tabIndex == 0;

    return DefaultTabController(
      initialIndex: appModel.tabIndex,
      length: 2,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: YaruWindowTitleBar(
                leading: Navigator.of(context).canPop()
                    ? const YaruBackButton()
                    : null,
                backgroundColor: Colors.transparent,
                border: BorderSide.none,
                title: SizedBox(
                  width: 230,
                  child: YaruTabBar(
                    onTap: (v) => appModel.tabIndex = v,
                    tabs: const [
                      Tab(
                        text: 'Today',
                      ),
                      Tab(
                        text: 'Forecast',
                      ),
                    ],
                  ),
                ),
              ),
              body: initializing == true
                  ? Center(
                      child: YaruCircularProgressIndicator(
                        color: theme.colorScheme.onSurface,
                        strokeWidth: 3,
                      ),
                    )
                  : data == null
                      ? Center(
                          child: error != null
                              ? Text(error)
                              : const SizedBox.shrink(),
                        )
                      : Column(
                          children: [
                            if (showToday)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: TodayTile(
                                    width: mq.size.width -
                                        kPaneWidth -
                                        2 * kYaruPagePadding,
                                    padding:
                                        const EdgeInsets.all(kYaruPagePadding),
                                    day: 'Now',
                                    height: mq.size.height,
                                    position: cityFromPosition,
                                    data: data,
                                    fontSize: 20,
                                    cityName: cityName,
                                  ),
                                ),
                              ),
                            if (!showToday)
                              ForeCastChart(
                                data: notTodayForeCast,
                              ),
                            if (showToday)
                              SizedBox(
                                height: showToday
                                    ? 300
                                    : mq.size.height - kYaruPagePadding * 3,
                                width: mq.size.width,
                                child: ListView.builder(
                                  itemCount: showToday
                                      ? todayForeCast.length
                                      : notTodayForeCast.length,
                                  padding: const EdgeInsetsDirectional.all(
                                    kYaruPagePadding,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    if (showToday) {
                                      return ForecastTile(
                                        width: 300,
                                        height: 400,
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        day: todayForeCast[index]
                                            .getDate(context),
                                        time: todayForeCast[index]
                                            .getTime(context),
                                        data: todayForeCast[index],
                                        fontSize: 15,
                                      );
                                    }
                                    return ForecastTile(
                                      width: 300,
                                      height: mq.size.height,
                                      padding: const EdgeInsets.only(right: 20),
                                      day: notTodayForeCast[index]
                                          .getDate(context),
                                      time: notTodayForeCast[index]
                                          .getTime(context),
                                      data: notTodayForeCast[index],
                                      fontSize: 15,
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

/* var foreCastTiles = [
  if (todayForeCast().isNotEmpty == true)
    for (final todayForecast in todayForeCast())
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
  if (notTodayForeCast.isNotEmpty == true)
    for (int i = 0; i < notTodayForeCast.length; i++)
      ForecastTile(
        width: mq.size.width - 40,
        height: 200,
        padding: const EdgeInsets.only(bottom: 20),
        day: notTodayForeCast[i].getDate(context),
        time: notTodayForeCast[i].getTime(context),
        selectedData: notTodayForeCast[i],
        data: const [],
        fontSize: 15,
        // borderRadius: getBorderRadius(i, notTodayForeCast),
      ),
] */
