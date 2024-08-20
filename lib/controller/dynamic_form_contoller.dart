import 'package:flutter/material.dart';
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
  RxMap<String, dynamic> formData = <String, dynamic>{}.obs;

  RxMap<String, String> dropdownSelections = <String, String>{}.obs;
  RxMap<String, String> radioSelections = <String, String>{}.obs;

  bool fieldsLoaded = false; // Flag to check if fields are loaded

  @override
  void onInit() {
    super.onInit();
    loadFormData();
  }

  // Call this method when the form is first loaded
  void initializeFormData(Map<String, dynamic>? initialData) {
    if (initialData != null) {
      initialData.forEach((key, value) {
        if (value is List) {
          // Convert list elements to strings
          formData[key] = value.map((e) => e["_id"].toString()).toList();
        } else if (value is Map) {
          formData[key] = value["_id"];
        } else {
          formData[key] = value;
        }
      });
    }
    print(
        "------------------------------------00000000000000 Current Page Data 0000000000000--------------------------------");
    print(jsonEncode(formData));
  }

  Future<void> getPageFields(String pageName) async {
    pageFields.value = await formResponse
        .where((e) => e.page == pageName)
        .expand((e) => e.pageFields)
        .toList();

    update();
  }

  Future<void> loadFormData() async {
    isLoading(true);
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        await loadJsonFromAssets();
      } else {
        await loadJsonFromAssets(); // Should be loadJsonFromApi() if online
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
      // print(
      //     "------------------------------------00000000000000000000000000000000000000000000--------------------------------");
      // print(jsonEncode(formResponse));
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

  Future<List<Map<String, String>>> getDropdownData(
      String endpoint, String key) async {
    final dropdownResult = await ApiService().getRequest(endpoint);
    return dropdownResult
        .map<Map<String, String>>((element) => {
              '_id': element['_id'].toString(),
              key: element[key].toString(), // Use the dynamic key here
            })
        .toList();
  }

  void deleteData() async {}

  void updateFormData(String key, dynamic value) {
    formData[key] = value;
    update();
    print(
        "------------------------------------00000000000000 Updated Data 0000000000000--------------------------------");
    print("Updated form data: $formData");
  }

  void updateDropdownSelection(String key, String value) {
    dropdownSelections[key] = value;
    print(jsonEncode(dropdownSelections));
    updateFormData(key, value);
  }

  void updateRadioSelection(String key, String value) {
    radioSelections[key] = value;
    updateFormData(key, value);
  }

  //validations for the dynamic form
  String? validateTextField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  String? validateDropdown(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select an option';
    }
    return null;
  }

  Future<void> updateData() async {
    try {
      print(
          "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUubmitted Data ");
      print(jsonEncode(formData));

      await ApiService().updateData("permit", formData["_id"], formData);
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('Data Updated Successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Get.back();
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text('Error Updating data: $e'),
          backgroundColor: Colors.red,
        ),
      );
      print(e);
    }
  }

  Future<void> submitForm() async {
    isLoading(true);
    print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSubmitted Data");
    print(jsonEncode(formData));
    try {
      final response = await ApiService().postRequest("permit", formData);
      if (response == 201) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text('Data Submitted Successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Get.back();
      }
    } catch (e) {
      print("Error submitting form: $e");
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text('Error submitting form: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      isLoading(false);
    }
  }
}
