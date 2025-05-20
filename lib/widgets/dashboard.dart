import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/app_constants/colors.dart';
import 'package:rohan_suraksha_sathi/controller/safety_report_controller%20copy.dart';
import 'package:rohan_suraksha_sathi/helpers/sixed_boxes.dart';
import 'package:rohan_suraksha_sathi/widgets/new_bar_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final SafetyReportChartController safetyReportController1 =
      Get.put(SafetyReportChartController());

  late PageController _pageController;
  int _currentPage = 0;
  List<Widget> charts = [];
  String selectedFilter = "Recent";
  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 1000,
      viewportFraction: 1.0,
    );
    updateCharts();
  }

  /// Creates a list of chart instances dynamically
  List<Widget> getCharts({bool showLegend = false}) {
    return [
      DynamicChart(
        data: safetyReportController1.tbtMeeting,
        title: "TBT Meeting Hours",
        legendName: "Meeting Hours",
        showLegend: showLegend,
        chartType: ChartType.column,
      ),
      DynamicChart(
        data: safetyReportController1.safetyInduction,
        title: "Safety Induction Hours",
        legendName: "Induction",
        showLegend: showLegend,
        chartType: ChartType.pie,
      ),
      DynamicChart(
        data: safetyReportController1.specificTraining,
        title: "Specific Training Hours",
        legendName: "Training Hours",
        showLegend: showLegend,
        chartType: ChartType.doughnut,
      ),
      DynamicChart(
        data: safetyReportController1.safetyTraining,
        title: "Total Safety Training Hours",
        legendName: "Total Hours",
        showLegend: showLegend,
        chartType: ChartType.area,
      ),
      DynamicChart(
        data: safetyReportController1.avgManPowers,
        title: "Avg. Manpower",
        legendName: "Manpower",
        showLegend: showLegend,
        chartType: ChartType.bar,
      ),
      DynamicChart(
        title: "Injury Incident",
        groupedData: [
          safetyReportController1.fatality,
          safetyReportController1.ltiCases,
          safetyReportController1.mtiCases,
          safetyReportController1.fac
        ],
        legendNames: const [
          "Fatal",
          "LTI",
          "MTI",
          "FAC",
        ],
        showLegend: showLegend,
        chartType: ChartType.groupedColumn,
      ),
      DynamicChart(
        title: "Non-Injury Incident",
        groupedData: [
          safetyReportController1.majorEnvironmentalCases,
          safetyReportController1.animalAndInsectBiteCases,
          safetyReportController1.dangerousOccurrences,
          safetyReportController1.nearMissIncidents,
          safetyReportController1.fireCases,
        ],
        legendNames: const [
          "Environmental Incident",
          "Animal or InsectBiteCases",
          "Dangerous Occurrences",
          "Near Miss",
          "Fire",
        ],
        showLegend: showLegend,
        chartType: ChartType.groupedColumn,
      )
    ];
  }

  /// Updates the chart list for the main view
  void updateCharts() {
    setState(() {
      charts = getCharts();
    });
  }

  /// Shows a full-screen dialog with a newly created chart (with legend)

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index % charts.length;
          });
        },
        itemBuilder: (context, index) {
          final chartIndex = index % charts.length;

          return GestureDetector(
            onTap: () => _showFullScreenChart(
              chartIndex,
              context,
              safetyReportController1,
              getCharts,
              selectedFilter,
              (newFilter) {
                // Add this callback
                setState(() {
                  selectedFilter = newFilter;
                  updateCharts(); // Update charts when filter changes
                });
              },
            ), // Open full-screen chart
            child: AnimatedScale(
              scale: _currentPage == chartIndex ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width * 0.75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: charts[chartIndex]),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(

                        children: [
                          Text(
                            "$selectedFilter observations",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          CircleAvatar(
                            radius: 12,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.more_horiz_rounded,
                                color: Colors.black,
                              ))
                        ],
                      ),
                    ),
                    sb8
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void _showFullScreenChart(
  int chartIndex,
  BuildContext context,
  SafetyReportChartController safetyReportController,
  Function({bool showLegend}) getCharts,
  String selectedFilter,
  Function(String) onFilterChanged, // Add this callback
) {
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          List<Widget> charts = getCharts(showLegend: true);

          return Dialog(
            insetPadding: EdgeInsets.all(8.0),
            backgroundColor: AppColors.appMainMid,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(

                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.appMainDark),
                  value: selectedFilter,
                  onChanged: (filter) {
                    if (filter != null) {
                      setDialogState(() {
                        selectedFilter = filter;
                        onFilterChanged(
                            filter); // Call the callback to update the state in DashboardPage3
                        safetyReportController.updateDataForFilter(filter);
                      });
                    }
                  },
                  items: const [
                    DropdownMenuItem(value: "Weekly", child: Text("Weekly")),
                    DropdownMenuItem(value: "Monthly", child: Text("Monthly")),
                    DropdownMenuItem(
                        value: "Quarterly", child: Text("Quarterly")),
                    DropdownMenuItem(value: "Yearly", child: Text("Yearly")),
                    DropdownMenuItem(value: "Recent", child: Text("Recent")),
                  ],
                ),
                FutureBuilder<void>(
                  future: Future.microtask(() {
                    safetyReportController.updateDataForFilter(selectedFilter);
                  }),
                  builder: (context, snapshot) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: charts[chartIndex],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
