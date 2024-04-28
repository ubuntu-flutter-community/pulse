import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../constants.dart';
import '../../weather.dart';
import '../weather/weather_model.dart';
import 'app_model.dart';
import 'offline_page.dart';
import 'side_bar.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppTitle,
      debugShowCheckedModeBanner: false,
      theme: yaruLight,
      darkTheme: yaruDark.copyWith(
        tabBarTheme: TabBarTheme.of(context).copyWith(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(
            0.8,
          ),
        ),
      ),
      home: const AppPage(),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
          PointerDeviceKind.trackpad,
        },
      ),
    );
  }
}

class AppPage extends StatefulWidget with WatchItStatefulWidgetMixin {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  @override
  void initState() {
    di<WeatherModel>().loadWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = watchPropertyValue((AppModel m) => m.isOnline);

    final weatherType = watchPropertyValue((WeatherModel m) => m.weatherType);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Opacity(
              opacity: 0.7,
              child: WeatherBg(
                weatherType: weatherType,
                width: constraints.maxWidth,
                height: constraints.maxHeight,
              ),
            ),
            Row(
              children: [
                if (constraints.maxWidth > kBreakPoint) const SideBar(),
                Expanded(
                  child: !isOnline
                      ? const OfflinePage()
                      : WeatherPage(
                          showDrawer: constraints.maxWidth < kBreakPoint,
                        ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
