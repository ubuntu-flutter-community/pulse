import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:open_weather_client/models/weather_data.dart';
import '../utils.dart';
import '../../../string_x.dart';
import '../weather_data_x.dart';

class ForecastTile extends StatefulWidget {
  final List<WeatherData> data;
  final WeatherData selectedData;
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
    required this.selectedData,
    this.cityName,
    this.fontSize = 20,
    this.position,
    required this.width,
    required this.height,
    this.day,
    required this.padding,
    this.time,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    required this.data,
  });

  @override
  State<ForecastTile> createState() => _ForecastTileState();
}

class _ForecastTileState extends State<ForecastTile> {
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
            widget.selectedData.currentTemperature,
            style: style,
          ),
          Text(
            'Feels like: ${widget.selectedData.feelsLike}',
            style: style,
          ),
          Text(
            'Wind: ${widget.selectedData.windSpeed}',
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
          getIcon(widget.selectedData, theme.colorScheme),
          const SizedBox(
            width: 10,
          ),
          Text(
            widget.selectedData.longDescription.capitalize(),
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

    final banner = Card(
      child: Stack(
        children: [
          Opacity(
            opacity: light ? 1 : 0.4,
            child: ClipRRect(
              borderRadius: widget.borderRadius,
              child: WeatherBg(
                weatherType: getWeatherType(widget.selectedData),
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
      ),
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
