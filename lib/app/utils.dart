import 'package:flutter/material.dart';
import 'package:weather/app/weather_model.dart';

Color getColor(FormattedWeatherData formattedWeatherData) {
  if (formattedWeatherData.weatherData?.date == null) {
    return Colors.transparent;
  }
  final hour = DateTime.fromMillisecondsSinceEpoch(
    formattedWeatherData.weatherData!.date * 1000,
  ).hour;
  final night = hour > 20 || hour < 6;

  switch (formattedWeatherData.shortDescription) {
    case 'Clouds':
      return night
          ? const Color.fromARGB(255, 68, 40, 26).withOpacity(0.3)
          : const Color.fromARGB(255, 59, 40, 17).withOpacity(0.3);
    case 'Drizzle':
      return night
          ? const Color.fromARGB(255, 48, 46, 45).withOpacity(0.3)
          : const Color.fromARGB(255, 151, 146, 140).withOpacity(0.3);
    case 'Rain':
      return night
          ? const Color.fromARGB(255, 72, 34, 104).withOpacity(0.3)
          : const Color.fromARGB(255, 145, 71, 187).withOpacity(0.3);
    case 'Snow':
      return night
          ? const Color.fromARGB(255, 116, 116, 116).withOpacity(0.3)
          : const Color.fromARGB(255, 255, 255, 255).withOpacity(0.3);
    case 'Clear':
      return night
          ? Colors.blue[900]!.withOpacity(0.3)
          : Colors.yellow[300]!.withOpacity(0.05);
    case 'Sunny':
      return night
          ? Colors.blue[900]!.withOpacity(0.3)
          : Colors.yellow[300]!.withOpacity(0.05);
    default:
      return Colors.transparent;
  }
}
