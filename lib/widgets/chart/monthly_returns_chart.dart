import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key, required this.myData});

  final List<FlSpot> myData;

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    const Color.fromARGB(255, 92, 106, 195),
    const Color.fromARGB(255, 0, 90, 187),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: LineChart(
            mainData(widget.myData),
          ),
        ),
      ],
    );
  }

  // Generates widgets for bottom titles based on the given value
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    // Switch case to display specific month names based on value
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 6:
        text = const Text('JUL', style: style);
        break;
      case 10:
        text = const Text('NOV', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  // Generates widgets for left titles based on the given value
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );

    String text = value.toStringAsFixed(0);

    return Text("${text}K", style: style, textAlign: TextAlign.left);
  }

// Configures the main data for the line chart
  LineChartData mainData(List<FlSpot> mainData) {
    // Calculate minY and maxY values from the data points
    double minY = mainData.map((spot) => spot.y).reduce(min);
    double maxY = mainData.map((spot) => spot.y).reduce(max);

    //  padding to minY and maxY for better visual spacing
    double yAxisPadding = (maxY - minY) * 0.2; // 20% padding
    minY -= yAxisPadding;
    maxY += yAxisPadding;

    double scaleFactor =
        (maxY > 1e1) ? 1e3 : 1; // Example scaling, adjust as needed
    maxY /= scaleFactor;
    minY /= scaleFactor;

    double interval = (maxY - minY) / 3;

    List<FlSpot> scaledData = (scaleFactor == 1)
        ? mainData
        : mainData
            .map((spot) => FlSpot(spot.x,
                double.parse((spot.y / scaleFactor).toStringAsFixed(2))))
            .toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: maxY / 10,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
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
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: interval,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: scaledData,
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
