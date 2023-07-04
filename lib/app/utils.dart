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
          ? const Color.fromARGB(255, 66, 66, 66).withOpacity(0.3)
          : const Color.fromARGB(255, 170, 170, 170).withOpacity(0.3);
    case 'Drizzle':
      return night
          ? const Color.fromARGB(255, 6, 39, 43).withOpacity(0.3)
          : const Color.fromARGB(255, 41, 255, 251).withOpacity(0.3);
    case 'Rain':
      return night
          ? const Color.fromARGB(255, 51, 56, 91).withOpacity(0.3)
          : const Color.fromARGB(255, 109, 128, 157).withOpacity(0.3);
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
