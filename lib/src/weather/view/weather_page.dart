import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../constants.dart';
import '../../app/app_model.dart';
import '../../app/side_bar.dart';
import '../../l10n/l10n.dart';
import 'forecast_chart.dart';
import 'today_chart.dart';

class WeatherPage extends StatelessWidget with WatchItMixin {
  const WeatherPage({super.key, this.showDrawer = false});

  final bool showDrawer;

  @override
  Widget build(BuildContext context) {
    final appModel = watchIt<AppModel>();
    final showToday = appModel.tabIndex == 0;

    return DefaultTabController(
      initialIndex: appModel.tabIndex,
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: Builder(
            builder: (context) {
              return SideBar(
                onSelected: () => Scaffold.of(context).closeDrawer(),
              );
            },
          ),
        ),
        backgroundColor: Colors.transparent,
        appBar: YaruWindowTitleBar(
          leading: showDrawer
              ? Builder(
                  builder: (context) {
                    return Center(
                      child: IconButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: const Icon(YaruIcons.menu),
                      ),
                    );
                  },
                )
              : null,
          backgroundColor: Colors.transparent,
          border: BorderSide.none,
          title: SizedBox(
            width: kPaneWidth,
            child: YaruTabBar(
              onTap: (v) => appModel.tabIndex = v,
              tabs: [
                Tab(text: context.l10n.hourly),
                Tab(text: context.l10n.daily),
              ],
            ),
          ),
        ),
        body: showToday ? const TodayChart() : const ForeCastChart(),
      ),
    );
  }
}
