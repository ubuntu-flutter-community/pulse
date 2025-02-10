import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../constants.dart';
import '../extensions/build_context_x.dart';
import '../weather/view/city_search_field.dart';
import '../weather/weather_model.dart';

class SideBar extends StatelessWidget with WatchItMixin {
  const SideBar({super.key, this.onSelected});

  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final model = di<WeatherModel>();

    final favLocationsLength =
        watchPropertyValue((WeatherModel m) => m.favLocations.length);
    final favLocations = watchPropertyValue((WeatherModel m) => m.favLocations);
    final lastLocation = watchPropertyValue((WeatherModel m) => m.lastLocation);

    final listView = ListView.builder(
      itemCount: favLocationsLength,
      itemBuilder: (context, index) {
        final location = favLocations.elementAt(index);
        return Stack(
          alignment: Alignment.centerRight,
          children: [
            YaruMasterTile(
              onTap: () {
                model.loadWeather(cityName: location);
                onSelected?.call();
              },
              selected: lastLocation == location,
              title: Text(
                favLocations.elementAt(index),
              ),
            ),
            if (favLocationsLength > 1 && lastLocation == location)
              Positioned(
                right: 20,
                child: SizedBox.square(
                  dimension: 30,
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
                ),
              ),
          ],
        );
      },
    );

    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0.4),
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
    );
  }
}
