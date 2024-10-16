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
    controller.initializeFormData(initialData);

    return Scaffold(
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Obx(
              () {
                controller.getPageFields(pageName);
                return GetBuilder<DynamicFormController>(builder: (controller) {
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
                                        buildFormField(field),
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
                                        buildFormField(field),
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
                                // Build form fields dynamically for mobile view
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
      case 'imagepicker':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(field.title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            // Image Upload Button
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Call the function to pick and upload the image
                    await controller.pickAndUploadImage(
                        field.headers, field.endpoint ?? "", "");
                  },
                  child: const Text('Gallery'),
                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: () async {
                    // Call the function to pick and upload the image
                    await controller.pickAndUploadImage(
                        field.headers, field.endpoint ?? "", "camera");
                  },
                  child: const Text('Camera'),
                ),
              ],
            ),

            // Display uploaded image URL
            Obx(() {
              // Check if the field.endpoint exists in formData and is a non-null String
              final imageUrl = controller.formData[field.headers];

              // Ensure that imageUrl is a String and not null
              if (imageUrl is String && imageUrl.isNotEmpty) {
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    Image.network(imageUrl,
                        height: 150), // Safely use the non-null imageUrl
                    const SizedBox(height: 10),
                    const Text('Image uploaded successfully!'),
                  ],
                );
              } else {
                // Return an empty Container or some placeholder when no image is uploaded
                return Container();
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
                  .map((item) => item as Map<String, dynamic>)
                  .toList();
        }

        return Column(
          children: [
            // Button to add attendees
            TextButton(
              onPressed: () async {
                var result = await Get.bottomSheet(
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SubForm(pageName: field.headers),
                  ),
                  backgroundColor: Colors.white,
                );
                if (controller.formData[field.headers] == null) {
                  controller.formData[field.headers] = [];
                }
                controller.formData[field.headers].add(result);
                controller.subformData.value =
                    (controller.formData[field.headers] as List)
                        .map((item) => item as Map<String, dynamic>)
                        .toList();
                print(
                    "---------------------------------------------------------------------------");
                print(controller.subformData);
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
                                      IconButton(
                                          onPressed: () async {
                                            var result = await Get.bottomSheet(
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
                                              int index = controller.subformData
                                                  .indexOf(attendee);

                                              if (index != -1) {
                                                // Replace the attendee with the updated result
                                                controller.subformData[index] =
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
                                          icon: const Icon(Icons.edit))
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
                                          Text(
                                              entry.value?.toString() ?? "N/A"),
                                        ],
                                      ),
                                    );
                                  }).toList(),

                                  const SizedBox(height: 16),
                                ]),
                          ),
                          backgroundColor: Colors.white,
                        );
                        if (controller.formData[field.headers] == null) {
                          controller.formData[field.headers] = [];
                        }
                        controller.formData[field.headers].add(result);
                        controller.subformData.value =
                            (controller.formData[field.headers] as List)
                                .map((item) => item as Map<String, dynamic>)
                                .toList();
                        print(
                            "---------------------------------------------------------------------------");
                        print(controller.subformData);
                      },
                      child: Chip(
                        label: Text(attendee[field.key] ?? ""),
                        onDeleted: () {
                          controller.subformData.remove(
                              attendee); // Remove the chip from the list
                          controller.formData[field.headers] =
                              controller.subformData;
                          print(
                              "Removed attendee: $attendee"); // Optional: for debugging
                        },
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
      case 'simplemultiselect':
        return MultiSelectDialogField<String>(
          dialogHeight: 300,
          items: (field.options != null)
              ? field.options!.map((option) {
                  return MultiSelectItem<String>(option, option);
                }).toList()
              : [],

          // Ensure initialValue is a non-null, valid list
          initialValue: controller.formData[field.headers] != null
              ? List<String>.from(controller.formData[field.headers])
              : [],

          onConfirm: (List<String> selectedValues) {
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
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(border: InputBorder.none),
                  validator: (value) => controller.validateDropdown(value),
                  elevation: 0, // Remove default elevation
                  value: controller.formData[field.headers]
                      ?.toString(), // Keep this as null initially
                  hint: const Text('Select an option'), // Hint text
                  items: (field.options != null)
                      ? field.options!.map((option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option ?? ''),
                          );
                        }).toList()
                      : [], // Return an empty list if `field.options` is null

                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.updateDropdownSelection(
                          field.headers, newValue);
                    }
                  },
                ),
              ),
            ),
          ],
        );

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
      case 'switch':
        if (isEdit) {
          return Obx(() {
            final bool isSwitched = controller.formData[field.headers] == true;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SwitchListTile(
                  title: Text(field.title),
                  value: isSwitched,
                  onChanged: (bool newValue) {
                    controller.updateSwitchSelection(field.headers, newValue);
                  },
                ),
                const SizedBox(height: 10),
              ],
            );
          });
        } else {
          return const SizedBox.shrink();
        }
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
