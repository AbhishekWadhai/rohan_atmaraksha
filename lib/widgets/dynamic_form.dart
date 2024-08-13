import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_atmaraksha/controller/dynamic_form_contoller.dart';

import 'package:rohan_atmaraksha/model/form_data_model.dart';

class DynamicForm extends StatelessWidget {
  final String pageName;

  DynamicForm({super.key, required this.pageName});

  final DynamicFormController controller = Get.put(DynamicFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              controller.getPageFields(pageName);
              return GetBuilder<DynamicFormController>(builder: (controller) {
                return ListView.separated(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: controller.pageFields.length +
                      1, // Increment itemCount by 1
                  shrinkWrap: true,
                  itemBuilder: (context, innerIndex) {
                    if (innerIndex < controller.pageFields.length) {
                      return buildFormField(controller.pageFields[innerIndex]);
                    } else {
                      return ElevatedButton(
                        onPressed: () {
                          controller.submitForm();
                        },
                        child: const Text('Submit'),
                      );
                    }
                  },
                  separatorBuilder: (context, innerIndex) =>
                      const SizedBox(height: 10),
                );
              });
            },
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
              field.headers,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              onChanged: (value) {
                textController.text = value;
                controller.updateFormData(field.headers, value);
              },
            ),
            const SizedBox(height: 10),
          ],
        );
      case 'dropdown':
        return FutureBuilder<List<String>>(
          future:
              controller.getDropdownData(field.endpoint ?? "", field.key ?? ""),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the data is being fetched, show a loading spinner or similar
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.headers,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const CircularProgressIndicator(), // Loading indicator
                  const SizedBox(height: 10),
                ],
              );
            } else if (snapshot.hasError) {
              // If there's an error, display it
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.headers,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text("Error loading data"), // Error message
                  const SizedBox(height: 10),
                ],
              );
            } else if (snapshot.hasData) {
              // Once data is loaded, build the dropdown with the data
              final List<String> options = snapshot.data ?? [""];
              final String selectedValue =
                  controller.formData[field.headers] ?? options.first;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.headers,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedValue,
                    items: options.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      controller.updateFormData(field.headers, newValue);
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              );
            } else {
              // In case there's no data, return an empty container
              return Container();
            }
          },
        );

      case 'datepicker':
        return myDatePicker(field);

      case 'timepicker':
        return TextButton(
            onPressed: () async {
              TimeOfDay? selectedTime = await showTimePicker(
                  context: Get.context!, initialTime: TimeOfDay.now());

              if (selectedTime != null) {
                controller.updateFormData(field.headers, selectedTime.toString());
              }
            },
            child: const Text("Select a time"));

      case 'radio':
        final String selectedValue = controller.formData[field.headers] ?? '';
        final List<String> options = ["true", "false"];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.headers,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: options.map((option) {
                return RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: selectedValue,
                  onChanged: (String? newValue) {
                    controller.updateFormData(field.headers, newValue);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
          ],
        );

      default:
        return const Text('Unsupported field type');
    }
  }

  Widget myDatePicker(PageField field) {
    return TextButton(
      onPressed: () async {
        DateTime? pickedDate = await showDatePicker(
          context: Get.context!,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          controller.updateFormData(field.headers, pickedDate.toString());
        }
      },
      child: const Text("testing"),
    );
  }
}