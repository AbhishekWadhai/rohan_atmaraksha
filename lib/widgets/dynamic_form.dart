import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_atmaraksha/controller/dynamic_form_contoller.dart';
import 'package:rohan_atmaraksha/model/form_data_model.dart';

class DynamicForm extends StatelessWidget {
  final String pageName;
  const DynamicForm({super.key, required this.pageName});
  @override
  Widget build(BuildContext context) {
    final DynamicFormController controller = Get.put(DynamicFormController());
    final pageFields = controller.formResponse
                .where((e) => e.page == pageName)
                .expand((e) => e.pageFields)
                .toList();

    return Obx(
      () {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.separated(
          itemCount: pageFields.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, innerIndex) {
            
            return buildFormField(pageFields[innerIndex]);
          },
          separatorBuilder: (context, innerIndex) => SizedBox(height: 10),
        );
      },
    );
  }

  Widget buildFormField(PageField field) {
    switch (field.type) {
      case 'CustomTextField':
        return TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: field.headers,
          ),
        );

      case 'CustomTextField':
        return SwitchListTile(
          title: const Text("For Switch"),
          value: false, // Initial value
          onChanged: (bool value) {
            // Use GetX for state management
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
      child: Text("testing"),
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
