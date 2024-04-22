import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:open_weather_client/models/weather_data.dart';
import 'weather_data_x.dart';
import 'package:yaru/icons.dart';

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

  return switch (weatherData.longDescription) {
    'overcast clouds' => night ? WeatherType.cloudyNight : WeatherType.cloudy,
    'scattered clouds' => night ? WeatherType.cloudyNight : WeatherType.cloudy,
    'broken clouds' => night ? WeatherType.cloudyNight : WeatherType.cloudy,
    'few clouds' => night ? WeatherType.cloudyNight : WeatherType.cloudy,
    'light rain' => WeatherType.lightRainy,
    'heavy rain' => WeatherType.heavyRainy,
    'light snow' => WeatherType.lightSnow,
    'heavy snow' => WeatherType.heavySnow,
    'clear sky' => night ? WeatherType.sunnyNight : WeatherType.sunny,
    _ => switch (weatherData.shortDescription) {
        'Clouds' => night ? WeatherType.cloudyNight : WeatherType.cloudy,
        'Drizzle' => WeatherType.lightRainy,
        'Rain' => WeatherType.middleRainy,
        'Snow' => WeatherType.heavySnow,
        'Clear' => night ? WeatherType.sunnyNight : WeatherType.sunny,
        'Sunny' => night ? WeatherType.sunnyNight : WeatherType.sunny,
        'Wind' => night ? WeatherType.dusty : WeatherType.dusty,
        _ => WeatherType.thunder
      }
  };
}
