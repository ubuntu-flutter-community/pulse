import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/widgets.dart';

import '../../app/app_model.dart';
import '../../build_context_x.dart';
import '../weather_model.dart';
import 'forecast_chart.dart';
import 'today_chart.dart';

class WeatherPage extends StatelessWidget with WatchItMixin {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final initializing = watchPropertyValue((WeatherModel m) => m.initializing);

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
                  : Column(
                      children: [
                        if (showToday)
                          Expanded(
                            child: SizedBox(
                              width: context.mq.size.width,
                              child: const TodayChart(),
                            ),
                          ),
                        if (!showToday) const ForeCastChart(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
