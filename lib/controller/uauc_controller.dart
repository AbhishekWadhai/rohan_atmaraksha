import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';
import 'package:rohan_suraksha_sathi/model/uauc_model.dart';
import 'package:rohan_suraksha_sathi/services/api_services.dart';

class UaucController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  RxList<UaUc> uaucList = <UaUc>[].obs;
  var currentPage = 0.obs;
  final int itemsPerPage = 100; // You can change this to your preferred number
  var searchQuery = ''.obs;
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();
  final RxList<String> selectedSeverities = <String>[].obs;

  @override
  void onInit() {
    super.onInit();

    getPermitData();
  }

  void updateDateRange(DateTime? start, DateTime? end) {
    startDate.value = start;
    endDate.value = end;
    currentPage.value = 0;
  }

  List<dynamic> get paginatedWorkPermits {
    final filteredList = uaucList.where((uauc) {
      final projectName = uauc.project?.projectName?.toLowerCase() ?? "";
      final matchesSearch =
          projectName.contains(searchQuery.value.toLowerCase()) ||
              (uauc.date?.contains(searchQuery.value) ?? false);

      final uaucDate = DateTime.tryParse(uauc.date ?? "");

      final matchesDate = (startDate.value == null ||
              (uaucDate != null && !uaucDate.isBefore(startDate.value!))) &&
          (endDate.value == null ||
              (uaucDate != null && !uaucDate.isAfter(endDate.value!)));

      final matchSeverity = selectedSeverities.isEmpty ||
          selectedSeverities.contains(uauc.riskValue?.severity);

      return matchesSearch && matchesDate && matchSeverity;
    }).toList();

    int start = currentPage.value * itemsPerPage;
    int end = start + itemsPerPage;
    return filteredList.sublist(
        start, end > filteredList.length ? filteredList.length : end);
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    currentPage.value = 0; // Reset to the first page after a new search
  }

  void nextPage() {
    if ((currentPage.value + 1) * itemsPerPage < uaucList.length) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }

  getPermitData() async {
    try {
      final meetingtData = await ApiService().getRequest("uauc");

      if (meetingtData == null) {
        throw Exception("Received null data from API");
      }

      // Ensure that the API response is a List of Map<String, dynamic>
      if (meetingtData is List) {
        // Check for any null elements in the list
        if (Strings.roleName == "Admin") {
          uaucList.value = meetingtData
              .where((e) => e != null)
              .map((e) => UaUc.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          uaucList.value = meetingtData
              .where((e) => e != null)
              .map((e) => UaUc.fromJson(e as Map<String, dynamic>))
              .where((induction) =>
                  induction.project!.id ==
                  Strings.endpointToList['project']['_id'])
              .toList();
        }

        print(jsonEncode(uaucList));
      } else {
        throw Exception("Unexpected data format");
      }

      print("Permit List Length: ${meetingtData.length}");
    } catch (e) {
      print("Error fetching permit data: $e");
      // Handle the error accordingly, e.g., show a dialog or retry
    }
  }

  deleteSelection(String key) async {
    await ApiService().deleteRequest("uauc", key);
    getPermitData();
  }
}
