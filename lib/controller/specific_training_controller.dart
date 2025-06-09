import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';

import 'package:rohan_suraksha_sathi/model/secific_training_model.dart';

import 'package:rohan_suraksha_sathi/services/api_services.dart';

class SpecificTrainingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  RxList<SpecificTraining> trainingList = <SpecificTraining>[].obs;
  RxInt currentPage = 0.obs;
  final int itemsPerPage = 20;
  RxString searchQuery = ''.obs;
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();
  final RxList<Map<String, dynamic>> topics =
      (Strings.endpointToList["topic"] as List?)
              ?.cast<Map<String, dynamic>>()
              .obs ??
          <Map<String, dynamic>>[].obs;
  var selectedTopics = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    print("---------------------On init called---------------------");
    getPermitData();
  }

  List<SpecificTraining> get paginatedTrainingList {
    final filteredList = trainingList.where((training) {
      // Search query matching
      final projectName = training.project.projectName?.toLowerCase() ?? "";
      final dateText = training.date.toLowerCase();
      final matchesSearch =
          projectName.contains(searchQuery.value.toLowerCase()) ||
              dateText.contains(searchQuery.value.toLowerCase());

      // Parse training date
      final trainingDate = DateTime.tryParse(training.date);

      // Date range filtering
      final matchesDate = (startDate.value == null ||
              (trainingDate != null &&
                  (trainingDate.isAtSameMomentAs(startDate.value!) ||
                      trainingDate.isAfter(startDate.value!)))) &&
          (endDate.value == null ||
              (trainingDate != null &&
                  trainingDate
                      .isBefore(endDate.value!.add(const Duration(days: 1)))));

      final matchesTopic = selectedTopics.isEmpty ||
          (training.typeOfTopic != null &&
              training.typeOfTopic!
                  .any((topic) => selectedTopics.contains(topic.id)));

      return matchesSearch && matchesDate && matchesTopic;
    }).toList();

    int start = currentPage.value * itemsPerPage;
    int end = start + itemsPerPage;
    return filteredList.sublist(
        start, end > filteredList.length ? filteredList.length : end);
  }

  // Update the search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    currentPage.value = 0; // Reset to the first page when a new search is made
  }

  // Navigate to the next page
  void nextPage() {
    if ((currentPage.value + 1) * itemsPerPage < trainingList.length) {
      currentPage.value++;
    }
  }

  // Navigate to the previous page
  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }

  getPermitData() async {
    try {
      final meetingtData = await ApiService().getRequest("specific");

      if (meetingtData == null) {
        throw Exception("Received null data from API");
      }

      // Ensure that the API response is a List of Map<String, dynamic>
      if (meetingtData is List) {
        // Check for any null elements in the list
        if (Strings.roleName == "Admin") {
          trainingList.value = meetingtData
              .where((e) => e != null)
              .map((e) => SpecificTraining.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          trainingList.value = meetingtData
              .where((e) => e != null)
              .map((e) => SpecificTraining.fromJson(e as Map<String, dynamic>))
              .where((data) =>
                  data.project.id == Strings.endpointToList['project']['_id'])
              .toList();
        }
        print("---------------------Permit called---------------------");
        print(jsonEncode(trainingList));
      } else {
        throw Exception("Unexpected data format");
      }

      print("---------------------Permit called---------------------");
      print("Permit List Length: ${meetingtData.length}");
    } catch (e) {
      print("Error fetching permit data: $e");
      // Handle the error accordingly, e.g., show a dialog or retry
    }
  }

  deleteSelection(String key) async {
    await ApiService().deleteRequest("specific", key);
    getPermitData();
  }
}
