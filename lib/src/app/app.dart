import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../build_context_x.dart';
import '../../constants.dart';
import '../../weather.dart';
import '../weather/view/city_search_field.dart';
import '../weather/weather_model.dart';
import '../weather/weather_utils.dart';
import 'app_model.dart';
import 'offline_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: yaruDark,
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
    final lastLocation = di<WeatherModel>().lastLocation;
    if (lastLocation != null) {
      di<WeatherModel>().loadWeather(cityName: lastLocation);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = watchPropertyValue((AppModel m) => m.isOnline);

    final model = di<WeatherModel>();
    final mq = context.mq;
    final theme = context.theme;
    final data = watchPropertyValue((WeatherModel m) => m.data);
    final favLocationsLength =
        watchPropertyValue((WeatherModel m) => m.favLocations.length);
    final favLocations = watchPropertyValue((WeatherModel m) => m.favLocations);
    final lastLocation = watchPropertyValue((WeatherModel m) => m.lastLocation);

    final listView = ListView.builder(
      itemCount: favLocationsLength,
      itemBuilder: (context, index) {
        final location = favLocations.elementAt(index);
        return YaruMasterTile(
          onTap: () => model.loadWeather(cityName: location),
          selected: lastLocation == location,
          title: Text(
            favLocations.elementAt(index),
          ),
          trailing: favLocationsLength > 1
              ? Center(
                  widthFactor: 0.1,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      model.removeFavLocation(location).then(
                            (value) => model.loadWeather(
                              cityName: favLocations.lastOrNull,
                            ),
                          );
                    },
                    icon: const Icon(
                      YaruIcons.window_close,
                    ),
                  ),
                )
              : null,
        );
      },
    );

    return Stack(
      children: [
        if (data != null)
          Opacity(
            opacity: 0.6,
            child: WeatherBg(
              weatherType: getWeatherType(data),
              width: mq.size.width,
              height: mq.size.height,
            ),
          ),
        Row(
          children: [
            Material(
              color: theme.colorScheme.surface.withOpacity(0.4),
              child: SizedBox(
                width: kPaneWidth,
                child: Column(
                  children: [
                    const YaruDialogTitleBar(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(kYaruContainerRadius),
                        ),
                      ),
                      backgroundColor: Colors.transparent,
                      border: BorderSide.none,
                      style: YaruTitleBarStyle.undecorated,
                      title: CitySearchField(),
                    ),
                    Expanded(child: listView),
                  ],
                ),
              ),
            ),
            Expanded(
              child: !isOnline ? const OfflinePage() : const WeatherPage(),
            ),
          ],
        ),
      ],
    );
  }
}
