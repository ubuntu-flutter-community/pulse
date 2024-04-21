import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:open_weather_client/models/weather_data.dart';
import '../utils.dart';
import '../../../string_x.dart';
import '../weather_data_x.dart';

class TodayTile extends StatelessWidget {
  final WeatherData data;
  final String? cityName;
  final double fontSize;
  final String? position;
  final double? width;
  final double? height;
  final String? day;
  final EdgeInsets padding;
  final String? time;

  const TodayTile({
    super.key,
    required this.data,
    this.cityName,
    this.fontSize = 20,
    this.position,
    required this.width,
    required this.height,
    this.day,
    required this.padding,
    this.time,
  });

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
        ),
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
          getIcon(data, theme.colorScheme),
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
        )
      else if (position != null)
        SizedBox(
          width: 300,
          child: Text(
            position ?? '',
            style: style,
            textAlign: TextAlign.center,
          ),
        ),
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
            child: Wrap(
              direction: Axis.vertical,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 20,
              runSpacing: 20,
              runAlignment: WrapAlignment.center,
              children: children,
            ),
          ),
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
