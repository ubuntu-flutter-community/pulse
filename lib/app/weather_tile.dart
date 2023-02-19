import 'package:weather/app/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class WeatherTile extends StatelessWidget {
  final FormattedWeatherData data;
  final String? cityName;
  final double fontSize;
  final Position? position;
  final double? width;
  final double? height;
  final bool foreCast;
  final String? day;
  final EdgeInsets padding;

  const WeatherTile({
    Key? key,
    required this.data,
    this.cityName,
    this.fontSize = 20,
    this.position,
    this.width,
    this.height,
    this.foreCast = false,
    this.day,
    required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge;

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
      if (day != null && foreCast)
        Text(
          day!,
          style: style,
        ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(data.icon),
          const SizedBox(
            width: 10,
          ),
          Text(
            data.shortDescription,
            textAlign: TextAlign.center,
            style: style!.copyWith(fontSize: fontSize * 1.5),
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
          'Position: ${position!.longitude.toString()}, ${position!.latitude.toString()}',
          style: style,
        )
    ];

    var banner = YaruBanner(
      surfaceTintColor: data.color,
      child: Center(
        child: foreCast
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: children,
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
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
