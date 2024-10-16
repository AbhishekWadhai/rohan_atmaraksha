import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_atmaraksha/app_constants/app_strings.dart';
import 'package:rohan_atmaraksha/model/uauc_model.dart';
import 'package:rohan_atmaraksha/routes/routes_string.dart';
import 'package:rohan_atmaraksha/services/api_services.dart';
import 'package:rohan_atmaraksha/widgets/dynamic_form.dart';

class HomeController extends GetxController {
  RxList<UaUc> uaucList = <UaUc>[].obs;
  String? payLoad;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await getPermitData();

    checkPendingActions();
  }

  @override
  void onReady() {
    super.onReady();
    // This will be called when the HomeController is ready
    // Use this to check pending actions when the view is displayed
    ever(uaucList, (_) => checkPendingActions());
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
        uaucList.value = meetingtData
            .where((e) => e != null)
            .map((e) => UaUc.fromJson(e as Map<String, dynamic>))
            .toList();
        print("---------------------Permit called---------------------");
        print(jsonEncode(uaucList));
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

  checkPendingActions() {
    if (uaucList.any((uauc) =>
        uauc.assignedTo?.id == Strings.userId && uauc.status == "Open")) {
      print("One task assigned to you");
      Get.snackbar("Alert", "Some Actions are pending",
          backgroundColor: Colors.yellow,
          duration: const Duration(minutes: 30),
          isDismissible: false,
          mainButton: TextButton(
              onPressed: () {
                Get.back();
                Get.toNamed(
                  Routes.soraPage,
                );
              },
              child: Text("click")));
    } else {
      Get.snackbar("Alert", "No pending actions",
          backgroundColor: Colors.green, isDismissible: true);
    }
  }
}
