import 'package:weather/app/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:geolocator/geolocator.dart';

class WeatherTile extends StatelessWidget {
  final int count;
  final FormattedWeatherData data;
  final String? cityName;
  final double fontSize;
  final Position? position;
  final double? width;
  final double? height;
  final bool foreCast;

  const WeatherTile({
    Key? key,
    this.count = 1,
    required this.data,
    this.cityName,
    this.fontSize = 20,
    this.position,
    this.width,
    this.height,
    this.foreCast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var radius = 20.0 - 2 * count;
    var margin = 10.0 - count;
    var mq = MediaQuery.of(context);
    final style = TextStyle(
      color: Colors.white,
      fontSize: fontSize,
      shadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.9),
          spreadRadius: 8,
          blurRadius: 8,
          offset: const Offset(0, 1), // changes position of shadow
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
        ],
      ),
      Text(
        'Wind: ${data.windSpeed}',
        style: style,
      ),
      Text(
        data.shortDescription,
        textAlign: TextAlign.center,
        style: style.copyWith(fontSize: fontSize * 2),
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

    return Card(
      elevation: 6,
      margin: EdgeInsets.all(margin),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            WeatherBg(
              weatherType: data.weatherType,
              width: width ?? mq.size.width / count,
              height: height ?? mq.size.width * 2,
            ),
            Center(
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
            )
          ],
        ),
      ),
    );
  }
}
