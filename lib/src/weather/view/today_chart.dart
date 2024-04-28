import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:open_weather_client/models/weather_data.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../constants.dart';
import '../../build_context_x.dart';
import '../../l10n/l10n.dart';
import '../weather_data_x.dart';
import '../weather_model.dart';
import 'error_view.dart';
import 'today_tile.dart';

class TodayChart extends StatefulWidget with WatchItStatefulWidgetMixin {
  const TodayChart({super.key});

  @override
  State<TodayChart> createState() => _TodayChartState();
}

class _TodayChartState extends State<TodayChart> {
  late ScrollController _scrollController;

  List<Color> gradientColors = [
    Colors.cyan,
    YaruColors.blue,
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forecast =
        watchPropertyValue((WeatherModel m) => m.fiveDaysForCast ?? []);
    final mq = context.mq;

    final cityName = watchPropertyValue((WeatherModel m) => m.lastLocation);
    final data = watchPropertyValue((WeatherModel m) => m.data);
    final error = watchPropertyValue((WeatherModel m) => m.error);

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: kPagePadding,
          height: mq.size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kYaruContainerRadius),
            color: context.theme.colorScheme.surface.withOpacity(0.3),
          ),
          child: error != null
              ? ErrorView(error: error)
              : data == null
                  ? Center(
                      child: YaruCircularProgressIndicator(
                        color: context.theme.colorScheme.onSurface,
                        strokeWidth: 3,
                      ),
                    )
                  : SingleChildScrollView(
                      controller: _scrollController,
                      padding: EdgeInsets.only(top: mq.size.height / 3),
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: forecast.length * 100,
                        height: 400,
                        child: LineChart(
                          mainData(forecast: forecast, data: data),
                        ),
                      ),
                    ),
        ),
        if (error == null)
          Positioned(
            left: 65,
            child: FloatingActionButton.small(
              backgroundColor: Colors.white,
              onPressed: () => _scrollController.animateTo(
                _scrollController.position.pixels - 200,
                duration: const Duration(milliseconds: 100),
                curve: Curves.bounceIn,
              ),
              child: const Icon(
                YaruIcons.go_previous,
                color: Colors.black,
              ),
            ),
          ),
        if (error == null)
          Positioned(
            right: 65,
            child: FloatingActionButton.small(
              backgroundColor: Colors.white,
              onPressed: () => _scrollController.animateTo(
                _scrollController.position.pixels + 200,
                duration: const Duration(milliseconds: 100),
                curve: Curves.ease,
              ),
              child: const Icon(
                YaruIcons.go_next,
                color: Colors.black,
              ),
            ),
          ),
        if (data != null)
          TodayTile(
            data: data,
            fontSize: 20,
            cityName: cityName,
          ),
      ],
    );
  }

  Widget bottomTitleWidgets({
    required double value,
    required TitleMeta meta,
    required List<WeatherData> forecast,
    required WeatherData data,
  }) {
    final weekday = forecast[value.toInt()].getWeekDay(context);
    return SideTitleWidget(
      fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
      axisSide: meta.axisSide,
      child: Column(
        children: [
          Text(
            forecast[value.toInt()].getTime(context),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            weekday == data.getWeekDay(context) ? context.l10n.today : weekday,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  LineChartData mainData({
    required List<WeatherData> forecast,
    required WeatherData data,
  }) {
    final outlineColor = context.theme.colorScheme.onSurface.withOpacity(0.2);

    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: outlineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: outlineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 55,
            interval: 1,
            getTitlesWidget: (value, meta) => bottomTitleWidgets(
              value: value,
              meta: meta,
              forecast: forecast,
              data: data,
            ),
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 0,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(
          color: context.theme.colorScheme.onSurface.withOpacity(0.2),
        ),
      ),
      minX: 0,
      maxX: (forecast.length - 1).toDouble(),
      minY: forecast.map((e) => e.temperature.currentTemperature).min,
      maxY: forecast.map((e) => e.temperature.currentTemperature).max,
      lineBarsData: [
        LineChartBarData(
          spots: forecast
              .mapIndexed(
                (i, e) => FlSpot(
                  i.toDouble(),
                  e.temperature.currentTemperature,
                ),
              )
              .toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
