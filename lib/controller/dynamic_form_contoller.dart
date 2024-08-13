import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rohan_atmaraksha/model/form_data_model.dart';
import 'package:rohan_atmaraksha/services/api_services.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class DynamicFormController extends GetxController {
  var formResponse = <ResponseForm>[].obs;
  var isLoading = true.obs;
  RxList<PageField> pageFields = <PageField>[].obs;
  RxList<String> dropdownData = <String>[].obs;
  var formData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadFormData();
  }

  getPageFields(String pageName) async {
    pageFields.value = await formResponse
        .where((e) => e.page == pageName)
        .expand((e) => e.pageFields)
        .toList();
    print(
        "------------------------------------00000000000000000000000000000000000000000000--------------------------------");
    print(jsonEncode(pageFields));
    update();
  }

  Future<void> loadFormData() async {
    isLoading(true);
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        await loadJsonFromAssets();
      } else {
        await loadJsonFromAssets();
      }
      print("Form data loaded: $formData");
    } catch (e) {
      print("Error loading form data: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadJsonFromAssets() async {
    try {
      final String response =
          await rootBundle.loadString('assets/json/form.json');
      final data = await json.decode(response) as List<dynamic>;
      formResponse.value = data
          .map<ResponseForm>((element) => ResponseForm.fromJson(element))
          .toList();
      print("Loaded form data from assets: $formResponse");
      print(
          "------------------------------------00000000000000000000000000000000000000000000--------------------------------");
      print(jsonEncode(formResponse));
    } catch (e) {
      print("Error loading JSON from assets: $e");
    }
  }

  Future<void> loadJsonFromApi() async {
    try {
      final jsonResult = await ApiService().getRequest("fields");
      formResponse.value = jsonResult
          .map<ResponseForm>((element) => ResponseForm.fromJson(element))
          .toList();
      print("Loaded form data from API: $formResponse");
    } catch (e) {
      print("Error loading JSON from API: $e");
    }
  }

  Future<List<String>> getDropdownData(String endpoint, String key) async {
    final dropdownResult = await ApiService().getRequest(endpoint);
    print(
        "------------------------------------Dropdown Data--------------------------------");
    print(jsonEncode(
        dropdownResult.map((element) => element[key].toString()).toList()));

    return dropdownResult
        .map<String>((element) => element["_id"].toString())
        .toList();
  }

  void deleteData() async {}

  void updateFormData(String key, dynamic value) {
    formData[key] = value;
    print("Updated form data: $formData");
  }

  Future<void> submitForm() async {
    isLoading(true);
    print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSubmitted Data");
    print(jsonEncode(formData));
    try {
      await ApiService().postRequest("permit", formData);
    } catch (e) {
      print("Error submitting form: $e");
    } finally {
      isLoading(false);
    }
  }
}
