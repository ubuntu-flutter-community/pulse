import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';

extension WeatherTypeX on WeatherType {
  String localize() {
    switch (this) {
      case WeatherType.sunny:
      case WeatherType.sunnyNight:
        return 'Sonnig';
      case WeatherType.cloudy:
      case WeatherType.cloudyNight:
        return 'Bewölkt';
      case WeatherType.overcast:
        return 'Bedeckt';
      case WeatherType.lightRainy:
        return 'Leichter Regen';
      case WeatherType.middleRainy:
        return 'Regen';
      case WeatherType.heavyRainy:
        return 'Starker Regen';
      case WeatherType.thunder:
        return 'Gewitter';
      case WeatherType.hazy:
        return 'Hagel';
      case WeatherType.foggy:
        return 'Nebelig';
      case WeatherType.lightSnow:
        return 'Leichter Schneefall';
      case WeatherType.middleSnow:
        return 'Schneefall';
      case WeatherType.heavySnow:
        return 'Starker Schneefall';
      case WeatherType.dusty:
        return 'Staubig';
      default:
        return '';
    }
  }
}
