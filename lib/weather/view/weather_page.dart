import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../app/app_model.dart';
import '../../app/side_bar.dart';
import '../../constants.dart';
import '../../l10n/l10n.dart';
import '../weather_data_x.dart';
import '../weather_model.dart';
import 'daily_bar_chart.dart';
import 'hourly_line_chart.dart';

class WeatherPage extends StatelessWidget with WatchItMixin {
  const WeatherPage({super.key, this.showDrawer = false});

  final bool showDrawer;

  @override
  Widget build(BuildContext context) {
    final appModel = watchIt<AppModel>();
    final showToday = appModel.tabIndex == 0;
    final weatherType =
        watchPropertyValue((WeatherModel m) => m.data?.weatherType);

    final labelColor = weatherType == null
        ? null
        : contrastColor(WeatherUtil.getColor(weatherType).first);
    return DefaultTabController(
      initialIndex: appModel.tabIndex,
      length: 2,
      child: Scaffold(
        drawer: Platform.isMacOS ? null : const _Drawer(),
        endDrawer: Platform.isMacOS ? const _Drawer() : null,
        backgroundColor: Colors.transparent,
        appBar: YaruWindowTitleBar(
          leading: Platform.isMacOS
              ? null
              : showDrawer
                  ? const _DrawerButton()
                  : null,
          actions: [
            if (Platform.isMacOS && showDrawer)
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: _DrawerButton(),
              ),
          ],
          backgroundColor: Colors.transparent,
          border: BorderSide.none,
          title: SizedBox(
            width: kPaneWidth,
            child: YaruTabBar(
              labelColor: labelColor,
              unselectedLabelColor: labelColor?.withValues(alpha: 0.8),
              onTap: (v) => appModel.tabIndex = v,
              tabs: [
                Tab(text: context.l10n.hourly),
                Tab(text: context.l10n.daily),
              ],
            ),
          ),
        ),
        body: showToday ? const HourlyLineChart() : const DailyBarChart(),
      ),
    );
  }
}

class _DrawerButton extends StatelessWidget {
  const _DrawerButton();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Center(
          child: IconButton(
            onPressed: () {
              if (Platform.isMacOS) {
                Scaffold.of(context).openEndDrawer();
              } else {
                Scaffold.of(context).openDrawer();
              }
            },
            icon: const Icon(YaruIcons.menu),
          ),
        );
      },
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Builder(
        builder: (context) {
          return SideBar(
            onSelected: () {
              if (Platform.isMacOS) {
                Scaffold.of(context).closeEndDrawer();
              } else {
                Scaffold.of(context).closeDrawer();
              }
            },
          );
        },
      ),
    );
  }
}
