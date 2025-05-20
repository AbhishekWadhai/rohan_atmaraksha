import 'package:flutter/material.dart';
import 'package:rohan_suraksha_sathi/app_constants/colors.dart';
import 'package:rohan_suraksha_sathi/app_constants/textstyles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  final String category;
  final double value;

  ChartData(this.category, this.value);
}

enum ChartType {
  column,
  line,
  bar,
  pie,
  area,
  scatter,
  doughnut,
  groupedColumn,
}

class DynamicChart extends StatelessWidget {
  final String title;
  final List<ChartData>? data;
  final List<List<ChartData>>? groupedData; // For grouped column chart
  final String? legendName;
  final List<String>? legendNames; // For grouped column chart
  final bool showLegend;
  final ChartType chartType;

  const DynamicChart({
    Key? key,
    required this.title,
    this.data,
    this.groupedData,
    this.legendName,
    this.legendNames,
    required this.showLegend,
    required this.chartType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (chartType) {
      case ChartType.column:
        return _buildColumnChart(context);
      case ChartType.line:
        return _buildLineChart();
      case ChartType.bar:
        return _buildBarChart(context);
      case ChartType.pie:
        return _buildPieChart();
      case ChartType.area:
        return _buildAreaChart();
      case ChartType.scatter:
        return _buildScatterChart();
      case ChartType.doughnut:
        return _buildDoughnutChart();
      case ChartType.groupedColumn:
        return _buildGroupedColumnChart();
      default:
        throw ArgumentError('Invalid chart type');
    }
  }

  Widget _buildColumnChart(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth < 400 ? 12.0 : 16.0;
    final labelFontSize = screenWidth < 400 ? 10.0 : 12.0;

    return SfCartesianChart(
      margin: const EdgeInsets.all(10),
      title: ChartTitle(text: title, textStyle: TextStyles.chartTitle),
      primaryXAxis: CategoryAxis(
        labelStyle: TextStyle(color: Colors.white),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        labelStyle: TextStyle(color: Colors.white),
        axisLine: const AxisLine(width: 0),
        majorGridLines: MajorGridLines(
          width: 0.5,
          color: Colors.white24,
        ),
      ),
      legend: Legend(isVisible: showLegend),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<dynamic, dynamic>>[
        ColumnSeries<dynamic, dynamic>(
          width: 0.4,
          dataSource: data,
          xValueMapper: (dynamic sales, _) => sales.category,
          yValueMapper: (dynamic sales, _) => sales.value,
          name: legendName,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.greenAccent], // Gradient colors
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
      ],
    );
  }

  Widget _buildLineChart() {
    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        labelStyle: TextStyle(color: Colors.white),
      ),
      primaryYAxis: CategoryAxis(
        labelStyle: TextStyle(color: Colors.white),
      ),
      title: ChartTitle(text: title, textStyle: TextStyles.chartTitle),
      legend: Legend(isVisible: showLegend),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<dynamic, dynamic>>[
        LineSeries<dynamic, dynamic>(
          dataSource: data,
          xValueMapper: (dynamic sales, _) => sales.category,
          yValueMapper: (dynamic sales, _) => sales.value,
          name: legendName,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  Widget _buildBarChart(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth < 400 ? 12.0 : 16.0;
    final labelFontSize = screenWidth < 400 ? 10.0 : 12.0;
    final chartHeight = screenWidth < 400 ? 250.0 : 300.0;
    final List<Color> barColors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
    ];

    return SfCartesianChart(
      title: ChartTitle(text: title, textStyle: TextStyles.chartTitle),
      primaryXAxis: const CategoryAxis(
        labelStyle: TextStyle(color: Colors.white),
      ),
      primaryYAxis: CategoryAxis(
        labelStyle: TextStyle(color: Colors.white),
      ),
      legend: Legend(isVisible: showLegend),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<dynamic, dynamic>>[
        BarSeries<dynamic, dynamic>(
          color: Colors.white,
          dataSource: data,
          xValueMapper: (dynamic sales, _) => sales.category,
          yValueMapper: (dynamic sales, _) => sales.value,
          name: legendName,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          pointColorMapper: (dynamic sales, int index) =>
              barColors[index % barColors.length], // Assigns different colors
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    return SfCircularChart(
      title: ChartTitle(text: title, textStyle: TextStyles.chartTitle),
      legend: Legend(isVisible: showLegend),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CircularSeries>[
        PieSeries<ChartData, String>(
          dataSource: data,
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.value,
          name: legendName,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  Widget _buildAreaChart() {
    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        labelStyle: TextStyle(color: Colors.white),
      ),
      primaryYAxis: CategoryAxis(
        labelStyle: TextStyle(color: Colors.white),
      ),
      title: ChartTitle(text: title, textStyle: TextStyles.chartTitle),
      legend: Legend(isVisible: showLegend),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<dynamic, dynamic>>[
        AreaSeries<dynamic, dynamic>(
          dataSource: data,
          xValueMapper: (dynamic sales, _) => sales.category,
          yValueMapper: (dynamic sales, _) => sales.value,
          name: legendName,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  Widget _buildScatterChart() {
    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        labelStyle: TextStyle(color: Colors.white),
      ),
      primaryYAxis: CategoryAxis(labelStyle: TextStyle(color: Colors.white),),
      title: ChartTitle(text: title, textStyle: TextStyles.chartTitle),
      legend: Legend(isVisible: showLegend),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<dynamic, dynamic>>[
        ScatterSeries<dynamic, dynamic>(
          dataSource: data,
          xValueMapper: (dynamic sales, _) => sales.category,
          yValueMapper: (dynamic sales, _) => sales.value,
          name: legendName,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  Widget _buildDoughnutChart() {
    return SfCircularChart(
      title: ChartTitle(text: title, textStyle: TextStyles.chartTitle),
      legend: Legend(isVisible: showLegend),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CircularSeries>[
        DoughnutSeries<ChartData, String>(
          dataSource: data,
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.value,
          name: legendName,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          innerRadius: '60%',
        ),
      ],
    );
  }

  Widget _buildGroupedColumnChart() {
    if (groupedData == null || legendNames == null) {
      throw ArgumentError(
          'groupedData and legendNames are required for grouped column chart');
    }

    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(labelStyle: TextStyle(color: Colors.white),),
      // primaryYAxis: CategoryAxis(labelStyle: TextStyle(color: Colors.white),),
      title: ChartTitle(text: title, textStyle: TextStyles.chartTitle),
      legend: Legend(isVisible: showLegend),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: List.generate(groupedData!.length, (index) {
        return ColumnSeries<ChartData, String>(
          dataSource: groupedData![index],
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.value,
          name: legendNames![index],
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        );
      }),
    );
  }
}
