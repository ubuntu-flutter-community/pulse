import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../weather.dart';
import '../weather/view/city_search_field.dart';
import '../weather/weather_model.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      theme: yaruLight,
      darkTheme: yaruDark,
      home: const MasterDetailPage(),
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

class MasterDetailPage extends StatelessWidget with WatchItMixin {
  const MasterDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = di<WeatherModel>();
    final favLocationsLength =
        watchPropertyValue((WeatherModel m) => m.favLocations.length);
    final favLocations = watchPropertyValue((WeatherModel m) => m.favLocations);
    final lastLocation = watchPropertyValue((WeatherModel m) => m.lastLocation);
    return YaruMasterDetailPage(
      controller: YaruPageController(
        length: favLocationsLength == 0 ? 1 : favLocationsLength,
      ),
      tileBuilder: (context, index, selected, availableWidth) {
        final location = favLocations.elementAt(index);
        return YaruMasterTile(
          // TODO: assign pages to location
          onTap: () => model.init(cityName: location),
          selected: lastLocation == location,
          title: Text(
            favLocations.elementAt(index),
          ),
          trailing: favLocationsLength > 1
              ? IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    model.removeFavLocation(location).then(
                          (value) => model.init(
                            cityName: favLocations.lastOrNull,
                          ),
                        );
                  },
                  icon: const Icon(
                    YaruIcons.window_close,
                  ),
                )
              : null,
        );
      },
      pageBuilder: (context, index) {
        return const WeatherPage();
      },
      appBar: YaruDialogTitleBar(
        backgroundColor: YaruMasterDetailTheme.of(context).sideBarColor,
        border: BorderSide.none,
        style: YaruTitleBarStyle.undecorated,
        leading: Center(
          child: YaruIconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.location_on,
              size: 16,
            ),
            onPressed: () => model.init(cityName: null),
          ),
        ),
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.only(right: 15),
          child: CitySearchField(),
        ),
      ),
    );
  }
}
