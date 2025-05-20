import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';

import 'package:rohan_suraksha_sathi/model/safety_report_model.dart';
import 'package:rohan_suraksha_sathi/widgets/new_bar_chart.dart';

class SafetyReportChartController extends GetxController {
  RxList<SafetyReportModel> safetyReportData = <SafetyReportModel>[].obs;
  RxList<ChartData> avgManPowers = <ChartData>[].obs;
  RxList<ChartData> tbtMeeting = <ChartData>[].obs;
  RxList<ChartData> safetyTraining = <ChartData>[].obs;
  RxList<ChartData> uaucResolved = <ChartData>[].obs;
  RxList<ChartData> safetyInduction = <ChartData>[].obs;
  RxList<ChartData> specificTraining = <ChartData>[].obs;
  RxList<ChartData> totalManHoursWorked = <ChartData>[].obs;
  RxList<ChartData> fatality = <ChartData>[].obs;
  RxList<ChartData> ltiCases = <ChartData>[].obs;
  RxList<ChartData> mtiCases = <ChartData>[].obs;
  RxList<ChartData> fac = <ChartData>[].obs;
  RxList<ChartData> majorEnvironmentalCases = <ChartData>[].obs;
  RxList<ChartData> animalAndInsectBiteCases = <ChartData>[].obs;
  RxList<ChartData> dangerousOccurrences = <ChartData>[].obs;
  RxList<ChartData> nearMissIncidents = <ChartData>[].obs;
  RxList<ChartData> fireCases = <ChartData>[].obs;
  RxList<ChartData> manDaysLost = <ChartData>[].obs;
  RxList<ChartData> fr = <ChartData>[].obs;
  RxList<ChartData> sr = <ChartData>[].obs;
  RxList<ChartData> safeLtiFreeDays = <ChartData>[].obs;
  RxList<ChartData> safeLtiFreeManHours = <ChartData>[].obs;
  RxList<ChartData> ncrPenaltyWarnings = <ChartData>[].obs;
  RxList<ChartData> suggestionsReceived = <ChartData>[].obs;
  RxList<ChartData> uaUcReportedClosed = <ChartData>[].obs;
  RxList<ChartData> tbtMeetingHours = <ChartData>[].obs;
  RxList<ChartData> personsSafetyInducted = <ChartData>[].obs;
  RxList<ChartData> specificSafetyTrainingHours = <ChartData>[].obs;
  RxList<ChartData> totalTrainingHours = <ChartData>[].obs;
  RxList<ChartData> safetyItemsInspections = <ChartData>[].obs;
  RxList<ChartData> safetyCommitteeMeetings = <ChartData>[].obs;
  RxList<ChartData> internalAudits = <ChartData>[].obs;
  RxList<ChartData> externalAudits = <ChartData>[].obs;
  RxList<ChartData> awardsAndAppreciations = <ChartData>[].obs;
  RxList<ChartData> safetyAwardRatingHighest = <ChartData>[].obs;
  RxList<ChartData> safetyAwardRatingLowest = <ChartData>[].obs;

  bool isOpen = false;
  int openedChart = 0;

  @override
  void onInit() {
    super.onInit();
    print("------------------getting safety data");
    safetyReportData.value =
        Strings.safetyreport.map((e) => SafetyReportModel.fromJson(e)).toList();
    print("------------------${Strings.safetyreport}");
    _populateChartData();
  }

  void _populateChartData() {
    List<SafetyReportModel> safetyReportData = filterLatestEntries(7);
    _updateChartData(safetyReportData);
  }

