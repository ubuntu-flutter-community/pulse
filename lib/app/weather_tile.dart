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
  final String? day;
  final double widthFactor;
  final EdgeInsets padding;

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
    this.day,
    required this.widthFactor,
    required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var radius = foreCast ? 10.0 : 20.0;
    var mq = MediaQuery.of(context);
    final style = TextStyle(
      color: Colors.white,
      fontSize: fontSize,
      shadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.9),
          spreadRadius: 4,
          blurRadius: 3,
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

    var card = Card(
      elevation: 6,
      margin: EdgeInsets.zero,
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
              width: width ?? mq.size.width * widthFactor,
              height: height ?? mq.size.width,
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

    return Padding(
      padding: padding,
      child: card,
    );
  }
}
