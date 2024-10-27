import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:rohan_atmaraksha/controller/dynamic_form_contoller.dart';

import 'package:rohan_atmaraksha/model/form_data_model.dart';
import 'package:rohan_atmaraksha/widgets/subform.dart';

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
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    print(
        "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv");
    print(initialData);

    return Scaffold(
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Builder(builder: (context) {
              return Obx(
                () {
                  controller.initializeFormData(initialData);
                  controller.getPageFields(pageName);

                  return GetBuilder<DynamicFormController>(
                      builder: (controller) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double screenWidth =
                                MediaQuery.of(context).size.width;

                            // Define breakpoints for responsiveness
                            if (screenWidth > 1200) {
                              // Large screen (desktop view)
                              return Column(
                                children: [
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          3, // 3 columns for large screens
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20,
                                      childAspectRatio: 2,
                                    ),
                                    itemCount: controller.pageFields.length,
                                    itemBuilder: (context, index) {
                                      var field = controller.pageFields[index];
                                      return Column(
                                        children: [
                                          //buildFormField(field),
                                        ],
                                      );
                                    },
                                  ),
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
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
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
                              );
                            } else if (screenWidth > 600) {
                              // Medium screen (tablet view)
                              return Column(
                                children: [
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          2, // 2 columns for medium screens
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20,
                                      childAspectRatio: 2.5,
                                    ),
                                    itemCount: controller.pageFields.length,
                                    itemBuilder: (context, index) {
                                      var field = controller.pageFields[index];
                                      return Column(
                                        children: [
                                          //buildFormField(field),
                                        ],
                                      );
                                    },
                                  ),
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
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
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
                              );
                            } else {
                              // Small screen (mobile view)
                              return Column(
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
                                                      field.permissions?.edit ??
                                                          [])),
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
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
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
                              );
                            }
                          },
                        ),
                      ),
                    );
                  });
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildFormField(PageField field, bool isEditable) {
    switch (field.type) {
      case 'CustomTextField':
        final TextEditingController textController = TextEditingController(
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
            TextFormField(
              // Skip validation if the field is read-only
              validator: (value) {
                if (!isEditable) return null; // Don't validate read-only fields
                return controller.validateTextField(
                    value); // Apply validation for editable fields
              },

              controller: textController,
              decoration: kTextFieldDecoration("Enter ${field.title}"),

              readOnly:
                  !isEditable, // Make the field read-only if it's not editable

              // Update data only if the field is editable
              onChanged: isEditable
                  ? (value) {
                      _debounce?.cancel();

                      // Start a new timer for debounce
                      _debounce = Timer(const Duration(milliseconds: 2000), () {
                        controller.updateFormData(field.headers, value);
                      });
                    }
                  : null, // No action if it's not editable
            ),
            const SizedBox(height: 10),
          ],
        );

      case 'editablechip':
        return buildEditableChipField(field, isEditable);
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
              final List<String> selectedIds =
                  (controller.formData[field.headers] as List<String>?) ?? [];

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
                ElevatedButton(
                  onPressed: isEditable
                      ? () async {
                          // Call the function to pick and upload the image
                          await controller.pickAndUploadImage(
                              field.headers, field.endpoint ?? "", "");
                        }
                      : null, // Disable the button if not editable
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEditable
                        ? null
                        : Colors.grey, // Visual feedback if disabled
                  ),
                  child: const Text('Gallery'),
                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: isEditable
                      ? () async {
                          // Call the function to pick and upload the image from the camera
                          await controller.pickAndUploadImage(
                              field.headers, field.endpoint ?? "", "camera");
                        }
                      : null, // Disable the button if not editable
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEditable
                        ? null
                        : Colors.grey, // Visual feedback if disabled
                  ),
                  child: const Text('Camera'),
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
                    Image.network(
                      imageUrl,
                      height: 150,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text('Failed to load image');
                      },
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
          children: [
            // Button to add attendees (only shown if editable)
            if (isEditable)
              TextButton(
                onPressed: () async {
                  var result = await Get.bottomSheet(
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SubForm(pageName: field.headers),
                    ),
                    backgroundColor: Colors.white,
                  );
                  if (result != null) {
                    // Ensure formData[field.headers] is a list before adding
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
                  }
                },
                child: const Text("Add Attendee's Name"),
              ),

            // Displaying the attendees as chips
            Obx(() => Wrap(
                  spacing: 8.0, // space between chips
                  runSpacing: 4.0, // space between rows of chips
                  children: controller.subformData.map((attendee) {
                    return InkWell(
                      onTap: () async {
                        if (isEditable) {
                          var result = await Get.bottomSheet(
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Details",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        if (isEditable) // Only show edit button if editable
                                          IconButton(
                                            onPressed: () async {
                                              var result =
                                                  await Get.bottomSheet(
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SubForm(
                                                    pageName: field.headers,
                                                    initialData: attendee,
                                                    isEdit: true,
                                                  ),
                                                ),
                                                backgroundColor: Colors.white,
                                              );
                                              if (result != null) {
                                                // Find index of current attendee in the list
                                                int index = controller
                                                    .subformData
                                                    .indexOf(attendee);

                                                if (index != -1) {
                                                  // Replace the attendee with the updated result
                                                  controller
                                                          .subformData[index] =
                                                      result;
                                                  controller.formData[
                                                          field.headers] =
                                                      List.from(controller
                                                          .subformData); // Update the main form data
                                                  print(
                                                      "Updated attendee: $result");
                                                }
                                              }
                                              Get.back();
                                            },
                                            icon: const Icon(Icons.edit),
                                          )
                                      ],
                                    ),
                                    const SizedBox(height: 16),

                                    // Dynamically create Text widgets for each key-value pair
                                    ...attendee.entries.map((entry) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 18.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${entry.key}: ", // Field key
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(entry.value?.toString() ??
                                                "N/A"),
                                          ],
                                        ),
                                      );
                                    }).toList(),

                                    const SizedBox(height: 16),
                                  ]),
                            ),
                            backgroundColor: Colors.white,
                          );
                          if (result != null) {
                            // Update formData and subformData
                            if (controller.formData[field.headers] == null) {
                              controller.formData[field.headers] = [];
                            }
                            controller.formData[field.headers].add(result);
                            controller.subformData.value = (controller
                                    .formData[field.headers] as List)
                                .where((item) => item is Map<String, dynamic>)
                                .map((item) => item as Map<String, dynamic>)
                                .toList();
                            print("Updated attendee: $result");
                          }
                        }
                      },
                      child: Chip(
                        label: Text(attendee[field.key] ?? ""),
                        // Only show delete button if editable
                        onDeleted: isEditable
                            ? () {
                                controller.subformData.remove(
                                    attendee); // Remove the chip from the list
                                controller.formData[field.headers] =
                                    controller.subformData;
                                print(
                                    "Removed attendee: $attendee"); // Optional: for debugging
                              }
                            : null, // Disable deletion when not editable
                      ),
                    );
                  }).toList(),
                )),
          ],
        );

      case 'dropdown':
        return Obx(() {
          final selectedValue = controller.formData[field.headers];

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
              (controller.formData[field.headers] is List<String>)
                  ? List<String>.from(
                      controller.formData[field.headers] as List<String>)
                  : [];

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
                onChanged: isEditable // Check if it's editable
                    ? (bool newValue) {
                        controller.updateSwitchSelection(
                            field.headers, newValue);
                      }
                    : null, // Disable onChanged if not editable
                // Optionally, change the appearance of the disabled switch
                activeColor: isEditable ? null : Colors.grey,
                inactiveThumbColor: isEditable ? null : Colors.grey,
                inactiveTrackColor: isEditable ? null : Colors.grey[300],
              ),
              const SizedBox(height: 10),
            ],
          );
        });

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
          controller: dateController,
          readOnly:
              !isEditable, // Make the TextField read-only based on isEditable
          decoration: kTextFieldDecoration("Select Date"),
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
                    dateController.text =
                        formattedDate; // Update the TextField with the selected date
                    controller.updateFormData(
                        field.headers, formattedDate); // Update the form data
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
          decoration: kTextFieldDecoration("Select Time"),
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

  Widget buildEditableChipField(PageField field, bool isEditable) {
    // Extract existing chips from form data or initialize as an empty list
    List<String> existingChips =
        (controller.formData[field.headers] as List<String>?) ?? [];
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

InputDecoration kTextFieldDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );
}
