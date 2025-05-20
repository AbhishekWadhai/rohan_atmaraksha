import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';
import 'package:rohan_suraksha_sathi/model/checklist_model.dart';

import 'package:rohan_suraksha_sathi/model/secific_training_model.dart';

import 'package:rohan_suraksha_sathi/services/api_services.dart';

class ChecklistController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  RxList<ChecklistModel> checkLists = <ChecklistModel>[].obs;
  RxInt currentPage = 0.obs;
  final int itemsPerPage = 20;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    print("---------------------On init called---------------------");
    getPermitData();
  }

  List<ChecklistModel> get paginatedTrainingList {
    final filteredList = checkLists
        .where((checkList) =>
            (checkList.project.projectName?.toLowerCase() ?? "")
                .contains(searchQuery.value.toLowerCase()) ||
            checkList.date.contains(searchQuery.value))
        .toList();

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
    if ((currentPage.value + 1) * itemsPerPage < checkLists.length) {
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
      final meetingtData = await ApiService().getRequest("checklist");

      if (meetingtData == null) {
        throw Exception("Received null data from API");
      }

      // Ensure that the API response is a List of Map<String, dynamic>
      if (meetingtData is List) {
        // Check for any null elements in the list
        if (Strings.roleName == "Admin") {
          checkLists.value = meetingtData
              .where((e) => e != null)
              .map((e) => ChecklistModel.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          // checkLists.value = meetingtData
          //     .where((e) => e != null)
          //     .map((e) => SpecificTraining.fromJson(e as Map<String, dynamic>))
          //     .where((data) =>
          //         data.project.id == Strings.endpointToList['project']['_id'])
          //     .toList();
        }
        print("---------------------Permit called---------------------");
        print(jsonEncode(checkLists));
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
