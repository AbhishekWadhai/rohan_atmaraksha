import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';
import 'package:rohan_suraksha_sathi/model/safety_report_model.dart';
import 'package:rohan_suraksha_sathi/services/api_services.dart';

class SafetyReportController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  RxBool isLoading = false.obs;
  RxList<SafetyReportModel> reportList = <SafetyReportModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    print("---------------------On init called---------------------");
    getPermitData();
  }

  getPermitData() async {
    isLoading.value = true;
    try {
      final meetingtData = await ApiService().getRequest("safetyreport");

      if (meetingtData == null) {
        throw Exception("Received null data from API");
      }

      // Ensure that the API response is a List of Map<String, dynamic>
      if (meetingtData is List) {
        // Check for any null elements in the list
        reportList.value = meetingtData
            .where((e) => e != null)
            .map((e) => SafetyReportModel.fromJson(e as Map<String, dynamic>))
            .where((induction) =>
                induction.project.id ==
                Strings.endpointToList['project']['_id'])
            .toList();
        // reportList.value = meetingtData
        //     .where((e) => e != null)
        //     .map((e) => SafetyReportModel.fromJson(e as Map<String, dynamic>))
        //     .toList();
        print("---------------------Safety Report---------------------");
        print(jsonEncode(reportList));
      } else {
        throw Exception("Unexpected data format");
      }

      print("---------------------Safety Report---------------------");
      print("Permit List Length: ${meetingtData.length}");
    } catch (e) {
      print("Error fetching permit data: $e");
      // Handle the error accordingly, e.g., show a dialog or retry
    } finally {
      isLoading.value = false;
    }
  }

  deletePermit(String key) async {
    await ApiService().deleteRequest("permit", key);
    getPermitData();
  }
}
