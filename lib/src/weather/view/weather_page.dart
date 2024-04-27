import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/widgets.dart';

import '../../../constants.dart';
import '../../app/app_model.dart';
import 'forecast_chart.dart';
import 'today_chart.dart';

class WeatherPage extends StatelessWidget with WatchItMixin {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appModel = watchIt<AppModel>();
    final showToday = appModel.tabIndex == 0;

    return DefaultTabController(
      initialIndex: appModel.tabIndex,
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: YaruWindowTitleBar(
          leading:
              Navigator.of(context).canPop() ? const YaruBackButton() : null,
          backgroundColor: Colors.transparent,
          border: BorderSide.none,
          title: SizedBox(
            width: kPaneWidth,
            child: YaruTabBar(
              onTap: (v) => appModel.tabIndex = v,
              tabs: const [
                Tab(text: 'Hourly'),
                Tab(text: 'Daily'),
              ],
            ),
          ),
        ),
        body: showToday ? const TodayChart() : const ForeCastChart(),
      ),
    );
  }
}
