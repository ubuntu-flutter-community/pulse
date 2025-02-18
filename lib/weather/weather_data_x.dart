import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:intl/intl.dart';
import 'package:open_weather_client/models/weather_data.dart';
import 'package:yaru/yaru.dart';
import 'weekday.dart';

extension WeatherDataX on WeatherData {
  WeatherType get weatherType {
    final hour = DateTime.fromMillisecondsSinceEpoch(
      date * 1000,
    ).hour;
    final night = hour > 20 || hour < 6;

    return switch (longDescription) {
      'overcast clouds' => night ? WeatherType.cloudyNight : WeatherType.cloudy,
      'scattered clouds' =>
        night ? WeatherType.cloudyNight : WeatherType.cloudy,
      'broken clouds' => night ? WeatherType.cloudyNight : WeatherType.cloudy,
      'few clouds' => night ? WeatherType.cloudyNight : WeatherType.cloudy,
      'light rain' => WeatherType.lightRainy,
      'heavy rain' => WeatherType.heavyRainy,
      'light snow' => WeatherType.lightSnow,
      'heavy snow' => WeatherType.heavySnow,
      'clear sky' => night ? WeatherType.sunnyNight : WeatherType.sunny,
      _ => switch (shortDescription) {
          'Clouds' => night ? WeatherType.cloudyNight : WeatherType.cloudy,
          'Drizzle' => WeatherType.lightRainy,
          'Rain' => WeatherType.middleRainy,
          'Snow' => WeatherType.heavySnow,
          'Clear' => night ? WeatherType.sunnyNight : WeatherType.sunny,
          'Sunny' => night ? WeatherType.sunnyNight : WeatherType.sunny,
          'Wind' => night ? WeatherType.dusty : WeatherType.dusty,
          'Mist' => WeatherType.foggy,
          _ => WeatherType.thunder
        }
    };
  }

  String get currentTemperature => '${temperature.currentTemperature} °C';
  String get feelsLike => '${temperature.feelsLike} °C';

  String get windSpeed => '${wind.speed} km/h';

  String get shortDescription =>
      details.firstOrNull?.weatherShortDescription ?? '';
  String get longDescription =>
      details.firstOrNull?.weatherLongDescription ?? '';

  String getDate(BuildContext context) {
    final realDateTime = dateTime;

    if (realDateTime.day == DateTime.now().day) {
      return 'Today';
    }
    return DateFormat.MMMd(
      Localizations.maybeLocaleOf(context)?.toLanguageTag(),
    ).format(realDateTime);
  }

  String getWeekDay(BuildContext context) {
    final weekDay = DateFormat.EEEE(
      Localizations.maybeLocaleOf(context)?.toLanguageTag(),
    ).format(
      dateTime,
    );

    return weekDay;
  }

  WeekDay getWD() {
    var index = dateTime.weekday;
    var weekDay = weekDayFromIndex(index);
    return weekDay;
  }

  String getTime(BuildContext context) {
    return DateFormat.Hm(Localizations.maybeLocaleOf(context)?.toLanguageTag())
        .format(
          dateTime,
        )
        .toString();
  }

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(date * 1000);

  int get dailyDateTime =>
      (dateTime.copyWith(hour: 12).millisecondsSinceEpoch) ~/ 1000;

  Color get minColor {
    if (temperature.tempMin > 20) {
      return const Color.fromARGB(255, 0, 198, 229);
    } else if (temperature.tempMin > -5) {
      return YaruColors.blue;
    } else {
      return YaruColors.purple;
    }
  }

  Color get maxColor {
    if (temperature.tempMax > 40) {
      return YaruColors.red;
    } else if (temperature.tempMax > 30) {
      return Colors.orange;
    } else if (temperature.tempMax > 25) {
      return Colors.yellow;
    } else {
      return const Color.fromARGB(255, 124, 255, 59);
    }
  }

  IconData get icon {
    final hour = dateTime.hour;
    final night = hour > 20 || hour < 6;

    return switch (shortDescription) {
      'Clouds' =>
        night ? YaruIcons.few_clouds_night_filled : YaruIcons.few_clouds_filled,
      'Drizzle' => YaruIcons.showers_filled,
      'Rain' => YaruIcons.rain_filled,
      'Snow' => YaruIcons.snow_filled,
      'Clear' => night ? YaruIcons.clear_night_filled : YaruIcons.sun_filled,
      'Sunny' => night ? YaruIcons.clear_night_filled : YaruIcons.sun_filled,
      _ => night ? YaruIcons.clear_night_filled : YaruIcons.sun_filled
    };
  }
}
