import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pulse/app/utils.dart';
import 'package:pulse/app/weather_model.dart';
import 'package:pulse/string_x.dart';

class WeatherTile extends StatelessWidget {
  final FormattedWeatherData data;
  final String? cityName;
  final double fontSize;
  final Position? position;
  final double? width;
  final double? height;
  final bool isForeCastTile;
  final String? day;
  final EdgeInsets padding;
  final String? time;

  const WeatherTile({
    Key? key,
    required this.data,
    this.cityName,
    this.fontSize = 20,
    this.position,
    required this.width,
    required this.height,
    this.isForeCastTile = false,
    this.day,
    required this.padding,
    this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final light = theme.brightness == Brightness.light;
    final style = theme.textTheme.headlineSmall?.copyWith(
      color: Colors.white,
      fontSize: 20,
      shadows: [
        Shadow(
          color: Colors.black.withOpacity(0.8),
          offset: const Offset(0, 1),
          blurRadius: 3,
        )
      ],
    );

    final children = [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            data.currentTemperature,
            style: style,
          ),
          Text(
            'Feels like: ${data.feelsLike}',
            style: style,
          ),
          Text(
            'Wind: ${data.windSpeed}',
            style: style,
          ),
        ],
      ),
      if (day != null)
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              day!,
              style: style,
            ),
            if (time != null && isForeCastTile)
              Text(
                time!,
                style: style,
              ),
          ],
        ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          getIcon(data, theme.colorScheme),
          const SizedBox(
            width: 10,
          ),
          Text(
            data.longDescription.capitalize(),
            textAlign: TextAlign.center,
            style: style,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
      if (cityName != null)
        Text(
          cityName!,
          style: style,
        )
      else if (position != null)
        Text(
          'Position: ${position!.longitude.toStringAsFixed(4)}, ${position!.latitude.toStringAsFixed(4)}',
          style: style,
          textAlign: TextAlign.center,
        )
    ];

    final banner = Card(
      child: Stack(
        children: [
          Opacity(
            opacity: light ? 1 : 0.4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: WeatherBg(
                weatherType: getWeatherType(data),
                width: width ?? double.infinity,
                height: height ?? double.infinity,
              ),
            ),
          ),
          Center(
            child: isForeCastTile
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 40,
                      runAlignment: WrapAlignment.center,
                      runSpacing: 20,
                      children: children,
                    ),
                  )
                : Wrap(
                    direction: Axis.vertical,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 20,
                    runSpacing: 20,
                    runAlignment: WrapAlignment.center,
                    children: children,
                  ),
          )
        ],
      ),
    );

    return SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: padding,
        child: banner,
      ),
    );
  }
}
