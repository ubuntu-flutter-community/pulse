import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_weather_client/models/weather_data.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../constants.dart';
import '../../build_context_x.dart';
import '../weather_data_x.dart';
import '../weather_model.dart';

class ForeCastChart extends StatelessWidget with WatchItMixin {
  const ForeCastChart({super.key});

  @override
  Widget build(BuildContext context) {
    final notTodayForecastDaily =
        watchPropertyValue((WeatherModel m) => m.notTodayForecastDaily);

    final error = watchPropertyValue((WeatherModel m) => m.error);

    return Center(
      child: Container(
        margin: kPagePadding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kYaruContainerRadius),
          color: context.theme.colorScheme.surface.withOpacity(0.3),
        ),
        width: context.mq.size.width,
        child: (error != null)
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(kYaruPagePadding),
                  child: Text(
                    error,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : (notTodayForecastDaily == null)
                ? Center(
                    child: YaruCircularProgressIndicator(
                      color: context.theme.colorScheme.onSurface,
                      strokeWidth: 3,
                    ),
                  )
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: kYaruPagePadding),
                    child: BarChart(
                      BarChartData(
                        baselineY: 0,
                        titlesData:
                            getTitlesData(context, notTodayForecastDaily + []),
                        borderData: borderData,
                        barGroups: getBarGroups(notTodayForecastDaily),
                        gridData: const FlGridData(show: false),
                        alignment: BarChartAlignment.spaceAround,
                        maxY: notTodayForecastDaily
                            .map((e) => e.temperature.tempMax)
                            .max,
                        minY: notTodayForecastDaily
                            .map((e) => e.temperature.tempMin)
                            .min,
                      ),
                    ),
                  ),
      ),
    );
  }

  FlTitlesData getTitlesData(BuildContext context, List<WeatherData> data) =>
      FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  '${data[value.toInt()].temperature.tempMin.toInt()} °',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: data[value.toInt()]
                        .minColor
                        .scale(lightness: context.light ? -0.6 : 0.4),
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false, reservedSize: 0),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 150,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Column(
                  children: [
                    Flexible(
                      child: Text(
                        data[value.toInt()].getWeekDay(context),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        data[value.toInt()].getDate(context),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Icon(data[value.toInt()].icon),
                    const SizedBox(
                      height: 40,
                    ),
                    Flexible(
                      child: Text(
                        '${data[value.toInt()].temperature.tempMax.toInt()} °',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: data[value.toInt()]
                              .maxColor
                              .scale(lightness: context.light ? -0.6 : 0.4),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient getBarGradient({required Color minColor, required maxColor}) =>
      LinearGradient(
        colors: [
          maxColor,
          minColor,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  List<BarChartGroupData> getBarGroups(List<WeatherData> data) =>
      data.mapIndexed(
        (i, e) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                width: 30,
                toY: data[i].temperature.tempMax,
                fromY: data[i].temperature.tempMin + 1,
                gradient: getBarGradient(
                  maxColor: data[i].maxColor,
                  minColor: data[i].minColor,
                ),
              ),
            ],
          );
        },
      ).toList();
}
