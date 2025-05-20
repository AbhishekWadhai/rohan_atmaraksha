import 'dart:convert';

import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';
import 'package:rohan_suraksha_sathi/model/work_permit_model.dart';
import 'package:rohan_suraksha_sathi/services/api_services.dart';
import 'package:rohan_suraksha_sathi/services/shared_preferences.dart';

class WorkPermitController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList<WorkPermit> workPermitList = <WorkPermit>[].obs;
  var currentPage = 0.obs;
  final int itemsPerPage = 20;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    print("---------------------On init called---------------------");
    getData();
    getPermitData();
  }

  // Get filtered and paginated permits
  List<dynamic> get paginatedWorkPermits {
    final filteredList = workPermitList
        .where((permit) =>
            (permit.workDescription?.toLowerCase() ?? "")
                .contains(searchQuery.value.toLowerCase()) ||
            (permit.date ?? "").contains(searchQuery.value))
        .toList();

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
    if ((currentPage.value + 1) * itemsPerPage < workPermitList.length) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
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
        // workPermitList.value = permitData
        //     .where((e) => e != null)
        //     .map((e) => WorkPermit.fromJson(e as Map<String, dynamic>))
        //     .toList();
        if (Strings.roleName == "Admin") {
          workPermitList.value = permitData
              .where((e) => e != null)
              .map((e) => WorkPermit.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          workPermitList.value = permitData
              .where((e) => e != null)
              .map((e) => WorkPermit.fromJson(e as Map<String, dynamic>))
              .where((permit) =>
                  permit.project?.id ==
                  Strings.endpointToList['project']['_id'])
              .toList();
        }
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
