import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_atmaraksha/model/work_permit_model.dart';
import 'package:rohan_atmaraksha/services/api_services.dart';
import 'package:rohan_atmaraksha/services/shared_preferences.dart';

class WorkPermitController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList<WorkPermit> workPermitList = <WorkPermit>[].obs;

  @override
  void onInit() {
    super.onInit();
    print("---------------------On init called---------------------");
    getData();
    getPermitData();
  }

  getData() async {
    String t = await SharedPrefService().getString("token") ?? "";
    print(t);
  }

  getPermitData() async {
    try {
      final permitData = await ApiService().getRequest("workpermit");

      if (permitData == null) {
        throw Exception("Received null data from API");
      }

      // Ensure that the API response is a List of Map<String, dynamic>
      if (permitData is List) {
        // Check for any null elements in the list
        workPermitList.value = permitData
            .where((e) => e != null)
            .map((e) => WorkPermit.fromJson(e as Map<String, dynamic>))
            .toList();
        print("---------------------Permit called---------------------");
        print(jsonEncode(workPermitList));
      } else {
        throw Exception("Unexpected data format");
      }

      print("---------------------Permit called---------------------");
      print("Permit List Length: ${workPermitList.length}");
    } catch (e) {
      print("Error fetching permit data: $e");
      // Handle the error accordingly, e.g., show a dialog or retry
    }
  }

  deletePermit(String key) async {
    await ApiService().deleteRequest("workpermit", key);
    getPermitData();
  }
}
