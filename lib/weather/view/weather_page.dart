import 'dart:io';

import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../constants.dart';
import '../../app/app_model.dart';
import '../../app/side_bar.dart';
import '../../l10n/l10n.dart';
import 'daily_bar_chart.dart';
import 'hourly_line_chart.dart';

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
