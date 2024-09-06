import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:rohan_atmaraksha/controller/dynamic_form_contoller.dart';

import 'package:rohan_atmaraksha/model/form_data_model.dart';

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
    controller.initializeFormData(initialData);
    return Scaffold(
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Obx(
              () {
                controller.getPageFields(pageName);

                //controller.initializeFormData(initialData);
                print(
                    "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
                print(jsonEncode(initialData));
                return GetBuilder<DynamicFormController>(builder: (controller) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Build form fields dynamically
                          ...controller.pageFields
                              .map((field) => Column(
                                    children: [
                                      buildFormField(field),
                                      const SizedBox(height: 10),
                                    ],
                                  ))
                              .toList(),

                          const SizedBox(height: 10),

                          // Submit button
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                if (isEdit) {
                                  controller.updateData(
                                      pageName); // Call update method
                                } else {
                                  controller.submitForm(
                                      pageName); // Call submit method
                                }
                              } else {
                                // If the form is invalid, show an error
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
                                )),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFormField(PageField field) {
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
              validator: (value) => controller.validateTextField(value),
              controller: textController,
              decoration: kTextFieldDecoration("Enter ${field.title}"),
              onChanged: (value) {
                //textController.text = value;
                _debounce?.cancel();

                // Start a new timer
                _debounce = Timer(const Duration(milliseconds: 2000), () {
                  controller.updateFormData(field.headers, value);
                });
              },
            ),
            const SizedBox(height: 10),
          ],
        );
      case 'editablechip':
        return buildEditableChipField(field);
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
                  FormField<List<String>>(
                    initialValue: selectedIds,
                    validator: (selectedItems) {
                      if (selectedItems == null || selectedItems.isEmpty) {
                        return 'Please select at least one option';
                      }
                      return null;
                    },
                    builder: (FormFieldState<List<String>> state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MultiSelectDialogField<String>(
                            dialogHeight: 300,
                            items: options.map((Map<String, String> option) {
                              return MultiSelectItem<String>(
                                option['_id'] ?? "", // Use `_id` as the value
                                option[field.key] ??
                                    '', // Display the dynamic key (e.g., `projectName`)
                              );
                            }).toList(),
                            initialValue: selectedIds,
                            onConfirm: (List<String> selectedValues) {
                              state.didChange(
                                  selectedValues); // Update the form field state
                              controller.updateFormData(
                                  field.headers, selectedValues);
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
                          ),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                state.errorText ?? '',
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 12),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              );
            } else {
              return Container();
            }
          },
        );

      case 'dropdown':
        return Obx(() {
          final selectedValue = controller.formData[field.headers];

          return FutureBuilder<List<Map<String, String>>>(
            future: controller.getDropdownData(
                field.endpoint ?? "", field.key ?? ""),
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, String>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(field.title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 10),
                  ],
                );
              } else if (snapshot.hasError) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(field.title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const Text("Error loading data"),
                    const SizedBox(height: 10),
                  ],
                );
              } else if (snapshot.hasData) {
                final List<Map<String, String>> options = snapshot.data ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(field.title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
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
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            validator: (value) =>
                                controller.validateDropdown(value),
                            elevation: 0, // Remove default elevation
                            value: selectedValue, // Keep this as null initially
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
                return Container();
              }
            },
          );
        });

      case 'datepicker':
        return myDatePicker(field);

      case 'timepicker':
        return myTimePicker(field);

      case 'radio':
        return Obx(() {
          final selectedValue = controller.formData[field.headers].toString();
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
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.updateRadioSelection(
                              field.headers, newValue);
                        }
                      },
                    ),
                  );
                }).toList(),
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
          onTap: () async {
            await controller.fetchGeolocation(field.headers);
          },
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
        const SizedBox(height: 10),
      ],
    );
  });


      case 'slider':
        return Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Number of Attendees - ${controller.formData[field.headers] ?? "0"}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Slider(
                value: controller.formData[field.headers] ?? 0,
                min: 0.0,
                max: 100.0,
                divisions: 100,
                label: controller.formData[field.headers].toString(),
                onChanged: (value) {
                  controller.formData[field.headers] = value;
                },
              ),
            ],
          );
        });

      default:
        return const Text('Unsupported field type');
    }
  }

  Widget myDatePicker(PageField field) {
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
              true, // Make the TextField read-only so the user can't manually edit it
          decoration: kTextFieldDecoration("Select Date"),
          onTap: () async {
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
          },
        ),
      ],
    );
  }

  Widget myTimePicker(PageField field) {
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
              true, // Make the TextField read-only so the user can't manually edit it
          decoration: kTextFieldDecoration("Select Time"),
          onTap: () async {
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
          },
        ),
      ],
    );
  }

  Widget buildEditableChipField(PageField field) {
    // Extract existing chips from form data or initialize as empty list
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
              onDeleted: () {
                existingChips.remove(chip);
                controller.updateFormData(field.headers, existingChips);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: chipController,
                decoration: kTextFieldDecoration("Add a chip"),
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
    );
  }

  Widget buildInputChips(List<String> options, String fieldName) {
    return Wrap(
      spacing: 8.0,
      children: options.map((option) {
        return InputChip(
          label: Text(option),
          selected: controller.selectedChips.contains(option),
          onSelected: (isSelected) {
            isSelected
                ? controller.selectedChips.add(option)
                : controller.selectedChips.remove(option);
            // Call setState or update your controller here
          },
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
