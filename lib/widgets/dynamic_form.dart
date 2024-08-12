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
    // Call getPageFields with the provided pageName

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
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              onChanged: (value) {
                textController.text = value;
                controller.updateFormData(field.id, value);
              },
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );

      case 'Type 2':
        return SwitchListTile(
          title: Text(field.headers),
          value: controller.formData[field.headers] ??
              false, // Get initial value from formData
          onChanged: (bool value) {
            controller.updateFormData(field.id, value);
          },
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
          // Handle picked date
        }
      },
      child: const Text("testing"),
    );
  }

  // Widget dropDownWidget(List<Options>? options) {
  //   return DropdownButton<String>(
  //     isExpanded: true,
  //     hint: Text('Select an option'),
  //     items: options?.map((option) {
  //       return DropdownMenuItem<String>(
  //         value: option.optionValue,
  //         child: Text(option.optionLabel!),
  //       );
  //     }).toList(),
  //     onChanged: (value) {
  //       // Handle dropdown selection with GetX
  //     },
  //   );
  // }
}
