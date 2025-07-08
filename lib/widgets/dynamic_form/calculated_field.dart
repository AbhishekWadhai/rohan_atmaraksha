import 'package:flutter/material.dart';
import 'package:rohan_suraksha_sathi/controller/dynamic_form_contoller.dart';
import 'package:rohan_suraksha_sathi/model/form_data_model.dart';
import 'package:rohan_suraksha_sathi/widgets/dynamic_form/form_extras.dart';

Widget buildCalculatedField(PageField field, DynamicFormController controller) {
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
        controller: textController,
        decoration: kTextFieldDecoration("Tap to calculate ${field.title}"),
        readOnly: true,
        maxLines: null,
        onTap: () {
          controller.updateFormDataFromControllers();
          final String? value1String =
              controller.formData[field.endpoint]?.toString();
          final String? value2String = field.key;

          final int value1 = int.tryParse(value1String ?? '') ?? 0;
          final double value2 = double.tryParse(value2String ?? '') ?? 0.0;

          final double result = value1 * value2;
          final String roundedResult = result.toStringAsFixed(2);

          textController.text = roundedResult;
          controller.updateFormData(field.headers, roundedResult);
        },
        keyboardType: TextInputType.number,
      ),
    ],
  );
}
