import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:open_weather_client/models/weather_data.dart';
import 'package:pulse/weather_data_x.dart';
import 'package:yaru_icons/yaru_icons.dart';

Color getColor(WeatherData weatherData) {
  final hour = DateTime.fromMillisecondsSinceEpoch(
    weatherData.date * 1000,
  ).hour;
  final night = hour > 20 || hour < 6;

  switch (weatherData.shortDescription) {
    case 'Clouds':
      return night
          ? const Color.fromARGB(255, 55, 55, 55)
          : const Color.fromARGB(221, 102, 102, 102);
    case 'Drizzle':
      return night
          ? const Color.fromARGB(255, 6, 39, 43)
          : const Color.fromARGB(255, 41, 255, 251);
    case 'Rain':
      return night ? Colors.grey : Colors.grey;
    case 'Snow':
      return Colors.white;
    case 'Clear':
      return night ? Colors.blueAccent : Colors.blueAccent;
    case 'Sunny':
      return night ? Colors.blueAccent : Colors.blueAccent;
    default:
      return Colors.transparent;
  }
}

Icon getIcon(
  WeatherData weatherData,
  ColorScheme colorScheme,
) {
  final hour = DateTime.fromMillisecondsSinceEpoch(
    weatherData.date * 1000,
  ).hour;
  final night = hour > 20 || hour < 6;
  final shadows = [
    Shadow(
      color: Colors.black.withOpacity(0.8),
      offset: const Offset(0, 1),
      blurRadius: 3,
    ),
  ];

  switch (weatherData.shortDescription) {
    case 'Clouds':
      return Icon(
        night ? YaruIcons.few_clouds_night_filled : YaruIcons.few_clouds_filled,
        color: Colors.white,
        shadows: shadows,
      );
    case 'Drizzle':
      return Icon(
        YaruIcons.showers_filled,
        color: Colors.white,
        shadows: shadows,
      );
    case 'Rain':
      return Icon(
        YaruIcons.rain_filled,
        color: Colors.white,
        shadows: shadows,
      );
    case 'Snow':
      return Icon(
        YaruIcons.snow_filled,
        color: Colors.white,
        shadows: shadows,
      );
    case 'Clear':
      return night
          ? Icon(
              YaruIcons.clear_night_filled,
              color: Colors.white,
              shadows: shadows,
            )
          : Icon(
              YaruIcons.sun_filled,
              color: Colors.white,
              shadows: shadows,
            );
    case 'Sunny':
      return night
          ? Icon(
              YaruIcons.clear_night_filled,
              color: Colors.white,
              shadows: shadows,
            )
          : Icon(
              YaruIcons.sun_filled,
              color: Colors.white,
              shadows: shadows,
            );
    default:
      return night
          ? Icon(
              YaruIcons.clear_night_filled,
              color: Colors.white,
              shadows: shadows,
            )
          : Icon(
              YaruIcons.sun_filled,
              color: Colors.white,
              shadows: shadows,
            );
  }
}

WeatherType getWeatherType(WeatherData weatherData) {
  final hour = DateTime.fromMillisecondsSinceEpoch(
    weatherData.date * 1000,
  ).hour;
  final night = hour > 20 || hour < 6;

  switch (weatherData.shortDescription) {
    case 'Clouds':
      return night ? WeatherType.cloudyNight : WeatherType.cloudy;
    case 'Drizzle':
      return WeatherType.lightRainy;
    case 'Rain':
      return WeatherType.heavyRainy;
    case 'Snow':
      return WeatherType.heavySnow;
    case 'Clear':
      return night ? WeatherType.sunnyNight : WeatherType.sunny;
    case 'Sunny':
      return night ? WeatherType.sunnyNight : WeatherType.sunny;
    default:
      return WeatherType.thunder;
  }
}
