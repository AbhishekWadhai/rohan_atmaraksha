import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rohan_atmaraksha/app_constants/app_strings.dart';
import 'package:rohan_atmaraksha/model/form_data_model.dart';
import 'package:rohan_atmaraksha/services/api_services.dart';
import 'package:rohan_atmaraksha/services/image_service.dart';
import 'package:rohan_atmaraksha/services/location_service.dart';

class DynamicFormController extends GetxController {
  final ImageService imageUploadService = ImageService();

  // Observable variables
  var formResponse = <ResponseForm>[].obs;
  var isLoading = true.obs;
  RxList<PageField> pageFields = <PageField>[].obs;
  RxMap<String, dynamic> formData = <String, dynamic>{}.obs;

  RxMap<String, String> dropdownSelections = <String, String>{}.obs;
  RxMap<String, String> radioSelections = <String, String>{}.obs;

  bool fieldsLoaded = false;

  // Selected chips observable
  var selectedChips = <String>[].obs;
  // Observable list for storing attendees' names as maps
  var subformData = <Map<String, dynamic>>[].obs;

  // Lifecycle hook
  @override
  void onInit() {
    super.onInit();
    loadFormData();
  }

  // Function to check if the user has permission to view a field
  bool hasViewPermission(List<String> requiredPermissions) {
    return requiredPermissions.isEmpty ||
        requiredPermissions.any((perm) => Strings.permisssions.contains(perm));
  }

  // Function to check if the user has permission to edit a field
  bool hasEditPermission(List<String> requiredPermissions) {
    return requiredPermissions.isEmpty ||
        requiredPermissions.any((perm) => Strings.permisssions.contains(perm));
  }

  Future<void> initializeAndFetchData(
      Map<String, dynamic>? initialData, String pageName) async {
    await getPageFields(pageName);
    await initializeFormData(initialData); // Initialize form data first

    // Then call getPageFields after initialization
  }

  // Form Data Initialization
  initializeFormData(Map<String, dynamic>? initialData) {
    print("Initializing form data...");
    print(initialData);

    if (initialData != null) {
      initialData.forEach((key, value) {
        // Find the matching field in pageFields based on the header (key)
        PageField? pageField = pageFields.firstWhere(
          (field) => field.headers == key,
          orElse: () => PageField(
              headers: '',
              type: '',
              title: "",
              id: ""), // Safely return null if no matching field is found
        );

        print("Processing key: $key with value: $value");

        if (pageField != null) {
          String fieldType = pageField.type;

          if (value is List) {
            formData[key] = value.map((e) {
              if (e is Map && e.containsKey("_id")) {
                // Store only _id for multiselect
                return fieldType == "multiselect" ? e["_id"].toString() : e;
              } else if (e is String) {
                return e;
              }
              return e.toString();
            }).toList();
          } else if (value is Map && value.containsKey("_id")) {
            // Store entire map for subform fields, otherwise store only _id
            formData[key] = value["_id"].toString();
          } else {
            formData[key] = value;
          }
        } else {
          // If no matching pageField is found, store the value as it is
          print("No matching pageField found for key: $key");
          formData[key] = value;
        }
      });
    }

    print("Initialized form data: ${jsonEncode(formData)}");
  }

  void updateSwitchSelection(String header, bool newValue) {
    formData[header] = newValue;
    update(); // Update the UI if using GetX
  }

  Future<dynamic> pickAndUploadImage(
      String key, String endpoint, String source) async {
    File? imageFile;
    // Pick an image
    if (source == "camera") {
      imageFile = await imageUploadService.pickImage(ImageSource.camera);
    } else {
      imageFile = await imageUploadService.pickImage(ImageSource.gallery);
    }
    if (imageFile != null) {
      // Upload the image and get the URL
      String? imageUrl =
          await imageUploadService.uploadImage(imageFile, endpoint);

      if (imageUrl != null) {
        // Save the image URL in the formData
        updateFormData(key, imageUrl);
        print('Image uploaded successfully: $imageUrl');
      } else {
        print('Image upload failed.');
      }
    } else {
      print('No image selected.');
    }
  }

  // Toggle chip selection for multi-select fields
  void toggleChipSelection(String chipValue) {
    if (selectedChips.contains(chipValue)) {
      selectedChips.remove(chipValue);
    } else {
      selectedChips.add(chipValue);
    }
  }

  // Form Fields Loader
  Future<void> getPageFields(String pageName) async {
    pageFields.value = await formResponse
        .where((e) => e.page == pageName)
        .expand((e) => e.pageFields)
        .toList();
    update();
  }

  // Form Data Loader
  Future<void> loadFormData() async {
    isLoading(true);
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        await loadJsonFromAssets();
      } else {
        await loadJsonFromAssets(); // Replace with loadJsonFromApi() for online mode
      }
      print("Form data loaded: $formData");
    } catch (e) {
      print("Error loading form data: $e");
    } finally {
      isLoading(false);
    }
  }

  // Method to add a new attendee
  void addAttendee(Map<String, String> attendee) {
    print("function called");
    subformData.add(attendee);
    print("Updated attendees list: $subformData");
  }

  // Load JSON from Assets
  Future<void> loadJsonFromAssets() async {
    try {
      final String response =
          await rootBundle.loadString('assets/json/form.json');
      final data = await json.decode(response) as List<dynamic>;
      formResponse.value = data
          .map<ResponseForm>((element) => ResponseForm.fromJson(element))
          .toList();
      print("Loaded form data from assets: $formResponse");
    } catch (e) {
      print("Error loading JSON from assets: $e");
    }
  }

  // Load JSON from API
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

  // Update form data for input fields
  void updateFormData(String key, dynamic value) {
    formData[key] = value;
    update();
    print("Updated form data: ${jsonEncode(formData)}");
  }

  // Update dropdown selection
  void updateDropdownSelection(String key, String value) {
    dropdownSelections[key] = value;
    updateFormData(key, value);
  }

  // Update radio button selection
  void updateRadioSelection(String key, String value) {
    radioSelections[key] = value;
    updateFormData(key, value);
  }

  // Get dropdown data dynamically from API
  Future<List<Map<String, String>>> getDropdownData(
      String endpoint, String key) async {
    final dropdownResult = await ApiService().getRequest(endpoint);
    return dropdownResult
        .map<Map<String, String>>((element) => {
              '_id': element['_id'].toString(),
              key: element[key].toString(),
            })
        .toList();
  }

  // Form Submission
  Future<void> submitForm(String endpoint) async {
    isLoading(true);
    try {
      final response = await ApiService().postRequest(endpoint, formData);
      if (response == 201) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text('Data Submitted Successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Get.back(result: true);
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

  // Data Update
  Future<void> updateData(String endpoint) async {
    try {
      await ApiService().updateData(endpoint, formData["_id"], formData);
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('Data Updated Successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Get.back(result: true);
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

  // Fetch Geolocation
  Future<void> fetchGeolocation(String fieldKey) async {
    try {
      Position position = await LocationService().determinePosition();
      String latLong = "${position.latitude}, ${position.longitude}";
      updateFormData(fieldKey, latLong);
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  // Validations for form fields
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
}