  void _updateChartData(List<SafetyReportModel> data) {
    avgManPowers.value =
        _aggregateData(data, (report) => report.totalAvgManpower.toDouble());
    tbtMeeting.value = _aggregateData(data, (report) => report.tbtMeetingHours);
    safetyTraining.value =
        _aggregateData(data, (report) => report.totalTrainingHours.toDouble());
    uaucResolved.value =
        _aggregateData(data, (report) => report.uaUcReportedClosed.toDouble());
    safetyInduction.value = _aggregateData(
        data, (report) => report.personsSafetyInducted.toDouble());
    specificTraining.value = _aggregateData(
        data, (report) => report.specificSafetyTrainingHours.toDouble());

    totalManHoursWorked.value =
        _aggregateData(data, (report) => report.totalManHoursWorked.toDouble());
    fatality.value =
        _aggregateData(data, (report) => report.fatality.toDouble());
    ltiCases.value =
        _aggregateData(data, (report) => report.ltiCases.toDouble());
    mtiCases.value =
        _aggregateData(data, (report) => report.mtiCases.toDouble());
    fac.value = _aggregateData(data, (report) => report.fac.toDouble());
    majorEnvironmentalCases.value = _aggregateData(
        data, (report) => report.majorEnvironmentalCases.toDouble());
    animalAndInsectBiteCases.value = _aggregateData(
        data, (report) => report.animalAndInsectBiteCases.toDouble());
    dangerousOccurrences.value = _aggregateData(
        data, (report) => report.dangerousOccurrences.toDouble());
    nearMissIncidents.value =
        _aggregateData(data, (report) => report.nearMissIncidents.toDouble());
    fireCases.value =
        _aggregateData(data, (report) => report.fireCases.toDouble());
    manDaysLost.value =
        _aggregateData(data, (report) => report.manDaysLost.toDouble());
    fr.value = _aggregateData(data, (report) => report.fr.toDouble());
    sr.value = _aggregateData(data, (report) => report.sr.toDouble());
    safeLtiFreeDays.value =
        _aggregateData(data, (report) => report.safeLtiFreeDays.toDouble());
    safeLtiFreeManHours.value =
        _aggregateData(data, (report) => report.safeLtiFreeManHours.toDouble());
    ncrPenaltyWarnings.value =
        _aggregateData(data, (report) => report.ncrPenaltyWarnings.toDouble());
    suggestionsReceived.value =
        _aggregateData(data, (report) => report.suggestionsReceived.toDouble());
    safetyItemsInspections.value = _aggregateData(
        data, (report) => report.safetyItemsInspections.toDouble());
    safetyCommitteeMeetings.value = _aggregateData(
        data, (report) => report.safetyCommitteeMeetings.toDouble());
    internalAudits.value =
        _aggregateData(data, (report) => report.internalAudits.toDouble());
    externalAudits.value =
        _aggregateData(data, (report) => report.externalAudits.toDouble());
    awardsAndAppreciations.value = _aggregateData(
        data, (report) => report.awardsAndAppreciations.toDouble());
    safetyAwardRatingHighest.value = _aggregateData(
        data, (report) => report.safetyAwardRatingHighest.toDouble());
    safetyAwardRatingLowest.value = _aggregateData(
        data, (report) => report.safetyAwardRatingLowest.toDouble());
  }

  /// Aggregates data by summing values for a specific period
  List<ChartData> _aggregateData(
    List<SafetyReportModel> data,
    double Function(SafetyReportModel) valueSelector,
  ) {
    final Map<String, double> aggregatedData = {};

    for (var report in data) {
      String periodKey = _getPeriodKey(report.createdAt);
      aggregatedData[periodKey] =
          (aggregatedData[periodKey] ?? 0) + valueSelector(report);
    }

    return aggregatedData.entries
        .map((entry) => ChartData(entry.key, entry.value))
        .toList();
  }

  /// Returns the period key (e.g., "2023-01 (Monthly)" or "2023-Q1 (Quarterly)")
  String _getPeriodKey(DateTime date) {
    switch (_selectedFilter) {
      case "Weekly":
        final weekStart = date.subtract(Duration(days: date.weekday - 1));
        final weekNumber =
            ((date.day - 1) ~/ 7) + 1; // Calculate the week number in the month
        return "Week $weekNumber ";
      case "Monthly":
        final monthName = _getMonthName(date.month); // Get month name
        return "$monthName, ${date.year}";
      case "Quarterly":
        final quarter = ((date.month - 1) ~/ 3) + 1;
        return "Q-$quarter";
      case "Yearly":
        return "${date.year}";
      case "Recent":
        return _formatDate(date);
      default:
        final monthName = _getMonthName(date.month);
        return "$monthName, ${date.year}";
    }
  }

  String _getMonthName(int month) {
    const monthNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return monthNames[month - 1];
  }

  /// Formats date as 'YYYY-MM-DD'
  String _formatDate(DateTime date) {
    return "${_getMonthName(date.month)} ${date.day.toString().padLeft(2, '0')}";
  }

  /// Updates chart data based on the selected filter
  void updateDataForFilter(String filter) {
    _selectedFilter = filter;
    List<SafetyReportModel> filteredData;

    if (filter == "Recent") {
      filteredData = filterLatestEntries(7);
    } else {
      filteredData =
          safetyReportData.toList(); // No additional filtering for now.
    }

    _updateChartData(filteredData);
  }

  String _selectedFilter = "Recent";

  /// Fetches the latest N entries for daily display
  List<SafetyReportModel> filterLatestEntries(int count) {
    // Reverse the list to get the most recent entries first, then take the desired count
    return safetyReportData
        .toList()
        .reversed
        .take(count)
        .toList()
        .reversed
        .toList();
  }
}
