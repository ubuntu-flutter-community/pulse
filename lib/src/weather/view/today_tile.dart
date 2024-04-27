import 'package:flutter/material.dart';
import 'package:open_weather_client/models/weather_data.dart';
import 'package:yaru/constants.dart';

import '../../../constants.dart';
import '../../../string_x.dart';
import '../../build_context_x.dart';
import '../theme_x.dart';
import '../weather_data_x.dart';

class TodayTile extends StatelessWidget {
  final WeatherData data;
  final String? cityName;
  final double fontSize;
  final String? position;
  final String? day;
  final String? time;
  final BorderRadiusGeometry? borderRadius;

  const TodayTile({
    super.key,
    required this.data,
    this.cityName,
    this.fontSize = 20,
    this.position,
    this.day,
    this.time,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final style = theme.weatherBgTextStyle;

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
            if (time != null)
              Text(
                time!,
                style: style,
              ),
          ],
        ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            data.icon,
            color: style?.color,
            shadows: style?.shadows,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            data.longDescription.capitalize(),
            textAlign: TextAlign.center,
            style: style,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      if (cityName != null)
        Text(
          cityName!,
          style: style,
          textAlign: TextAlign.center,
        )
      else if (position != null)
        Text(
          position ?? '',
          style: style,
          textAlign: TextAlign.center,
        ),
    ];

    return Center(
      child: Container(
        margin: kPagePadding,
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 2 * kYaruPagePadding,
              ),
              Wrap(
                direction: Axis.vertical,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 20,
                runSpacing: 20,
                runAlignment: WrapAlignment.center,
                children: children,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
