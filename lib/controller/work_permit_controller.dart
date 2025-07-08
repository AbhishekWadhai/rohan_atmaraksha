import 'dart:convert';

import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';
import 'package:rohan_suraksha_sathi/model/work_permit_model.dart';
import 'package:rohan_suraksha_sathi/services/api_services.dart';
import 'package:rohan_suraksha_sathi/services/shared_preferences.dart';

class WorkPermitController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList<WorkPermit> workPermitList = <WorkPermit>[].obs;
  RxBool isLoading = false.obs;
  var currentPage = 0.obs;
  final int itemsPerPage = 20;
  var searchQuery = ''.obs;
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();
  final RxList<Map<String, dynamic>> permitTypes =
      (Strings.endpointToList["permitstype"] as List?)
              ?.cast<Map<String, dynamic>>()
              .obs ??
          <Map<String, dynamic>>[].obs;

  RxnString selectedPermitTypeId = RxnString(); // Stores selected _id
  @override
  void onInit() {
    super.onInit();
    print("---------------------On init called---------------------");
    getData();
    getPermitData();
  }

  // Get filtered and paginated permits
  List<dynamic> get paginatedWorkPermits {
    final filteredList = workPermitList.where((permit) {
      final workDesc = permit.workDescription?.toLowerCase() ?? "";
      final query = searchQuery.value.toLowerCase();
      final dateStr = permit.date ?? "";

      final matchesSearch =
          workDesc.contains(query) || dateStr.contains(searchQuery.value);

      final permitDate = DateTime.tryParse(dateStr);
      final matchesStartDate = startDate.value == null ||
          (permitDate != null && !permitDate.isBefore(startDate.value!));
      final matchesEndDate = endDate.value == null ||
          (permitDate != null && !permitDate.isAfter(endDate.value!));

      final matchesType = selectedPermitTypeId.value == null ||
          permit.permitTypes?.id == selectedPermitTypeId.value;

      return matchesSearch && matchesStartDate && matchesEndDate && matchesType;
    }).toList();

    int start = currentPage.value * itemsPerPage;
    int end = start + itemsPerPage;

    if (start >= filteredList.length) return [];

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
    isLoading.value = true;
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
    } finally {
      isLoading.value = false;
    }
  }

  deletePermit(String key) async {
    await ApiService().deleteRequest("workpermit", key);
    getPermitData();
  }
}
