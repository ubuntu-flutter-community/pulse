import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_weather_client/models/weather_data.dart';
import 'package:yaru/yaru.dart';

import '../../build_context_x.dart';
import '../../../constants.dart';
import '../weather_data_x.dart';

class ForeCastChart extends StatelessWidget {
  const ForeCastChart({super.key, required this.data});

  final List<WeatherData> data;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(2 * kYaruPagePadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kYaruContainerRadius),
          color: context.theme.colorScheme.surface.withOpacity(0.3),
        ),
        height:
            context.mq.size.height - kYaruTitleBarHeight - 4 * kYaruPagePadding,
        width: context.mq.size.width - kPaneWidth - 2 * kYaruPagePadding,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: kYaruPagePadding),
          child: BarChart(
            BarChartData(
              baselineY: 0,
              titlesData: getTitlesData(context),
              borderData: borderData,
              barGroups: barGroups,
              gridData: const FlGridData(show: false),
              alignment: BarChartAlignment.spaceAround,
              maxY: data.map((e) => e.temperature.tempMax).max,
              minY: data.map((e) => e.temperature.tempMin).min,
            ),
          ),
        ),
      ),
    );
  }

  FlTitlesData getTitlesData(BuildContext context) => FlTitlesData(
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

  List<BarChartGroupData> get barGroups => data.mapIndexed(
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