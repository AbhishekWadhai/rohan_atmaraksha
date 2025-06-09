import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/app_constants/colors.dart';
import 'package:rohan_suraksha_sathi/controller/safety_report_controller%20copy.dart';
import 'package:rohan_suraksha_sathi/helpers/sixed_boxes.dart';
import 'package:rohan_suraksha_sathi/widgets/new_bar_chart.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
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

  final List<String> filters = [
    "Weekly",
    "Monthly",
    "Quarterly",
    "Yearly",
    "Recent"
  ];
  int selectedYear = DateTime.now().year;
  int? selectedQuarter;
  int? selectedMonth;

  final List<int> years = List.generate(5, (i) => DateTime.now().year - i);
  final List<String> quarters = [
    "Quarter 1",
    "Quarter 2",
    "Quarter 3",
    "Quarter 4"
  ];
  final Map<String, int> monthMap = {
    'January': 1,
    'February': 2,
    'March': 3,
    'April': 4,
    'May': 5,
    'June': 6,
    'July': 7,
    'August': 8,
    'September': 9,
    'October': 10,
    'November': 11,
    'December': 12,
  };
  List<Map<String, dynamic>> weeks = [];

  /// Creates a list of chart instances dynamically
  List<Widget> getCharts({bool showLegend = false}) {
    return [
      DynamicChart(
        data: safetyReportController1.avgManPowers,
        title: "Avg. Manpower",
        legendName: "Manpower",
        showLegend: true,
        chartType: ChartType.column,
        textColor: Colors.black,
      ),
      DynamicChart(
        data: safetyReportController1.totalManHoursWorkedinM,
        title: "Avg. Manhours Worked",
        legendName: "Avg. Manhours Worked",
        showLegend: true,
        chartType: ChartType.column,
        textColor: Colors.black,
      ),
      DynamicChart(
        data: safetyReportController1.safetyTraining,
        title: "Safety Training Target(%)",
        legendName: "Percentages of Trainees",
        showLegend: true,
        chartType: ChartType.doughnut,
        textColor: Colors.black,
      ),
      DynamicChart(
        title: "Frequency Rate(FR) and Severity Rate(SR)",
        groupedData: [
          safetyReportController1.fr,
          safetyReportController1.sr,
        ],
        legendNames: const [
          "FR",
          "SR",
        ],
        showLegend: true,
        chartType: ChartType.groupedColumn,
        textColor: Colors.black,
      ),
      DynamicChart(
        data: safetyReportController1.uaucResolved,
        title: "UAUC Rectified(%)",
        legendName: "UAUC",
        showLegend: true,
        chartType: ChartType.bar,
        textColor: Colors.black,
      ),
      DynamicChart(
        data: safetyReportController1.safetyInduction,
        title: "No. of Persons Safety Inducted",
        legendName: "Training Hours",
        showLegend: true,
        chartType: ChartType.bar,
        textColor: Colors.black,
      ),
      DynamicChart(
        data: safetyReportController1.safetyCommitteeMeetings,
        title: "Safety Committee Meetings",
        legendName: "Training Hours",
        showLegend: true,
        chartType: ChartType.column,
        textColor: Colors.black,
      ),
      DynamicChart(
        title: "Safety Audit",
        groupedData: [
          safetyReportController1.externalAudits,
          safetyReportController1.internalAudits,
        ],
        legendNames: const ["External", "Internal"],
        showLegend: true,
        chartType: ChartType.groupedColumn,
        textColor: Colors.black,
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
        showLegend: true,
        chartType: ChartType.groupedColumn,
        textColor: Colors.black,
      ),
      DynamicChart(
        title: "Injury Incident",
        groupedData: [
              safetyReportController1.fatality,
              safetyReportController1.ltiCases,
              safetyReportController1.mtiCases,
              safetyReportController1.fac
            ],
            legendNames: const ["Fatal", "LTI", "MTI", "FAC"],
        showLegend: true,
        chartType: ChartType.groupedColumn,
        textColor: Colors.black,
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          IconButton(
            onPressed: () {
              Get.dialog(
                Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    // height: 200,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Filter Options"),
                        // Add your filter widgets here
                        Column(
                          children: [
                            // 🔽 Year Dropdown
                            Column(
                              children: [
                                const Text(
                                  "Select Year:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Obx(
                                  () => DropdownButton<int>(
                                    value: int.parse(safetyReportController1
                                        .selectedYear.value),
                                    items: years.map((year) {
                                      return DropdownMenuItem<int>(
                                        value: year,
                                        child: Text(year.toString()),
                                      );
                                    }).toList(),
                                    onChanged: (year) {
                                      print(safetyReportController1
                                          .safetyReportData.length);
                                      setState(() {
                                        weeks = safetyReportController1
                                            .getWeeksOfYear(year!);
                                        safetyReportController1.selectedYear
                                            .value = year.toString();
                                        safetyReportController1
                                            .updateDataForFilter("Yearly");
                                        // Call chart update or controller logic here
                                        updateCharts();
                                        //updateCards();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            sb18,
                            // 🔽 Quarter Dropdown
                            Column(
                              children: [
                                const Text(
                                  "Select Quarter",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Obx(
                                  () => DropdownButton<String>(
                                    value: safetyReportController1
                                        .selectedQuarter.value,
                                    items: quarters.map((quarter) {
                                      return DropdownMenuItem<String>(
                                        value: quarter,
                                        child: Text(quarter),
                                      );
                                    }).toList(),
                                    onChanged: (year) {
                                      print(safetyReportController1
                                          .safetyReportData.length);
                                      setState(() {
                                        safetyReportController1.selectedQuarter
                                            .value = year.toString();
                                        safetyReportController1
                                            .updateDataForFilter("Quarterly");
                                        // Call chart update or controller logic here
                                        updateCharts();
                                        //updateCards();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            sb18,
                            // 🔽 Month Dropdown
                            Column(
                              children: [
                                const Text(
                                  "Select Month",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Obx(
                                  () => DropdownButton<String>(
                                    value: safetyReportController1
                                        .selectedMonth.value
                                        .toString(),
                                    items: monthMap.entries.map((entry) {
                                      return DropdownMenuItem<String>(
                                        value: entry.value
                                            .toString(), // The month name as String
                                        child: Text(entry.key),
                                      );
                                    }).toList(),
                                    onChanged: (month) {
                                      print(safetyReportController1
                                          .safetyReportData.length);
                                      setState(() {
                                        safetyReportController1.selectedMonth
                                            .value = int.parse(month!);
                                        safetyReportController1
                                            .updateDataForFilter("Monthly");
                                        // Call chart update or controller logic here
                                        updateCharts();
                                        //updateCards();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            sb18,
                            // 🔽 Week Dropdown
                            Column(
                              children: [
                                const Text(
                                  "Select Week:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                DropdownButton<Map<String, dynamic>>(
                                  value: safetyReportController1.selectedWeek,
                                  hint: Text('Select Week'),
                                  onChanged: (value) {
                                    setState(() {
                                      safetyReportController1.selectedWeek =
                                          value;
                                      safetyReportController1
                                          .updateDataForFilter("Weekly");
                                    });
                                  },
                                  items: weeks.map((week) {
                                    return DropdownMenuItem<
                                        Map<String, dynamic>>(
                                      value: week,
                                      child: Text(week['label']),
                                    );
                                  }).toList(),
                                ),
                                // Obx(
                                //   () => DropdownButton<int>(
                                //     value: int.parse(
                                //         safetyReportController1.selectedYear.value),
                                //     items: years.map((year) {
                                //       return DropdownMenuItem<int>(
                                //         value: year,
                                //         child: Text(year.toString()),
                                //       );
                                //     }).toList(),
                                //     onChanged: (year) {
                                //       print(safetyReportController1
                                //           .safetyReportData.length);
                                //       setState(() {
                                //         safetyReportController1.selectedYear.value =
                                //             year.toString();
                                //         safetyReportController1
                                //             .updateDataForFilter("Yearly");
                                //         // Call chart update or controller logic here
                                //         updateCharts();
                                //         updateCards();
                                //       });
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                            sb18,
                            // TextButton(
                            //   onPressed: () => showDateRangeDialog(context),
                            //   child: Text(
                            //     safetyReportController1.startDate != null &&
                            //             safetyReportController1.endDate != null
                            //         ? "${formatDate(safetyReportController1.startDate!)} - ${formatDate(safetyReportController1.endDate!)}"
                            //         : "Pick Date Range",
                            //     style: const TextStyle(
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: 16,
                            //       color: Colors.black,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            icon: Icon(Icons.filter_list_rounded),
          )
        ],
      ),
      body: ListView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: charts.length,
        itemBuilder: (context, index) {
          final chartIndex = index;

          return SizedBox(
            height: 300,
            child: GestureDetector(
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: charts[chartIndex], // Keep your chart inside
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            "$selectedFilter observations",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.grey.shade200,
                            child: const Icon(
                              Icons.more_horiz_rounded,
                              size: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
  SafetyReportChartController safetyReportController1,
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
                        safetyReportController1.updateDataForFilter(filter);
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
                    safetyReportController1.updateDataForFilter(selectedFilter);
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
