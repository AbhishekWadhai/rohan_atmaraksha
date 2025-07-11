import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';
import 'package:rohan_suraksha_sathi/helpers/dialogos.dart';
import 'package:rohan_suraksha_sathi/model/form_data_model.dart';
import 'package:rohan_suraksha_sathi/routes/routes_string.dart';
import 'package:rohan_suraksha_sathi/services/api_services.dart';
import 'package:rohan_suraksha_sathi/services/image_service.dart';
import 'package:rohan_suraksha_sathi/services/load_dropdown_data.dart';
import 'package:rohan_suraksha_sathi/services/location_service.dart';
import 'package:rohan_suraksha_sathi/services/notification_service/notification_handler.dart';
import 'package:rohan_suraksha_sathi/services/shared_preferences.dart';
import 'package:rohan_suraksha_sathi/widgets/custom_alert_dialog.dart';
import 'package:rohan_suraksha_sathi/widgets/progress_indicators.dart';
import 'package:signature/signature.dart';

class DynamicFormController extends GetxController {
  RxInt severity = 0.obs;
  RxInt likelihood = 0.obs;
  RxString riskLevel = 'Low'.obs;
  RxList<Map<String, dynamic>> checkList = <Map<String, dynamic>>[].obs;
  RxList<PageField> additionalFields = <PageField>[].obs;
  RxBool isSaved = false.obs;
  final CameraService cameraService = CameraService();
  RxMap<String, dynamic> customFields = <String, dynamic>{}.obs;
  // Observable variables
  var formResponse = <ResponseForm>[].obs;
  var isLoading = true.obs;
  RxList<PageField> pageFields = <PageField>[].obs;
  RxMap<String, dynamic> formData = <String, dynamic>{}.obs;
  Map<String, Timer?> debounceMap = {};
  RxMap<String, String> dropdownSelections = <String, String>{}.obs;
  RxMap<String, String> radioSelections = <String, String>{}.obs;
  String pagename = "";
  bool fieldsLoaded = false;
  final Map<String, TextEditingController> textControllers = {};
  RxMap<String, SignatureController> signatureControllers =
      <String, SignatureController>{}.obs;
  // Selected chips observable
  var selectedChips = <String>[].obs;
  // Observable list for storing attendees' names as maps
  var subformData = <Map<String, dynamic>>[].obs;
  final imageErrors = <String, String?>{}.obs;
  final matrixError = <String, String?>{}.obs;

  // Lifecycle hook
  @override
  void onInit() {
    super.onInit();
    loadFormData();
  }

