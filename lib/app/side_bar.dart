import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../constants.dart';
import '../extensions/build_context_x.dart';
import '../weather/view/city_search_field.dart';
import '../weather/weather_model.dart';

class SideBar extends StatefulWidget with WatchItStatefulWidgetMixin {
  const SideBar({super.key, this.onSelected});

  final VoidCallback? onSelected;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final favLocationsLength =
        watchPropertyValue((WeatherModel m) => m.favLocations.length);
    final favLocations = watchPropertyValue((WeatherModel m) => m.favLocations);
    final currentLocation =
        watchPropertyValue((WeatherModel m) => m.lastLocation);

    final listView = ListView.builder(
      itemCount: favLocationsLength,
      itemBuilder: (context, index) {
        final selected = currentLocation == favLocations.elementAt(index);
        return Tile(
          selected: selected,
          location: favLocations.elementAt(index),
          onClear: favLocationsLength > 1
              ? () => di<WeatherModel>().loadWeather(
                    cityName: selected
                        ? favLocations.elementAtOrNull(index - 1)
                        : currentLocation,
                  )
              : null,
          onSelected: widget.onSelected,
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

class Tile extends StatefulWidget {
  const Tile({
    super.key,
    required this.location,
    required this.onSelected,
    required this.onClear,
    required this.selected,
  });

  final String location;
  final VoidCallback? onSelected;
  final bool selected;
  final Function()? onClear;

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Tooltip(
            message: widget.location,
            child: YaruMasterTile(
              onTap: () {
                di<WeatherModel>().loadWeather(cityName: widget.location);
                widget.onSelected?.call();
              },
              selected: widget.selected,
              title: Text(
                widget.location,
              ),
            ),
          ),
          if (widget.onClear != null && (_hovered || widget.selected))
            Positioned(
              right: 20,
              child: SizedBox.square(
                dimension: 30,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    di<WeatherModel>().removeFavLocation(widget.location).then(
                          (_) => widget.onClear?.call(),
                        );
                  },
                  icon: const Icon(
                    YaruIcons.window_close,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
