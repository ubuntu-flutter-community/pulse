import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:open_weather_client/models/weather_data.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../constants.dart';
import '../../build_context_x.dart';
import '../weather_data_x.dart';
import '../weather_model.dart';
import 'today_tile.dart';

class TodayChart extends StatefulWidget with WatchItStatefulWidgetMixin {
  const TodayChart({super.key});

  @override
  State<TodayChart> createState() => _TodayChartState();
}

class _TodayChartState extends State<TodayChart> {
  List<Color> gradientColors = [
    Colors.cyan,
    YaruColors.blue,
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    final forecast = watchPropertyValue((WeatherModel m) => m.fiveDaysForCast);
    final mq = context.mq;

    final cityName = watchPropertyValue((WeatherModel m) => m.lastLocation);
    final data = watchPropertyValue((WeatherModel m) => m.data);
    final error = watchPropertyValue((WeatherModel m) => m.error);

    return Stack(
      children: [
        Container(
          margin: kPagePadding,
          height: mq.size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kYaruContainerRadius),
            color: context.theme.colorScheme.surface.withOpacity(0.3),
          ),
          child: error != null
              ? Center(
                  child: Text(error),
                )
              : forecast == null || data == null
                  ? Center(
                      child: YaruCircularProgressIndicator(
                        color: context.theme.colorScheme.onSurface,
                        strokeWidth: 3,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.only(top: mq.size.height / 3),
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: forecast.length * 50,
                        height: 400,
                        child: LineChart(
                          showAvg ? avgData(forecast) : mainData(forecast),
                        ),
                      ),
                    ),
        ),
        Positioned(
          right: 65,
          bottom: 100,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Icon(
              showAvg ? YaruIcons.weather : YaruIcons.minus,
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

  Widget bottomTitleWidgets(
    double value,
    TitleMeta meta,
    List<WeatherData> data,
  ) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    text = Text(
      data[value.toInt()].getTime(context),
      style: style,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: style, textAlign: TextAlign.left),
    );
  }

  LineChartData mainData(List<WeatherData> data) {
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
            reservedSize: 35,
            interval: 1,
            getTitlesWidget: (value, meta) =>
                bottomTitleWidgets(value, meta, data),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
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
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
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

  LineChartData avgData(List<WeatherData> data) {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: false,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: false,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 30,
            getTitlesWidget: (value, meta) =>
                bottomTitleWidgets(value, meta, data),
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