  saveForm() async {
    //await SharedPrefService
  }
  getCustomFields(String permitKey) {
    final newFields = Strings.workpermitPageFild;
    if (newFields != null) {
      // Find the matching permit by comparing permitsType with checklistKey
      final matchingFields = newFields.firstWhere(
        (permit) => permit["permitType"]["permitsType"] == permitKey,
        orElse: () => null,
      );
      if (matchingFields != null) {
        // Assign its SafetyChecks to checkList.value
        additionalFields.value =
            (matchingFields["PageFields"] as List<dynamic>?)
                    ?.map((e) => PageField.fromJson(e as Map<String, dynamic>))
                    .toList()
                    .cast<PageField>() ??
                [];
      } else {
        // If no match is found, clear the checklist
        print(
            ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::if null");
        print(matchingFields);
      }
    }
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

  initializeFormData(Map<String, dynamic>? initialData) {
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
        print("------------------------------${pageField.type}");
        print("Processing key: $key with value: $value----${pageField.type}");

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
            formData[key] = value;
          } else if (value is String) {
            formData[key] = value.toString();
          } else if (value is int || value is double) {
            formData[key] = value;
          } else if (value is bool) {
            // Add check for boolean values
            formData[key] = value;
          } else if (value is Map) {
            // Add check for boolean values
            formData[key] = value;
          }
        } else {
          // If no matching pageField is found, store the value as it is
          print("No matching pageField found for key: $key");
          formData[key] = value.toString();
        }
      });
    }

    checkList.value = (formData["safetyMeasuresTaken"] as List<Object>?)
            ?.map((item) => item is Map<String, dynamic> ? item : {})
            .toList()
            .cast<Map<String, dynamic>>() ??
        [];
    customFields.value =
        (formData["customFields"] as Map<String, dynamic>?) ?? {};
    getCustomFields(formData["permitTypes"]?["permitsType"] ?? "");

    print("Initialized form data: ${jsonEncode(formData["comment"])}");
  }

  void updateSwitchSelection(String header, bool newValue) {
    formData[header] = newValue;
    update(); // Update the UI if using GetX
  }

  Future<dynamic> pickAndUploadImage(
      String key, String endpoint, String source) async {
    File? imageFile;

    try {
      // Show loading dialog
      Get.dialog(
        const Center(
          child: ImageProgressIndicator(),
        ),
        barrierDismissible: false, // Prevent dismissing the dialog
      );

      // Pick an image

      if (source == "camera") {
        // Open custom camera screen
        imageFile = await Get.to(() => CameraPreviewScreen());
      } else {
        // Pick image from gallery
        final picked =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (picked != null) imageFile = File(picked.path);
      }

      if (imageFile != null) {
        // Upload the image and get the URL
        String? imageUrl =
            await cameraService.uploadImage(imageFile, endpoint, false);

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
    } catch (e) {
      print('Error during image upload: $e');
    } finally {
      // Close the loading dialog
      Get.back();
    }
  }

  Future<String?> saveSignature(
    String key,
    String endpoint,
  ) async {
    File? imageFile;
    final controller = signatureControllers[key];
    if (controller != null && controller.isNotEmpty) {
      // Show the loading dialog
      Get.dialog(
        const Center(
          child: ImageProgressIndicator(),
        ),
        barrierDismissible: false, // Prevent dismissing the dialog
      );

      try {
        // Convert the signature to bytes
        final bytes = await controller.toPngBytes();
        final directory = await getApplicationDocumentsDirectory();
        imageFile = File('${directory.path}/signature.png');

        // Save the bytes to the file
        await imageFile.writeAsBytes(bytes!);

        if (imageFile != null) {
          // Upload the image and get the URL
          String? imageUrl =
              await cameraService.uploadImage(imageFile, endpoint, true);

          if (imageUrl != null) {
            // Save the image URL in the formData
            print('Image uploaded successfully: $imageUrl');
            return imageUrl;
          } else {
            print('Image upload failed.');
            return "";
          }
        } else {
          print('No image selected.');
        }
      } catch (e) {
        print("Error: $e");
        return "";
      } finally {
        // Close the loading dialog
        Get.back();
      }
    } else {
      throw Exception("Signature is empty");
    }
    return null; // Ensures all code paths return a value
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
    pagename = pageName;
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
    final dropdownResult = Strings.endpointToList[endpoint] ?? [];
    return dropdownResult
        .map<Map<String, String>>((element) => {
              '_id': element['_id'].toString(),
              key: element[key].toString(),
            })
        .toList();
  }

  // Form Submission
  Future<void> submitForm(String endpoint) async {
    await updateFormDataFromControllers();
    formData["customFields"] = customFields;
    bool isValid = true;
    print("-----------------------------------------------");
    print(formData["riskValue"]);
    for (var field in pageFields) {
      switch (field.type) {
        case 'imagepicker':
          if (!validateImagePickerField(field.headers, field.title,
              isEditable: hasEditPermission(field.permissions?.edit ?? []))) {
            isValid = false;
          }

          break;
        case 'signature':
          if (!validateSignatureField(field.headers, field.title,
              isEditable: hasEditPermission(field.permissions?.edit ?? []))) {
            isValid = false;
          }
          break;
        case 'riskMatrix':
          if (!validateRiskMatrixField(field.headers, field.title,
              isEditable: hasEditPermission(field.permissions?.edit ?? []))) {
            isValid = false;
          }
          break;
        // handle other types...
      }
    }

    if (!isValid) {
      Get.snackbar("Validation Failed", "Please complete all required fields",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    final bool isConfirmed = await Get.dialog(
      CustomAlertDialog(
        title: "Confirmation",
        description: "Are you sure you want to submit the Data?",
        buttons: [
          CustomDialogButton(
            onPressed: () {
              print(jsonEncode(formData));
              Get.back(result: false); // Close the dialog and return false
            },
            label: "Cancel",
          ),
          CustomDialogButton(
            onPressed: () {
              print(jsonEncode(formData));
              Get.back(result: true); // Close the dialog and return true
            },
            label: "Submit",
          ),
        ],
      ),
    );

    if (isConfirmed != true) return; // Exit if the user cancels

    isLoading(true);
    try {
      await Future.delayed(const Duration(milliseconds: 2500));
      final response = await ApiService().postRequest(endpoint, formData);
      if (response != null || response == 200 || response == 201) {
        showSuccessDialog(
            title: "Successful",
            message: "Data Submitted successfully, press OK to continue",
            onOkPressed: sendNotification(endpoint, false));
      }
    } catch (e) {
      isLoading.value = false;

      // Show error snackbar
      Get.snackbar(
        "Error",
        "Error Submitting data: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      print(e);
    }
  }

  // Data Update

  Future<void> updateData(String endpoint) async {
    await updateFormDataFromControllers();
    formData["customFields"] = customFields;
    final isConfirmed = await Get.dialog(
      AlertDialog(
        title: const Text("Confirmation"),
        content: const Text("Are you sure you want to update the data?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Update"),
          ),
        ],
      ),
    );

    if (isConfirmed != true) return;

    // Set isLoading to true to show the loading indicator
    isLoading.value = true;

    try {
      // Simulate delay for API call
      await Future.delayed(const Duration(seconds: 2));

      // Make API call
      final response =
          await ApiService().updateData(endpoint, formData["_id"], formData);

      // Stop loading indicator
      isLoading.value = false;

      if (response == 200 || response == 201) {
        // Show success dialog
        showSuccessDialog(
          title: "Update Successful",
          message: "Data updated successfully, press OK to continue",
        );
      } else {
        throw Exception("Unexpected response code: $response");
      }
    } catch (e) {
      // Stop loading on error
      isLoading.value = false;

      // Show error snackbar
      Get.snackbar(
        "Error",
        "Error updating data: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      print(e);
    }
  }

  // Fetch Geolocation
  Future<void> fetchGeolocation(String fieldKey) async {
    try {
      // Show loading dialog
      Get.dialog(
        const LocationProgressIndicator(),

        barrierDismissible: false, // Prevent dismissing the dialog manually
      );

      // Fetch the user's geolocation
      Position position = await LocationService().determinePosition();
      String latLong = "${position.latitude}, ${position.longitude}";
      String? locationName = await LocationService().determineLocationName();

      // Update the form data with the geolocation
      String result = "$locationName ($latLong)";
      updateFormData(fieldKey, result);
      print("Geolocation fetched: $result");

      // Optional: Notify the user of success
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('Geolocation fetched successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Error fetching location: $e");

      // Optional: Notify the user of the error
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text('Error fetching geolocation: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Close the loading dialog
      Get.back();
    }
  }

  // Validations for form fields------------------------------------------//

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

  String? validateMultiSelect(List<String>? values) {
    if (values == null || values.isEmpty) {
      return 'Please select at least one option';
    }
    return null;
  }

  bool validateImagePickerField(String fieldKey, String fieldTitle,
      {bool isEditable = true}) {
    if (!isEditable) return true; // Skip validation if field is not editable

    final imageUrl = formData[fieldKey];
    if (imageUrl == null || imageUrl.toString().isEmpty) {
      imageErrors[fieldKey] = "$fieldTitle is required";
      return false;
    } else {
      imageErrors[fieldKey] = null;
      return true;
    }
  }

  bool validateRiskMatrixField(String fieldKey, String fieldTitle,
      {bool isEditable = true}) {
    if (!isEditable) return true; // Skip validation if field is not editable

    final riskValue = formData[fieldKey];
    if (riskValue == null || riskValue.toString().isEmpty) {
      matrixError[fieldKey] =
          "$fieldTitle should be Updated please select again";
      return false;
    } else {
      matrixError[fieldKey] = null;
      return true;
    }
  }

  bool validateSignatureField(String fieldKey, String fieldTitle,
      {bool isEditable = true}) {
    if (!isEditable) return true; // Skip validation if field is not editable

    final signatureUrl = formData[fieldKey];
    if (signatureUrl == null || signatureUrl.toString().isEmpty) {
      imageErrors[fieldKey] = "$fieldTitle is required"; // reuse same error map
      return false;
    } else {
      imageErrors[fieldKey] = null;
      return true;
    }
  }

  updateFormDataFromControllers() async {
    textControllers.forEach((key, controller) {
      formData[key] = controller.text;
    });
  }

  // Validations for form fields------------------------------------------//
  sendNotification(String source, bool isUpdate) {
    switch (source) {
      case "uauc":
        isUpdate
            ? NotificationHandler().sendNotification(notifications: [
                {
                  "userId": formData["createdby"],
                  "title": "Update UAUC",
                  "message": "An Update made in UAUC, Check It out",
                  "source": "uauc"
                }
              ])
            : NotificationHandler().sendNotification(notifications: [
                {
                  "userId": formData["assignedTo"],
                  "title": "UAUC REPORTED",
                  "message":
                      "UAUC Incident Assigned, Take Necessary actions ASAP ",
                  "source": "uauc"
                }
              ]);
        break;
      case "workpermit":
        if (isUpdate) {
          if (formData["verifiedDone"] == "true") {
            NotificationHandler().sendNotification(notifications: [
              {
                "userId": formData["createdby"],
                "title": "Work Permit Verified",
                "message": "An Update made in Work Permit, Check It out",
                "source": "workpermit",
              }
            ]);
          }
        } else {
          // Map assignedTo list into the notification format
          List<Map<String, String>> notifications =
              (formData["verifiedBy"] as List<String>).map((String userId) {
            return {
              "userId": userId,
              "title": "Work Permit Verification",
              "message": "New Work Permit created, Please verify it",
              "source": "workpermit",
            };
          }).toList();

// Pass the entire list to sendNotification
          NotificationHandler().sendNotification(notifications: notifications);
        }
        break;
    }
  }

  void calculateRiskLevel() {
    final score = severity.value * likelihood.value;
    if (score <= 3) {
      riskLevel.value = 'Low';
    } else if (score < 8) {
      riskLevel.value = 'Medium';
    } else if (score < 12) {
      riskLevel.value = 'High';
    } else {
      riskLevel.value = 'Critical';
    }
    final matchedValue = Strings.endpointToList["RiskRating"].firstWhere((e) {
      print('Comparing: ${e['severity']} with ${riskLevel.value}');
      return e['severity'] == riskLevel.value;
    }, orElse: () => null);

    if (matchedValue != null) {
      formData['riskValue'] = matchedValue['_id'];

      // Parse the alert timeline (in hours)
      final int timelineHours =
          int.tryParse(matchedValue['alertTimeline'] ?? '0') ?? 0;

      // Calculate deadline
      final DateTime deadline =
          DateTime.now().add(Duration(hours: timelineHours));

      // Format deadline nicely
      final String formattedDeadline =
          "${deadline.day.toString().padLeft(2, '0')}/"
          "${deadline.month.toString().padLeft(2, '0')}/"
          "${deadline.year} at ${deadline.hour.toString().padLeft(2, '0')}:"
          "${deadline.minute.toString().padLeft(2, '0')}";

      // Show the dialog
      Get.defaultDialog(
        title: "Risk Level: ${riskLevel.value}",
        middleText:
            "You have to complete the given action by $formattedDeadline.\n\n"
            "Severity: ${matchedValue['severity']}\n"
            "Alert Window: $timelineHours hour(s)",
        textConfirm: "OK",
        confirmTextColor: Colors.white,
        onConfirm: () => Get.back(),
      );
    }

    print(formData);
  }

  Future<void> refreshDropdownData() async {
    print("refreshing data-----------------------");
    isLoading.value = true;
    await loadDropdownData(); // Loads the latest dropdowns globally or for this form
    refresh(); // Reinitializes fields
    isLoading.value = false;
  }
//Risk Calculation-------------------------------------------------------------

  SignatureController getSignatureController(String fieldKey) {
    if (!signatureControllers.containsKey(fieldKey)) {
      signatureControllers[fieldKey] = SignatureController();
    }
    return signatureControllers[fieldKey]!;
  }

  TextEditingController getTextController(String fieldHeader) {
    print(formData[fieldHeader]);
    if (!textControllers.containsKey(fieldHeader)) {
      print(formData[fieldHeader]);
      // Create a new controller if it doesn't exist
      textControllers[fieldHeader] = TextEditingController(
        text: formData[fieldHeader]?.toString() ?? '',
      );
    }
    return textControllers[fieldHeader]!;
  }

  getChecklist(String checklistKey) {
    final permitsList = Strings.endpointToList["permitstype"];

    if (permitsList != null) {
      // Find the matching permit by comparing permitsType with checklistKey
      final matchingPermit = permitsList.firstWhere(
        (permit) => permit["permitsType"] == checklistKey,
        orElse: () => null,
      );

      if (matchingPermit != null) {
        // Assign its SafetyChecks to checkList.value
        checkList.value = (matchingPermit["SafetyChecks"] as List<dynamic>?)
                ?.map((e) => e as Map<String, dynamic>)
                .toList() ??
            [];
      } else {
        // If no match is found, clear the checklist
        checkList.clear();
      }
    } else {
      // If permitsList is null, clear the checklist
      checkList.clear();
    }
  }

  saveCheckList() {}
}
