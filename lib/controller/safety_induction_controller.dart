import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';
import 'package:rohan_suraksha_sathi/model/induction_model.dart';
import 'package:rohan_suraksha_sathi/services/api_services.dart';

class SafetyInductionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  RxList<Induction> inductionList = <Induction>[].obs;
  var searchQuery = ''.obs;
  var currentPage = 0.obs;
  final int itemsPerPage = 100;

  @override
  void onInit() {
    super.onInit();
    print("---------------------On init called---------------------");
    getPermitData();
  }

  List<Induction> get filteredInductions {
    return inductionList
        .where((induction) =>
            induction.typeOfTopic.topicTypes
                ?.toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ??
            false)
        .toList();
  }

  // Paginated inductions
  List<Induction> get paginatedInductions {
    int start = currentPage.value * itemsPerPage;
    int end = start + itemsPerPage;
    return filteredInductions.sublist(start,
        end > filteredInductions.length ? filteredInductions.length : end);
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    currentPage.value = 0; // Reset to the first page after a new search
  }

  void nextPage() {
    if ((currentPage.value + 1) * itemsPerPage < filteredInductions.length) {
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
      final meetingtData = await ApiService().getRequest("induction");

      if (meetingtData == null) {
        throw Exception("Received null data from API");
      }

      // Ensure that the API response is a List of Map<String, dynamic>
      if (meetingtData is List) {
        // Check for any null elements in the list
        if (Strings.roleName == "Admin") {
          inductionList.value = meetingtData
              .where((e) => e != null)
              .map((e) => Induction.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          inductionList.value = meetingtData
              .where((e) => e != null)
              .map((e) => Induction.fromJson(e as Map<String, dynamic>))
              .where((induction) =>
                  induction.project.id ==
                  Strings.endpointToList['project']['_id'])
              .toList();
        }
        print("---------------------Permit called---------------------");
        print(jsonEncode(inductionList));
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
    await ApiService().deleteRequest("induction", key);
    getPermitData();
  }
}
