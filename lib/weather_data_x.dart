import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_weather_client/models/weather_data.dart';
import 'package:pulse/weekday.dart';

extension WeatherDataX on WeatherData {
  String get currentTemperature => '${temperature.currentTemperature} °C';
  String get feelsLike => '${temperature.feelsLike} °C';

  String get windSpeed => '${wind.speed} km/h';

  String get shortDescription =>
      details.firstOrNull?.weatherShortDescription ?? '';
  String get longDescription =>
      details.firstOrNull?.weatherLongDescription ?? '';

  String getDate(BuildContext context) {
    final realDateTime = dateTime();

    if (realDateTime.day == DateTime.now().day) {
      return 'Today';
    }
    return DateFormat.yMMMMEEEEd(
      Localizations.maybeLocaleOf(context)?.toLanguageTag(),
    ).format(realDateTime);
  }

  String getWeekDay(BuildContext context) {
    final weekDay = DateFormat.EEEE(
      Localizations.maybeLocaleOf(context)?.toLanguageTag(),
    ).format(
      dateTime(),
    );

    return weekDay;
  }

  WeekDay getWD() {
    var index = dateTime().weekday;
    var weekDay = weekDayFromIndex(index);
    return weekDay;
  }

  String getTime(BuildContext context) {
    return DateFormat.Hm(Localizations.maybeLocaleOf(context)?.toLanguageTag())
        .format(
          dateTime(),
        )
        .toString();
  }

  DateTime dateTime() => DateTime.fromMillisecondsSinceEpoch(date * 1000);
}
