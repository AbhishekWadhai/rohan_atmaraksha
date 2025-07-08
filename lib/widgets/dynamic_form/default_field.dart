import 'package:flutter/material.dart';
import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';
import 'package:rohan_suraksha_sathi/controller/dynamic_form_contoller.dart';
import 'package:rohan_suraksha_sathi/model/form_data_model.dart';
import 'package:rohan_suraksha_sathi/widgets/dynamic_form.dart';

import 'form_extras.dart';

Widget buildDefaultField(
  PageField field,
  DynamicFormController controller,
  bool isEdit,
) {
  final dynamic savedValue = controller.formData[field.headers];

  if (isEdit && field.headers.toLowerCase() == "createdby") {
    return const SizedBox.shrink();
  }

  String displayValue = "";
  String saveValue = "";

  if (isEdit && savedValue != null) {
    if (savedValue is Map) {
      displayValue = savedValue[field.key] ?? "";
      saveValue = savedValue["_id"] ?? "";
      controller.updateFormData(field.headers, savedValue);
    } else if (savedValue is String) {
      displayValue = savedValue;
      saveValue = savedValue;
      controller.updateFormData(field.headers, savedValue);
    }
  } else {
    displayValue = Strings.endpointToList[field.endpoint][field.key];
    saveValue = Strings.endpointToList[field.endpoint]["_id"];
    controller.updateFormData(field.headers, saveValue);
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        field.title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      TextFormField(
        controller: TextEditingController(text: displayValue),
        decoration: kTextFieldDecoration(""),
        readOnly: true,
      ),
      const SizedBox(height: 10),
    ],
  );
}
