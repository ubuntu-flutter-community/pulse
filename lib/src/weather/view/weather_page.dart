import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/constants.dart';
import 'package:yaru/widgets.dart';

import '../../build_context_x.dart';
import '../../../constants.dart';
import '../../app/app_model.dart';
import 'forecast_chart.dart';
import 'today_tile.dart';
import '../weather_model.dart';

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
                                  padding: kPagePadding,
                                  child: TodayTile(
                                    width: mq.size.width -
                                        kPaneWidth -
                                        2 * kYaruPagePadding,
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
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
