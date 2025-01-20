import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';

import 'package:rohan_suraksha_sathi/controller/dynamic_form_contoller.dart';
import 'package:rohan_suraksha_sathi/controller/sub_form_controller.dart';

import 'package:rohan_suraksha_sathi/model/form_data_model.dart';
import 'package:rohan_suraksha_sathi/views/image_view_page.dart';
import 'package:rohan_suraksha_sathi/widgets/subform.dart';
import 'package:signature/signature.dart';

class DynamicForm extends StatelessWidget {
  final String pageName;
  final Map<String, dynamic>? initialData;
  final bool isEdit;

  DynamicForm(
      {super.key,
      required this.pageName,
      this.initialData,
      this.isEdit = false});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DynamicFormController controller = Get.put(DynamicFormController());

  @override
  Widget build(BuildContext context) {
    controller.initializeFormData(initialData);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Builder(builder: (context) {
              return Obx(
                () {
                  controller.getPageFields(pageName);

                  return GetBuilder<DynamicFormController>(
                      builder: (controller) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Filter fields based on view permissions and build form fields dynamically for mobile view
                            ...controller.pageFields
                                .where((field) {
                                  var viewPermissions = List<String>.from(
                                      field.permissions?.view ?? []);
                                  return controller.hasViewPermission(
                                      viewPermissions); // Check if the user has view permission
                                })
                                .map((field) => Column(
                                      children: [
                                        // Build the form field dynamically and check for edit permissions
                                        buildFormField(
                                            field,
                                            controller.hasEditPermission(
                                                field.permissions?.edit ?? []),
                                            context),
                                        const SizedBox(height: 10),
                                      ],
                                    ))
                                .toList(),

                            const SizedBox(height: 10),

                            // Submit button
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  if (isEdit) {
                                    controller.updateData(pageName);
                                  } else {
                                    controller.submitForm(pageName);
                                  }
                                } else {
                                  // Show an error if form is invalid
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please correct the errors in the form'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  isEdit ? 'Update' : 'Submit',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              );
            }),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                  child:
                      CircularProgressIndicator()); // Show the CircularProgressIndicator
            } else {
              return SizedBox.shrink(); // Your regular content goes here
            }
          })
        ],
      ),
    );
  }

  Widget buildFormField(
      PageField field, bool isEditable, BuildContext context) {
    switch (field.type) {
      case 'defaultField':
        final dynamic savedValue = controller.formData[field.headers];

        // Skip rendering this field if in edit mode and field.headers is "createdBy"
        if (isEdit && field.headers == "createdby") {
          return const SizedBox.shrink(); // Return an empty widget
        }

        String displayValue = "";
        String saveValue = "";
        if (isEdit && savedValue != null) {
          print(
              "222222222222Opened in edit mode=======================================");
          if (savedValue is Map) {
            print(
                "222222222222is a Map=======================================");
            // Handle the case where savedValue is a Map
            displayValue = savedValue[field.key] ?? "";
            saveValue = savedValue["_id"] ?? "";
            controller.updateFormData(field.headers, savedValue);
          } else if (savedValue is String) {
            print(
                "222222222222Opened is A string=======================================");
            // Handle the case where savedValue is a String
            displayValue = savedValue;
            saveValue = savedValue;
            controller.updateFormData(field.headers, savedValue);
          }
        } else {
          print(
              "222222222222Opened in create mode=======================================");
          // Extract the projectName and _id
          displayValue = Strings.endpointToList[field.endpoint][field.key];
          saveValue = Strings.endpointToList[field.endpoint]["_id"];
          controller.updateFormData(field.headers, saveValue);
        }

        // Store the project ID in formData

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              // Display the projectName as the field value
              controller: TextEditingController(text: displayValue),
              decoration: kTextFieldDecoration(""),
              readOnly: true, // Make this field read-only
            ),
            const SizedBox(height: 10),
          ],
        );

      case 'checklist':
        // Fetch and type-check the checklist
        final List<Map<String, dynamic>> checkListItems = controller.checkList;

        return ExpansionTile(
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Text(field.title),
          children: checkListItems.map((checkPoint) {
            final String checkPointTitle = checkPoint['CheckPoints'] ?? '';
            final String initialResponse = checkPoint['response'] ?? 'No';

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the checkpoint title
                  Text(
                    checkPointTitle,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 8.0),
                  // Render radio options
                  Row(
                    children: ['Yes', 'No', 'N/A'].map((option) {
                      return Row(
                        children: [
                          Obx(() => Radio<String>(
                                value: option,
                                groupValue: controller.formData[field.headers]
                                        ?.firstWhere(
                                            (e) =>
                                                e['CheckPoints'] ==
                                                checkPointTitle,
                                            orElse: () => {
                                                  'CheckPoints':
                                                      checkPointTitle,
                                                  'response': initialResponse
                                                })['response'] ??
                                    initialResponse,
                                onChanged: isEditable
                                    ? (value) {
                                        // Update safetyMeasuresTaken on selection
                                        final updatedCheckPoint = {
                                          'CheckPoints': checkPointTitle,
                                          'response': value,
                                        };

                                        // Update formData with new response for the specific checkpoint
                                        controller.formData.update(
                                          field.headers,
                                          (existing) {
                                            final List<Map<String, dynamic>>
                                                updatedList =
                                                List.from(existing);
                                            final existingIndex =
                                                updatedList.indexWhere((e) =>
                                                    e['CheckPoints'] ==
                                                    checkPointTitle);

                                            if (existingIndex >= 0) {
                                              // Update the existing response
                                              updatedList[existingIndex] =
                                                  updatedCheckPoint;
                                            } else {
                                              // Add new checkpoint response if not already present
                                              updatedList
                                                  .add(updatedCheckPoint);
                                            }
                                            return updatedList;
                                          },
                                          ifAbsent: () => [
                                            updatedCheckPoint
                                          ], // Default value if no entry exists
                                        );
                                      }
                                    : null,
                              )),
                          Text(option),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }).toList(),
        );

      case 'CustomTextField':
        final TextEditingController textController =
            controller.getTextController(field.headers);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              validator: (value) {
                if (!isEditable)
                  return null; // Skip validation for read-only fields
                return controller
                    .validateTextField(value); // Validate editable fields
              },
              controller: textController,
              decoration: kTextFieldDecoration("Enter ${field.title}"),
              readOnly: !isEditable,
              onChanged: isEditable
                  ? (value) {
                      controller.debounceMap[field.headers]?.cancel();

                      // Start a new timer for debounce specific to this field
                      controller.debounceMap[field.headers] =
                          Timer(const Duration(milliseconds: 2000), () {
                        // Update the form data after debounce
                        controller.updateFormData(field.headers, value);
                      });
                    }
                  : null,
              keyboardType:
                  field.key == "numeric" ? TextInputType.number : null,
            ),
          ],
        );
      case 'calculatedField':
        // Fetch the TextEditingController for this field
        TextEditingController textController =
            controller.getTextController(field.headers);

        // Fetch the values from formData
        String? value1String = controller.formData[field.endpoint];
        String? value2String = field.key;

        // Debug: Print values to ensure they're being fetched
        debugPrint("value1: $value1String, value2: $value2String");

        // Parse the values safely
        final value1 = int.tryParse(value1String ?? '') ?? 0;
        final value2 = double.tryParse(value2String ?? '') ?? 0.0;

        // Debug: Check parsed values
        debugPrint("Parsed value1: $value1, value2: $value2");

        // Perform the calculation
        final result = value1 * value2;

        // Debug: Log the result
        debugPrint("Calculation result: $result");

        // Update the text controller with the result
        textController.text = result.toString();
        controller.updateFormData(field.headers, textController.text);
        // Return the UI for the calculated field
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: textController,
              decoration: kTextFieldDecoration("Enter ${field.title}"),
              readOnly: true, // Dynamically control editability
              maxLines: null,
              keyboardType: field.key == "numeric"
                  ? TextInputType.number
                  : TextInputType.text,
            ),
          ],
        );

      case 'editablechip':
        return buildEditableChipField(field, isEditable, isEdit);
      case 'multiselect':
        return FutureBuilder<List<Map<String, String>>>(
          future:
              controller.getDropdownData(field.endpoint ?? "", field.key ?? ""),
          builder: (BuildContext context,
              AsyncSnapshot<List<Map<String, String>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10),
                ],
              );
            } else if (snapshot.hasError) {
              Get.snackbar(
                  duration: Duration(seconds: 30),
                  snapshot.stackTrace.toString(),
                  snapshot.error.toString());
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text("Error loading data"),
                  const SizedBox(height: 10),
                ],
              );
            } else if (snapshot.hasData) {
              final List<Map<String, String>> options = snapshot.data ?? [];
              final List<String> selectedIds = (controller
                          .formData[field.headers] as List?)
                      ?.map((item) {
                        if (item is String) {
                          return item; // If item is already a String, return it directly.
                        } else if (item is Map<String, dynamic> &&
                            item.containsKey('_id')) {
                          return item['_id']?.toString() ??
                              ''; // If it's a Map, extract '_id' as String.
                        } else {
                          return ''; // For any unexpected type, return an empty string.
                        }
                      })
                      .where((id) => id.isNotEmpty) // Remove any empty strings.
                      .toList() ??
                  [];

              // final List<String> selectedIds = (controller
              //             .formData[field.headers] as List?)
              //         ?.where((item) =>
              //             item is Map<String, dynamic> &&
              //             item.containsKey('_id'))
              //         .map((item) =>
              //             (item as Map<String, dynamic>)['_id']?.toString() ??
              //             '')
              //         .where((id) => id.isNotEmpty)
              //         .toList() ??
              //     [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Wrap MultiSelectDialogField with GestureDetector if not editable
                  GestureDetector(
                    onTap: isEditable
                        ? null // Allow normal behavior if editable
                        : () {
                            // Do nothing if not editable
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('This field is not editable for you'),
                                backgroundColor: Colors.grey,
                              ),
                            );
                          },
                    child: AbsorbPointer(
                      absorbing:
                          !isEditable, // Prevent interaction if not editable
                      child: MultiSelectDialogField<String>(
                        dialogHeight: 300,
                        items: options.map((Map<String, String> option) {
                          return MultiSelectItem<String>(
                            option['_id'] ?? "", // Use `_id` as the value
                            option[field.key] ?? '', // Display dynamic key
                          );
                        }).toList(),
                        initialValue: selectedIds,
                        onConfirm: (List<String> selectedValues) {
                          if (isEditable) {
                            // Update only if editable
                            controller.updateFormData(
                                field.headers, selectedValues);
                          }
                        },
                        title: Text("Select ${field.title}"),
                        buttonText: Text(
                          "Select ${field.title}",
                          style: TextStyle(
                            color: isEditable
                                ? Colors.black
                                : Colors.grey, // Change color if not editable
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: isEditable
                                  ? Colors.grey
                                  : Colors
                                      .grey), // Visual indication of read-only
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            } else {
              return Container();
            }
          },
        );

      case 'imagepicker':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            // Image Upload Buttons (conditional on editable state)
            Row(
              children: [
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: isEditable
                      ? () async {
                          // Call the function to pick and upload the image from the camera
                          await controller.pickAndUploadImage(
                              field.headers, field.endpoint ?? "");
                        }
                      : null, // Disable the button if not editable
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEditable
                        ? null
                        : Colors.grey, // Visual feedback if disabled
                  ),
                  child: const Text('Take Image'),
                ),
              ],
            ),

            // Display uploaded image URL
            Obx(() {
              // Check if the image URL exists in formData
              final imageUrl = controller.formData[field.headers];

              // Ensure that imageUrl is a String and not null
              if (imageUrl is String && imageUrl.isNotEmpty) {
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Get.to(ImageViewPage(imageUrl: imageUrl));
                      },
                      child: Image.network(
                        imageUrl,
                        height: 150,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('Failed to load image');
                        },
                      ),
                    ), // Display the uploaded image
                    const SizedBox(height: 10),
                    const Text('Image uploaded successfully!'),
                  ],
                );
              } else {
                // Return an empty Container or some placeholder when no image is uploaded
                return const SizedBox(height: 10);
              }
            })
          ],
        );

      case 'secondaryForm':
        // Initialize subformData if it's not initialized
        if (controller.formData[field.headers] != null &&
            controller.formData[field.headers].isNotEmpty &&
            controller.subformData.isEmpty) {
          controller.subformData.value =
              (controller.formData[field.headers] as List)
                  .where((item) => item is Map<String, dynamic>)
                  .map((item) => item as Map<String, dynamic>)
                  .toList();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add new attendee section
            Text(
              field.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            if (isEditable)
              ListTile(
                title: const Text("Add Data"),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    // Open a SubForm as a dialog
                    var result = await Get.dialog(
                      Dialog(
                        child: WillPopScope(
                          onWillPop: () async {
                            Get.delete<SubFormController>();
                            return true;
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SubForm(
                              pageName: field.headers,
                            ),
                          ),
                        ),
                      ),
                      barrierDismissible:
                          true, // Allow tapping outside to close
                    );
                    print(
                        "{{{{{{{{{{{{{{{{{{{{{{{{{{{{${result}}}}}}}}}}}}}}}}}}}}}}}}}}}}}");
                    if (result != null) {
                      if (controller.formData[field.headers] == null) {
                        controller.formData[field.headers] = [];
                      }

                      // Add result to formData and update subformData
                      controller.formData[field.headers].add(result);
                      controller.subformData.value =
                          (controller.formData[field.headers] as List)
                              .where((item) => item is Map<String, dynamic>)
                              .map((item) => item as Map<String, dynamic>)
                              .toList();
                    } else {
                      print(
                          "{{{{{{{{{{{{{{{{{{{{{{{{{{{{returning null}}}}}}}}}}}}}}}}}}}}}}}}}}}}");
                    }
                  },
                ),
              ),

            // Display attendees using ExpansionTile
            Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.subformData.length,
                  itemBuilder: (context, index) {
                    final attendee = controller.subformData[index];
                    return ExpansionTile(
                      key: ValueKey(attendee),
                      title: Text(attendee[field.key] ?? ""),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ...attendee.entries.map((entry) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${entry.key}: ",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          entry.value?.toString() ?? "N/A",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              Row(children: [
                                if (isEditable)
                                  TextButton.icon(
                                    onPressed: () async {
                                      print(
                                          "zzzzzzzzzzzzzzzzzzzzzzzzzzz${attendee}");
                                      var result = await Get.dialog(
                                        Dialog(
                                          child: WillPopScope(
                                            onWillPop: () async {
                                              Get.delete<SubFormController>();
                                              return true;
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SubForm(
                                                pageName: field.headers,
                                                initialData: attendee,
                                                isEdit: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                      if (result != null) {
                                        controller.subformData[index] = result;
                                        controller.formData[field.headers] =
                                            List.from(controller.subformData);
                                      }
                                    },
                                    icon: const Icon(Icons.edit),
                                    label: const Text("Edit"),
                                  ),

                                // Delete attendee button
                                if (isEditable)
                                  TextButton.icon(
                                    onPressed: () {
                                      controller.subformData.removeAt(index);
                                      controller.formData[field.headers] =
                                          List.from(controller.subformData);
                                    },
                                    icon: const Icon(Icons.delete),
                                    label: const Text("Remove"),
                                  ),
                              ]),
                              // Edit attendee button
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                )),
          ],
        );

      case 'dropdown':
        return Obx(() {
          final selectedValue = (controller.formData[field.headers] is Map)
              ? controller.formData[field.headers]["_id"].toString()
              : controller.formData[field.headers]?.toString();

          return FutureBuilder<List<Map<String, String>>>(
            future: controller.getDropdownData(
                field.endpoint ?? "", field.key ?? ""),
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, String>>> snapshot) {
              // Title for the dropdown
              Column titleColumn = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(field.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                ],
              );

              // Loading state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleColumn,
                    const CircularProgressIndicator(),
                    const SizedBox(height: 10),
                  ],
                );
              }

              // Error state
              if (snapshot.hasError) {
                print(
                    "dsjbsdjbsjvbsdjbvjsvnnnnnnnnnnnnnnnnnnnnnnn${snapshot.stackTrace}");

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleColumn,
                    const Text("Error loading data"),
                    const SizedBox(height: 10),
                  ],
                );
              }

              // Data available
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final List<Map<String, String>> options = snapshot.data ?? [];

                if (isEditable) {
                  // Editable Dropdown
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleColumn,
                      DropdownButtonHideUnderline(
                        child: Container(
                          width: double.infinity, // Occupy full width
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(10.0), // Border radius
                            border: Border.all(
                                color: Colors.grey,
                                width: 1.0), // Optional border
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              validator: (value) {
                                if (!isEditable)
                                  return null; // Skip validation if read-only
                                return controller.validateDropdown(
                                    value); // Validate only if editable
                              },
                              elevation: 0, // Remove default elevation
                              value:
                                  selectedValue, // Keep this as null initially
                              hint: const Text('Select an option'), // Hint text
                              items: options.map((Map<String, String> option) {
                                return DropdownMenuItem<String>(
                                  value: option['_id'], // Use `_id` as value
                                  child: Text(option[field.key] ??
                                      ''), // Display the dynamic key (e.g., `projectName`)
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  controller.updateDropdownSelection(
                                      field.headers, newValue);
                                  if (field.title == "Permit Types") {
                                    // Find the selected option using `_id` and extract the required field value
                                    final selectedOption = options.firstWhere(
                                        (option) => option['_id'] == newValue,
                                        orElse: () => {});
                                    controller.getChecklist(
                                        selectedOption[field.key] ?? '');
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                } else {
                  // Read-only display
                  // Find the display text for the selected value
                  String displayText = options.firstWhere(
                        (option) => option['_id'] == selectedValue,
                        orElse: () =>
                            {field.key ?? "": 'Action not available for user'},
                      )[field.key] ??
                      'Action not available for user';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleColumn,
                      Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                              color: Colors.grey,
                              width: 1.0), // Optional border
                        ),
                        child: Text(
                          displayText, // Display the matched value or default message
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }
              }

              // Handle case where data is empty
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleColumn,
                  const Text("No options available"),
                  const SizedBox(height: 10),
                ],
              );
            },
          );
        });

      case 'simplemultiselect':
        return Obx(() {
          // Ensure initial value is a non-null, valid list of Strings
          List<String> initialSelectedValues =
              (controller.formData[field.headers] as List<dynamic>? ?? [])
                  .map((e) => e.toString())
                  .toList();

          print(
              "--------------multiselect----------------${controller.formData[field.headers].runtimeType}");
          return MultiSelectDialogField<String>(
            dialogHeight: 300,
            items: (field.options != null)
                ? field.options!.map((option) {
                    return MultiSelectItem<String>(option, option);
                  }).toList()
                : [],

            // Set initial value for the multi-select dialog
            initialValue: initialSelectedValues,

            onConfirm: (List<String> selectedValues) {
              // Update the form data with the selected values
              controller.updateFormData(field.headers, selectedValues);
            },

            title: Text("Select ${field.title}"),
            buttonText: Text(
              "Select ${field.title}",
              style: const TextStyle(),
            ),

            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
          );
        });

      case 'simpledropdown':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(field.title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), // Border radius
                border: Border.all(
                    color: Colors.grey, width: 1.0), // Optional border
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Obx(() {
                  // Safely get the selected value from formData
                  final selectedValue =
                      controller.formData[field.headers] as String?;

                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(border: InputBorder.none),
                    validator: (value) => controller.validateDropdown(value),
                    elevation: 0, // Remove default elevation
                    value: selectedValue, // Set the selected value
                    hint: const Text('Select an option'), // Hint text
                    items: (field.options != null)
                        ? field.options!.map((option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option ?? ''), // Display option text
                            );
                          }).toList()
                        : [], // Return an empty list if `field.options` is null

                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.updateDropdownSelection(
                            field.headers, newValue);
                      }
                    },
                  );
                }),
              ),
            ),
          ],
        );

      case 'datepicker':
        return myDatePicker(field, isEditable);

      case 'timepicker':
        return myTimePicker(field, isEditable);

      case 'radio':
        return Obx(() {
          final selectedValue = controller.formData[field.headers]?.toString();
          final List<String> options = field.options!;
          print("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww$selectedValue");
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(field.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: options.map((option) {
                  return Expanded(
                    child: RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: selectedValue,
                      onChanged: isEditable // Check if it's editable
                          ? (String? newValue) {
                              if (newValue != null) {
                                controller.updateRadioSelection(
                                    field.headers, newValue);
                              }
                            }
                          : null, // Disable onChanged if not editable
                      // Optionally, change the appearance of disabled tiles
                      activeColor: isEditable ? null : Colors.grey,
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],
          );
        });

      case 'switch':
        return Obx(() {
          final bool isSwitched = controller.formData[field.headers] == true;
          print("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww${isSwitched}");

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                field.title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                title: Text(field.title),
                value: isSwitched,
                onChanged: isEditable &&
                        controller.formData[field.endpoint] != null &&
                        (controller.formData[field.endpoint] as List)
                            .any((item) {
                          if (item is String) {
                            return item == Strings.userName;
                          } else if (item is Map<String, dynamic>) {
                            return item.containsValue(Strings.userName);
                          }
                          return false; // For any unexpected type, return false.
                        })
                    ? (bool newValue) {
                        controller.updateSwitchSelection(
                            field.headers, newValue);
                      }
                    : null,
                // Disable onChanged if not editable
                // Optionally, change the appearance of the disabled switch
                activeColor: isEditable ? null : Colors.grey,
                inactiveThumbColor: isEditable ? null : Colors.grey,
                inactiveTrackColor: isEditable ? null : Colors.grey[300],
              ),
              const SizedBox(height: 10),
            ],
          );
        });
      case 'signature':
        String? signatureUrl = controller.formData[field.headers];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            isEdit
                ? (signatureUrl != null && signatureUrl.isNotEmpty
                    ? Image.network(
                        signatureUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : const Text("No signature available."))
                : Signature(
                    controller:
                        controller.getSignatureController(field.headers),
                    height: 200,
                    backgroundColor: Colors.grey[200]!,
                  ),
            if (!isEdit) // Show buttons only if not in edit mode
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.signatureControllers[field.headers]?.clear();
                    },
                    child: const Text("Clear"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.saveSignature(
                        field.headers,
                        field.endpoint ?? "",
                      );
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
          ],
        );

      case 'geolocation':
        return Obx(() {
          String? currentLocation = controller.formData[field.headers];
          double? latitude, longitude;

          if (currentLocation != null && currentLocation.isNotEmpty) {
            var coordinates = currentLocation.split(',');
            latitude = double.tryParse(coordinates[0]);
            longitude = double.tryParse(coordinates[1]);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                field.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: TextEditingController(
                  text: currentLocation ?? 'Fetching location...',
                ),
                readOnly: true, // Make the TextField read-only
                decoration: kTextFieldDecoration("Location"),
                onTap: isEditable // Check if it's editable
                    ? () async {
                        await controller.fetchGeolocation(field.headers);
                      }
                    : null, // Disable onTap if not editable
              ),
              const SizedBox(height: 10),
              if (latitude != null && longitude != null)
                SizedBox(
                  height: 200.0,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(latitude, longitude),
                      zoom: 15.0,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId("currentLocation"),
                        position: LatLng(latitude, longitude),
                      ),
                    },
                  ),
                ),
              // Show a message if not editable
              if (!isEditable)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Location is read-only.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              const SizedBox(height: 10),
            ],
          );
        });

      case 'slider':
        return Obx(() {
          final double currentValue = controller.formData[field.headers] ?? 0.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Number of Attendees - $currentValue",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (isEditable) // Show slider only if editable
                Slider(
                  value: currentValue,
                  min: 0.0,
                  max: 100.0,
                  divisions: 100,
                  label: currentValue.toString(),
                  onChanged: (value) {
                    controller.formData[field.headers] = value;
                  },
                )
              else // If not editable, show the value only
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    currentValue.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
            ],
          );
        });

      default:
        return const Text('Unsupported field type');
    }
  }

  Widget myDatePicker(PageField field, bool isEditable) {
    // Create a TextEditingController to store and display the picked date
    final TextEditingController dateController = TextEditingController(
      text: controller.formData[field.headers] != null
          ? DateFormat('d-M-yyyy').format(
              DateFormat('yyyy-MM-dd')
                  .parse(controller.formData[field.headers].toString()),
            )
          : '', // Provide a fallback value for null, like an empty string
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: dateController,
          readOnly:
              !isEditable, // Make the TextField read-only based on isEditable
          decoration: kTextFieldDecoration("Select Date",
              suffixIcon: Icon(Icons.calendar_month_rounded)),
          onTap: isEditable // Only show date picker if editable
              ? () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: Get.context!,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}"; // Format the date
                    dateController.text = pickedDate
                        .toString(); // Update the TextField with the selected date
                    controller.updateFormData(field.headers,
                        pickedDate.toString()); // Update the form data
                  }
                }
              : null, // Disable onTap if not editable
        ),
        // Display the current date if not editable
        if (!isEditable)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              controller.formData[field.headers]?.toString() ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
      ],
    );
  }

  Widget myTimePicker(PageField field, bool isEditable) {
    // Create a TextEditingController to store and display the selected time
    final TextEditingController timeController = TextEditingController(
      text: controller.formData[field.headers]?.toString() ?? '',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: timeController,
          readOnly:
              !isEditable, // Make the TextField read-only based on isEditable
          decoration: kTextFieldDecoration("Select Time",
              suffixIcon: Icon(Icons.access_time_filled_sharp)),
          onTap: isEditable // Only show time picker if editable
              ? () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: Get.context!,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    String formattedTime =
                        selectedTime.format(Get.context!); // Format the time
                    timeController.text =
                        formattedTime; // Update the TextField with the selected time
                    controller.updateFormData(
                        field.headers, formattedTime); // Update the form data
                  }
                }
              : null, // Disable onTap if not editable
        ),
        // Display the current time if not editable
        // if (!isEditable)
        //   Padding(
        //     padding: const EdgeInsets.only(top: 8.0),
        //     child: Text(
        //       controller.formData[field.headers] ?? '',
        //       style: const TextStyle(fontSize: 16, color: Colors.grey),
        //     ),
        //   ),
      ],
    );
  }

  Widget buildEditableChipField(PageField field, bool isEditable, bool isEdit) {
    // Extract existing chips from form data or initialize as an empty list
    List<String> existingChips =
        (controller.formData[field.headers] as List<dynamic>?)
                ?.cast<String>() ??
            [];
    TextEditingController chipController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          children: existingChips.map((chip) {
            return Chip(
              label: Text(chip),
              onDeleted: isEditable
                  ? () {
                      existingChips.remove(chip);
                      controller.updateFormData(field.headers, existingChips);
                    }
                  : null, // Disable deletion if not editable
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        // Only show the input field and button if isEditable is true
        if (isEditable) ...[
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: chipController,
                  decoration: kTextFieldDecoration("Add"),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      existingChips.add(value);
                      chipController.clear();
                      controller.updateFormData(field.headers, existingChips);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () {
                  final value = chipController.text.trim();
                  if (value.isNotEmpty) {
                    existingChips.add(value);
                    chipController.clear();
                    controller.updateFormData(field.headers, existingChips);
                  }
                },
                child: const Text("Add"),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget buildInputChips(
      List<String> options, String fieldName, bool isEditable) {
    return Wrap(
      spacing: 8.0,
      children: options.map((option) {
        return isEditable
            ? InputChip(
                label: Text(option),
                selected: controller.selectedChips.contains(option),
                onSelected: (isSelected) {
                  isSelected
                      ? controller.selectedChips.add(option)
                      : controller.selectedChips.remove(option);
                  // Call setState or update your controller here
                },
              )
            : FilterChip(
                label: Text(option),
                selected: controller.selectedChips.contains(option),
                onSelected: null, // Disable selection
              );
      }).toList(),
    );
  }
}

InputDecoration kTextFieldDecoration(String hintText, {Widget? suffixIcon}) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintText: hintText,
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    suffixIcon: suffixIcon, // Add suffixIcon here
  );
}
