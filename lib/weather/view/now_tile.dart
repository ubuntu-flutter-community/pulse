import 'package:flutter/material.dart';
import 'package:open_weather_client/models/weather_data.dart';
import 'package:yaru/constants.dart';

import '../../constants.dart';
import '../../extensions/string_x.dart';
import '../../extensions/build_context_x.dart';
import '../../l10n/l10n.dart';
import '../theme_x.dart';
import '../weather_data_x.dart';

class NowTile extends StatelessWidget {
  final WeatherData data;
  final String? cityName;
  final double fontSize;
  final String? position;
  final String? time;
  final BorderRadiusGeometry? borderRadius;

  const NowTile({
    super.key,
    required this.data,
    this.cityName,
    this.fontSize = 20,
    this.position,
    this.time,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final style = theme.weatherBgTextStyle;

    return Center(
      child: Container(
        margin: kPagePadding,
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 2 * kYaruPagePadding,
              ),
              Wrap(
                direction: Axis.vertical,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 20,
                runSpacing: 20,
                runAlignment: WrapAlignment.center,
                children: [
                  Text(
                    context.l10n.now,
                    style: style?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (cityName != null)
                    Text(
                      cityName!,
                      style: style,
                      textAlign: TextAlign.center,
                    ),
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        data.icon,
                        color: style?.color,
                        shadows: style?.shadows,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        data.longDescription.capitalize(),
                        textAlign: TextAlign.center,
                        style: style,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
