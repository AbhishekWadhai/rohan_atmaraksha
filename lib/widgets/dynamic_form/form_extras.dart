import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';
import 'package:rohan_suraksha_sathi/controller/dynamic_form_contoller.dart';
import 'package:rohan_suraksha_sathi/model/form_data_model.dart';

Obx buildSwitch(
    PageField field, DynamicFormController controller, bool isEditable) {
  return Obx(() {
    final bool isSwitched = controller.formData[field.headers] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SwitchListTile(
          title: Text(field.title),
          value: isSwitched,
          onChanged: isEditable &&
                  controller.formData[field.endpoint] != null &&
                  (controller.formData[field.endpoint] as List).any((item) {
                    if (item is String) {
                      return item == Strings.userName;
                    } else if (item is Map<String, dynamic>) {
                      return item.containsValue(Strings.userName);
                    }
                    return false; // For any unexpected type, return false.
                  })
              ? (bool newValue) {
                  controller.updateSwitchSelection(field.headers, newValue);
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
}

Widget buildEditableChipField(PageField field, DynamicFormController controller,
    bool isEditable, bool isEdit) {
  // Extract existing chips from form data or initialize as an empty list
  List<String> existingChips =
      (controller.formData[field.headers] as List<dynamic>?)?.cast<String>() ??
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

//   Widget buildInputChips(
//       List<String> options, String fieldName, bool isEditable) {
//     return Wrap(
//       spacing: 8.0,
//       children: options.map((option) {
//         return isEditable
//             ? InputChip(
//                 label: Text(option),
//                 selected: controller.selectedChips.contains(option),
//                 onSelected: (isSelected) {
//                   isSelected
//                       ? controller.selectedChips.add(option)
//                       : controller.selectedChips.remove(option);
//                   // Call setState or update your controller here
//                 },
//               )
//             : FilterChip(
//                 label: Text(option),
//                 selected: controller.selectedChips.contains(option),
//                 onSelected: null, // Disable selection
//               );
//       }).toList(),
//     );
//   }
// }

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
