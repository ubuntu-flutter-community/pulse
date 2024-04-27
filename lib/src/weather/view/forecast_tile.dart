import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:open_weather_client/models/weather_data.dart';
import 'package:yaru/constants.dart';

import '../../build_context_x.dart';
import '../../../string_x.dart';
import '../theme_x.dart';
import '../weather_data_x.dart';

class ForecastTile extends StatefulWidget {
  final WeatherData data;
  final String? cityName;
  final double fontSize;
  final String? position;
  final double? width;
  final double? height;
  final String? day;
  final EdgeInsets padding;
  final String? time;
  final BorderRadius borderRadius;

  const ForecastTile({
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
    this.borderRadius =
        const BorderRadius.all(Radius.circular(kYaruContainerRadius)),
  });

  @override
  State<ForecastTile> createState() => _ForecastTileState();
}

class _ForecastTileState extends State<ForecastTile> {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final style = theme.weatherBgTextStyle;

    final children = [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.data.currentTemperature,
            style: style,
          ),
          Text(
            'Feels like: ${widget.data.feelsLike}',
            style: style,
          ),
          Text(
            'Wind: ${widget.data.windSpeed}',
            style: style,
          ),
        ],
      ),
      if (widget.day != null)
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.day!,
              style: style,
            ),
            if (widget.time != null)
              Text(
                widget.time!,
                style: style,
              ),
          ],
        ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.data.icon,
            color: style?.color,
            shadows: style?.shadows,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            widget.data.longDescription.capitalize(),
            textAlign: TextAlign.center,
            style: style,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      if (widget.cityName != null)
        Text(
          widget.cityName!,
          style: style,
        )
      else if (widget.position != null)
        Text(
          widget.position ?? '',
          style: style,
          textAlign: TextAlign.center,
        ),
    ];

    final banner = Stack(
      children: [
        Opacity(
          opacity: 0.9,
          child: ClipRRect(
            borderRadius: widget.borderRadius,
            child: WeatherBg(
              weatherType: widget.data.weatherType,
              width: widget.width ?? double.infinity,
              height: widget.height ?? double.infinity,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 40,
              runAlignment: WrapAlignment.center,
              runSpacing: 20,
              children: children,
            ),
          ),
        ),
      ],
    );

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Padding(
        padding: widget.padding,
        child: banner,
      ),
    );
  }
}
